# Exact condition and field-expression register

Generated from Python AST for active application modules. Line numbers refer to the frozen implementation appendix/source manifest. This is a completeness index, not an instruction to treat every display predicate as a trading gate. `if` includes elif; conditional expressions, while guards, assertions, comprehension filters and exception handlers are separately registered. Loop, function and exception ordering is in the full source appendix. Dictionary entries also cover nested API/UI payload fields; dynamic kwargs/setattr expressions appear in source.

## app/__init__.py

### Conditions and exception handlers

| Line | Kind | Exact expression |
|---|---|---|

### Dictionary fields and value expressions

| Line | Field/key | Value |
|---|---|---|

### Runtime attribute assignments

| Line | Attribute | Value |
|---|---|---|
## app/api/__init__.py

### Conditions and exception handlers

| Line | Kind | Exact expression |
|---|---|---|

### Dictionary fields and value expressions

| Line | Field/key | Value |
|---|---|---|

### Runtime attribute assignments

| Line | Attribute | Value |
|---|---|---|
## app/api/audit_routes.py

### Conditions and exception handlers

| Line | Kind | Exact expression |
|---|---|---|
| 18 | If | `config_type` |
| 34 | IfExp | `log.created_at` |

### Dictionary fields and value expressions

| Line | Field/key | Value |
|---|---|---|
| 25 | `'id'` | `log.id` |
| 26 | `'user_email'` | `log.user_email` |
| 27 | `'config_type'` | `log.config_type` |
| 28 | `'field_name'` | `log.field_name` |
| 29 | `'old_value'` | `log.old_value` |
| 30 | `'new_value'` | `log.new_value` |
| 31 | `'apply_mode'` | `log.apply_mode` |
| 32 | `'status'` | `log.status` |
| 33 | `'ip_address'` | `log.ip_address` |
| 34 | `'created_at'` | `log.created_at.strftime('%Y-%m-%d %H:%M:%S') if log.created_at else ''` |

### Runtime attribute assignments

| Line | Attribute | Value |
|---|---|---|
## app/api/auth_routes.py

### Conditions and exception handlers

| Line | Kind | Exact expression |
|---|---|---|
| 13 | If | `not user or not verify_password(form_data.password, user.password_hash)` |
| 19 | If | `not user.is_active` |

### Dictionary fields and value expressions

| Line | Field/key | Value |
|---|---|---|
| 17 | `'WWW-Authenticate'` | `'Bearer'` |
| 22 | `'role'` | `user.role` |
| 22 | `'sub'` | `user.username` |
| 24 | `'access_token'` | `access_token` |
| 25 | `'token_type'` | `'bearer'` |
| 26 | `'username'` | `user.username` |
| 27 | `'email'` | `user.email` |
| 28 | `'role'` | `user.role` |
| 34 | `'id'` | `current_user.id` |
| 35 | `'username'` | `current_user.username` |
| 36 | `'email'` | `current_user.email` |
| 37 | `'role'` | `current_user.role` |
| 38 | `'is_active'` | `current_user.is_active` |

### Runtime attribute assignments

| Line | Attribute | Value |
|---|---|---|
## app/api/config_routes.py

### Conditions and exception handlers

| Line | Kind | Exact expression |
|---|---|---|
| 39 | IfExp | `existing` |
| 41 | If | `old_val_str == new_val_str` |
| 44 | If | `existing` |
| 107 | If | `'FIRST_TP_OPTION_MULTIPLIER' in payload` |
| 110 | except | `(ValueError, TypeError)` |
| 112 | If | `isinstance(payload['FIRST_TP_OPTION_MULTIPLIER'], bool) or not math.isfinite(multiplier) or multiplier <= 0` |
| 115 | If | `'MIN_STRIKE_GAP' in payload` |
| 118 | except | `(ValueError, TypeError)` |
| 120 | If | `gap not in (250, 500)` |
| 130 | IfExp | `existing` |
| 132 | If | `old_val_str == new_val_str` |
| 135 | If | `existing` |
| 177 | If | `strat_id` |
| 179 | If | `not strategy` |
| 182 | If | `not strategy` |
| 189 | If | `'enabled' in payload` |
| 190 | If | `'direction' in payload` |
| 191 | If | `'trade_start_h' in payload` |
| 192 | If | `'trade_start_m' in payload` |
| 193 | If | `'trade_end_h' in payload` |
| 194 | If | `'trade_end_m' in payload` |
| 195 | If | `'force_close_h' in payload` |
| 196 | If | `'force_close_m' in payload` |
| 197 | If | `'contract_qty' in payload` |
| 198 | If | `'max_premium' in payload` |
| 199 | If | `'max_time_value' in payload` |

### Dictionary fields and value expressions

| Line | Field/key | Value |
|---|---|---|
| 18 | `'active'` | `{c.key: c.value for c in configs}` |
| 19 | `'pending'` | `{p.field_name: p.pending_value for p in pending}` |
| 65 | `'status'` | `'APPLIED'` |
| 66 | `'message'` | `'Configuration updated live immediately.'` |
| 67 | `'applied_fields'` | `applied_results` |
| 76 | `'active'` | `{c.key: c.value for c in configs}` |
| 77 | `'strategies'` | `[{'id': s.id, 'strategy_name': s.strategy_name, 'strategy_key': s.strategy_key, 'enabled': s.enabled, 'direction': s.direction, 'trade_start': f'{s.trade_start_h:02d}:{s.trade_start_m:02d}', 'trade_end': f'{s.trade_end_h:02d}:{s.trade_end_m:02d}', 'force_close': f'{s.force_close_h:02d}:{s.force_close_m:02d}', 'contract_qty': s.contract_qty, 'max_premium': s.max_premium, 'max_time_value': s.max_time_value, 'price_diff_percent': s.price_diff_percent, 'partial_profit_ratio': s.partial_profit_ratio, 'partial_tp_multiplier': s.partial_tp_multiplier, 'rebuy_mode': s.rebuy_mode} for s in strategies]` |
| 79 | `'id'` | `s.id` |
| 80 | `'strategy_name'` | `s.strategy_name` |
| 81 | `'strategy_key'` | `s.strategy_key` |
| 82 | `'enabled'` | `s.enabled` |
| 83 | `'direction'` | `s.direction` |
| 84 | `'trade_start'` | `f'{s.trade_start_h:02d}:{s.trade_start_m:02d}'` |
| 85 | `'trade_end'` | `f'{s.trade_end_h:02d}:{s.trade_end_m:02d}'` |
| 86 | `'force_close'` | `f'{s.force_close_h:02d}:{s.force_close_m:02d}'` |
| 87 | `'contract_qty'` | `s.contract_qty` |
| 88 | `'max_premium'` | `s.max_premium` |
| 89 | `'max_time_value'` | `s.max_time_value` |
| 90 | `'price_diff_percent'` | `s.price_diff_percent` |
| 91 | `'partial_profit_ratio'` | `s.partial_profit_ratio` |
| 92 | `'partial_tp_multiplier'` | `s.partial_tp_multiplier` |
| 93 | `'rebuy_mode'` | `s.rebuy_mode` |
| 97 | `'pending'` | `{p.field_name: p.pending_value for p in pending}` |
| 162 | `'status'` | `'APPLIED'` |
| 163 | `'message'` | `'Hedge configuration updated live immediately.'` |
| 164 | `'applied_fields'` | `applied_results` |
| 202 | `'message'` | `f"Strategy rules updated for '{strategy.strategy_name}'"` |
| 202 | `'status'` | `'SUCCESS'` |

### Runtime attribute assignments

| Line | Attribute | Value |
|---|---|---|
## app/api/dashboard_routes.py

### Conditions and exception handlers

| Line | Kind | Exact expression |
|---|---|---|
| 24 | IfExp | `straddle_sessions` |
| 29 | IfExp | `hedge_sessions` |
| 39 | comprehension filter | `isinstance(item, dict)` |
| 40 | except | `Exception` |
| 49 | If | `'FUTURES' in pos.symbol` |
| 51 | If | `pos.side.upper() in ['LONG', 'BUY']` |
| 58 | IfExp | `pos.side.upper() in ['LONG', 'BUY']` |
| 59 | except | `ValueError` |
| 70 | IfExp | `current_price is not None` |
| 71 | IfExp | `pnl is not None` |
| 78 | If | `straddle_engine.active_session_id` |
| 80 | IfExp | `active_ord` |
| 87 | If | `straddle_engine.state == 'IN_TRADE'` |
| 89 | If | `latest_sess and latest_sess.futures_entry_price` |
| 90 | IfExp | `latest_sess.futures_tp_price > latest_sess.futures_entry_price` |
| 98 | If | `mark_price <= 0` |
| 110 | IfExp | `straddle_engine.active_session_id` |
| 157 | If | `active_session` |
| 194 | If | `hw` |
| 231 | If | `sw` |
| 237 | If | `lt` |
| 255 | While | `True` |
| 268 | except | `WebSocketDisconnect` |
| 270 | except | `Exception` |

### Dictionary fields and value expressions

| Line | Field/key | Value |
|---|---|---|
| 63 | `'id'` | `pos.id` |
| 64 | `'session_id'` | `pos.session_id` |
| 65 | `'symbol'` | `pos.symbol` |
| 66 | `'side'` | `pos.side` |
| 67 | `'entry_price'` | `pos.entry_price` |
| 68 | `'qty'` | `pos.qty` |
| 69 | `'leverage'` | `pos.leverage` |
| 70 | `'current_price'` | `round(current_price, 2) if current_price is not None else None` |
| 71 | `'unrealized_pnl'` | `round(pnl, 2) if pnl is not None else None` |
| 99 | `'algo'` | `'System'` |
| 99 | `'detail'` | `'Mark price feed slow'` |
| 99 | `'severity'` | `'Warning'` |
| 99 | `'type'` | `'Binance API'` |
| 102 | `'market'` | `{'btc_mark_price': mark_price, 'btc_spot_price': spot_price, 'currency_symbol': '$'}` |
| 103 | `'btc_mark_price'` | `mark_price` |
| 104 | `'btc_spot_price'` | `spot_price` |
| 105 | `'currency_symbol'` | `'$'` |
| 107 | `'straddle'` | `{'state': straddle_engine.state, 'config': straddle_cfg, 'trade_qty': straddle_engine.session_qty(db, straddle_engine.active_session_id) if straddle_engine.active_session_id else float(straddle_cfg.get('TRADE_QTY', '10')), 'active_session': latest_straddle, 'live_futures_mark': straddle_engine.last_futures_mark, 'live_call_strike': straddle_engine.current_strike, 'live_put_strike': straddle_engine.current_strike, 'live_call_mark': straddle_engine.current_call_mark, 'live_put_mark': straddle_engine.current_put_mark, 'active_call_mark': straddle_engine.active_call_mark, 'active_put_mark': straddle_engine.active_put_mark, 'history': straddle_sessions, 'orders': straddle_orders, 'ledger': straddle_ledger, 'live_monitoring': straddle_engine.get_live_monitoring_snapshot(db)}` |
| 108 | `'state'` | `straddle_engine.state` |
| 109 | `'config'` | `straddle_cfg` |
| 110 | `'trade_qty'` | `straddle_engine.session_qty(db, straddle_engine.active_session_id) if straddle_engine.active_session_id else float(straddle_cfg.get('TRADE_QTY', '10'))` |
| 111 | `'active_session'` | `latest_straddle` |
| 112 | `'live_futures_mark'` | `straddle_engine.last_futures_mark` |
| 113 | `'live_call_strike'` | `straddle_engine.current_strike` |
| 114 | `'live_put_strike'` | `straddle_engine.current_strike` |
| 115 | `'live_call_mark'` | `straddle_engine.current_call_mark` |
| 116 | `'live_put_mark'` | `straddle_engine.current_put_mark` |
| 117 | `'active_call_mark'` | `straddle_engine.active_call_mark` |
| 118 | `'active_put_mark'` | `straddle_engine.active_put_mark` |
| 119 | `'history'` | `straddle_sessions` |
| 120 | `'orders'` | `straddle_orders` |
| 121 | `'ledger'` | `straddle_ledger` |
| 122 | `'live_monitoring'` | `straddle_engine.get_live_monitoring_snapshot(db)` |
| 124 | `'hedge'` | `{'state': hedge_engine.state, 'config': hedge_cfg, 'active_session': latest_hedge, 'history': hedge_sessions, 'orders': hedge_orders, 'positions': hedge_positions, 'live_monitoring': hedge_engine.get_live_monitoring_snapshot(db)}` |
| 125 | `'state'` | `hedge_engine.state` |
| 126 | `'config'` | `hedge_cfg` |
| 127 | `'active_session'` | `latest_hedge` |
| 128 | `'history'` | `hedge_sessions` |
| 129 | `'orders'` | `hedge_orders` |
| 130 | `'positions'` | `hedge_positions` |
| 131 | `'live_monitoring'` | `hedge_engine.get_live_monitoring_snapshot(db)` |
| 133 | `'health'` | `{'database_healthy': True, 'straddle_engine_healthy': straddle_engine.is_running, 'hedge_engine_healthy': hedge_engine.is_running, 'audit_issues': health_issues}` |
| 134 | `'database_healthy'` | `True` |
| 135 | `'straddle_engine_healthy'` | `straddle_engine.is_running` |
| 136 | `'hedge_engine_healthy'` | `hedge_engine.is_running` |
| 137 | `'audit_issues'` | `health_issues` |
| 139 | `'wallet'` | `{'paper_wallet_usdt': total_wallet_valuation, 'cash_balance': cash_balance, 'open_positions_val': open_positions_val, 'currency': 'USD'}` |
| 140 | `'paper_wallet_usdt'` | `total_wallet_valuation` |
| 141 | `'cash_balance'` | `cash_balance` |
| 142 | `'open_positions_val'` | `open_positions_val` |
| 143 | `'currency'` | `'USD'` |
| 162 | `'message'` | `logger_msg` |
| 162 | `'status'` | `'SUCCESS'` |
| 174 | `'message'` | `logger_msg` |
| 174 | `'status'` | `'SUCCESS'` |
| 213 | `'message'` | `'Hedge Trader records cleared for a fresh start. Straddle Panel remains untouched.'` |
| 213 | `'status'` | `'SUCCESS'` |
| 249 | `'message'` | `'Straddle Bot records cleared for a fresh start. Hedge Panel remains untouched.'` |
| 249 | `'status'` | `'SUCCESS'` |
| 260 | `'btc_mark'` | `mark_price` |
| 261 | `'btc_spot'` | `spot_price` |
| 262 | `'straddle_state'` | `straddle_engine.state` |
| 263 | `'hedge_state'` | `hedge_engine.state` |

### Runtime attribute assignments

| Line | Attribute | Value |
|---|---|---|
## app/api/report_routes.py

### Conditions and exception handlers

| Line | Kind | Exact expression |
|---|---|---|
| 29 | IfExp | `s.created_at` |
| 34 | IfExp | `h.expiry_session` |
| 38 | IfExp | `h.created_at` |

### Dictionary fields and value expressions

| Line | Field/key | Value |
|---|---|---|
| 45 | `'Content-Disposition'` | `'attachment; filename=Hedgesnstraddle_Trade_History.csv'` |

### Runtime attribute assignments

| Line | Attribute | Value |
|---|---|---|
## app/config.py

### Conditions and exception handlers

| Line | Kind | Exact expression |
|---|---|---|

### Dictionary fields and value expressions

| Line | Field/key | Value |
|---|---|---|

### Runtime attribute assignments

| Line | Attribute | Value |
|---|---|---|
## app/core/__init__.py

### Conditions and exception handlers

| Line | Kind | Exact expression |
|---|---|---|

### Dictionary fields and value expressions

| Line | Field/key | Value |
|---|---|---|

### Runtime attribute assignments

| Line | Attribute | Value |
|---|---|---|
## app/core/auth.py

### Conditions and exception handlers

| Line | Kind | Exact expression |
|---|---|---|
| 22 | If | `expires_delta` |
| 38 | If | `username is None` |
| 40 | except | `JWTError` |
| 44 | If | `user is None or not user.is_active` |
| 49 | If | `current_user.role.upper() != 'ADMIN'` |
| 58 | If | `forwarded` |
| 60 | IfExp | `request.client` |

### Dictionary fields and value expressions

| Line | Field/key | Value |
|---|---|---|
| 26 | `'exp'` | `expire` |
| 33 | `'WWW-Authenticate'` | `'Bearer'` |

### Runtime attribute assignments

| Line | Attribute | Value |
|---|---|---|
## app/core/binance_client.py

### Conditions and exception handlers

| Line | Kind | Exact expression |
|---|---|---|
| 26 | If | `symbol != 'BTCUSDT'` |
| 28 | If | `time.time() < _rate_limit_until.get('FUTURES_TRADES', 0)` |
| 31 | If | `from_id is not None` |
| 33 | If | `not latest` |
| 34 | If | `start_ms is None or end_ms is None or (not 0 <= end_ms - start_ms < 3600000)` |
| 40 | If | `response.status_code in (418, 429)` |
| 45 | If | `not isinstance(rows, list) or len(rows) > limit` |
| 49 | If | `not isinstance(row, dict)` |
| 51 | If | `row.get('symbol', symbol) != symbol` |
| 53 | If | `any((type(row.get(k)) is not int or row[k] < 0 for k in ('a', 'T')))` |
| 55 | If | `any((not math.isfinite(float(row[k])) or float(row[k]) <= 0 for k in ('p', 'q')))` |
| 57 | If | `from_id is not None and row['a'] < from_id` |
| 59 | If | `not latest and from_id is None and (not start_ms <= row['T'] <= end_ms)` |
| 61 | If | `previous and (row['a'] != previous['a'] + 1 or row['T'] < previous['T'])` |
| 65 | except | `(httpx.HTTPError, ValueError, TypeError, KeyError)` |
| 72 | If | `not rows` |
| 80 | If | `type(server_ms) is not int or server_ms < rows[-1]['T']` |
| 84 | except | `(httpx.HTTPError, ValueError, KeyError, TypeError)` |
| 90 | If | `cached and time.time() - cached[1] <= MAX_STALE_SECONDS` |
| 98 | If | `'BTCUSDT' in _price_cache and now - _price_cache['BTCUSDT'][1] < 2.0` |
| 107 | If | `resp.status_code == 200` |
| 109 | If | `price_val is not None` |
| 111 | If | `not math.isfinite(price) or price <= 0` |
| 115 | except | `Exception` |
| 124 | If | `'BTC_SPOT' in _price_cache and now - _price_cache['BTC_SPOT'][1] < 2.0` |
| 133 | If | `resp.status_code == 200` |
| 135 | If | `price_val is not None` |
| 137 | If | `not math.isfinite(price) or price <= 0` |
| 141 | except | `Exception` |
| 156 | If | `cache_key in _price_cache and now - _price_cache[cache_key][1] < 30.0` |
| 162 | If | `resp.status_code == 200` |
| 164 | If | `isinstance(data, list)` |
| 167 | comprehension filter | `isinstance(item, dict) and item.get('symbol', '').startswith('BTC-')` |
| 169 | If | `btc_opts` |
| 174 | except | `Exception` |
| 178 | If | `not res` |
| 203 | If | `now < ban_until` |
| 211 | If | `cache_key in _price_cache and now - _price_cache[cache_key][1] < 5.0` |
| 218 | If | `resp.status_code == 200` |
| 220 | If | `isinstance(data, list)` |
| 223 | comprehension filter | `isinstance(item, dict) and item.get('symbol', '').startswith('BTC-')` |
| 225 | If | `btc_marks` |
| 233 | If | `isinstance(data, dict) and data.get('code') == -1003` |
| 237 | If | `match` |
| 248 | If | `resp.status_code in (418, 429)` |
| 258 | except | `Exception` |
| 262 | If | `not res` |

### Dictionary fields and value expressions

| Line | Field/key | Value |
|---|---|---|
| 30 | `'limit'` | `limit` |
| 30 | `'symbol'` | `symbol` |
| 105 | `'symbol'` | `'BTCUSDT'` |
| 131 | `'symbol'` | `'BTCUSDT'` |

### Runtime attribute assignments

| Line | Attribute | Value |
|---|---|---|
## app/core/futures_targets.py

### Conditions and exception handlers

| Line | Kind | Exact expression |
|---|---|---|
| 23 | If | `value.tzinfo is None` |
| 30 | If | `symbol in ('BTC-USDT-FUTURES', 'BTCUSDT')` |
| 36 | If | `order.side not in ('BUY', 'SELL') or any((not math.isfinite(v) or v <= 0 for v in (order.price, order.qty)))` |
| 46 | If | `anchor` |
| 50 | If | `other_order is not None` |
| 51 | If | `contract_symbol(other_order.symbol) != symbol or other_order.qty != order.qty or other_order.side not in ('BUY', 'SELL') or (other_order.side == order.side) or (not math.isfinite(other_order.price)) or (other_order.price <= 0)` |
| 55 | IfExp | `order.side == 'SELL'` |
| 56 | IfExp | `order.side == 'SELL'` |
| 57 | If | `sell.price <= buy.price` |
| 72 | If | `event is None` |
| 76 | If | `order is None or order.session_id != session_id` |
| 84 | If | `state['active_ms'] > deadline or (state['active_ms'] == deadline and (not state.get('activation_trade_id')))` |
| 96 | If | `hit.get('order_id', order.id) != order.id or hit['fill_price'] != order.price` |
| 110 | If | `order.status != 'PENDING'` |
| 113 | If | `contract_symbol(order.symbol) != state['symbol'] or order.id != state['order_id'] or order.price != state['limit_price'] or (order.qty != state['qty']) or (order.side != state['side'])` |
| 117 | If | `state.get('hit')` |
| 120 | If | `other_order is not None` |
| 122 | If | `other_order.status != 'PENDING' or contract_symbol(other_order.symbol) != state['symbol'] or expected != dict(order_id=other_order.id, limit_price=other_order.price, qty=other_order.qty, side=other_order.side)` |
| 128 | IfExp | `until` |
| 129 | If | `end_ms <= state['active_ms'] or (until and replay_complete(event, until))` |
| 131 | If | `now_ms - state['checked_ms'] >= HISTORY_MS` |
| 133 | If | `now_ms - state['last_poll_ms'] < POLL_MS` |
| 135 | If | `state['last_id'] is None` |
| 139 | While | `(pages == 0 or state['checked_ms'] < end_ms) and pages < MAX_PAGES` |
| 141 | IfExp | `state['last_id'] is not None` |
| 142 | While | `pages < MAX_PAGES` |
| 145 | IfExp | `from_id is None` |
| 146 | IfExp | `from_id is None` |
| 151 | If | `state['last_id'] is not None and trade_id <= state['last_id']` |
| 153 | If | `state['last_id'] is not None and trade_id != state['last_id'] + 1` |
| 155 | If | `state.get('last_trade_ms') is not None and trade_ms < state['last_trade_ms']` |
| 157 | If | `trade_ms > window_end` |
| 167 | IfExp | `o.side == 'SELL'` |
| 167 | comprehension filter | `price >= o.price if o.side == 'SELL' else price <= o.price` |
| 168 | If | `len(qualifying) > 1` |
| 173 | If | `after_activation and qualifying` |
| 182 | If | `reached_end or len(rows) < PAGE_LIMIT` |
| 183 | If | `state['last_id'] is not None or reached_end` |
| 188 | If | `pages >= MAX_PAGES and state['checked_ms'] < window_end` |
| 190 | If | `not rows and state['last_id'] is None` |
| 193 | IfExp | `state['checked_ms'] >= end_ms` |

### Dictionary fields and value expressions

| Line | Field/key | Value |
|---|---|---|

### Runtime attribute assignments

| Line | Attribute | Value |
|---|---|---|
## app/core/hedge_engine.py

### Conditions and exception handlers

| Line | Kind | Exact expression |
|---|---|---|
| 38 | If | `mins_from_midnight >= session_start_mins` |
| 42 | except | `Exception` |
| 47 | If | `now_ist.time() >= datetime.strptime('13:30:00', '%H:%M:%S').time()` |
| 108 | IfExp | `slot1_cfg` |
| 109 | IfExp | `slot1_cfg` |
| 110 | IfExp | `slot1_cfg` |
| 111 | IfExp | `slot1_cfg` |
| 112 | IfExp | `slot1_cfg` |
| 113 | IfExp | `slot1_cfg` |
| 123 | If | `diff1_open < 0` |
| 124 | IfExp | `diff1_open > 0` |
| 127 | If | `diff1_sq < 0` |
| 131 | IfExp | `slot2_cfg` |
| 132 | IfExp | `slot2_cfg` |
| 133 | IfExp | `slot2_cfg` |
| 134 | IfExp | `slot2_cfg` |
| 135 | IfExp | `slot2_cfg` |
| 136 | IfExp | `slot2_cfg` |
| 146 | If | `diff2_open < 0` |
| 147 | IfExp | `diff2_open > 0` |
| 150 | If | `diff2_sq < 0` |
| 156 | IfExp | `slot1_cfg` |
| 157 | IfExp | `slot1_cfg` |
| 158 | IfExp | `slot1_cfg` |
| 169 | IfExp | `slot2_cfg` |
| 170 | IfExp | `slot2_cfg` |
| 171 | IfExp | `slot2_cfg` |
| 184 | If | `cfg.get('BOT_ENABLED', '1') != '1' or cfg.get('ENGINE_ENABLED', '1') != '1'` |
| 186 | If | `cfg.get('GLOBAL_PAUSE', '0') == '1'` |
| 191 | If | `not self.slot1_session_id` |
| 192 | If | `entry_block_reason` |
| 194 | If | `slot1_cfg and (not slot1_cfg.enabled)` |
| 196 | If | `getattr(self, 'slot1_completed', False) or self.slot1_traded_session_key == current_session_key` |
| 198 | If | `is_weekend_session() and cfg.get('SKIP_WEEKENDS', '1') == '1'` |
| 200 | If | `not w1_start_rel <= now_rel <= get_session_relative_minutes(w1_end)` |
| 202 | If | `s1_put_mark > s1_max_prem and s1_call_mark > s1_max_prem` |
| 204 | If | `s1_put_tv > s1_max_tv and s1_call_tv > s1_max_tv` |
| 206 | If | `s1_put_mark <= 0 and s1_call_mark <= 0` |
| 213 | If | `not self.slot2_session_id` |
| 214 | If | `entry_block_reason` |
| 216 | If | `slot2_cfg and (not slot2_cfg.enabled)` |
| 218 | If | `getattr(self, 'slot2_completed', False) or self.slot2_traded_session_key == current_session_key` |
| 220 | If | `is_weekend_session() and cfg.get('SKIP_WEEKENDS', '1') == '1'` |
| 222 | If | `not w2_start_rel <= now_rel <= get_session_relative_minutes(w2_end)` |
| 224 | If | `not getattr(self, 'preview_slot2_selected', None) and getattr(self, 'preview_slot2_required_direction', 'Auto') in ('Bullish', 'Bearish')` |
| 226 | If | `s2_put_mark > s2_max_prem and s2_call_mark > s2_max_prem` |
| 228 | If | `s2_put_tv > s2_max_tv and s2_call_tv > s2_max_tv` |
| 230 | If | `s2_put_mark <= 0 and s2_call_mark <= 0` |
| 237 | If | `self.slot1_session_id` |
| 246 | IfExp | `fut_pos1 and fut_pos1.entry_price > 0` |
| 247 | IfExp | `dir_str1 == 'Bullish'` |
| 252 | IfExp | `fut_pos1` |
| 252 | IfExp | `held_option1` |
| 254 | IfExp | `held_option1` |
| 255 | except | `ValueError` |
| 257 | IfExp | `dir_str1 == 'Bullish'` |
| 258 | If | `fut_pos1 is None` |
| 261 | IfExp | `opt_cur_mark1 is not None` |
| 263 | IfExp | `fut_entry1 * s1_qty > 0` |
| 265 | IfExp | `self.tp_rank_1_slot == '1st Trader'` |
| 265 | IfExp | `self.tp_rank_2_slot == '1st Trader'` |
| 269 | IfExp | `dir_str1 == 'Bullish'` |
| 274 | IfExp | `held_mark1 is not None` |
| 282 | If | `self.slot2_session_id` |
| 291 | IfExp | `fut_pos2 and fut_pos2.entry_price > 0` |
| 292 | IfExp | `dir_str2 == 'Bullish'` |
| 297 | IfExp | `fut_pos2` |
| 297 | IfExp | `held_option2` |
| 299 | IfExp | `held_option2` |
| 300 | except | `ValueError` |
| 302 | IfExp | `dir_str2 == 'Bullish'` |
| 303 | If | `fut_pos2 is None` |
| 306 | IfExp | `opt_cur_mark2 is not None` |
| 308 | IfExp | `fut_entry2 * s2_qty > 0` |
| 310 | IfExp | `self.tp_rank_1_slot == '2nd Trader'` |
| 310 | IfExp | `self.tp_rank_2_slot == '2nd Trader'` |
| 314 | IfExp | `dir_str2 == 'Bullish'` |
| 319 | IfExp | `held_mark2 is not None` |
| 343 | IfExp | `getattr(self, 'slot1_completed', False)` |
| 343 | IfExp | `self.slot1_session_id` |
| 346 | IfExp | `self.slot1_session_id` |
| 349 | IfExp | `self.slot1_session_id` |
| 350 | IfExp | `s1_active_trade` |
| 356 | IfExp | `s1_put_mark > 0` |
| 356 | IfExp | `slot1_cfg` |
| 358 | IfExp | `s1_put_mark > 0` |
| 359 | IfExp | `s1_put_mark > 0` |
| 367 | IfExp | `s1_call_mark > 0` |
| 367 | IfExp | `slot1_cfg` |
| 369 | IfExp | `s1_call_mark > 0` |
| 370 | IfExp | `s1_call_mark > 0` |
| 382 | IfExp | `getattr(self, 'slot2_completed', False)` |
| 382 | IfExp | `self.slot2_session_id` |
| 385 | IfExp | `self.slot2_session_id` |
| 388 | IfExp | `self.slot2_session_id` |
| 389 | IfExp | `s2_active_trade` |
| 395 | IfExp | `s2_put_mark > 0` |
| 395 | IfExp | `slot2_cfg` |
| 397 | IfExp | `s2_put_mark > 0` |
| 398 | IfExp | `s2_put_mark > 0` |
| 406 | IfExp | `s2_call_mark > 0` |
| 406 | IfExp | `slot2_cfg` |
| 408 | IfExp | `s2_call_mark > 0` |
| 409 | IfExp | `s2_call_mark > 0` |
| 424 | If | `not pending_items` |
| 430 | IfExp | `old_item` |
| 432 | If | `old_item` |
| 459 | If | `not math.isfinite(spot_price) or spot_price <= 0` |
| 463 | If | `not isinstance(quote, dict)` |
| 466 | If | `not isinstance(symbol, str)` |
| 469 | If | `len(parts) != 4 or parts[0] != 'BTC' or parts[3] not in ('C', 'P')` |
| 475 | except | `(ValueError, TypeError)` |
| 477 | If | `not timedelta(0) < expiry - now < timedelta(hours=24)` |
| 479 | If | `not math.isfinite(strike) or strike <= 0 or (not math.isfinite(premium)) or (premium <= 0)` |
| 481 | If | `direction == 'Bullish' and side != 'P' or (direction == 'Bearish' and side != 'C')` |
| 484 | If | `side == 'P' and strike < spot_price or (side == 'C' and strike > spot_price)` |
| 487 | If | `premium <= max_premium and tv <= max_time_value` |
| 489 | If | `not candidates` |
| 500 | If | `not option_mark or option_mark <= 0` |
| 502 | If | `option_type.upper() in ['PUT', 'P']` |
| 515 | If | `role == '2nd Trader'` |
| 523 | If | `first is None` |
| 526 | If | `len(parts) != 4 or parts[0] != 'BTC' or parts[3] not in ('P', 'C')` |
| 530 | If | `gap not in (250, 500) or not math.isfinite(strike) or strike <= 0` |
| 532 | IfExp | `parts[3] == 'P'` |
| 533 | If | `direction in ('Bullish', 'Bearish') and direction != required` |
| 538 | If | `not isinstance(quote, dict)` |
| 541 | IfExp | `isinstance(symbol, str)` |
| 542 | If | `len(candidate) != 4 or candidate[:2] != parts[:2]` |
| 546 | except | `ValueError` |
| 548 | If | `parts[3] == 'P' and candidate[3] == 'C' and (k <= strike - gap) or (parts[3] == 'C' and candidate[3] == 'P' and (k >= strike + gap))` |
| 552 | If | `not quotes` |
| 558 | If | `role_name == '2nd Trader'` |
| 566 | If | `first` |
| 567 | IfExp | `first.bull_entry` |
| 585 | If | `not role_config.enabled or cfg.get('BOT_ENABLED', '1') != '1' or cfg.get('ENGINE_ENABLED', '1') != '1' or (cfg.get('GLOBAL_PAUSE', '0') == '1')` |
| 588 | If | `not math.isfinite(qty) or qty <= 0` |
| 594 | If | `existing` |
| 597 | If | `quotes is None` |
| 604 | except | `ValueError` |
| 607 | IfExp | `opt_symbol.endswith('-P')` |
| 609 | If | `not math.isfinite(option_mark) or option_mark <= 0` |
| 616 | IfExp | `is_bullish` |
| 617 | IfExp | `is_bullish` |
| 624 | IfExp | `is_bullish` |
| 625 | IfExp | `not is_bullish` |
| 633 | IfExp | `is_bullish` |
| 673 | IfExp | `is_bullish` |
| 687 | If | `role_name == '1st Trader'` |
| 718 | If | `sess.expiry_session == key` |
| 720 | If | `sess.status not in ('Open', 'OPEN')` |
| 722 | If | `sess.status not in ('Open', 'OPEN')` |
| 725 | comprehension filter | `'FUTURES' in p.symbol` |
| 726 | comprehension filter | `'FUTURES' not in p.symbol` |
| 727 | If | `opt` |
| 732 | IfExp | `sess.bull_entry` |
| 744 | If | `cash is None` |
| 757 | If | `order is None` |
| 760 | IfExp | `bullish` |
| 761 | IfExp | `bullish` |
| 769 | comprehension filter | `'FUTURES' in p.symbol` |
| 770 | comprehension filter | `'FUTURES' not in p.symbol` |
| 771 | If | `not opt` |
| 777 | If | `fut and (not event)` |
| 779 | If | `target_order is None` |
| 783 | If | `target_order.symbol != fut.symbol or target_order.qty != fut.qty or target_order.side != ('SELL' if fut.side.upper() in ('LONG', 'BUY') else 'BUY') or (bullish != (fut.side.upper() in ('LONG', 'BUY'))) or (fut.entry_price != (sess.bull_entry or sess.bear_entry))` |
| 784 | IfExp | `fut.side.upper() in ('LONG', 'BUY')` |
| 790 | If | `until and (not replay_complete(tracking, until))` |
| 793 | If | `fut and (not event) and hit` |
| 800 | If | `rank == 1` |
| 803 | If | `not math.isfinite(multiplier) or multiplier <= 0 or (not math.isfinite(option_target)) or (option_target <= 0)` |
| 808 | IfExp | `bullish` |
| 813 | If | `bullish` |
| 822 | IfExp | `rank == 1` |
| 823 | IfExp | `rank == 1 or not bullish` |
| 824 | IfExp | `rank == 1` |
| 825 | IfExp | `bullish` |
| 825 | IfExp | `rank == 1` |
| 831 | If | `tp_only` |
| 835 | If | `order.order_type == 'OPTION_TARGET'` |
| 836 | If | `option_mark(self.option_quotes, opt.symbol) >= order.price` |
| 839 | If | `order.order_type == 'REENTRY_LIMIT' and fut is None` |
| 840 | IfExp | `order.side == 'BUY'` |
| 841 | If | `hit` |
| 845 | IfExp | `order.side == 'BUY'` |
| 851 | If | `session_ids is not None` |
| 854 | If | `not sessions` |
| 856 | IfExp | `self.slot1_session_id or self.slot2_session_id` |
| 863 | If | `not positions` |
| 866 | If | `not order` |
| 868 | IfExp | `'FUTURES' in pos.symbol` |
| 872 | If | `cash is None` |
| 881 | IfExp | `long` |
| 883 | IfExp | `reason == 'Option Target Hit'` |
| 885 | If | `target_order` |
| 890 | IfExp | `long` |
| 892 | If | `'FUTURES' in pos.symbol` |
| 893 | If | `long` |
| 900 | If | `pending.status == 'PENDING'` |
| 916 | IfExp | `self.slot1_session_id or self.slot2_session_id` |
| 923 | If | `manual` |
| 933 | If | `not active and (not enabled or paused or weekend)` |
| 934 | IfExp | `not enabled` |
| 934 | IfExp | `paused` |
| 947 | except | `ValueError` |
| 954 | If | `not config` |
| 961 | except | `ValueError` |
| 966 | except | `ValueError` |
| 976 | except | `ValueError` |
| 981 | If | `sid` |
| 985 | If | `deadline <= entry` |
| 988 | If | `now >= deadline` |
| 993 | except | `ValueError` |
| 1000 | IfExp | `start <= end` |
| 1002 | If | `not (enabled and (not paused) and (not weekend) and config.enabled and in_window)` |
| 1006 | except | `ValueError` |
| 1009 | IfExp | `active` |
| 1009 | IfExp | `not enabled` |
| 1009 | IfExp | `paused` |
| 1009 | IfExp | `weekend` |
| 1009 | IfExp | `window_open` |
| 1010 | If | `not active and enabled and (not paused) and (not weekend)` |
| 1015 | While | `self.is_running` |
| 1019 | except | `Exception` |
| 1027 | If | `not self.is_running` |
| 1032 | If | `self._task` |

### Dictionary fields and value expressions

| Line | Field/key | Value |
|---|---|---|
| 268 | `'direction'` | `dir_str1` |
| 269 | `'strategy_label'` | `'🟢 BULLISH (BUY PUT + LONG)' if dir_str1 == 'Bullish' else '🔴 BEARISH (BUY CALL + SHORT)'` |
| 270 | `'strike'` | `self.slot1_strike or 0.0` |
| 271 | `'option_entry_mark'` | `opt_mark1` |
| 272 | `'futures_entry'` | `fut_entry1` |
| 273 | `'futures_tp'` | `fut_tp1` |
| 274 | `'pnl_usdt'` | `round(pnl_total1, 2) if held_mark1 is not None else None` |
| 275 | `'data_available'` | `held_mark1 is not None` |
| 276 | `'pnl_pct'` | `round(pnl_pct1, 2)` |
| 277 | `'tp_rank'` | `rank1` |
| 313 | `'direction'` | `dir_str2` |
| 314 | `'strategy_label'` | `'🟢 BULLISH (BUY PUT + LONG)' if dir_str2 == 'Bullish' else '🔴 BEARISH (BUY CALL + SHORT)'` |
| 315 | `'strike'` | `self.slot2_strike or 0.0` |
| 316 | `'option_entry_mark'` | `opt_mark2` |
| 317 | `'futures_entry'` | `fut_entry2` |
| 318 | `'futures_tp'` | `fut_tp2` |
| 319 | `'pnl_usdt'` | `round(pnl_total2, 2) if held_mark2 is not None else None` |
| 320 | `'data_available'` | `held_mark2 is not None` |
| 321 | `'pnl_pct'` | `round(pnl_pct2, 2)` |
| 322 | `'tp_rank'` | `rank2` |
| 328 | `'state'` | `self.state` |
| 329 | `'active_role'` | `self.active_role` |
| 330 | `'server_time'` | `now_time_full` |
| 331 | `'last_spot_price'` | `self.last_spot_price` |
| 332 | `'last_futures_mark'` | `self.last_futures_mark` |
| 333 | `'hedge_paper_wallet_usdt'` | `hedge_wallet_val` |
| 334 | `'active_session_key'` | `current_session_key` |
| 335 | `'slot1'` | `{'role': '1st Trader', 'qty': s1_qty, 'window_start': w1_start, 'window_end': w1_end, 'sq_end': sq1_end, 'open_countdown': slot1_open_cd, 'squareoff_countdown': slot1_sq_cd, 'status': 'Active' if self.slot1_session_id else 'Completed' if getattr(self, 'slot1_completed', False) else 'Idle', 'idle_reason': s1_idle_reason, 'active_trade': s1_active_trade, 'filled_direction': getattr(self, 'slot1_direction', None) if self.slot1_session_id else None, 'filled_strike': self.slot1_strike or 0.0, 'filled_opt_mark': self.slot1_option_mark or 0.0, 'filled_fut_entry': getattr(self, 'slot1_fut_entry', 0.0) if self.slot1_session_id else 0.0, 'filled_fut_tp': s1_active_trade['futures_tp'] if s1_active_trade else 0.0, 'bullish': {'strike': s1_put_strk, 'option_type': 'PUT', 'selection_reason': getattr(self, 'preview_slot1_put_reason', ''), 'option_mark': s1_put_mark, 'estimated_option_cost': round(s1_put_mark * (slot1_cfg.contract_qty if slot1_cfg else 1.0), 2) if s1_put_mark > 0 else None, 'time_value': round(s1_put_tv, 2), 'rule_b_valid': s1_put_mark <= s1_max_prem if s1_put_mark > 0 else False, 'tv_valid': s1_put_tv <= s1_max_tv if s1_put_mark > 0 else False, 'futures_tp': self.last_futures_mark + s1_put_mark}, 'bearish': {'strike': s1_call_strk, 'option_type': 'CALL', 'selection_reason': getattr(self, 'preview_slot1_call_reason', ''), 'option_mark': s1_call_mark, 'estimated_option_cost': round(s1_call_mark * (slot1_cfg.contract_qty if slot1_cfg else 1.0), 2) if s1_call_mark > 0 else None, 'time_value': round(s1_call_tv, 2), 'rule_b_valid': s1_call_mark <= s1_max_prem if s1_call_mark > 0 else False, 'tv_valid': s1_call_tv <= s1_max_tv if s1_call_mark > 0 else False, 'futures_tp': self.last_futures_mark - s1_call_mark}}` |
| 336 | `'role'` | `'1st Trader'` |
| 337 | `'qty'` | `s1_qty` |
| 338 | `'window_start'` | `w1_start` |
| 339 | `'window_end'` | `w1_end` |
| 340 | `'sq_end'` | `sq1_end` |
| 341 | `'open_countdown'` | `slot1_open_cd` |
| 342 | `'squareoff_countdown'` | `slot1_sq_cd` |
| 343 | `'status'` | `'Active' if self.slot1_session_id else 'Completed' if getattr(self, 'slot1_completed', False) else 'Idle'` |
| 344 | `'idle_reason'` | `s1_idle_reason` |
| 345 | `'active_trade'` | `s1_active_trade` |
| 346 | `'filled_direction'` | `getattr(self, 'slot1_direction', None) if self.slot1_session_id else None` |
| 347 | `'filled_strike'` | `self.slot1_strike or 0.0` |
| 348 | `'filled_opt_mark'` | `self.slot1_option_mark or 0.0` |
| 349 | `'filled_fut_entry'` | `getattr(self, 'slot1_fut_entry', 0.0) if self.slot1_session_id else 0.0` |
| 350 | `'filled_fut_tp'` | `s1_active_trade['futures_tp'] if s1_active_trade else 0.0` |
| 351 | `'bullish'` | `{'strike': s1_put_strk, 'option_type': 'PUT', 'selection_reason': getattr(self, 'preview_slot1_put_reason', ''), 'option_mark': s1_put_mark, 'estimated_option_cost': round(s1_put_mark * (slot1_cfg.contract_qty if slot1_cfg else 1.0), 2) if s1_put_mark > 0 else None, 'time_value': round(s1_put_tv, 2), 'rule_b_valid': s1_put_mark <= s1_max_prem if s1_put_mark > 0 else False, 'tv_valid': s1_put_tv <= s1_max_tv if s1_put_mark > 0 else False, 'futures_tp': self.last_futures_mark + s1_put_mark}` |
| 352 | `'strike'` | `s1_put_strk` |
| 353 | `'option_type'` | `'PUT'` |
| 354 | `'selection_reason'` | `getattr(self, 'preview_slot1_put_reason', '')` |
| 355 | `'option_mark'` | `s1_put_mark` |
| 356 | `'estimated_option_cost'` | `round(s1_put_mark * (slot1_cfg.contract_qty if slot1_cfg else 1.0), 2) if s1_put_mark > 0 else None` |
| 357 | `'time_value'` | `round(s1_put_tv, 2)` |
| 358 | `'rule_b_valid'` | `s1_put_mark <= s1_max_prem if s1_put_mark > 0 else False` |
| 359 | `'tv_valid'` | `s1_put_tv <= s1_max_tv if s1_put_mark > 0 else False` |
| 360 | `'futures_tp'` | `self.last_futures_mark + s1_put_mark` |
| 362 | `'bearish'` | `{'strike': s1_call_strk, 'option_type': 'CALL', 'selection_reason': getattr(self, 'preview_slot1_call_reason', ''), 'option_mark': s1_call_mark, 'estimated_option_cost': round(s1_call_mark * (slot1_cfg.contract_qty if slot1_cfg else 1.0), 2) if s1_call_mark > 0 else None, 'time_value': round(s1_call_tv, 2), 'rule_b_valid': s1_call_mark <= s1_max_prem if s1_call_mark > 0 else False, 'tv_valid': s1_call_tv <= s1_max_tv if s1_call_mark > 0 else False, 'futures_tp': self.last_futures_mark - s1_call_mark}` |
| 363 | `'strike'` | `s1_call_strk` |
| 364 | `'option_type'` | `'CALL'` |
| 365 | `'selection_reason'` | `getattr(self, 'preview_slot1_call_reason', '')` |
| 366 | `'option_mark'` | `s1_call_mark` |
| 367 | `'estimated_option_cost'` | `round(s1_call_mark * (slot1_cfg.contract_qty if slot1_cfg else 1.0), 2) if s1_call_mark > 0 else None` |
| 368 | `'time_value'` | `round(s1_call_tv, 2)` |
| 369 | `'rule_b_valid'` | `s1_call_mark <= s1_max_prem if s1_call_mark > 0 else False` |
| 370 | `'tv_valid'` | `s1_call_tv <= s1_max_tv if s1_call_mark > 0 else False` |
| 371 | `'futures_tp'` | `self.last_futures_mark - s1_call_mark` |
| 374 | `'slot2'` | `{'role': '2nd Trader', 'qty': s2_qty, 'window_start': w2_start, 'window_end': w2_end, 'sq_end': sq2_end, 'open_countdown': slot2_open_cd, 'squareoff_countdown': slot2_sq_cd, 'status': 'Active' if self.slot2_session_id else 'Completed' if getattr(self, 'slot2_completed', False) else 'Idle', 'idle_reason': s2_idle_reason, 'active_trade': s2_active_trade, 'filled_direction': getattr(self, 'slot2_direction', None) if self.slot2_session_id else None, 'filled_strike': self.slot2_strike or 0.0, 'filled_opt_mark': self.slot2_option_mark or 0.0, 'filled_fut_entry': getattr(self, 'slot2_fut_entry', 0.0) if self.slot2_session_id else 0.0, 'filled_fut_tp': s2_active_trade['futures_tp'] if s2_active_trade else 0.0, 'bullish': {'strike': s2_put_strk, 'option_type': 'PUT', 'selection_reason': getattr(self, 'preview_slot2_put_reason', ''), 'option_mark': s2_put_mark, 'estimated_option_cost': round(s2_put_mark * (slot2_cfg.contract_qty if slot2_cfg else 1.0), 2) if s2_put_mark > 0 else None, 'time_value': round(s2_put_tv, 2), 'rule_b_valid': s2_put_mark <= s2_max_prem if s2_put_mark > 0 else False, 'tv_valid': s2_put_tv <= s2_max_tv if s2_put_mark > 0 else False, 'futures_tp': self.last_futures_mark + s2_put_mark}, 'bearish': {'strike': s2_call_strk, 'option_type': 'CALL', 'selection_reason': getattr(self, 'preview_slot2_call_reason', ''), 'option_mark': s2_call_mark, 'estimated_option_cost': round(s2_call_mark * (slot2_cfg.contract_qty if slot2_cfg else 1.0), 2) if s2_call_mark > 0 else None, 'time_value': round(s2_call_tv, 2), 'rule_b_valid': s2_call_mark <= s2_max_prem if s2_call_mark > 0 else False, 'tv_valid': s2_call_tv <= s2_max_tv if s2_call_mark > 0 else False, 'futures_tp': self.last_futures_mark - s2_call_mark}}` |
| 375 | `'role'` | `'2nd Trader'` |
| 376 | `'qty'` | `s2_qty` |
| 377 | `'window_start'` | `w2_start` |
| 378 | `'window_end'` | `w2_end` |
| 379 | `'sq_end'` | `sq2_end` |
| 380 | `'open_countdown'` | `slot2_open_cd` |
| 381 | `'squareoff_countdown'` | `slot2_sq_cd` |
| 382 | `'status'` | `'Active' if self.slot2_session_id else 'Completed' if getattr(self, 'slot2_completed', False) else 'Idle'` |
| 383 | `'idle_reason'` | `s2_idle_reason` |
| 384 | `'active_trade'` | `s2_active_trade` |
| 385 | `'filled_direction'` | `getattr(self, 'slot2_direction', None) if self.slot2_session_id else None` |
| 386 | `'filled_strike'` | `self.slot2_strike or 0.0` |
| 387 | `'filled_opt_mark'` | `self.slot2_option_mark or 0.0` |
| 388 | `'filled_fut_entry'` | `getattr(self, 'slot2_fut_entry', 0.0) if self.slot2_session_id else 0.0` |
| 389 | `'filled_fut_tp'` | `s2_active_trade['futures_tp'] if s2_active_trade else 0.0` |
| 390 | `'bullish'` | `{'strike': s2_put_strk, 'option_type': 'PUT', 'selection_reason': getattr(self, 'preview_slot2_put_reason', ''), 'option_mark': s2_put_mark, 'estimated_option_cost': round(s2_put_mark * (slot2_cfg.contract_qty if slot2_cfg else 1.0), 2) if s2_put_mark > 0 else None, 'time_value': round(s2_put_tv, 2), 'rule_b_valid': s2_put_mark <= s2_max_prem if s2_put_mark > 0 else False, 'tv_valid': s2_put_tv <= s2_max_tv if s2_put_mark > 0 else False, 'futures_tp': self.last_futures_mark + s2_put_mark}` |
| 391 | `'strike'` | `s2_put_strk` |
| 392 | `'option_type'` | `'PUT'` |
| 393 | `'selection_reason'` | `getattr(self, 'preview_slot2_put_reason', '')` |
| 394 | `'option_mark'` | `s2_put_mark` |
| 395 | `'estimated_option_cost'` | `round(s2_put_mark * (slot2_cfg.contract_qty if slot2_cfg else 1.0), 2) if s2_put_mark > 0 else None` |
| 396 | `'time_value'` | `round(s2_put_tv, 2)` |
| 397 | `'rule_b_valid'` | `s2_put_mark <= s2_max_prem if s2_put_mark > 0 else False` |
| 398 | `'tv_valid'` | `s2_put_tv <= s2_max_tv if s2_put_mark > 0 else False` |
| 399 | `'futures_tp'` | `self.last_futures_mark + s2_put_mark` |
| 401 | `'bearish'` | `{'strike': s2_call_strk, 'option_type': 'CALL', 'selection_reason': getattr(self, 'preview_slot2_call_reason', ''), 'option_mark': s2_call_mark, 'estimated_option_cost': round(s2_call_mark * (slot2_cfg.contract_qty if slot2_cfg else 1.0), 2) if s2_call_mark > 0 else None, 'time_value': round(s2_call_tv, 2), 'rule_b_valid': s2_call_mark <= s2_max_prem if s2_call_mark > 0 else False, 'tv_valid': s2_call_tv <= s2_max_tv if s2_call_mark > 0 else False, 'futures_tp': self.last_futures_mark - s2_call_mark}` |
| 402 | `'strike'` | `s2_call_strk` |
| 403 | `'option_type'` | `'CALL'` |
| 404 | `'selection_reason'` | `getattr(self, 'preview_slot2_call_reason', '')` |
| 405 | `'option_mark'` | `s2_call_mark` |
| 406 | `'estimated_option_cost'` | `round(s2_call_mark * (slot2_cfg.contract_qty if slot2_cfg else 1.0), 2) if s2_call_mark > 0 else None` |
| 407 | `'time_value'` | `round(s2_call_tv, 2)` |
| 408 | `'rule_b_valid'` | `s2_call_mark <= s2_max_prem if s2_call_mark > 0 else False` |
| 409 | `'tv_valid'` | `s2_call_tv <= s2_max_tv if s2_call_mark > 0 else False` |
| 410 | `'futures_tp'` | `self.last_futures_mark - s2_call_mark` |
| 413 | `'cond_time_window_valid'` | `cond_time_window_valid` |
| 414 | `'cond_rule_a_valid'` | `any((m > 0 for m in (s1_put_mark, s1_call_mark, s2_put_mark, s2_call_mark)))` |
| 415 | `'cond_rule_b_valid'` | `0 < s1_put_mark <= s1_max_prem or 0 < s1_call_mark <= s1_max_prem` |

### Runtime attribute assignments

| Line | Attribute | Value |
|---|---|---|
| 67 | `self.is_running` | `False` |
| 68 | `self.state` | `'IDLE'` |
| 69 | `self.active_role` | `'1st Trader'` |
| 70 | `self._task` | `None` |
| 73 | `self.slot1_session_id` | `None` |
| 74 | `self.slot2_session_id` | `None` |
| 75 | `self.slot1_strike` | `None` |
| 76 | `self.slot2_strike` | `None` |
| 77 | `self.slot1_option_mark` | `None` |
| 78 | `self.slot2_option_mark` | `None` |
| 80 | `self.slot1_traded_session_key` | `None` |
| 81 | `self.slot2_traded_session_key` | `None` |
| 82 | `self.active_session_key` | `None` |
| 84 | `self.tp_rank_1_slot` | `None` |
| 85 | `self.tp_rank_2_slot` | `None` |
| 87 | `self.option_quotes` | `[]` |
| 88 | `self.slot1_completed` | `False` |
| 89 | `self.slot2_completed` | `False` |
| 90 | `self.last_futures_mark` | `0.0` |
| 91 | `self.last_spot_price` | `0.0` |
| 688 | `self.slot1_session_id` | `sess.id` |
| 689 | `self.slot1_strike` | `strike` |
| 690 | `self.slot1_option_mark` | `option_mark` |
| 691 | `self.slot1_fut_entry` | `futures_mark` |
| 692 | `self.slot1_direction` | `direction` |
| 693 | `self.slot1_traded_session_key` | `current_session_key` |
| 695 | `self.slot2_session_id` | `sess.id` |
| 696 | `self.slot2_strike` | `strike` |
| 697 | `self.slot2_option_mark` | `option_mark` |
| 698 | `self.slot2_fut_entry` | `futures_mark` |
| 699 | `self.slot2_direction` | `direction` |
| 700 | `self.slot2_traded_session_key` | `current_session_key` |
| 707 | `self.active_session_key` | `key` |
| 708 | `self.tp_rank_1_slot` | `None` |
| 708 | `self.tp_rank_2_slot` | `None` |
| 856 | `self.state` | `'IN_TRADE' if self.slot1_session_id or self.slot2_session_id else 'COMPLETED'` |
| 916 | `self.state` | `'IN_TRADE' if self.slot1_session_id or self.slot2_session_id else 'COMPLETED'` |
| 934 | `self.state` | `'DISABLED' if not enabled else 'PAUSED' if paused else 'SKIP_WEEKEND'` |
| 943 | `self.last_spot_price` | `await get_btc_spot_price()` |
| 944 | `self.last_futures_mark` | `await get_btc_futures_mark_price()` |
| 946 | `self.option_quotes` | `await get_btc_options_mark_prices()` |
| 948 | `self.option_quotes` | `[]` |
| 1009 | `self.state` | `'IN_TRADE' if active else 'DISABLED' if not enabled else 'PAUSED' if paused else 'SKIP_WEEKEND' if weekend else 'ENTRY_WINDOW' if window_open else 'IDLE'` |
| 1014 | `self.is_running` | `True` |
| 1028 | `self._task` | `asyncio.create_task(self.run_loop())` |
| 1031 | `self.is_running` | `False` |
## app/core/market_data.py

### Conditions and exception handlers

| Line | Kind | Exact expression |
|---|---|---|
| 8 | If | `quote.get('symbol') == symbol` |
| 11 | except | `(KeyError, TypeError, ValueError)` |
| 13 | If | `math.isfinite(value) and value >= 0` |
| 24 | except | `(ValueError, IndexError)` |

### Dictionary fields and value expressions

| Line | Field/key | Value |
|---|---|---|

### Runtime attribute assignments

| Line | Attribute | Value |
|---|---|---|
## app/core/straddle_engine.py

### Conditions and exception handlers

| Line | Kind | Exact expression |
|---|---|---|
| 32 | If | `total_mins >= session_start_mins` |
| 36 | except | `Exception` |
| 82 | If | `not pending_items` |
| 88 | IfExp | `old_item` |
| 90 | If | `old_item` |
| 126 | If | `not symbol.endswith('-C') or not unexpired(symbol)` |
| 129 | If | `put_symbol not in symbols` |
| 135 | If | `call > 0 and put > 0` |
| 137 | except | `ValueError` |
| 139 | If | `not pairs` |
| 155 | If | `not order or not math.isfinite(order.qty) or order.qty <= 0` |
| 161 | If | `order is None` |
| 167 | IfExp | `entry.side == 'SELL'` |
| 176 | If | `event` |
| 179 | comprehension filter | `o.leg_label == 'SHORT_LIMIT'` |
| 180 | comprehension filter | `o.leg_label == 'LONG_LIMIT'` |
| 183 | If | `legacy` |
| 188 | If | `legacy` |
| 193 | IfExp | `sess.created_at.tzinfo is None` |
| 196 | IfExp | `deadline <= entry` |
| 203 | IfExp | `sess` |
| 204 | If | `not sess` |
| 205 | If | `not manual` |
| 211 | If | `order.leg_label == 'SHORT_LIMIT'` |
| 214 | If | `order.leg_label == 'LONG_LIMIT'` |
| 219 | If | `manual or sess.status == 'MANUAL_SQUAREOFF'` |
| 221 | If | `sess.futures_entry_price and sess.futures_entry_price > 0` |
| 223 | If | `self.is_short_limit_active or self.is_long_limit_active` |
| 257 | If | `self.nearest_expiry != 'N/A'` |
| 260 | If | `expiry_dt.weekday() in [5, 6]` |
| 262 | except | `Exception` |
| 300 | While | `self.is_running` |
| 307 | If | `not bot_enabled and (not self.active_session_id) and (self.state != 'SQUAREOFF')` |
| 321 | If | `self.active_session_id` |
| 332 | If | `not self.active_session_id` |
| 354 | If | `expiry != 'N/A' and skip_weekends` |
| 357 | If | `expiry_dt.weekday() in [5, 6]` |
| 359 | except | `Exception` |
| 362 | IfExp | `self.active_session_id` |
| 363 | IfExp | `self.active_session_id` |
| 366 | If | `bot_enabled and w_start_rel <= now_rel <= w_end_rel and (self.state in ['IDLE', 'COMPLETED'])` |
| 371 | If | `bot_enabled and w_start_rel <= now_rel <= w_end_rel and (self.state == 'ENTRY_WINDOW') and (not self.active_session_id)` |
| 379 | IfExp | `expiry != 'N/A'` |
| 382 | If | `premium_ok and gap_ok and (not is_weekend_session) and (not already_traded)` |
| 384 | If | `not math.isfinite(qty) or qty <= 0` |
| 410 | If | `last_traded_cfg` |
| 477 | IfExp | `wallet_item` |
| 479 | If | `wallet_item` |
| 505 | If | `self.state == 'LIMITS_PLACED' and self.active_session_id` |
| 514 | If | `hit` |
| 515 | IfExp | `hit['order_id'] == primary.id` |
| 516 | IfExp | `filled is primary` |
| 525 | IfExp | `filled.side == 'SELL'` |
| 537 | If | `replay_complete(tracking, cutoff)` |
| 546 | If | `self.state == 'IN_TRADE' and self.active_session_id` |
| 548 | If | `sess and sess.futures_tp_price` |
| 551 | If | `target_order is None` |
| 555 | If | `target_order.qty != self.session_qty(db, sess.id) or target_order.price != sess.futures_tp_price` |
| 557 | If | `target_order.side != ('BUY' if sess.futures_tp_price < sess.futures_entry_price else 'SELL')` |
| 557 | IfExp | `sess.futures_tp_price < sess.futures_entry_price` |
| 559 | IfExp | `sess.created_at.tzinfo is None` |
| 562 | If | `deadline <= entry_time` |
| 565 | If | `not tp_hit` |
| 567 | If | `datetime.now(ist) >= deadline and (not replay_complete(tracking, deadline))` |
| 570 | If | `tp_hit` |
| 586 | If | `sess.futures_entry_price and sess.futures_entry_price > 0` |
| 588 | If | `is_short` |
| 601 | IfExp | `wallet_item` |
| 603 | If | `wallet_item` |
| 662 | If | `self.state == 'RECOVERY' and self.active_session_id` |
| 664 | If | `sess` |
| 671 | If | `current_recovery_val >= recovery_threshold_pct * entry_premium` |
| 675 | IfExp | `sess.futures_entry_price` |
| 684 | IfExp | `wallet_item` |
| 686 | If | `wallet_item` |
| 733 | If | `self.state == 'LIMITS_PLACED' and now_rel >= sq_end_rel` |
| 737 | If | `self.state == 'SQUAREOFF' or (now_rel >= sq_end_rel and self.state in ['IN_TRADE', 'ENTRY_WINDOW', 'LIMITS_PLACED', 'RECOVERY'])` |
| 739 | If | `self.active_session_id` |
| 741 | If | `sess and sess.status in ['Open', 'OPEN', 'MANUAL_SQUAREOFF']` |
| 742 | IfExp | `self.state == 'SQUAREOFF'` |
| 746 | IfExp | `sess.futures_entry_price` |
| 758 | If | `sess.futures_entry_price and sess.futures_entry_price > 0` |
| 760 | If | `is_short` |
| 779 | IfExp | `wallet_item` |
| 781 | If | `wallet_item` |
| 825 | If | `sess.futures_entry_price and sess.futures_entry_price > 0` |
| 826 | IfExp | `sess.futures_tp_price and sess.futures_tp_price < sess.futures_entry_price` |
| 849 | except | `Exception` |
| 852 | If | `not self.active_session_id` |
| 864 | If | `not self.is_running` |
| 869 | If | `self._task` |

### Dictionary fields and value expressions

| Line | Field/key | Value |
|---|---|---|
| 267 | `'state'` | `self.state` |
| 268 | `'preview_data_available'` | `self.preview_data_available` |
| 269 | `'server_time'` | `now_time_full` |
| 270 | `'last_spot_price'` | `self.last_spot_price` |
| 271 | `'last_futures_mark'` | `self.last_futures_mark` |
| 272 | `'nearest_expiry'` | `self.nearest_expiry` |
| 273 | `'current_strike'` | `self.current_strike` |
| 274 | `'current_call_mark'` | `self.current_call_mark` |
| 275 | `'current_put_mark'` | `self.current_put_mark` |
| 276 | `'combined_premium'` | `self.combined_premium` |
| 277 | `'short_limit_price'` | `self.short_limit_price` |
| 278 | `'long_limit_price'` | `self.long_limit_price` |
| 281 | `'window_start'` | `window_start` |
| 282 | `'window_end'` | `window_end` |
| 283 | `'futures_entry_cutoff'` | `futures_entry_cutoff` |
| 284 | `'sq_end'` | `sq_end` |
| 285 | `'max_premium_limit'` | `max_premium_limit` |
| 286 | `'max_gap_limit'` | `max_gap_limit` |
| 289 | `'cond_time_window_valid'` | `self.cond_time_window_valid` |
| 290 | `'cond_premium_valid'` | `self.cond_premium_valid` |
| 291 | `'cond_premium_gap_valid'` | `self.cond_premium_gap_valid` |
| 292 | `'cond_same_strike_valid'` | `self.cond_same_strike_valid` |
| 293 | `'cond_itm_otm_valid'` | `self.cond_itm_otm_valid` |
| 294 | `'cond_weekend_skip'` | `self.cond_weekend_skip` |

### Runtime attribute assignments

| Line | Attribute | Value |
|---|---|---|
| 41 | `self.is_running` | `False` |
| 42 | `self.active_session_id` | `None` |
| 43 | `self.state` | `'IDLE'` |
| 46 | `self.last_spot_price` | `0.0` |
| 47 | `self.last_futures_mark` | `0.0` |
| 48 | `self.nearest_expiry` | `'N/A'` |
| 49 | `self.current_strike` | `0.0` |
| 50 | `self.current_call_mark` | `0.0` |
| 51 | `self.current_put_mark` | `0.0` |
| 52 | `self.combined_premium` | `0.0` |
| 55 | `self.active_call_mark` | `0.0` |
| 56 | `self.active_put_mark` | `0.0` |
| 59 | `self.short_limit_price` | `0.0` |
| 60 | `self.long_limit_price` | `0.0` |
| 61 | `self.is_short_limit_active` | `False` |
| 62 | `self.is_long_limit_active` | `False` |
| 63 | `self.target_tp_price` | `0.0` |
| 66 | `self.cond_time_window_valid` | `False` |
| 67 | `self.cond_premium_valid` | `False` |
| 68 | `self.cond_premium_gap_valid` | `False` |
| 69 | `self.cond_same_strike_valid` | `True` |
| 70 | `self.cond_itm_otm_valid` | `True` |
| 71 | `self.cond_weekend_skip` | `False` |
| 72 | `self.preview_data_available` | `False` |
| 74 | `self._task` | `None` |
| 203 | `self.active_session_id` | `sess.id if sess else None` |
| 206 | `self.state` | `'IDLE'` |
| 209 | `self.is_long_limit_active` | `False` |
| 209 | `self.is_short_limit_active` | `False` |
| 212 | `self.short_limit_price` | `order.price` |
| 213 | `self.is_short_limit_active` | `order.status == 'PENDING'` |
| 215 | `self.long_limit_price` | `order.price` |
| 216 | `self.is_long_limit_active` | `order.status == 'PENDING'` |
| 217 | `self.combined_premium` | `sess.net_straddle_ask` |
| 218 | `self.target_tp_price` | `sess.futures_tp_price or 0.0` |
| 220 | `self.state` | `'SQUAREOFF'` |
| 222 | `self.state` | `'IN_TRADE'` |
| 224 | `self.state` | `'LIMITS_PLACED'` |
| 226 | `self.state` | `'RECOVERY'` |
| 247 | `self.cond_time_window_valid` | `w_start_rel <= now_rel <= w_end_rel` |
| 248 | `self.cond_premium_valid` | `self.preview_data_available and self.combined_premium <= max_premium_limit` |
| 249 | `self.cond_premium_gap_valid` | `self.preview_data_available and abs(self.current_call_mark - self.current_put_mark) <= max_gap_limit` |
| 252 | `self.cond_itm_otm_valid` | `True` |
| 264 | `self.cond_weekend_skip` | `is_weekend and skip_weekends_enabled` |
| 298 | `self.is_running` | `True` |
| 308 | `self.state` | `'DISABLED'` |
| 310 | `self.preview_data_available` | `False` |
| 314 | `self.last_spot_price` | `spot` |
| 319 | `self.last_futures_mark` | `futures_mark` |
| 327 | `self.current_strike` | `strike` |
| 328 | `self.current_call_mark` | `call_mark` |
| 329 | `self.current_put_mark` | `put_mark` |
| 330 | `self.nearest_expiry` | `expiry` |
| 331 | `self.preview_data_available` | `True` |
| 334 | `self.combined_premium` | `call_mark + put_mark` |
| 335 | `self.short_limit_price` | `strike + self.combined_premium * oco_limit_multiplier` |
| 336 | `self.long_limit_price` | `strike - self.combined_premium * oco_limit_multiplier` |
| 362 | `self.active_call_mark` | `call_mark if self.active_session_id else 0.0` |
| 363 | `self.active_put_mark` | `put_mark if self.active_session_id else 0.0` |
| 367 | `self.state` | `'ENTRY_WINDOW'` |
| 406 | `self.active_session_id` | `new_sess.id` |
| 496 | `self.is_short_limit_active` | `True` |
| 497 | `self.is_long_limit_active` | `True` |
| 498 | `self.state` | `'LIMITS_PLACED'` |
| 526 | `self.target_tp_price` | `sess.futures_tp_price` |
| 533 | `self.is_long_limit_active` | `False` |
| 533 | `self.is_short_limit_active` | `False` |
| 534 | `self.state` | `'IN_TRADE'` |
| 541 | `self.is_long_limit_active` | `False` |
| 541 | `self.is_short_limit_active` | `False` |
| 542 | `self.state` | `'RECOVERY'` |
| 657 | `self.active_session_id` | `None` |
| 658 | `self.state` | `'COMPLETED'` |
| 729 | `self.active_session_id` | `None` |
| 730 | `self.state` | `'COMPLETED'` |
| 842 | `self.active_session_id` | `None` |
| 844 | `self.state` | `'COMPLETED'` |
| 846 | `self.state` | `'IDLE'` |
| 851 | `self.preview_data_available` | `False` |
| 853 | `self.current_call_mark` | `0.0` |
| 853 | `self.current_put_mark` | `0.0` |
| 854 | `self.combined_premium` | `0.0` |
| 854 | `self.current_strike` | `0.0` |
| 855 | `self.long_limit_price` | `0.0` |
| 855 | `self.short_limit_price` | `0.0` |
| 856 | `self.nearest_expiry` | `'N/A'` |
| 865 | `self._task` | `asyncio.create_task(self.run_loop())` |
| 868 | `self.is_running` | `False` |
## app/database.py

### Conditions and exception handlers

| Line | Kind | Exact expression |
|---|---|---|
| 37 | If | `column not in existing` |
| 48 | If | `not admin` |
| 94 | If | `not existing` |
| 125 | If | `not existing` |
| 132 | If | `old_row` |
| 163 | If | `not existing` |
| 182 | except | `Exception` |

### Dictionary fields and value expressions

| Line | Field/key | Value |
|---|---|---|
| 28 | `'aggregate_trade_id'` | `'BIGINT'` |
| 28 | `'filled_at'` | `'TIMESTAMP'` |
| 28 | `'processed_at'` | `'TIMESTAMP'` |
| 28 | `'straddle_trade_orders'` | `{'filled_at': 'TIMESTAMP', 'processed_at': 'TIMESTAMP', 'aggregate_trade_id': 'BIGINT'}` |
| 29 | `'aggregate_trade_id'` | `'BIGINT'` |
| 29 | `'filled_at'` | `'TIMESTAMP'` |
| 29 | `'hedge_trade_orders'` | `{'filled_at': 'TIMESTAMP', 'processed_at': 'TIMESTAMP', 'aggregate_trade_id': 'BIGINT'}` |
| 29 | `'processed_at'` | `'TIMESTAMP'` |
| 30 | `'order_id'` | `'INTEGER'` |
| 30 | `'straddle_fills'` | `{'order_id': 'INTEGER'}` |
| 31 | `'hedge_fills'` | `{'order_id': 'INTEGER'}` |
| 31 | `'order_id'` | `'INTEGER'` |
| 62 | `'RUNTIME_MODE'` | `'Paper'` |
| 63 | `'BOT_ENABLED'` | `'1'` |
| 64 | `'PAPER_TRADING_ENABLED'` | `'1'` |
| 65 | `'WORKER_ID'` | `'straddle-worker-1'` |
| 66 | `'BINANCE_API_KEY'` | `''` |
| 67 | `'BINANCE_SECRET_KEY'` | `''` |
| 68 | `'TELEGRAM_TOKEN'` | `''` |
| 69 | `'TELEGRAM_CHAT_ID'` | `''` |
| 70 | `'WINDOW_START'` | `'18:50'` |
| 71 | `'WINDOW_END'` | `'18:55'` |
| 72 | `'FUTURES_ENTRY_CUTOFF'` | `'18:56'` |
| 73 | `'SQ_START'` | `'18:57'` |
| 74 | `'SQ_END'` | `'19:02'` |
| 75 | `'FUTURES_SQUAREOFF'` | `'19:02'` |
| 76 | `'STRADDLE_EXPIRY_TIME'` | `'19:00'` |
| 77 | `'TRADE_QTY'` | `'0.1'` |
| 78 | `'MIN_EXPIRY_HOURS'` | `'0.0'` |
| 79 | `'MAX_TOTAL_MARK'` | `'1500.0'` |
| 80 | `'MAX_PREMIUM_GAP'` | `'150.0'` |
| 81 | `'SKIP_WEEKENDS'` | `'1'` |
| 82 | `'FUTURES_TP_MULTIPLIER'` | `'1.0'` |
| 83 | `'OCO_LIMIT_MULTIPLIER'` | `'1.0'` |
| 84 | `'RECOVERY_THRESHOLD_PCT'` | `'0.65'` |
| 85 | `'SCAN_INTERVAL'` | `'1.0'` |
| 86 | `'RETRY_TIMEOUT'` | `'5.0'` |
| 87 | `'FUTURES_LEVERAGE'` | `'10'` |
| 88 | `'FUTURES_MM_RATE'` | `'0.004'` |
| 89 | `'PAPER_WALLET_USDT'` | `'100000.0'` |
| 90 | `'NOTES'` | `'Straddle Bot Default Configuration'` |
| 99 | `'MIN_STRIKE_GAP'` | `'500'` |
| 100 | `'RUNTIME_MODE'` | `'Paper'` |
| 101 | `'ENGINE_ENABLED'` | `'1'` |
| 102 | `'PAPER_TRADING_ENABLED'` | `'1'` |
| 103 | `'WORKER_ID'` | `'hedge-worker-1'` |
| 104 | `'WORKER_POLL_SECONDS'` | `'2'` |
| 105 | `'COMMAND_TIMEOUT_SECONDS'` | `'120'` |
| 106 | `'GLOBAL_PAUSE'` | `'0'` |
| 107 | `'SKIP_WEEKENDS'` | `'1'` |
| 108 | `'VIRTUAL_BALANCE_USDT'` | `'100000.0'` |
| 109 | `'MIN_PAPER_BALANCE'` | `'1000.0'` |
| 110 | `'FIRST_TP_OPTION_MULTIPLIER'` | `'1'` |
| 111 | `'SAFE_MODE_TIMEOUT_SEC'` | `'5'` |
| 112 | `'LATENCY_WARN_MS'` | `'500'` |
| 113 | `'FILL_TIMEOUT_SEC'` | `'5'` |
| 114 | `'SYMBOL'` | `'BTCUSDT'` |
| 115 | `'LEVERAGE'` | `'10'` |
| 116 | `'TRADE_QTY'` | `'0.05'` |
| 117 | `'BULL_TARGET_PCT'` | `'0.5'` |
| 118 | `'BEAR_TARGET_PCT'` | `'0.5'` |
| 119 | `'PAPER_WALLET_USDT'` | `'100000.0'` |
| 120 | `'BOT_ENABLED'` | `'1'` |
| 121 | `'NOTES'` | `'Hedge Trader Default Configuration'` |
| 139 | `'strategy_name'` | `'1st Trader'` |
| 140 | `'strategy_key'` | `'first_trader'` |
| 141 | `'direction'` | `'1st Trader Role'` |
| 142 | `'trade_start_h'` | `5` |
| 142 | `'trade_start_m'` | `0` |
| 143 | `'trade_end_h'` | `7` |
| 143 | `'trade_end_m'` | `0` |
| 144 | `'force_close_h'` | `13` |
| 144 | `'force_close_m'` | `0` |
| 145 | `'contract_qty'` | `1.0` |
| 146 | `'max_premium'` | `250.0` |
| 147 | `'max_time_value'` | `229.0` |
| 150 | `'strategy_name'` | `'2nd Trader'` |
| 151 | `'strategy_key'` | `'second_trader'` |
| 152 | `'direction'` | `'2nd Trader Role'` |
| 153 | `'trade_start_h'` | `7` |
| 153 | `'trade_start_m'` | `0` |
| 154 | `'trade_end_h'` | `11` |
| 154 | `'trade_end_m'` | `0` |
| 155 | `'force_close_h'` | `17` |
| 155 | `'force_close_m'` | `0` |
| 156 | `'contract_qty'` | `1.0` |
| 157 | `'max_premium'` | `400.0` |
| 158 | `'max_time_value'` | `350.0` |

### Runtime attribute assignments

| Line | Attribute | Value |
|---|---|---|
## app/models/__init__.py

### Conditions and exception handlers

| Line | Kind | Exact expression |
|---|---|---|

### Dictionary fields and value expressions

| Line | Field/key | Value |
|---|---|---|

### Runtime attribute assignments

| Line | Attribute | Value |
|---|---|---|
## app/models/schema.py

### Conditions and exception handlers

| Line | Kind | Exact expression |
|---|---|---|

### Dictionary fields and value expressions

| Line | Field/key | Value |
|---|---|---|

### Runtime attribute assignments

| Line | Attribute | Value |
|---|---|---|
## main.py

### Conditions and exception handlers

| Line | Kind | Exact expression |
|---|---|---|
| 59 | If | `__name__ == '__main__'` |

### Dictionary fields and value expressions

| Line | Field/key | Value |
|---|---|---|

### Runtime attribute assignments

| Line | Attribute | Value |
|---|---|---|
## readonly_mcp.py

### Conditions and exception handlers

| Line | Kind | Exact expression |
|---|---|---|
| 44 | If | `not self.database.is_file()` |
| 60 | If | `action == sqlite3.SQLITE_SELECT` |
| 62 | If | `action == sqlite3.SQLITE_READ and database == 'main' and (source is None) and (column in allowed.get(table, set()))` |
| 83 | If | `dataset not in TABLES` |
| 85 | If | `type(limit) is not int or not 1 <= limit <= 200` |
| 87 | If | `type(offset) is not int or not 0 <= offset <= 100000` |
| 92 | If | `session_id is not None` |
| 93 | If | `type(session_id) is not int or session_id < 1 or 'session_id' not in columns` |
| 104 | IfExp | `len(rows) > limit` |
| 107 | If | `strategy not in ('straddle', 'hedge')` |
| 154 | If | `__name__ == '__main__'` |

### Dictionary fields and value expressions

| Line | Field/key | Value |
|---|---|---|
| 15 | `'straddle_sessions'` | `'id expiry_sym expiry_dt status btc_entry_spot btc_entry_mark call_sym call_strike call_ask put_sym put_strike put_ask net_straddle_ask futures_entry_price futures_tp_price futures_exit_price opt_call_close_price opt_put_close_price pnl_realized created_at updated_at'` |
| 16 | `'straddle_trade_orders'` | `'id session_id paper_order_id symbol asset_type side leg_label order_type qty price status created_at'` |
| 17 | `'straddle_fills'` | `'id session_id instrument side fill_price fill_qty fee created_at'` |
| 18 | `'straddle_wallet_ledger'` | `'id session_id entry_type amount balance_after created_at'` |
| 19 | `'straddle_pnl_snapshots'` | `'id session_id btc_mark call_mark put_mark futures_mark unrealized_pnl realized_pnl created_at'` |
| 20 | `'straddle_runtime_status'` | `'id worker_id state last_heartbeat active_session_id'` |
| 21 | `'hedge_sessions'` | `'id symbol expiry_session status bull_entry bear_entry bull_exit bear_exit realized_pnl created_at updated_at'` |
| 22 | `'hedge_open_positions'` | `'id session_id symbol side entry_price qty leverage unrealized_pnl created_at'` |
| 23 | `'hedge_trade_orders'` | `'id session_id paper_order_id symbol side trader_leg order_type qty price status created_at'` |
| 24 | `'hedge_fills'` | `'id session_id trader_leg side fill_price fill_qty fee created_at'` |
| 25 | `'hedge_paper_ledger_entries'` | `'id session_id entry_type amount balance_after created_at'` |
| 26 | `'hedge_runtime_status'` | `'id worker_id state last_heartbeat'` |
| 27 | `'hedge_system_health_snapshots'` | `'id healthy database_connected open_positions_count issues_count created_at'` |
| 28 | `'hedge_strategy_configs'` | `'id strategy_name strategy_key enabled locked strategy_type direction trade_start_h trade_start_m trade_end_h trade_end_m force_close_h force_close_m skip_weekends contract_qty max_premium max_time_value price_diff_percent partial_profit_ratio partial_tp_multiplier rebuy_mode'` |
| 103 | `'dataset'` | `dataset` |
| 103 | `'rows'` | `[dict(row) for row in rows[:limit]]` |
| 104 | `'next_offset'` | `offset + limit if len(rows) > limit else None` |
| 115 | `'configuration'` | `{row['key']: row['value'] for row in rows}` |
| 115 | `'strategy'` | `strategy` |
| 134 | `'configuration_keys'` | `CONFIG_KEYS` |
| 134 | `'datasets'` | `TABLES` |
| 134 | `'max_limit'` | `200` |

### Runtime attribute assignments

| Line | Attribute | Value |
|---|---|---|
| 43 | `self.database` | `database.resolve(strict=True)` |
