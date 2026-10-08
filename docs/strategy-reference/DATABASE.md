# Database dictionary

All columns below are exact SQLAlchemy model definitions; SQL DEFAULT and Python-side defaults differ. `Column(default=...)` is an ORM insertion default, not a SQLite DEFAULT clause. Nullable is true unless explicitly false or a primary key. See schema.sql for new-database DDL. No ForeignKey constraints are declared. `session_id` and `order_id` are logical joins only.

Money, marks, quantities and PnL are FLOAT, not Decimal. Configuration values are TEXT. Dates use DateTime(timezone=True) declarations but SQLite does not enforce timezone semantics. Existing startup migration only adds nullable execution/order-link columns, without backfilling or adding all new-model indexes.

## config_audit_logs (`ConfigAuditLog`)

Global config updates and pending-config flushes; strategy-row updates do not create equivalent per-field audit rows.

| Field | Type | Nullable | Primary key | Unique | ORM/default expression |
|---|---|---|---|---|---|
| id | INTEGER | False | True | False | `Column(Integer, primary_key=True, index=True)` |
| user_email | VARCHAR(255) | False | False | False | `Column(String(255), nullable=False)` |
| config_type | VARCHAR(50) | False | False | False | `Column(String(50), nullable=False)` |
| field_name | VARCHAR(100) | False | False | False | `Column(String(100), nullable=False)` |
| old_value | TEXT | True | False | False | `Column(Text, nullable=True)` |
| new_value | TEXT | True | False | False | `Column(Text, nullable=True)` |
| apply_mode | VARCHAR(50) | False | False | False | `Column(String(50), nullable=False)` |
| status | VARCHAR(50) | True | False | False | `Column(String(50), default='APPLIED')` |
| ip_address | VARCHAR(100) | True | False | False | `Column(String(100), nullable=True)` |
| created_at | DATETIME | True | False | False | `Column(DateTime(timezone=True), server_default=func.now())` |

Indexes: `ix_config_audit_logs_id` (id)

## hedge_config (`HedgeConfig`)

Authoritative global key/value store and realized wallet.

| Field | Type | Nullable | Primary key | Unique | ORM/default expression |
|---|---|---|---|---|---|
| key | VARCHAR(255) | False | True | False | `Column(String(255), primary_key=True)` |
| value | TEXT | False | False | False | `Column(Text, nullable=False)` |
| updated_at | DATETIME | True | False | False | `Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())` |

Indexes: none

## hedge_fills (`HedgeFill`)

Only original replayed futures TP executions are written here; order_id supplies contract identity.

| Field | Type | Nullable | Primary key | Unique | ORM/default expression |
|---|---|---|---|---|---|
| id | INTEGER | False | True | False | `Column(Integer, primary_key=True, index=True)` |
| session_id | INTEGER | False | False | False | `Column(Integer, nullable=False)` |
| trader_leg | VARCHAR(50) | False | False | False | `Column(String(50), nullable=False)` |
| side | VARCHAR(50) | False | False | False | `Column(String(50), nullable=False)` |
| fill_price | FLOAT | False | False | False | `Column(Float, nullable=False)` |
| fill_qty | FLOAT | False | False | False | `Column(Float, nullable=False)` |
| fee | FLOAT | True | False | False | `Column(Float, default=0.0)` |
| created_at | DATETIME | True | False | False | `Column(DateTime(timezone=True), server_default=func.now())` |
| order_id | INTEGER | True | False | False | `Column(Integer, nullable=True, index=True)` |

Indexes: `ix_hedge_fills_id` (id); `ix_hedge_fills_order_id` (order_id)

## hedge_macro_events (`HedgeMacroEvent`)

Declared storage scaffold. Current trading engines do not populate/use this table as an active strategy rule.

| Field | Type | Nullable | Primary key | Unique | ORM/default expression |
|---|---|---|---|---|---|
| id | INTEGER | False | True | False | `Column(Integer, primary_key=True, index=True)` |
| event_name | VARCHAR(100) | False | False | False | `Column(String(100), nullable=False)` |
| event_time | DATETIME | False | False | False | `Column(DateTime(timezone=True), nullable=False)` |
| impact_level | VARCHAR(50) | True | False | False | `Column(String(50), default='HIGH')` |
| action_taken | TEXT | True | False | False | `Column(Text, nullable=True)` |

Indexes: `ix_hedge_macro_events_id` (id)

## hedge_open_positions (`HedgeOpenPosition`)

Live holdings. entry_price/qty are original basis per row; unrealized_pnl stored column remains default in normal engine path, API computes live value. leverage defaults10.

| Field | Type | Nullable | Primary key | Unique | ORM/default expression |
|---|---|---|---|---|---|
| id | INTEGER | False | True | False | `Column(Integer, primary_key=True, index=True)` |
| session_id | INTEGER | False | False | False | `Column(Integer, nullable=False)` |
| symbol | VARCHAR(100) | False | False | False | `Column(String(100), nullable=False)` |
| side | VARCHAR(50) | False | False | False | `Column(String(50), nullable=False)` |
| entry_price | FLOAT | False | False | False | `Column(Float, nullable=False)` |
| qty | FLOAT | False | False | False | `Column(Float, nullable=False)` |
| leverage | INTEGER | True | False | False | `Column(Integer, default=10)` |
| unrealized_pnl | FLOAT | True | False | False | `Column(Float, default=0.0)` |
| created_at | DATETIME | True | False | False | `Column(DateTime(timezone=True), server_default=func.now())` |

Indexes: `ix_hedge_open_positions_id` (id)

## hedge_order_block_zones (`HedgeOrderBlockZone`)

Declared storage scaffold. Current trading engines do not populate/use this table as an active strategy rule.

| Field | Type | Nullable | Primary key | Unique | ORM/default expression |
|---|---|---|---|---|---|
| id | INTEGER | False | True | False | `Column(Integer, primary_key=True, index=True)` |
| symbol | VARCHAR(50) | True | False | False | `Column(String(50), default='BTCUSDT')` |
| timeframe | VARCHAR(20) | True | False | False | `Column(String(20), default='15m')` |
| zone_type | VARCHAR(50) | False | False | False | `Column(String(50), nullable=False)` |
| high_price | FLOAT | False | False | False | `Column(Float, nullable=False)` |
| low_price | FLOAT | False | False | False | `Column(Float, nullable=False)` |
| is_active | BOOLEAN | True | False | False | `Column(Boolean, default=True)` |
| created_at | DATETIME | True | False | False | `Column(DateTime(timezone=True), server_default=func.now())` |

Indexes: `ix_hedge_order_block_zones_id` (id)

## hedge_paper_ledger_entries (`HedgePaperLedgerEntry`)

Realized increments: FUTURES_TP and SESSION_SQUAREOFF. No entry premium debit.

| Field | Type | Nullable | Primary key | Unique | ORM/default expression |
|---|---|---|---|---|---|
| id | INTEGER | False | True | False | `Column(Integer, primary_key=True, index=True)` |
| session_id | INTEGER | True | False | False | `Column(Integer, nullable=True)` |
| entry_type | VARCHAR(100) | False | False | False | `Column(String(100), nullable=False)` |
| amount | FLOAT | False | False | False | `Column(Float, nullable=False)` |
| balance_after | FLOAT | False | False | False | `Column(Float, nullable=False)` |
| detail | TEXT | True | False | False | `Column(Text, nullable=True)` |
| created_at | DATETIME | True | False | False | `Column(DateTime(timezone=True), server_default=func.now())` |

Indexes: `ix_hedge_paper_ledger_entries_id` (id)

## hedge_runtime_commands (`HedgeRuntimeCommand`)

SQUAREOFF QUEUED -> COMPLETED. Reset removes queued commands only.

| Field | Type | Nullable | Primary key | Unique | ORM/default expression |
|---|---|---|---|---|---|
| id | INTEGER | False | True | False | `Column(Integer, primary_key=True, index=True)` |
| command | VARCHAR(100) | False | False | False | `Column(String(100), nullable=False)` |
| status | VARCHAR(50) | True | False | False | `Column(String(50), default='QUEUED')` |
| payload_json | TEXT | True | False | False | `Column(Text, nullable=True)` |
| created_at | DATETIME | True | False | False | `Column(DateTime(timezone=True), server_default=func.now())` |

Indexes: `ix_hedge_runtime_commands_id` (id)

## hedge_runtime_status (`HedgeRuntimeStatus`)

Declared storage scaffold. Current trading engines do not populate/use this table as an active strategy rule.

| Field | Type | Nullable | Primary key | Unique | ORM/default expression |
|---|---|---|---|---|---|
| id | INTEGER | False | True | False | `Column(Integer, primary_key=True, index=True)` |
| worker_id | VARCHAR(100) | False | False | False | `Column(String(100), nullable=False)` |
| state | VARCHAR(50) | False | False | False | `Column(String(50), nullable=False)` |
| last_heartbeat | DATETIME | True | False | False | `Column(DateTime(timezone=True), server_default=func.now())` |

Indexes: `ix_hedge_runtime_status_id` (id)

## hedge_session_events (`HedgeSessionEvent`)

FUTURES_TP_TRACKING plus FUTURES_TP rank/execution events.

| Field | Type | Nullable | Primary key | Unique | ORM/default expression |
|---|---|---|---|---|---|
| id | INTEGER | False | True | False | `Column(Integer, primary_key=True, index=True)` |
| session_id | INTEGER | False | False | False | `Column(Integer, nullable=False)` |
| event_type | VARCHAR(100) | False | False | False | `Column(String(100), nullable=False)` |
| message | TEXT | False | False | False | `Column(Text, nullable=False)` |
| payload_json | TEXT | True | False | False | `Column(Text, nullable=True)` |
| created_at | DATETIME | True | False | False | `Column(DateTime(timezone=True), server_default=func.now())` |

Indexes: `ix_hedge_session_events_id` (id)

## hedge_sessions (`HedgeSession`)

One entry role per session. bull/bear entry/exit fields do not represent a full multi-execution position ledger.

| Field | Type | Nullable | Primary key | Unique | ORM/default expression |
|---|---|---|---|---|---|
| id | INTEGER | False | True | False | `Column(Integer, primary_key=True, index=True)` |
| symbol | VARCHAR(50) | True | False | False | `Column(String(50), default='BTCUSDT')` |
| expiry_session | VARCHAR(50) | True | False | False | `Column(String(50), nullable=True)` |
| status | VARCHAR(50) | True | False | False | `Column(String(50), default='Open')` |
| bull_entry | FLOAT | True | False | False | `Column(Float, default=0.0)` |
| bear_entry | FLOAT | True | False | False | `Column(Float, default=0.0)` |
| bull_exit | FLOAT | True | False | False | `Column(Float, default=0.0)` |
| bear_exit | FLOAT | True | False | False | `Column(Float, default=0.0)` |
| realized_pnl | FLOAT | True | False | False | `Column(Float, default=0.0)` |
| exit_reason | TEXT | True | False | False | `Column(Text, nullable=True)` |
| created_at | DATETIME | True | False | False | `Column(DateTime(timezone=True), server_default=func.now())` |
| updated_at | DATETIME | True | False | False | `Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())` |

Indexes: `ix_hedge_sessions_id` (id)

## hedge_strategy_configs (`HedgeStrategyConfig`)

Exactly named role rows drive hedge entry/deadline/filter rules.

| Field | Type | Nullable | Primary key | Unique | ORM/default expression |
|---|---|---|---|---|---|
| id | INTEGER | False | True | False | `Column(Integer, primary_key=True, index=True)` |
| strategy_name | VARCHAR(100) | False | False | True | `Column(String(100), unique=True, nullable=False)` |
| strategy_key | VARCHAR(100) | False | False | False | `Column(String(100), nullable=False)` |
| enabled | BOOLEAN | True | False | False | `Column(Boolean, default=True)` |
| locked | BOOLEAN | True | False | False | `Column(Boolean, default=False)` |
| strategy_type | VARCHAR(50) | True | False | False | `Column(String(50), default='Directional Hedge')` |
| direction | VARCHAR(50) | True | False | False | `Column(String(50), default='Bullish')` |
| executor_name | VARCHAR(100) | True | False | False | `Column(String(100), nullable=True)` |
| trade_start_h | INTEGER | True | False | False | `Column(Integer, default=5)` |
| trade_start_m | INTEGER | True | False | False | `Column(Integer, default=0)` |
| trade_end_h | INTEGER | True | False | False | `Column(Integer, default=7)` |
| trade_end_m | INTEGER | True | False | False | `Column(Integer, default=0)` |
| force_close_h | INTEGER | True | False | False | `Column(Integer, default=13)` |
| force_close_m | INTEGER | True | False | False | `Column(Integer, default=0)` |
| skip_weekends | BOOLEAN | True | False | False | `Column(Boolean, default=True)` |
| blackout_dates | TEXT | True | False | False | `Column(Text, nullable=True)` |
| contract_qty | FLOAT | True | False | False | `Column(Float, default=1.0)` |
| max_premium | FLOAT | True | False | False | `Column(Float, default=250.0)` |
| max_time_value | FLOAT | True | False | False | `Column(Float, default=229.0)` |
| price_diff_percent | FLOAT | True | False | False | `Column(Float, default=4.0)` |
| partial_profit_ratio | FLOAT | True | False | False | `Column(Float, default=1.1)` |
| partial_tp_multiplier | FLOAT | True | False | False | `Column(Float, default=1.1)` |
| rebuy_mode | VARCHAR(50) | True | False | False | `Column(String(50), default='tv_based')` |
| extra_config_json | TEXT | True | False | False | `Column(Text, nullable=True)` |

Indexes: `ix_hedge_strategy_configs_id` (id)

## hedge_system_health_snapshots (`HedgeSystemHealthSnapshot`)

Declared storage scaffold. Current trading engines do not populate/use this table as an active strategy rule.

| Field | Type | Nullable | Primary key | Unique | ORM/default expression |
|---|---|---|---|---|---|
| id | INTEGER | False | True | False | `Column(Integer, primary_key=True, index=True)` |
| healthy | BOOLEAN | True | False | False | `Column(Boolean, default=True)` |
| database_connected | BOOLEAN | True | False | False | `Column(Boolean, default=True)` |
| open_positions_count | INTEGER | True | False | False | `Column(Integer, default=0)` |
| issues_count | INTEGER | True | False | False | `Column(Integer, default=0)` |
| snapshot_json | TEXT | True | False | False | `Column(Text, nullable=True)` |
| created_at | DATETIME | True | False | False | `Column(DateTime(timezone=True), server_default=func.now())` |

Indexes: `ix_hedge_system_health_snapshots_id` (id)

## hedge_trade_orders (`HedgeTradeOrder`)

Option/futures MARKET entries/exits, original LIMIT TP, OPTION_TARGET and REENTRY_LIMIT. paper_order_id normally null; price of the latter two is overwritten on fill.

| Field | Type | Nullable | Primary key | Unique | ORM/default expression |
|---|---|---|---|---|---|
| id | INTEGER | False | True | False | `Column(Integer, primary_key=True, index=True)` |
| session_id | INTEGER | True | False | False | `Column(Integer, nullable=True)` |
| paper_order_id | INTEGER | True | False | True | `Column(Integer, unique=True, index=True)` |
| symbol | VARCHAR(100) | False | False | False | `Column(String(100), nullable=False)` |
| side | VARCHAR(50) | False | False | False | `Column(String(50), nullable=False)` |
| trader_leg | VARCHAR(50) | False | False | False | `Column(String(50), nullable=False)` |
| order_type | VARCHAR(50) | False | False | False | `Column(String(50), nullable=False)` |
| qty | FLOAT | False | False | False | `Column(Float, nullable=False)` |
| price | FLOAT | True | False | False | `Column(Float, default=0.0)` |
| status | VARCHAR(50) | True | False | False | `Column(String(50), default='Requested')` |
| cancel_reason | TEXT | True | False | False | `Column(Text, nullable=True)` |
| created_at | DATETIME | True | False | False | `Column(DateTime(timezone=True), server_default=func.now())` |
| filled_at | DATETIME | True | False | False | `Column(DateTime(timezone=True), nullable=True)` |
| processed_at | DATETIME | True | False | False | `Column(DateTime(timezone=True), nullable=True)` |
| aggregate_trade_id | BIGINT | True | False | False | `Column(BigInteger, nullable=True)` |

Indexes: `ix_hedge_trade_orders_id` (id); `ix_hedge_trade_orders_paper_order_id` (paper_order_id) UNIQUE

## pending_config_queue (`PendingConfig`)

Legacy deferred queue. Current normal config POSTs apply immediately; Straddle/Hedge flushing still consumes historical rows.

| Field | Type | Nullable | Primary key | Unique | ORM/default expression |
|---|---|---|---|---|---|
| id | INTEGER | False | True | False | `Column(Integer, primary_key=True, index=True)` |
| config_type | VARCHAR(50) | False | False | False | `Column(String(50), nullable=False)` |
| field_name | VARCHAR(100) | False | False | False | `Column(String(100), nullable=False)` |
| pending_value | TEXT | False | False | False | `Column(Text, nullable=False)` |
| user_email | VARCHAR(255) | False | False | False | `Column(String(255), nullable=False)` |
| created_at | DATETIME | True | False | False | `Column(DateTime(timezone=True), server_default=func.now())` |

Indexes: `ix_pending_config_queue_id` (id)

## straddle_config (`StraddleConfig`)

Authoritative global key/value store, expiry lock and cash wallet.

| Field | Type | Nullable | Primary key | Unique | ORM/default expression |
|---|---|---|---|---|---|
| key | VARCHAR(255) | False | True | False | `Column(String(255), primary_key=True)` |
| value | TEXT | False | False | False | `Column(Text, nullable=False)` |
| updated_at | DATETIME | True | False | False | `Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())` |

Indexes: none

## straddle_config_items (`StraddleConfigItem`)

Declared storage scaffold. Current trading engines do not populate/use this table as an active strategy rule.

| Field | Type | Nullable | Primary key | Unique | ORM/default expression |
|---|---|---|---|---|---|
| id | INTEGER | False | True | False | `Column(Integer, primary_key=True, index=True)` |
| key | VARCHAR(255) | False | False | True | `Column(String(255), unique=True, nullable=False)` |
| value | TEXT | False | False | False | `Column(Text, nullable=False)` |
| description | TEXT | True | False | False | `Column(Text, nullable=True)` |
| is_secret | BOOLEAN | True | False | False | `Column(Boolean, default=False)` |
| updated_at | DATETIME | True | False | False | `Column(DateTime(timezone=True), server_default=func.now())` |

Indexes: `ix_straddle_config_items_id` (id)

## straddle_fills (`StraddleFill`)

Only replayed OCO futures entries and futures targets are written here, not every FILLED order.

| Field | Type | Nullable | Primary key | Unique | ORM/default expression |
|---|---|---|---|---|---|
| id | INTEGER | False | True | False | `Column(Integer, primary_key=True, index=True)` |
| session_id | INTEGER | False | False | False | `Column(Integer, nullable=False)` |
| instrument | VARCHAR(100) | False | False | False | `Column(String(100), nullable=False)` |
| side | VARCHAR(50) | False | False | False | `Column(String(50), nullable=False)` |
| fill_price | FLOAT | False | False | False | `Column(Float, nullable=False)` |
| fill_qty | FLOAT | False | False | False | `Column(Float, nullable=False)` |
| fee | FLOAT | True | False | False | `Column(Float, default=0.0)` |
| created_at | DATETIME | True | False | False | `Column(DateTime(timezone=True), server_default=func.now())` |
| order_id | INTEGER | True | False | False | `Column(Integer, nullable=True, index=True)` |

Indexes: `ix_straddle_fills_id` (id); `ix_straddle_fills_order_id` (order_id)

## straddle_pnl_snapshots (`StraddlePnLSnapshot`)

Declared storage scaffold. Current trading engines do not populate/use this table as an active strategy rule.

| Field | Type | Nullable | Primary key | Unique | ORM/default expression |
|---|---|---|---|---|---|
| id | INTEGER | False | True | False | `Column(Integer, primary_key=True, index=True)` |
| session_id | INTEGER | False | False | False | `Column(Integer, nullable=False)` |
| btc_mark | FLOAT | True | False | False | `Column(Float, default=0.0)` |
| call_mark | FLOAT | True | False | False | `Column(Float, default=0.0)` |
| put_mark | FLOAT | True | False | False | `Column(Float, default=0.0)` |
| futures_mark | FLOAT | True | False | False | `Column(Float, default=0.0)` |
| unrealized_pnl | FLOAT | True | False | False | `Column(Float, default=0.0)` |
| realized_pnl | FLOAT | True | False | False | `Column(Float, default=0.0)` |
| created_at | DATETIME | True | False | False | `Column(DateTime(timezone=True), server_default=func.now())` |

Indexes: `ix_straddle_pnl_snapshots_id` (id)

## straddle_runtime_commands (`StraddleRuntimeCommand`)

Declared storage scaffold. Current trading engines do not populate/use this table as an active strategy rule.

| Field | Type | Nullable | Primary key | Unique | ORM/default expression |
|---|---|---|---|---|---|
| id | INTEGER | False | True | False | `Column(Integer, primary_key=True, index=True)` |
| command | VARCHAR(100) | False | False | False | `Column(String(100), nullable=False)` |
| status | VARCHAR(50) | True | False | False | `Column(String(50), default='QUEUED')` |
| payload_json | TEXT | True | False | False | `Column(Text, nullable=True)` |
| created_at | DATETIME | True | False | False | `Column(DateTime(timezone=True), server_default=func.now())` |

Indexes: `ix_straddle_runtime_commands_id` (id)

## straddle_runtime_status (`StraddleRuntimeStatus`)

Declared storage scaffold. Current trading engines do not populate/use this table as an active strategy rule.

| Field | Type | Nullable | Primary key | Unique | ORM/default expression |
|---|---|---|---|---|---|
| id | INTEGER | False | True | False | `Column(Integer, primary_key=True, index=True)` |
| worker_id | VARCHAR(100) | False | False | False | `Column(String(100), nullable=False)` |
| state | VARCHAR(50) | False | False | False | `Column(String(50), nullable=False)` |
| last_heartbeat | DATETIME | True | False | False | `Column(DateTime(timezone=True), server_default=func.now())` |
| active_session_id | INTEGER | True | False | False | `Column(Integer, nullable=True)` |

Indexes: `ix_straddle_runtime_status_id` (id)

## straddle_session_events (`StraddleSessionEvent`)

JSON cursor/evidence for FUTURES_ENTRY_TRACKING and FUTURES_TP_TRACKING.

| Field | Type | Nullable | Primary key | Unique | ORM/default expression |
|---|---|---|---|---|---|
| id | INTEGER | False | True | False | `Column(Integer, primary_key=True, index=True)` |
| session_id | INTEGER | False | False | False | `Column(Integer, nullable=False)` |
| event_type | VARCHAR(100) | False | False | False | `Column(String(100), nullable=False)` |
| message | TEXT | False | False | False | `Column(Text, nullable=False)` |
| payload_json | TEXT | True | False | False | `Column(Text, nullable=True)` |
| created_at | DATETIME | True | False | False | `Column(DateTime(timezone=True), server_default=func.now())` |

Indexes: `ix_straddle_session_events_id` (id)

## straddle_sessions (`StraddleSession`)

Basket state. call_ask/put_ask are entry marks, not asks. btc_entry_mark/call_sym/put_sym normally remain default/null.

| Field | Type | Nullable | Primary key | Unique | ORM/default expression |
|---|---|---|---|---|---|
| id | INTEGER | False | True | False | `Column(Integer, primary_key=True, index=True)` |
| expiry_sym | VARCHAR(100) | False | False | False | `Column(String(100), nullable=False)` |
| expiry_dt | VARCHAR(100) | False | False | False | `Column(String(100), nullable=False)` |
| status | VARCHAR(50) | True | False | False | `Column(String(50), default='OPEN')` |
| btc_entry_spot | FLOAT | True | False | False | `Column(Float, default=0.0)` |
| btc_entry_mark | FLOAT | True | False | False | `Column(Float, default=0.0)` |
| call_sym | VARCHAR(100) | True | False | False | `Column(String(100), nullable=True)` |
| call_strike | FLOAT | True | False | False | `Column(Float, default=0.0)` |
| call_ask | FLOAT | True | False | False | `Column(Float, default=0.0)` |
| put_sym | VARCHAR(100) | True | False | False | `Column(String(100), nullable=True)` |
| put_strike | FLOAT | True | False | False | `Column(Float, default=0.0)` |
| put_ask | FLOAT | True | False | False | `Column(Float, default=0.0)` |
| net_straddle_ask | FLOAT | True | False | False | `Column(Float, default=0.0)` |
| futures_entry_price | FLOAT | True | False | False | `Column(Float, default=0.0)` |
| futures_tp_price | FLOAT | True | False | False | `Column(Float, default=0.0)` |
| futures_exit_price | FLOAT | True | False | False | `Column(Float, default=0.0)` |
| opt_call_close_price | FLOAT | True | False | False | `Column(Float, default=0.0)` |
| opt_put_close_price | FLOAT | True | False | False | `Column(Float, default=0.0)` |
| pnl_realized | FLOAT | True | False | False | `Column(Float, default=0.0)` |
| exit_reason | TEXT | True | False | False | `Column(Text, nullable=True)` |
| created_at | DATETIME | True | False | False | `Column(DateTime(timezone=True), server_default=func.now())` |
| updated_at | DATETIME | True | False | False | `Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())` |

Indexes: `ix_straddle_sessions_id` (id)

## straddle_trade_orders (`StraddleTradeOrder`)

Option entries/exits and futures OCO/TP/market closes. paper_order_id normally null. Execution evidence is populated only for replayed futures orders.

| Field | Type | Nullable | Primary key | Unique | ORM/default expression |
|---|---|---|---|---|---|
| id | INTEGER | False | True | False | `Column(Integer, primary_key=True, index=True)` |
| session_id | INTEGER | True | False | False | `Column(Integer, nullable=True)` |
| paper_order_id | INTEGER | True | False | True | `Column(Integer, unique=True, index=True)` |
| symbol | VARCHAR(100) | False | False | False | `Column(String(100), nullable=False)` |
| asset_type | VARCHAR(50) | False | False | False | `Column(String(50), nullable=False)` |
| side | VARCHAR(50) | False | False | False | `Column(String(50), nullable=False)` |
| leg_label | VARCHAR(50) | False | False | False | `Column(String(50), nullable=False)` |
| order_type | VARCHAR(50) | False | False | False | `Column(String(50), nullable=False)` |
| qty | FLOAT | False | False | False | `Column(Float, nullable=False)` |
| price | FLOAT | True | False | False | `Column(Float, default=0.0)` |
| status | VARCHAR(50) | True | False | False | `Column(String(50), default='SUBMITTED')` |
| cancel_reason | TEXT | True | False | False | `Column(Text, nullable=True)` |
| created_at | DATETIME | True | False | False | `Column(DateTime(timezone=True), server_default=func.now())` |
| filled_at | DATETIME | True | False | False | `Column(DateTime(timezone=True), nullable=True)` |
| processed_at | DATETIME | True | False | False | `Column(DateTime(timezone=True), nullable=True)` |
| aggregate_trade_id | BIGINT | True | False | False | `Column(BigInteger, nullable=True)` |

Indexes: `ix_straddle_trade_orders_id` (id); `ix_straddle_trade_orders_paper_order_id` (paper_order_id) UNIQUE

## straddle_wallet_ledger (`StraddleWalletLedger`)

Signed cash movements: PREMIUM_BUY and TRADE_CLOSE. No automatic initial deposit row.

| Field | Type | Nullable | Primary key | Unique | ORM/default expression |
|---|---|---|---|---|---|
| id | INTEGER | False | True | False | `Column(Integer, primary_key=True, index=True)` |
| session_id | INTEGER | True | False | False | `Column(Integer, nullable=True)` |
| entry_type | VARCHAR(100) | False | False | False | `Column(String(100), nullable=False)` |
| amount | FLOAT | False | False | False | `Column(Float, nullable=False)` |
| balance_after | FLOAT | False | False | False | `Column(Float, nullable=False)` |
| detail | TEXT | True | False | False | `Column(Text, nullable=True)` |
| created_at | DATETIME | True | False | False | `Column(DateTime(timezone=True), server_default=func.now())` |

Indexes: `ix_straddle_wallet_ledger_id` (id)

## users (`User`)

Login and authorization. Seed admin only if missing.

| Field | Type | Nullable | Primary key | Unique | ORM/default expression |
|---|---|---|---|---|---|
| id | INTEGER | False | True | False | `Column(Integer, primary_key=True, index=True)` |
| username | VARCHAR(100) | False | False | True | `Column(String(100), unique=True, index=True, nullable=False)` |
| email | VARCHAR(255) | False | False | True | `Column(String(255), unique=True, index=True, nullable=False)` |
| password_hash | VARCHAR(255) | False | False | False | `Column(String(255), nullable=False)` |
| role | VARCHAR(50) | True | False | False | `Column(String(50), default='TRADER')` |
| is_active | BOOLEAN | True | False | False | `Column(Boolean, default=True)` |
| created_at | DATETIME | True | False | False | `Column(DateTime(timezone=True), server_default=func.now())` |

Indexes: `ix_users_email` (email) UNIQUE; `ix_users_id` (id); `ix_users_username` (username) UNIQUE
