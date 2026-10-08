# Reproduction and acceptance

## Rebuild deliverables

Required components for an equivalent implementation:

1. SQLAlchemy-equivalent 26-table model, defaults, indexes and startup migration semantics.
2. Public Binance price clients with the exact validation/caching/backoff behavior.
3. Durable aggregate-trade replay with immutable order terms and shared OCO cursor.
4. Straddle loop, Hedge loop, restart restoration and per-panel accounting as specified.
5. REST/auth/websocket endpoints and the frozen frontend files.
6. Seeded configuration and role settings; no private database is included in this documentation.
7. Offline acceptance suite plus optional opt-in Binance data audits.

Build in this order: storage and settings; price client; replay; engine state restoration; entry/exit transactions; API; frontend; tests; deployment. State restoration and transaction commits must not be postponed until after entry implementation, because durable records determine one-trade locks, clash reference, TP rank and idempotence.

## Exact source reconstruction from documentation

The implementation appendix contains all36 active source/support/test files required by this version's included package. Each section has a unique `## File:` header and a five-backtick fenced body. SOURCE_MANIFEST.json records both original-byte and normalized-LF SHA256 hashes. No original working tree is needed to extract those files.

Save the following as an external helper (outside the current application) and run with Python, supplying the reference directory and a **new, empty destination**:

```python
import hashlib
import json
import re
import sys
from pathlib import Path

reference = Path(sys.argv[1]).resolve()
destination = Path(sys.argv[2]).resolve()
if destination.exists() and any(destination.iterdir()):
    raise SystemExit('Destination must be empty.')
destination.mkdir(parents=True, exist_ok=True)
manifest = json.loads((reference / 'SOURCE_MANIFEST.json').read_text(encoding='utf-8'))
appendix = (reference / 'IMPLEMENTATION.md').read_text(encoding='utf-8')
sections = dict(re.findall(
    r'^## File: `([^`]+)`\n\n`````[^\n]*\n(.*?)^`````\n',
    appendix, flags=re.M | re.S,
))
for item in manifest['files']:
    name = item['path']
    target = (destination / name).resolve()
    if not target.is_relative_to(destination):
        raise SystemExit('Unsafe path: ' + name)
    data = sections[name].encode('utf-8')
    # A non-newline-terminated original has one presentation newline in the fence.
    if hashlib.sha256(data).hexdigest() != item['normalized_sha256']:
        data = data[:-1]
    if hashlib.sha256(data).hexdigest() != item['normalized_sha256']:
        raise SystemExit('Hash mismatch: ' + name)
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_bytes(data)
print('Reconstructed', len(manifest['files']), 'verified files at', destination)
```

This reproduces code and tests with normalized line endings. It does not reproduce account passwords customized outside source, historical trades, saved deployment parameters or private environment settings. Those require a consistent database backup and the corresponding SECRET_KEY. The source includes its built-in development credentials, which are already part of the original frontend/seed behavior.

## New isolated installation

Use a new directory and database. On Linux:

```bash
cd /path/to/reconstructed-tool
python3 -m venv env
source env/bin/activate
pip install -r requirements.txt
export DATABASE_URL="sqlite:////absolute/path/to/reconstructed-tool/paper.db?check_same_thread=False"
python -m uvicorn main:app --host 127.0.0.1 --port 8085
```

On Windows use `py -m venv env`, `env\Scripts\Activate.ps1`, and set `$env:DATABASE_URL` to the new absolute SQLite URL before invoking Python. Do not launch a second engine against the existing production or local-test database. Use one uvicorn worker and omit --reload for a stable independent instance. Startup creates tables, adds execution columns if missing and seeds config/admin/roles; it also starts both bots. Configure entry gates/time windows for isolated testing before supplying live market data if immediate paper entries are unwanted.

Dependencies are minimum-version declarations, not a lockfile. Exact future dependency-resolution reproducibility is not guaranteed by requirements.txt. The source includes imports of python-jose even though PyJWT is also listed. Optional MCP requirements are separate. The current tested workspace is Python3.14 on Windows; a new Linux environment must pass the same tests rather than assuming binary/environment equivalence.

`schema.sql` creates an empty SQLite schema with model-declared indexes, but Python-side defaults are not SQL defaults. Running it alone does not seed users/configuration. Normal app startup is the complete bootstrap. Existing migration adds filled_at,processed_at,aggregate_trade_id to both order tables, and order_id to both fill tables, nullable and repeatable. Historical rows are deliberately left unknown; migration is not an execution-history reconstruction.

## Existing Linux service behavior

The user-provided service is named hedgesnstraddle.service; directory /home/ubuntu/hedgesnstraddle; environment PORT=8085; executable env/bin/python main.py; Restart=always. main.py uses reload=True. A systemd-managed process may restart after kill; use systemctl stop to stop its unit, not a kill loop. Do not run a competing nohup application on the same port/database.

For a duplicate, configure its own unit, directory, port and database. A non-reload single-worker uvicorn invocation is suitable operationally; using main.py reproduces the current reload launch behavior. Nginx is outside the application source: the observed IP site proxies port80 to127.0.0.1:8085, forwards Host/X-Real-IP/X-Forwarded-For and Upgrade/Connection, and uses proxy_http_version1.1. A separate domain can route another application, so do not replace unrelated Nginx server blocks.

Deployment sequence: inspect clean branch and target service; obtain service's actual DATABASE_URL and working directory; make SQLite online-backup snapshot and integrity-check it; stop the service before replacing Python code when reload is enabled; fetch/fast-forward intended commit; start service; verify config/HTML/API fields, not just systemctl active; inspect journal; hard-refresh browser. Preserve secrets and saved database settings. A future update is not required to rerun historical fills or clear records.

## Backups and resets

Recommended backup package: active source, requirements, tests, manifest with commit and file hashes, consistent SQLite snapshot, separately protected environment configuration. Exclude virtual environments, caches and nested old backups. For an in-use SQLite database use sqlite3 Connection.backup, not a naked copy that can omit WAL content. Integrity-check the destination.

Default DB is project-root hedgesnstraddle.db; local testing in this conversation used .local/dashboard-test-20260917-170013/paper-test.sqlite3, explicitly selected through DATABASE_URL. The database chosen by a shell can differ from the service's environment; confirm it before reset. Documentation does not embed either database.

Reset Hedge deletes events, ledger, fills, orders, positions, sessions and queued commands, resets its wallet, clears in-memory slot/rank locks. Reset Straddle deletes events, PnL snapshots, ledger, fills, orders, sessions; resets wallet and LAST_TRADED_EXPIRY. Both preserve user accounts/configuration audits/strategy settings. Stop the common service first to eliminate races; resetting only Hedge still pauses Straddle briefly but does not erase Straddle records. Restart preserves previous bot enabled flags unless explicitly changed.

## Required acceptance cases

Run the embedded offline suite:

```bash
python -m unittest discover -s tests -q
node --check app/static/js/app.js
```

On 2026-09-24 the application was reconstructed from IMPLEMENTATION.md into an isolated directory and its suite was executed there:85 tests ran,84 passed and1 optional MCP protocol test was skipped. JavaScript syntax validation also passed. Install optional MCP dependencies if that protocol check is required. Tests create isolated databases and mock market feeds; they do not prove future Binance data completeness or historical profitability.

Acceptance matrix:

| Area | Required equivalent behavior |
|---|---|
| Straddle pairing | Earliest unexpired complete pair; nearest futures-mark strike; deterministic lower-strike distance tie; no nearest contract substitution for held marks |
| Entry gates | Inclusive time/premium/gap caps, expiry/weekend lock, positive qty, disabled entries but continuing management |
| OCO | Fixed placement prices, chronological first crossing, opposite cancellation, same-ms ID ordering and no pre-activation event fill |
| Cutoff | Recover crossing before cutoff even when processing late; event exactly at cutoff excluded; no premature expiry on empty/late page |
| TP | Fixed futures price, exact contract and quantity verification; no mark-only fake fill; actual trade timestamp differs from processing/placement |
| Recovery | Original premium basis, configured fraction, original qty after config edits, correct proceeds/PnL |
| Accounting | Straddle entry debit and close credit; Hedge realized increments; no double settle after repeat square-off/restart |
| Hedge direction | Second opposite to first recorded direction, including after first close/restart; missing reference means wait |
| Clash | Both directions,250/500 gap, inclusive exact boundary, reject same/wrong/too-close/wrong-expiry; apply before TV ranking, no bypass of premium/TV gates |
| Multiplier | Default1, positive fractional values, reject0/negative/NaN/infinity/boolean; target locks at creation; exact1x closure |
| Removed cap | Legacy Q_MAX_BTC does not block an otherwise valid entry |
| Role windows | Independent opening/force-close schedules, one-per-role expiry locks, overnight handling |
| Follow-up | First TP option target and second TP mark-based re-entry; re-entry preserves original TP event and no new original TP |
| Feeds | Invalid quotes, stale fallback expiry, missing held symbols, noncontiguous aggregate IDs, API failure/backoff defer rather than fabricate |
| Recovery persistence | Page-boundary cursor, same timestamp multiple IDs, retained bootstrap window, deadline later-event witness, retention failure |
| Administrative | Manual commands survive Hedge restart, reset isolation, API validation before mutation, config audit behavior |
| Migration/UI | Nullable migration repeatable; old rows retain unknown fill times; UI shows actual fill vs placement correctly |

Manual Binance audits are opt-in tools embedded under tests/manual_binance_*.py. Read their CLI/source before using them. They compare finite sampled/recovered history and do not guarantee every future raw tick. Historical evidence reports elsewhere in the original repository describe past runs, not a new validation of today's network in this documentation task.

## Documentation validation

The documentation build checks that schema.sql executes in an in-memory SQLite database and matches all26 tables/225 columns; embedded source hashes round-trip for all36 files; Python sources parse; Markdown local links resolve; the source manifest matches the source being documented. The condition register enumerates492 Python branches/handlers/filters,357 dictionary field expressions and135 explicit runtime attribute assignments. Dynamic setattr expressions and all JS/HTML conditions remain fully reproduced in the exact source appendix.

These counts describe this frozen baseline. When code changes, regenerate the appendices and update the prose/commit together. A configuration change alone requires updating the deployment's saved-parameter export if reproducing a particular run, but does not change the code-default specification.
