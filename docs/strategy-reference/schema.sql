-- New-database SQLite DDL generated from models, not a migration.
-- Python-side defaults require application insertion logic; see DATABASE.md.


CREATE TABLE config_audit_logs (
	id INTEGER NOT NULL, 
	user_email VARCHAR(255) NOT NULL, 
	config_type VARCHAR(50) NOT NULL, 
	field_name VARCHAR(100) NOT NULL, 
	old_value TEXT, 
	new_value TEXT, 
	apply_mode VARCHAR(50) NOT NULL, 
	status VARCHAR(50), 
	ip_address VARCHAR(100), 
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
	PRIMARY KEY (id)
)

;

CREATE INDEX ix_config_audit_logs_id ON config_audit_logs (id);


CREATE TABLE hedge_config (
	"key" VARCHAR(255) NOT NULL, 
	value TEXT NOT NULL, 
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
	PRIMARY KEY ("key")
)

;


CREATE TABLE hedge_fills (
	id INTEGER NOT NULL, 
	session_id INTEGER NOT NULL, 
	trader_leg VARCHAR(50) NOT NULL, 
	side VARCHAR(50) NOT NULL, 
	fill_price FLOAT NOT NULL, 
	fill_qty FLOAT NOT NULL, 
	fee FLOAT, 
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
	order_id INTEGER, 
	PRIMARY KEY (id)
)

;

CREATE INDEX ix_hedge_fills_id ON hedge_fills (id);

CREATE INDEX ix_hedge_fills_order_id ON hedge_fills (order_id);


CREATE TABLE hedge_macro_events (
	id INTEGER NOT NULL, 
	event_name VARCHAR(100) NOT NULL, 
	event_time DATETIME NOT NULL, 
	impact_level VARCHAR(50), 
	action_taken TEXT, 
	PRIMARY KEY (id)
)

;

CREATE INDEX ix_hedge_macro_events_id ON hedge_macro_events (id);


CREATE TABLE hedge_open_positions (
	id INTEGER NOT NULL, 
	session_id INTEGER NOT NULL, 
	symbol VARCHAR(100) NOT NULL, 
	side VARCHAR(50) NOT NULL, 
	entry_price FLOAT NOT NULL, 
	qty FLOAT NOT NULL, 
	leverage INTEGER, 
	unrealized_pnl FLOAT, 
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
	PRIMARY KEY (id)
)

;

CREATE INDEX ix_hedge_open_positions_id ON hedge_open_positions (id);


CREATE TABLE hedge_order_block_zones (
	id INTEGER NOT NULL, 
	symbol VARCHAR(50), 
	timeframe VARCHAR(20), 
	zone_type VARCHAR(50) NOT NULL, 
	high_price FLOAT NOT NULL, 
	low_price FLOAT NOT NULL, 
	is_active BOOLEAN, 
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
	PRIMARY KEY (id)
)

;

CREATE INDEX ix_hedge_order_block_zones_id ON hedge_order_block_zones (id);


CREATE TABLE hedge_paper_ledger_entries (
	id INTEGER NOT NULL, 
	session_id INTEGER, 
	entry_type VARCHAR(100) NOT NULL, 
	amount FLOAT NOT NULL, 
	balance_after FLOAT NOT NULL, 
	detail TEXT, 
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
	PRIMARY KEY (id)
)

;

CREATE INDEX ix_hedge_paper_ledger_entries_id ON hedge_paper_ledger_entries (id);


CREATE TABLE hedge_runtime_commands (
	id INTEGER NOT NULL, 
	command VARCHAR(100) NOT NULL, 
	status VARCHAR(50), 
	payload_json TEXT, 
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
	PRIMARY KEY (id)
)

;

CREATE INDEX ix_hedge_runtime_commands_id ON hedge_runtime_commands (id);


CREATE TABLE hedge_runtime_status (
	id INTEGER NOT NULL, 
	worker_id VARCHAR(100) NOT NULL, 
	state VARCHAR(50) NOT NULL, 
	last_heartbeat DATETIME DEFAULT CURRENT_TIMESTAMP, 
	PRIMARY KEY (id)
)

;

CREATE INDEX ix_hedge_runtime_status_id ON hedge_runtime_status (id);


CREATE TABLE hedge_session_events (
	id INTEGER NOT NULL, 
	session_id INTEGER NOT NULL, 
	event_type VARCHAR(100) NOT NULL, 
	message TEXT NOT NULL, 
	payload_json TEXT, 
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
	PRIMARY KEY (id)
)

;

CREATE INDEX ix_hedge_session_events_id ON hedge_session_events (id);


CREATE TABLE hedge_sessions (
	id INTEGER NOT NULL, 
	symbol VARCHAR(50), 
	expiry_session VARCHAR(50), 
	status VARCHAR(50), 
	bull_entry FLOAT, 
	bear_entry FLOAT, 
	bull_exit FLOAT, 
	bear_exit FLOAT, 
	realized_pnl FLOAT, 
	exit_reason TEXT, 
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
	PRIMARY KEY (id)
)

;

CREATE INDEX ix_hedge_sessions_id ON hedge_sessions (id);


CREATE TABLE hedge_strategy_configs (
	id INTEGER NOT NULL, 
	strategy_name VARCHAR(100) NOT NULL, 
	strategy_key VARCHAR(100) NOT NULL, 
	enabled BOOLEAN, 
	locked BOOLEAN, 
	strategy_type VARCHAR(50), 
	direction VARCHAR(50), 
	executor_name VARCHAR(100), 
	trade_start_h INTEGER, 
	trade_start_m INTEGER, 
	trade_end_h INTEGER, 
	trade_end_m INTEGER, 
	force_close_h INTEGER, 
	force_close_m INTEGER, 
	skip_weekends BOOLEAN, 
	blackout_dates TEXT, 
	contract_qty FLOAT, 
	max_premium FLOAT, 
	max_time_value FLOAT, 
	price_diff_percent FLOAT, 
	partial_profit_ratio FLOAT, 
	partial_tp_multiplier FLOAT, 
	rebuy_mode VARCHAR(50), 
	extra_config_json TEXT, 
	PRIMARY KEY (id), 
	UNIQUE (strategy_name)
)

;

CREATE INDEX ix_hedge_strategy_configs_id ON hedge_strategy_configs (id);


CREATE TABLE hedge_system_health_snapshots (
	id INTEGER NOT NULL, 
	healthy BOOLEAN, 
	database_connected BOOLEAN, 
	open_positions_count INTEGER, 
	issues_count INTEGER, 
	snapshot_json TEXT, 
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
	PRIMARY KEY (id)
)

;

CREATE INDEX ix_hedge_system_health_snapshots_id ON hedge_system_health_snapshots (id);


CREATE TABLE hedge_trade_orders (
	id INTEGER NOT NULL, 
	session_id INTEGER, 
	paper_order_id INTEGER, 
	symbol VARCHAR(100) NOT NULL, 
	side VARCHAR(50) NOT NULL, 
	trader_leg VARCHAR(50) NOT NULL, 
	order_type VARCHAR(50) NOT NULL, 
	qty FLOAT NOT NULL, 
	price FLOAT, 
	status VARCHAR(50), 
	cancel_reason TEXT, 
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
	filled_at DATETIME, 
	processed_at DATETIME, 
	aggregate_trade_id BIGINT, 
	PRIMARY KEY (id)
)

;

CREATE INDEX ix_hedge_trade_orders_id ON hedge_trade_orders (id);

CREATE UNIQUE INDEX ix_hedge_trade_orders_paper_order_id ON hedge_trade_orders (paper_order_id);


CREATE TABLE pending_config_queue (
	id INTEGER NOT NULL, 
	config_type VARCHAR(50) NOT NULL, 
	field_name VARCHAR(100) NOT NULL, 
	pending_value TEXT NOT NULL, 
	user_email VARCHAR(255) NOT NULL, 
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
	PRIMARY KEY (id)
)

;

CREATE INDEX ix_pending_config_queue_id ON pending_config_queue (id);


CREATE TABLE straddle_config (
	"key" VARCHAR(255) NOT NULL, 
	value TEXT NOT NULL, 
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
	PRIMARY KEY ("key")
)

;


CREATE TABLE straddle_config_items (
	id INTEGER NOT NULL, 
	"key" VARCHAR(255) NOT NULL, 
	value TEXT NOT NULL, 
	description TEXT, 
	is_secret BOOLEAN, 
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
	PRIMARY KEY (id), 
	UNIQUE ("key")
)

;

CREATE INDEX ix_straddle_config_items_id ON straddle_config_items (id);


CREATE TABLE straddle_fills (
	id INTEGER NOT NULL, 
	session_id INTEGER NOT NULL, 
	instrument VARCHAR(100) NOT NULL, 
	side VARCHAR(50) NOT NULL, 
	fill_price FLOAT NOT NULL, 
	fill_qty FLOAT NOT NULL, 
	fee FLOAT, 
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
	order_id INTEGER, 
	PRIMARY KEY (id)
)

;

CREATE INDEX ix_straddle_fills_id ON straddle_fills (id);

CREATE INDEX ix_straddle_fills_order_id ON straddle_fills (order_id);


CREATE TABLE straddle_pnl_snapshots (
	id INTEGER NOT NULL, 
	session_id INTEGER NOT NULL, 
	btc_mark FLOAT, 
	call_mark FLOAT, 
	put_mark FLOAT, 
	futures_mark FLOAT, 
	unrealized_pnl FLOAT, 
	realized_pnl FLOAT, 
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
	PRIMARY KEY (id)
)

;

CREATE INDEX ix_straddle_pnl_snapshots_id ON straddle_pnl_snapshots (id);


CREATE TABLE straddle_runtime_commands (
	id INTEGER NOT NULL, 
	command VARCHAR(100) NOT NULL, 
	status VARCHAR(50), 
	payload_json TEXT, 
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
	PRIMARY KEY (id)
)

;

CREATE INDEX ix_straddle_runtime_commands_id ON straddle_runtime_commands (id);


CREATE TABLE straddle_runtime_status (
	id INTEGER NOT NULL, 
	worker_id VARCHAR(100) NOT NULL, 
	state VARCHAR(50) NOT NULL, 
	last_heartbeat DATETIME DEFAULT CURRENT_TIMESTAMP, 
	active_session_id INTEGER, 
	PRIMARY KEY (id)
)

;

CREATE INDEX ix_straddle_runtime_status_id ON straddle_runtime_status (id);


CREATE TABLE straddle_session_events (
	id INTEGER NOT NULL, 
	session_id INTEGER NOT NULL, 
	event_type VARCHAR(100) NOT NULL, 
	message TEXT NOT NULL, 
	payload_json TEXT, 
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
	PRIMARY KEY (id)
)

;

CREATE INDEX ix_straddle_session_events_id ON straddle_session_events (id);


CREATE TABLE straddle_sessions (
	id INTEGER NOT NULL, 
	expiry_sym VARCHAR(100) NOT NULL, 
	expiry_dt VARCHAR(100) NOT NULL, 
	status VARCHAR(50), 
	btc_entry_spot FLOAT, 
	btc_entry_mark FLOAT, 
	call_sym VARCHAR(100), 
	call_strike FLOAT, 
	call_ask FLOAT, 
	put_sym VARCHAR(100), 
	put_strike FLOAT, 
	put_ask FLOAT, 
	net_straddle_ask FLOAT, 
	futures_entry_price FLOAT, 
	futures_tp_price FLOAT, 
	futures_exit_price FLOAT, 
	opt_call_close_price FLOAT, 
	opt_put_close_price FLOAT, 
	pnl_realized FLOAT, 
	exit_reason TEXT, 
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
	PRIMARY KEY (id)
)

;

CREATE INDEX ix_straddle_sessions_id ON straddle_sessions (id);


CREATE TABLE straddle_trade_orders (
	id INTEGER NOT NULL, 
	session_id INTEGER, 
	paper_order_id INTEGER, 
	symbol VARCHAR(100) NOT NULL, 
	asset_type VARCHAR(50) NOT NULL, 
	side VARCHAR(50) NOT NULL, 
	leg_label VARCHAR(50) NOT NULL, 
	order_type VARCHAR(50) NOT NULL, 
	qty FLOAT NOT NULL, 
	price FLOAT, 
	status VARCHAR(50), 
	cancel_reason TEXT, 
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
	filled_at DATETIME, 
	processed_at DATETIME, 
	aggregate_trade_id BIGINT, 
	PRIMARY KEY (id)
)

;

CREATE INDEX ix_straddle_trade_orders_id ON straddle_trade_orders (id);

CREATE UNIQUE INDEX ix_straddle_trade_orders_paper_order_id ON straddle_trade_orders (paper_order_id);


CREATE TABLE straddle_wallet_ledger (
	id INTEGER NOT NULL, 
	session_id INTEGER, 
	entry_type VARCHAR(100) NOT NULL, 
	amount FLOAT NOT NULL, 
	balance_after FLOAT NOT NULL, 
	detail TEXT, 
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
	PRIMARY KEY (id)
)

;

CREATE INDEX ix_straddle_wallet_ledger_id ON straddle_wallet_ledger (id);


CREATE TABLE users (
	id INTEGER NOT NULL, 
	username VARCHAR(100) NOT NULL, 
	email VARCHAR(255) NOT NULL, 
	password_hash VARCHAR(255) NOT NULL, 
	role VARCHAR(50), 
	is_active BOOLEAN, 
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
	PRIMARY KEY (id)
)

;

CREATE UNIQUE INDEX ix_users_email ON users (email);

CREATE INDEX ix_users_id ON users (id);

CREATE UNIQUE INDEX ix_users_username ON users (username);
