# Configuration dictionary

All global values are persisted as strings. Defaults below are seeded only if missing; existing saved values survive startup. These are **not** a claim about current Linux or local-test settings. The captured source commit, not prior conversation examples, defines this dictionary. Global POSTs accept arbitrary keys; this table covers every seeded key plus runtime/legacy keys known to current source.

The fallback register after the tables lists exact runtime .get expressions. Seed values and missing-key fallbacks can differ: for example Straddle seeded quantity0.1 vs runtime fallback10; seeded futures TP multiplier1 vs entry-processing fallback2. A normal initialized database receives seeds.

## Straddle global

| Key | Seeded value | Effect / units / timing |
|---|---|---|
| `RUNTIME_MODE` | `Paper` | Stored/displayed only. No execution mode switch or live trading route. |
| `BOT_ENABLED` | `1` | ACTIVE entry gate: must equal string 1; does not freeze existing-position management. |
| `PAPER_TRADING_ENABLED` | `1` | Stored/displayed only; not an execution gate. |
| `WORKER_ID` | `straddle-worker-1` | Stored/displayed only; no worker lock/coordination. |
| `BINANCE_API_KEY` | `` | Stored legacy credential setting; not used for public market data or order submission. |
| `BINANCE_SECRET_KEY` | `` | Stored legacy credential setting; not used for public market data or order submission. |
| `TELEGRAM_TOKEN` | `` | Stored only; no active notification sender. |
| `TELEGRAM_CHAT_ID` | `` | Stored only; no active notification sender. |
| `WINDOW_START` | `18:50` | ACTIVE Straddle options entry window start, inclusive minute precision, IST relative-day comparison. |
| `WINDOW_END` | `18:55` | ACTIVE Straddle options entry window end, inclusive entire minute. |
| `FUTURES_ENTRY_CUTOFF` | `18:56` | ACTIVE Straddle OCO deadline, exclusive; replay until deadline minus1ms. |
| `SQ_START` | `18:57` | Stored/displayed only; no independent square-off start gate. |
| `SQ_END` | `19:02` | ACTIVE Straddle automatic basket close time; also bounds TP replay. |
| `FUTURES_SQUAREOFF` | `19:02` | Stored/displayed only; SQ_END controls actual Straddle close. |
| `STRADDLE_EXPIRY_TIME` | `19:00` | Stored/displayed only; parsed option expiry remains08:00UTC. |
| `TRADE_QTY` | `0.1` | Straddle ACTIVE original quantity of each leg. Hedge GLOBAL value is inert: role.contract_qty controls entries. |
| `MIN_EXPIRY_HOURS` | `0.0` | Stored only; no applied Straddle minimum remaining-hours filter. |
| `MAX_TOTAL_MARK` | `1500.0` | ACTIVE Straddle combined option premium cap per unit, inclusive. |
| `MAX_PREMIUM_GAP` | `150.0` | ACTIVE Straddle absolute call-minus-put premium cap per unit, inclusive. |
| `SKIP_WEEKENDS` | `1` | ACTIVE: excludes target expiry Saturday/Sunday; Straddle uses selected expiry, Hedge uses current expiry-session key. |
| `FUTURES_TP_MULTIPLIER` | `1.0` | ACTIVE Straddle futures profit-distance multiplier on original combined premium. Read when entry crossing is processed; TP then locked. |
| `OCO_LIMIT_MULTIPLIER` | `1.0` | ACTIVE Straddle entry offsets from strike: plus/minus original combined premium times this value. Locked at placement. |
| `RECOVERY_THRESHOLD_PCT` | `0.65` | ACTIVE Straddle fraction of original combined premium required to close during RECOVERY. 0.65 means65%. |
| `SCAN_INTERVAL` | `1.0` | Stored only; actual Straddle loop sleeps2 seconds after work. |
| `RETRY_TIMEOUT` | `5.0` | Stored only; HTTP and replay timeouts are constants in client. |
| `FUTURES_LEVERAGE` | `10` | Stored only; no futures margin or PnL multiplication. |
| `FUTURES_MM_RATE` | `0.004` | Stored only; no maintenance margin/liquidation logic. |
| `PAPER_WALLET_USDT` | `100000.0` | ACTIVE account state, not just a parameter. Straddle cash/proceeds; Hedge realized balance. Reset returns to100000; arbitrary config edits bypass ledger deposits. |
| `NOTES` | `Straddle Bot Default Configuration` | Stored annotation, no strategy effect. |
## Hedge global

| Key | Seeded value | Effect / units / timing |
|---|---|---|
| `MIN_STRIKE_GAP` | `500` | ACTIVE Hedge second-trader clash filter. Only250/500 permitted through API; default500. Read for selection, not retroactive to positions. |
| `RUNTIME_MODE` | `Paper` | Stored/displayed only. No execution mode switch or live trading route. |
| `ENGINE_ENABLED` | `1` | ACTIVE Hedge entry gate, alongside BOT_ENABLED. |
| `PAPER_TRADING_ENABLED` | `1` | Stored/displayed only; not an execution gate. |
| `WORKER_ID` | `hedge-worker-1` | Stored/displayed only; no worker lock/coordination. |
| `WORKER_POLL_SECONDS` | `2` | Stored/displayed only; actual Hedge loop sleeps2 seconds after work. |
| `COMMAND_TIMEOUT_SECONDS` | `120` | Stored only; no runtime-command expiration mechanism. |
| `GLOBAL_PAUSE` | `0` | ACTIVE Hedge new-entry pause when string 1; positions continue management. |
| `SKIP_WEEKENDS` | `1` | ACTIVE: excludes target expiry Saturday/Sunday; Straddle uses selected expiry, Hedge uses current expiry-session key. |
| `VIRTUAL_BALANCE_USDT` | `100000.0` | Stored only; PAPER_WALLET_USDT is the actual wallet key. |
| `MIN_PAPER_BALANCE` | `1000.0` | Stored only; does not block entry. |
| `FIRST_TP_OPTION_MULTIPLIER` | `1` | ACTIVE Hedge first processed TP option-target factor. Positive finite number, default1. Read at target creation; no repricing of pending targets. |
| `SAFE_MODE_TIMEOUT_SEC` | `5` | Stored only; no implemented safe-mode timer. |
| `LATENCY_WARN_MS` | `500` | Stored only; no trading latency gate. |
| `FILL_TIMEOUT_SEC` | `5` | Stored/displayed only; does not expire simulated limits. |
| `SYMBOL` | `BTCUSDT` | Stored only for Hedge configuration; engine hardcodes BTC instruments. |
| `LEVERAGE` | `10` | Stored only for global Hedge configuration; position schema default10 is used. |
| `TRADE_QTY` | `0.05` | Straddle ACTIVE original quantity of each leg. Hedge GLOBAL value is inert: role.contract_qty controls entries. |
| `BULL_TARGET_PCT` | `0.5` | Stored only; original futures TP uses entry plus option premium. |
| `BEAR_TARGET_PCT` | `0.5` | Stored only; original futures TP uses entry minus option premium. |
| `PAPER_WALLET_USDT` | `100000.0` | ACTIVE account state, not just a parameter. Straddle cash/proceeds; Hedge realized balance. Reset returns to100000; arbitrary config edits bypass ledger deposits. |
| `BOT_ENABLED` | `1` | ACTIVE entry gate: must equal string 1; does not freeze existing-position management. |
| `NOTES` | `Hedge Trader Default Configuration` | Stored annotation, no strategy effect. |

## Runtime and retired keys

| Key | Behavior |
|---|---|
| LAST_TRADED_EXPIRY | ACTIVE Straddle duplicate-entry lock; created on entry/reset, not seeded initially. Empty after reset. |
| Q_MAX_BTC | Retired Hedge cap; no longer seeded, shown, read or enforced. Old DB rows can remain and appear in raw config responses. |
| MAX_OPTION_SPEND | Legacy value accepted as arbitrary config but does not block Hedge entry. Per-unit role premium cap applies instead. |

## Exact global read/fallback register

### BOT_ENABLED

- `app/core/hedge_engine.py:184: cfg.get('BOT_ENABLED', '1')`
- `app/core/hedge_engine.py:585: cfg.get('BOT_ENABLED', '1')`
- `app/core/hedge_engine.py:929: cfg.get('BOT_ENABLED', '1')`
- `app/core/straddle_engine.py:304: cfg.get('BOT_ENABLED', '1')`

### ENGINE_ENABLED

- `app/core/hedge_engine.py:184: cfg.get('ENGINE_ENABLED', '1')`
- `app/core/hedge_engine.py:586: cfg.get('ENGINE_ENABLED', '1')`
- `app/core/hedge_engine.py:929: cfg.get('ENGINE_ENABLED', '1')`

### FIRST_TP_OPTION_MULTIPLIER

- `app/core/hedge_engine.py:801: self.load_config(db).get('FIRST_TP_OPTION_MULTIPLIER', '1')`

### FUTURES_ENTRY_CUTOFF

- `app/core/straddle_engine.py:234: cfg.get('FUTURES_ENTRY_CUTOFF', '11:00')`
- `app/core/straddle_engine.py:343: cfg.get('FUTURES_ENTRY_CUTOFF', '11:00')`

### FUTURES_TP_MULTIPLIER

- `app/core/straddle_engine.py:523: cfg.get('FUTURES_TP_MULTIPLIER', '2')`

### FUTURES_TRADES

- `app/core/binance_client.py:28: _rate_limit_until.get('FUTURES_TRADES', 0)`

### GLOBAL_PAUSE

- `app/core/hedge_engine.py:930: cfg.get('GLOBAL_PAUSE', '0')`
- `app/core/hedge_engine.py:186: cfg.get('GLOBAL_PAUSE', '0')`
- `app/core/hedge_engine.py:586: cfg.get('GLOBAL_PAUSE', '0')`

### LAST_TRADED_EXPIRY

- `app/core/straddle_engine.py:378: cfg.get('LAST_TRADED_EXPIRY', '')`

### MAX_PREMIUM_GAP

- `app/core/straddle_engine.py:237: cfg.get('MAX_PREMIUM_GAP', '150.0')`
- `app/core/straddle_engine.py:373: cfg.get('MAX_PREMIUM_GAP', '150.0')`

### MAX_TOTAL_MARK

- `app/core/straddle_engine.py:236: cfg.get('MAX_TOTAL_MARK', '400.0')`
- `app/core/straddle_engine.py:372: cfg.get('MAX_TOTAL_MARK', '400.0')`

### MIN_STRIKE_GAP

- `app/core/hedge_engine.py:529: self.load_config(db).get('MIN_STRIKE_GAP', '500')`

### OCO_LIMIT_MULTIPLIER

- `app/core/straddle_engine.py:333: cfg.get('OCO_LIMIT_MULTIPLIER', '1.0')`

### PAPER_WALLET_USDT

- `app/api/dashboard_routes.py:74: straddle_cfg.get('PAPER_WALLET_USDT', '100000.0')`
- `app/core/hedge_engine.py:325: cfg.get('PAPER_WALLET_USDT', '100000.0')`

### RECOVERY_THRESHOLD_PCT

- `app/core/straddle_engine.py:670: cfg.get('RECOVERY_THRESHOLD_PCT', '0.65')`

### SKIP_WEEKENDS

- `app/core/hedge_engine.py:931: cfg.get('SKIP_WEEKENDS', '1')`
- `app/core/hedge_engine.py:198: cfg.get('SKIP_WEEKENDS', '1')`
- `app/core/hedge_engine.py:220: cfg.get('SKIP_WEEKENDS', '1')`
- `app/core/straddle_engine.py:255: cfg.get('SKIP_WEEKENDS', '1')`
- `app/core/straddle_engine.py:352: cfg.get('SKIP_WEEKENDS', '1')`

### SQ_END

- `app/core/straddle_engine.py:235: cfg.get('SQ_END', '12:30')`
- `app/core/straddle_engine.py:344: cfg.get('SQ_END', '12:30')`

### TRADE_QTY

- `app/api/dashboard_routes.py:80: straddle_cfg.get('TRADE_QTY', '10')`
- `app/api/dashboard_routes.py:110: straddle_cfg.get('TRADE_QTY', '10')`
- `app/core/straddle_engine.py:383: cfg.get('TRADE_QTY', '10')`

### WINDOW_END

- `app/core/straddle_engine.py:233: cfg.get('WINDOW_END', '07:30')`
- `app/core/straddle_engine.py:342: cfg.get('WINDOW_END', '07:30')`

### WINDOW_START

- `app/core/straddle_engine.py:232: cfg.get('WINDOW_START', '05:00')`
- `app/core/straddle_engine.py:341: cfg.get('WINDOW_START', '05:00')`

## Seeded Hedge roles

```json
[
  {
    "strategy_name": "1st Trader",
    "strategy_key": "first_trader",
    "direction": "1st Trader Role",
    "trade_start_h": 5,
    "trade_start_m": 0,
    "trade_end_h": 7,
    "trade_end_m": 0,
    "force_close_h": 13,
    "force_close_m": 0,
    "contract_qty": 1.0,
    "max_premium": 250.0,
    "max_time_value": 229.0
  },
  {
    "strategy_name": "2nd Trader",
    "strategy_key": "second_trader",
    "direction": "2nd Trader Role",
    "trade_start_h": 7,
    "trade_start_m": 0,
    "trade_end_h": 11,
    "trade_end_m": 0,
    "force_close_h": 17,
    "force_close_m": 0,
    "contract_qty": 1.0,
    "max_premium": 400.0,
    "max_time_value": 350.0
  }
]
```

Startup sets enabled=True and preserves an existing role row. Defaults for other columns come from the schema below. Startup deletes old roles named Default Directional Hedge, Bullish Hedge and Bearish Hedge; it does not migrate them into the two named roles.

## Every Hedge strategy column: effect

| Field | Runtime meaning |
|---|---|
| `id` | Database identity; POST may locate a row by id. |
| `strategy_name` | Engine lookup requires exactly 1st Trader or 2nd Trader. API may create other names but engine does not schedule them. |
| `strategy_key` | Stored identifier; not the engine lookup key. |
| `enabled` | New-entry gate; does not suspend management of existing positions. |
| `locked` | Stored only; no enforced edit/entry lock. |
| `strategy_type` | Stored label; no algorithm selector. |
| `direction` | Bullish limits to PUT; Bearish to CALL; Auto/unrecognized strings compare both for first role. Second role is overridden by durable opposite-direction reference. |
| `executor_name` | Stored metadata only. |
| `contract_qty` | Original quantity for both option/futures, finite>0 enforced. No global maximum. Held quantity survives settings edits. |
| `max_premium` | Inclusive option mark cap, per unit not total spend. |
| `max_time_value` | Inclusive max(0,mark-intrinsic) cap, per unit. |
| `skip_weekends` | Role flag stored but not used; global SKIP_WEEKENDS applies. |
| `blackout_dates` | Stored only; no blackout filter. |
| `price_diff_percent` | Stored only; not clash gap or target distance. |
| `partial_profit_ratio` | Stored/exposed only; no partial option exit. |
| `partial_tp_multiplier` | Stored/exposed only; global FIRST_TP_OPTION_MULTIPLIER controls first-TP option exit. |
| `rebuy_mode` | Stored/exposed only; re-entry always strike +/- original full premium. |
| `extra_config_json` | Stored only; not parsed by current engine. |
| `trade_start_h` | IST entry start inclusive; hour. No comprehensive API range validation. |
| `trade_start_m` | IST entry start inclusive; minute. No comprehensive API range validation. |
| `trade_end_h` | IST entry end inclusive (whole minute); hour. No comprehensive API range validation. |
| `trade_end_m` | IST entry end inclusive (whole minute); minute. No comprehensive API range validation. |
| `force_close_h` | IST close deadline based on original session date; rolls next day when <= entry; hour. No comprehensive API range validation. |
| `force_close_m` | IST close deadline based on original session date; rolls next day when <= entry; minute. No comprehensive API range validation. |

The strategy POST writes only enabled, direction, trade_start_h/m, trade_end_h/m, force_close_h/m, contract_qty, max_premium and max_time_value (plus identity on creation). Other supplied fields are ignored. Use JSON booleans: bool("false") evaluates true in this implementation.

## Environment and fixed constants

| Setting | Behavior |
|---|---|
| DATABASE_URL | Environment override; otherwise absolute project-root hedgesnstraddle.db SQLite URL with check_same_thread=False. No dotenv loader exists. |
| SECRET_KEY | Environment override for JWT/password hash; fallback development literal is reproduced in source appendix. Changing it invalidates password hashes/tokens. |
| PORT | Used only by python main.py; default8080. Explicit uvicorn --port takes precedence when launching uvicorn directly. |
| JWT | HS256, expiry60*24*7 minutes, sub=username and role claim; authorization rechecks database role and active flag. |
| Engine loops | Fixed sleep2 seconds after each pass; not a guaranteed2-second data cadence. |
| Replay | POLL_MS5000, WINDOW_MS1800000, HISTORY_MS169200000, PAGE_LIMIT1000, MAX_PAGES5. |
| Data cache | Spot/futures2 seconds, options5 seconds; stale fallback max30 seconds. |
| Snapshot / websocket | Browser poll3 seconds; server websocket updates1 second. |

## When changes take effect

Global config saves apply immediately. New entry qty/filter/window settings are read from DB; held entry terms do not change. OCO multiplier is sampled at Straddle placement; Straddle TP multiplier at entry processing; first-TP Hedge option multiplier at futures TP processing. Gap is checked on future second-trader selection only. Force-close settings are recalculated for current sessions. Existing pending target prices remain locked. Wallet edits are immediate and have no deposit-ledger counterpart.
