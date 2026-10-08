# HnS ETH paper bots

This copy now uses ETH options and ETHUSDT futures, following `PAPER TESTING SYSTEM(For ETHUSD).docx`. Minimum hedge strike gap choices are 10, 20, and 30 (default 10). Set Maximum Hedge Strike Gap in Hedge configuration before Trader 2 can enter; the document does not specify a default maximum. Both gap boundaries are inclusive. Other strategy mechanisms and parameters are retained.

The application and read-only MCP default to `hedgesnstraddle_eth.db`. Existing users and strategy settings were copied into this separate ETH database; BTC trade history remains in the untouched `hedgesnstraddle.db` snapshot. Do not point the ETH app at the BTC snapshot.

## Original backup provenance

Standalone copy of the current working files, including uncommitted documentation.
The original tool is unchanged. No Linux-server data was downloaded.

## Contents

- App code, static UI, requirements, tests, documentation and project reference files.
- hedgesnstraddle.db: consistent default local database snapshot.
- local-test-data/paper-test.sqlite3: separate local testing database snapshot.
- BACKUP_MANIFEST.json: hashes, source revision/status and exclusions.

## Start in PowerShell

```powershell
Set-Location -LiteralPath 'D:/HnS Development/Eth_paper bots'
py -m venv env
./env/Scripts/python.exe -m pip install -r requirements.txt
$env:DATABASE_URL = 'sqlite:///D:/HnS Development/Eth_paper bots/hedgesnstraddle_eth.db?check_same_thread=False'
./env/Scripts/python.exe -m uvicorn main:app --host 127.0.0.1 --port 8086
```

Open http://127.0.0.1:8086/. Port 8086 avoids the original local tool's port8085.
The existing `local-test-data/paper-test.sqlite3` is a BTC snapshot, not the ETH runtime database.

Set the database URL before starting Python. Bot settings are preserved: enabled
paper bots can trade when this copy starts. It writes to the copied database.
If a custom SECRET_KEY was used, supply the same value for existing login hashes.
Private process environment values have not been exported.

Start reading docs/STRATEGY_REBUILD_SPEC.md for the complete strategy specification.
Virtual environments, Git metadata, caches, logs and obsolete backup files were
excluded. Reinstall dependencies using requirements.txt; it specifies minimum
versions, not a complete environment lock. The two database snapshots are each
consistent independently, not a shared transaction across databases.
