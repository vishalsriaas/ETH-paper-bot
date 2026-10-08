# API and interface contract

Baseline: commit `1e3482f`. All paths below are relative to the application origin. See IMPLEMENTATION.md for exact serialization and CONDITIONS_AND_FIELDS.md for all nested dictionary value expressions. ORM rows serialize column fields including nulls; no separately versioned response models are declared.

## Endpoints

| Method / path | Permission | Request | Response / behavior |
|---|---|---|---|
| GET `/` | Public | None | index.html FileResponse |
| GET `/static/...` | Public | Asset path | Static HTML/JS/CSS assets |
| POST `/api/v1/auth/login` | Public | URL-encoded username, password | access_token, token_type=bearer, username, email, role; invalid credentials401, disabled account403 |
| GET `/api/v1/auth/me` | Bearer active user | None | id, username, email, role, is_active |
| GET `/api/v1/config/straddle` | Public | None | active key/value map; pending field/value map |
| POST `/api/v1/config/straddle` | ADMIN | JSON key/value map | status=APPLIED, message, applied_fields; values converted with str(), unchanged values skipped; audit row per changed field |
| GET `/api/v1/config/hedge` | Public | None | active map, pending map, strategies list |
| POST `/api/v1/config/hedge` | ADMIN | JSON key/value map | status=APPLIED, message, applied_fields; changed keys clear matching legacy pending entries; per-field audit |
| POST `/api/v1/config/hedge/strategies` | ADMIN | id or strategy_name plus editable fields | status=SUCCESS, message; create if not found; immediate commit |
| GET `/api/v1/dashboard/snapshot` | Public | None | market, straddle, hedge, health, wallet objects; can fail if required market feed unavailable |
| POST `/api/v1/dashboard/straddle/squareoff` | ADMIN | No required body | Sets engine SQUAREOFF, sets first open session MANUAL_SQUAREOFF and request reason; actual execution deferred to loop |
| POST `/api/v1/dashboard/hedge/squareoff` | ADMIN | No required body | Persists SQUAREOFF/QUEUED command, sets engine SQUAREOFF; actual execution deferred to loop |
| POST `/api/v1/dashboard/straddle/reset` | ADMIN | No required body | Clears panel data and wallet/expiry lock; status=SUCCESS, message |
| POST `/api/v1/dashboard/hedge/reset` | ADMIN | No required body | Clears panel data and wallet, queued commands; status=SUCCESS, message |
| WebSocket `/api/v1/dashboard/ws/live` | Public | No auth or subscription body | Every1 second: btc_mark, btc_spot, straddle_state, hedge_state; closes on exception/disconnect |
| GET `/api/v1/audit/logs` | Bearer active user | Optional config_type; limit default100, bounds1..1000 | Descending audit rows: id,user_email,config_type,field_name,old_value,new_value,apply_mode,status,ip_address,created_at |
| GET `/api/v1/reports/trades.csv` | Bearer active user | None | All Straddle sessions then all Hedge sessions, each descending ID; session summary, not full fill history |

FastAPI also exposes its normal `/docs`, `/redoc`, `/openapi.json` unless defaults are changed. No CORS middleware, CSRF-specific middleware, reverse-proxy authentication or TLS termination is configured in main.py.

Config validation: MIN_STRIKE_GAP accepts numeric250 or500, normalized to integer string; FIRST_TP_OPTION_MULTIPLIER must be finite>0 and not boolean, normalized to float string. Invalid values return422 before DB changes. Arbitrary other global values are accepted as strings; engines may later fail converting them. There is no whitelist preventing an ADMIN from editing PAPER_WALLET_USDT.

Role POST fields: enabled (bool conversion), direction (str), trade_start_h/m, trade_end_h/m, force_close_h/m (int), contract_qty, max_premium, max_time_value (float). Unknown fields are ignored. id lookup falls back to strategy_name, which defaults to legacy `Bullish Hedge`; create strategy_key from lowercase name with spaces replaced by underscores. Exact engine role names must be used. No per-field strategy audit is created.

Hedge config strategies response contains id,strategy_name,strategy_key,enabled,direction, formatted trade_start/trade_end/force_close,contract_qty,max_premium,max_time_value,price_diff_percent,partial_profit_ratio,partial_tp_multiplier,rebuy_mode. The last four do not implement trading behavior even though returned.

## Snapshot top-level fields

| Object | Fields / calculation |
|---|---|
| market | btc_mark_price,btc_spot_price,currency_symbol='$' |
| straddle | state,config,trade_qty,active_session,live_futures_mark,live_call_strike,live_put_strike,live_call_mark,live_put_mark,active_call_mark,active_put_mark,history,orders,ledger,live_monitoring |
| hedge | state,config,active_session,history,orders,positions,live_monitoring |
| health | database_healthy=true, straddle_engine_healthy=is_running, hedge_engine_healthy=is_running, audit_issues |
| wallet | paper_wallet_usdt=round(cash+open_positions_val,2),cash_balance,open_positions_val,currency='USD'; this object belongs to Straddle |

Session lists are last10, order lists last50, Straddle ledger last50. active_session is the first/latest session regardless of completion. Hedge positions are all rows. Neither list is paginated by this endpoint. Config responses include arbitrary stored keys and are public; do not assume stored legacy credentials are protected from readers.

Hedge position response: id,session_id,symbol,side,entry_price,qty,leverage,current_price,unrealized_pnl. FUTURES substring selects the single BTC mark feed; other symbols use exact option lookup. LONG/BUY uses positive price difference, other side negative. Option lookup failure yields both current_price and unrealized_pnl=null. Rounded display fields retain the original basis separately.

Straddle open_positions_val = (active_call_mark+active_put_mark)*Q plus signed futures unrealized PnL only when state IN_TRADE. Q in this wallet calculation is the first session order's qty (normally original option order) or global fallback; separate `trade_qty` uses strict original filled-option quantity. Futures direction is inferred by TP above/below entry. This inference relies on valid positive target-distance configuration.

Health fields are not comprehensive reconciliation/data-integrity checks. A live coroutine can report healthy while repeatedly logging data errors. audit_issues currently adds only a nonpositive futures-mark warning; the price client generally rejects such values earlier.

## Live-monitoring fields

Straddle: state,preview_data_available,server_time,last_spot_price,last_futures_mark,nearest_expiry,current_strike,current_call_mark,current_put_mark,combined_premium,short_limit_price,long_limit_price,window_start,window_end,futures_entry_cutoff,sq_end,max_premium_limit,max_gap_limit,cond_time_window_valid,cond_premium_valid,cond_premium_gap_valid,cond_same_strike_valid,cond_itm_otm_valid,cond_weekend_skip.

The premium/gap flags require preview_data_available. Same-strike and ITM/OTM flags are assumed true for the paired model. During an active session, combined_premium is the original session premium while current marks change; a display condition need not be a fresh entry decision.

Hedge: state,active_role,server_time,last_spot_price,last_futures_mark,hedge_paper_wallet_usdt,active_session_key,slot1,slot2,cond_time_window_valid,cond_rule_a_valid,cond_rule_b_valid. active_role is legacy in-memory label initialized1st Trader, not TP rank. cond_time_window_valid/cond_rule_b_valid refer to slot1; rule_a means at least one preview mark positive.

Each slot has role,qty,window_start,window_end,sq_end,open_countdown,squareoff_countdown,status,idle_reason,active_trade,filled_direction,filled_strike,filled_opt_mark,filled_fut_entry,filled_fut_tp,bullish,bearish. Each directional preview has strike,option_type,selection_reason,option_mark,estimated_option_cost,time_value,rule_b_valid,tv_valid,futures_tp. Estimated option cost=mark*configured role quantity; this is a display value, not a wallet debit/cap. Hypothetical futures_tp=current futures mark +/- preview option mark.

active_trade has direction,strategy_label,strike,option_entry_mark,futures_entry,futures_tp,pnl_usdt,pnl_pct,tp_rank. PnL is remaining held-position unrealized sum; missing option mark gives null PnL. Percentage denominator is futures entry*held qty. On re-entry futures_entry is the new open-position basis; displayed futures_tp still derives entry +/- original option premium even though no second regular TP is created. That is a display/computation limitation, not a pending order.

Countdown times are formatted HH:MM:00 using relative minutes and wrap negative differences by1440. New-entry gates use execution-specific time logic described in the main spec. Idle reasons prioritize disabled/paused, role disabled, traded/completed, weekend, time window, direction/quote/premium/TV; detailed per-direction selection_reason is the more specific clash explanation.

## Browser behavior and fields

The single-page interface consists of index.html, css/style.css and js/app.js. `data-view` navigation hides all panels then shows `view-<name>`, updates headings and fetches relevant config/audit data. Exact DOM IDs, labels, fields, styles and complete event handlers are embedded in IMPLEMENTATION.md; these files are part of the rebuild contract.

On load, ensureAuthToken attempts the built-in admin/Admin@123 login if no cached token; token/user are stored in localStorage. Config save retries once after401 by attempting this login. Auto-login is not a user-managed credential flow. Backend password hash is SHA256(password+SECRET_KEY), JWT HS256, expiration7 days. ADMIN authorization checks the active database user, not just JWT role. Forwarded-for is trusted for audit IP.

Snapshot polling every3 seconds updates panels; websocket supplements prices/states and reconnects after closure according to the JS handler. setInnerHTML avoids replacing content containing the focused input to reduce edit disruption. All precise frontend conditional behavior is in the embedded JS, not inferred from screenshots.

Global Hedge form fields: RUNTIME_MODE,ENGINE_ENABLED,PAPER_TRADING_ENABLED,GLOBAL_PAUSE,SKIP_WEEKENDS,MIN_STRIKE_GAP,FIRST_TP_OPTION_MULTIPLIER,WORKER_POLL_SECONDS,FILL_TIMEOUT_SEC. BOT_ENABLED is a backend gate but not one of these global form controls. Several visible fields are inert as documented. Gap is a250/500 selector; multiplier is numeric default1, step any; API rejects zero even though HTML min=0 allows it locally.

Straddle controls are enumerated by STRADDLE_FIELDS in the embedded JS and `cfg_straddle_...` HTML IDs. Inputs save raw value strings; no general engine-safe validation is present. Role forms save only supported fields and send a real Boolean enabled value.

Order time formatting replaces T with space and strips a trailing Z; it does not generally convert arbitrary UTC timestamps to IST. FILLED rows label fill time using filled_at, optionally milliseconds, or Not recorded; sublines show placement and processed values. Other statuses show placement. Never read this presentation as proof that UTC server-default timestamps were converted correctly.

Straddle active panel computes options(current-held-entry)*Q plus inferred futures PnL. Outside active statuses it resets these fields. Hedge hero wallet uses `value || 100000`, which incorrectly substitutes100000 for zero. Hedge hero total PnL is latest session's realized scalar, not a portfolio total. Session tables use session-level recorded values. Order rows show price rounded to2 decimals. CSV headers are Strategy,Session ID,Expiry/Symbol,Status,BTC Spot/Entry,Realized PnL ($),Exit Reason,Timestamp; Hedge CSV uses bull_entry even for bearish sessions, so it can show zero.

## Reset and authentication scope

Reset and square-off are different operations. Reset deletes records and resets a wallet; it does not sell positions at current prices. Stop the service before an offline reset to avoid concurrent writes. The reset API itself has no engine mutex. It preserves global configuration other than wallet/Straddle last expiry, role settings, users and configuration audits. Reset does not automatically enable/disable bots. Re-enabled/already-enabled bots can enter again for the same expiry after locks are deleted.

Optional readonly_mcp.py opens SQLite read-only, uses explicit table/column/config-key allowlists and an SQLite authorizer, limits query work, and does not import engines. Its allowlists predate clash/multiplier and fill-time additions, so those fields are not exposed by that MCP version. This optional interface is not needed for strategy execution; full source and MCP_README are embedded for duplication.
