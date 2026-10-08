# Hedgesnstraddle: complete strategy and application rebuild specification

Version: 2026-09-24. Source baseline: `1e3482fdba0de2def83b031dd8c7efce4e0b7558` (`new_2`).

This document describes the implemented paper simulator, including its imperfections. It is not a proposed trading system, an assertion of exchange fill accuracy, or a specification for live-money execution. Configuration stored on a particular deployment can override seeded defaults. No Linux settings or trading data were changed or assumed to be current during this documentation task.

## Reading and rebuilding from this package

Read this document for behavior, then the accompanying references for exhaustive details:

1. [Configuration dictionary](strategy-reference/CONFIGURATION.md): every seeded global parameter, consumer, fallback and every strategy-configuration column.
2. [Database dictionary and SQLite DDL](strategy-reference/DATABASE.md): all tables, columns, defaults, indexes, relationships and population caveats. [Executable DDL](strategy-reference/schema.sql).
3. [API and interface contract](strategy-reference/API_AND_UI.md): requests, responses, permissions, dashboard calculations and administrative behavior.
4. [Condition and field-expression register](strategy-reference/CONDITIONS_AND_FIELDS.md): source locations and exact expressions for every Python branch, loop/comprehension filter, persisted-column declaration, and dictionary field in active modules. This includes diagnostic branches that are not trading rules.
5. [Exact implementation appendix](strategy-reference/IMPLEMENTATION.md): complete source for the application, frontend, dependency declarations, optional read-only MCP and tests. It preserves details such as exception paths and rendering that cannot be safely inferred from prose. It contains the built-in development credentials present in source, not a dump of private credentials or the database.
6. [Reproduction and acceptance](strategy-reference/REPRODUCTION.md): reconstruction, startup, operating procedures, validation and the source manifest.

[Verification evidence and full regression-case index](strategy-reference/VERIFICATION.md).

The prose explains business meaning. The dictionaries enumerate fields. The condition register and embedded source remove ambiguity about incidental behavior. For exact behavioral duplication, reproduce the documented limitations as well; correcting them produces a changed system. Older planning documents and backup source files are not normative for this version.

## 1. Architecture and invariant conventions

One FastAPI process hosts two independent asynchronous engines. `main.py` initializes SQLAlchemy tables, adds missing execution timestamp columns, seeds missing configuration, then starts both engines. Each loop opens its own SQLAlchemy session, performs work and sleeps **2 seconds after the work finishes**. Network time adds to this interval. Neither engine uses the advertised configurable polling interval for its main sleep.

The app uses public Binance market data and local simulated orders. There is no authenticated exchange order submission, cancellation, exchange wallet sync or exchange execution-report stream. Setting a runtime field to Live does not create live trading support. Quantities are used directly as BTC/base exposure in price-difference formulas; there is no contract-size conversion, price tick rounding, exchange minimum notional or quantity-step enforcement.

Run one application worker. Each worker would start its own engines; no distributed lock, unique active-session database constraint or leader election prevents duplicate work. There are two independent paper wallets, one per strategy, normally seeded to 100,000. There is no joint portfolio margin or cross-strategy strike clash rule.

Core names:

| Name | Meaning |
|---|---|
| `BTCUSDT` | Actual Binance USD-M perpetual data symbol |
| `BTC-USDT-FUTURES` | Internal futures order/position alias; explicitly mapped to BTCUSDT for history replay |
| `BTC-YYMMDD-K-C/P` | Option identity, including expiry, strike and type |
| `1st Trader`, `2nd Trader` | Hedge entry roles; exact strategy names used in database queries |
| First/second TP trader | Rank assigned when futures TP processing is committed; not synonymous with entry role |
| `MARKET`, `LIMIT`, `OPTION_TARGET`, `REENTRY_LIMIT` | Local order labels; only selected LIMIT paths use trade-event replay |

Orders commonly use `PENDING`, `FILLED`, `CANCELLED`, `EXPIRED`; session code recognizes `Open` and `OPEN`, then writes `Completed`. Schema defaults also include `SUBMITTED` and `Requested`; do not normalize these silently in a duplicate.

## 2. Data sources and price ownership

| Value | Source used by code | Consumer |
|---|---|---|
| BTC spot | `https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT`, `price` | Hedge intrinsic/TV and ITM selection; dashboard; Straddle entry spot record |
| Futures mark | `https://fapi.binance.com/fapi/v1/premiumIndex?symbol=BTCUSDT`, `markPrice` | Straddle ATM selection, Hedge futures entry/re-entry, unrealized futures PnL, scheduled/manual exits |
| Option mark | `https://eapi.binance.com/eapi/v1/mark`, exact `symbol` + `markPrice` | Option entry, valuation, exits, premium/TV filtering |
| Futures executed aggregate trades | `https://fapi.binance.com/fapi/v1/aggTrades` | Straddle OCO entry, Straddle TP, Hedge original futures TP |
| Exchange clock | `https://fapi.binance.com/fapi/v1/time`, `serverTime` | Futures limit activation baseline and local clock offset |
| Option ticker | `/eapi/v1/ticker` | Compatibility helper only; not strategy execution price |

This table specifies calls made by this code; it is not a fresh verification of Binance's current exchange policies. Source comments asserting how all Binance options are priced are not independent factual guarantees. The actual implementation uses futures mark for Straddle selection and spot for Hedge selection.

`option_mark(quotes, symbol)` returns the **first exact matching symbol** with finite mark >= 0. Missing, nonnumeric, negative or nonfinite marks raise `ValueError`. An invalid first duplicate is not replaced by a later duplicate. Zero is permitted for marking/closing; new option entries require > 0. There is no nearest-strike fallback for held options. No individual-quote exchange timestamp is checked: freshness is based on cache retrieval time.

Spot/futures normal cache TTL is 2 seconds, HTTP timeout 2.5 seconds. Options mark TTL is **5 seconds**, HTTP timeout 5 seconds (the older 30-second comment is stale). A network failure may use cached data up to 30 seconds old; older data raises DATA_GAP. Options 418/429 imposes 90-second backoff; code -1003 in a 200 response parses a ban-until timestamp or uses 60 seconds. During a ban the same 30-second stale limit still applies. Futures history has no quote-cache fallback, a 10-second timeout, and 418/429 backoff of max(90 seconds, Retry-After). Clock lookup timeout is 5 seconds.

## 3. Clocks, expiry and quantity

Option expiry is parsed from YYMMDD at **08:00 UTC / 13:30 IST**. Time windows are IST. Engine-generated datetime columns are predominantly naive IST, despite SQLAlchemy `timezone=True`; SQLite server-default timestamps use database time, generally UTC. A duplicate must preserve or explicitly reconcile this mixed convention. Event replay uses epoch milliseconds and converts fills to naive IST.

Hedge session key rolls to the next date at **13:30:00 IST inclusive**. Weekend skip refers to the target expiry date's weekday, not necessarily today's weekday. Several monitoring/countdown helpers use a separate **13:31 IST** day boundary. These are different implementations, with a one-minute mismatch.

Straddle entry compares minute offsets relative to 13:31: `relative(t) = (minutes(t) - 811) mod 1440`. Invalid time parsing returns 0 in that helper. Entry bounds are inclusive at minute precision; 18:55 includes that entire minute. A range crossing the relative-day boundary is not automatically split. Hedge execution uses ordinary minutes: if start <= end, require start <= minute <= end; otherwise minute >= start OR minute <= end. Its preview/countdown uses the relative clock and can disagree at boundaries.

Deadline helper: take the original session creation date, substitute configured close/cutoff HH:MM with seconds and microseconds 0; if the result <= creation time, add one day. Straddle uses localized IST; Hedge uses fixed UTC+05:30. Configuration changes can alter deadline calculations for an existing session.

All original legs of a session use the recorded original quantity, not a later quantity setting. No weighted-average accumulation exists. Each Hedge open-position row has a single entry basis. Re-entry creates a new futures row; it does not average with the already-closed futures position.

## 4. Straddle strategy: complete flow

### S1. Selection and entry gates

Every loop loads configuration and restores the earliest open/manual session. Even when new entries are disabled, it refreshes previews; an existing session continues being managed.

Without an active session, build call/put pairs from the option-mark snapshot:

1. Call symbol ends in `-C`, expiry parses and is strictly later than now.
2. Matching put symbol is obtained by replacing the final C with P.
3. Both exact marks are valid and **strictly positive**.
4. Select minimum `(expiry_code, abs(strike - futures_mark), strike)`.

Thus earliest available complete expiry wins, then closest strike to futures mark, then lower strike on an equal-distance tie. There is **no <24-hour filter for Straddle**, no applied MIN_EXPIRY_HOURS rule, and no search for a cheaper farther pair if the nearest selected pair fails premium limits. Same strike/expiry follow from pairing; ITM/OTM and same-strike monitoring booleans are effectively assumed true, not separate execution filters. Symbols generated for held positions use integer strikes.

Set `P = call_mark + put_mark`. Preview levels are:

```text
SELL/short entry limit = K + P * OCO_LIMIT_MULTIPLIER
BUY/long entry limit  = K - P * OCO_LIMIT_MULTIPLIER
```

Entry is allowed only when all conditions hold:

- `BOT_ENABLED == "1"`.
- Entry time is within WINDOW_START..WINDOW_END inclusive using relative minutes.
- State is ENTRY_WINDOW and there is no active session.
- P <= MAX_TOTAL_MARK, and abs(call_mark - put_mark) <= MAX_PREMIUM_GAP.
- If SKIP_WEEKENDS is "1", selected expiry is not Saturday/Sunday.
- Neither LAST_TRADED_EXPIRY nor **any** persisted session already identifies that expiry.
- TRADE_QTY is finite and > 0.
- Binance futures activation anchor is available; pending OCO terms are positive, finite and nonoverlapping.

No available-cash, leverage/margin, API-key, fee, order-book depth, or balance floor check gates entry. A cash balance can become negative. The engine can buy options during its entry window even if configured cutoff/square-off times are inconsistent; general time-order validation does not exist.

### S2. Entry transaction

Create a session recording expiry, selected strikes, entry option marks in fields named `call_ask`/`put_ask`, combined premium, entry BTC spot, zero realized PnL, status Open and creation time. `btc_entry_mark`, `call_sym`, `put_sym` are not populated by this entry path.

Create two FILLED option MARKET BUY orders for Q at these marks and two PENDING futures LIMIT orders for Q at the above levels. Persist FUTURES_ENTRY_TRACKING with both orders and a Binance ID/time baseline. Save LAST_TRADED_EXPIRY. Debit paper cash by P*Q and create `PREMIUM_BUY` ledger entry. Commit, set LIMITS_PLACED. The option entries do not create separate StraddleFill rows or exchange fill timestamps.

### S3. OCO execution and cutoff

Replay both limits together in aggregate-trade ID order, from activation, through **cutoff minus 1 millisecond**. SELL qualifies at trade price >= short limit; BUY qualifies at trade price <= long limit. The earliest qualifying event wins, even if polling happens after the cutoff. Record execution at the stored limit price, full quantity; mark counterpart CANCELLED/OCO_CANCELLED and write one StraddleFill.

Let E be filled futures entry, d = +1 for BUY or -1 for SELL, and T = FUTURES_TP_MULTIPLIER read **at futures entry processing**:

```text
Futures TP = E + d * original_combined_premium * T
```

Create the opposite-side target for Q, anchored to the entry trade's ID and timestamp. This allows a subsequent ID in the same millisecond to fill TP. State becomes IN_TRADE. The TP replay can run in the same loop. OCO levels and option entry prices remain locked even if settings/marks change.

If no crossing exists and replay proves coverage past cutoff, both pending entries become EXPIRED/FUTURES_ENTRY_CUTOFF and state becomes RECOVERY. Elapsed wall time or an empty response is not sufficient evidence. Unresolved history defers automatic close rather than inventing a no-fill.

### S4. Futures TP exit

Before replay, target quantity must equal original Q, target price must equal session TP, and closing side must match inferred held direction. Replay is capped at the scheduled close deadline (inclusive). On TP:

- Complete session with reason `Futures TP Hit`.
- Record futures exit at locked TP, exchange fill time/ID and processing time; create StraddleFill.
- Sell both held options at **current exact-contract marks from the processing loop**, not reconstructed historical marks at the futures fill time.
- Create two FILLED option MARKET SELL orders.
- Record option and futures PnL, credit option sale proceeds plus futures PnL, create TRADE_CLOSE ledger entry and commit.

The recovered futures execution time can precede the option marks used to close the rest of the basket. This is an implemented simulation assumption.

### S5. Recovery without futures entry

RECOVERY evaluates `current_call + current_put >= RECOVERY_THRESHOLD_PCT * original_P`. Default fraction is **0.65**, not 65 and not the stale 80% log text. If true, sell both options at their exact current marks, credit proceeds, record PnL = (current sum - original sum)*Q, complete the session and write TRADE_CLOSE. This can happen immediately after entry orders expire. No futures are opened during recovery.

### S6. Scheduled/manual exit and restart

Manual state SQUAREOFF, or relative now >= SQ_END in IN_TRADE/ENTRY_WINDOW/LIMITS_PLACED/RECOVERY, enters square-off. A still-unverified pending OCO first raises DATA_GAP, deferring automatic close. IN_TRADE first attempts TP-history recovery through the deadline; unresolved coverage also defers automatic close.

Square-off cancels remaining pending orders, closes held options and any actual futures position at current marks, posts cash/PnL and marks Completed. Pending config is flushed; state returns IDLE. `SQ_START`, `FUTURES_SQUAREOFF` and `STRADDLE_EXPIRY_TIME` do not independently trigger exits. Manual Straddle close still depends on successful market-data refresh and does not replay pending OCO history first.

Restart derives state from persisted records: manual request/status -> SQUAREOFF; positive futures entry -> IN_TRADE; pending entry order -> LIMITS_PLACED; open session without either -> RECOVERY; none -> IDLE. Original quantities/prices are restored. An exception rolls back the current transaction, clears preview availability (and inactive preview prices), logs and retries after 2 seconds. Old active display values may persist when feed refresh fails.

## 5. Hedge strategy: complete flow

### H1. Roles, gates and order of work

Use exactly two configuration rows identified by `strategy_name`: 1st Trader and 2nd Trader. Each has independent time window, quantity, premium/TV caps, direction, force-close time and enabled flag. More arbitrary rows can be saved through the API but the engine iterates only these two names.

At every tick: consume manual SQUAREOFF commands first; restore sessions; load flags; refresh spot, futures mark, and one options snapshot; then process **slot 1 followed by slot 2**. Refresh selection previews even when entries are blocked. An options ValueError leaves an empty snapshot; spot/futures failures abort the tick. Each role with an active session is managed before considering entry and skips entry processing that tick.

New entry requires BOT_ENABLED and ENGINE_ENABLED exactly "1", GLOBAL_PAUSE not "1", no global weekend exclusion, role enabled, inclusive role time window, no existing active role session, and no persisted order for this role joined to the current expiry-key session. Quantity must be finite and positive. There is **no global Max BTC Quantity cap** in this version. Stored legacy Q_MAX_BTC is ignored. No cash sufficiency, margin or option-spend limit is enforced.

Disabling a bot, role or global engine, pausing or entering a weekend blocks new entries; existing positions continue management. Per-role `skip_weekends`, `blackout_dates`, `locked` and related schema fields are not applied execution gates.

### H2. Candidate selection and opposite direction

Validate spot finite and >0. For each dictionary quote require four symbol components, BTC prefix, C/P suffix, positive finite strike and premium, and **0 < expiry - snapshot time < 24 hours**. Both equality boundaries are excluded. At exactly 13:30 a tomorrow-expiry option with 24 hours remaining fails until time advances.

```text
Put intrinsic  = max(0, strike - spot)
Call intrinsic = max(0, spot - strike)
Time value     = max(0, option_mark - intrinsic)
```

Bullish selects P with strike >= spot; Bearish selects C with strike <= spot. Equality is allowed (ATM). `Auto` and other unrecognized direction strings compare both. In particular seeded strings `1st Trader Role` / `2nd Trader Role` do not themselves restrict type. Require mark <= role.max_premium AND TV <= role.max_time_value. Choose minimum `(TV, symbol, strike, premium, expiry_code)`; since symbol normally distinguishes candidates, ties resolve lexicographically by symbol. A farther ITM option can win. Below-intrinsic positive marks yield TV=0 and are not rejected.

The second trader's direction is the opposite of the first trader's persisted filled option BUY for the current expiry. A missing first entry now means **wait**, regardless of second role's configured direction. First trader's completion does not unlock that direction/reference within the same expiry.

### H3. Strike clash rule

`MIN_STRIKE_GAP` allows **250 or 500**, default **500**. Filter candidates before ranking by TV. Reference is the earliest qualifying first-trader filled option BUY ordered by session ID then order ID for the current expiry key; it is not a preview price or an in-memory strike.

| First trader hedge | Required second hedge | Inclusive bound |
|---|---|---|
| PUT at K1 (bullish futures) | CALL, same expiry | K2 <= K1 - G |
| CALL at K1 (bearish futures) | PUT, same expiry | K2 >= K1 + G |

For K1=85,000 and G=500: bullish first trader allows calls at 84,500 or lower; bearish first trader allows puts at 85,500 or higher. At G=250 the bounds become 84,750 and 85,250. Same strike, too-close strike, wrong side and wrong expiry fail. Existing ITM/premium/TV/expiry gates still apply. If no survivor qualifies, wait; there is no prohibited-strike fallback. Previews use the same filtering helper.

Changing the gap affects future second-trader selections; already-open positions are not relocated. The reference survives restart and first-trader closure. Corrupt reference/configuration fails selection. Since the first trader locks to one expiry/role, resetting Hedge records removes these locks and permits a new cycle.

### H4. Initial entry

Obtain a futures ID/time anchor, then atomically create:

- Open HedgeSession, symbol BTCUSDT, selected option expiry, `bull_entry=F` or `bear_entry=F`; unused direction entry remains zero.
- FILLED option MARKET BUY at option mark O, Q.
- FILLED futures MARKET BUY for bullish or SELL for bearish, at current futures mark F, Q.
- LONG option HedgeOpenPosition at O and LONG/SHORT futures row at F.
- PENDING futures LIMIT target: bullish SELL at F+O; bearish BUY at F-O, quantity Q, with tracking event.

Commit and set the slot reference fields. No option premium is deducted from the Hedge wallet and no entry ledger row is made. The wallet uses realized-PnL accounting, not Straddle's cash/proceeds accounting. Entry MARKET orders do not receive exchange execution timestamps or HedgeFill records. Schema leverage defaults to 10 on positions; no applied leverage multiplier changes PnL.

### H5. Original futures TP, rank and settlement

Match target contract/qty/side against the held futures and match entry basis against session original entry. Replay the target using aggregate trades. If history coverage is incomplete at force-close, scheduled closure waits. On hit:

1. Rank = 1 + count of already persisted FUTURES_TP events joined to sessions of the same expiry.
2. For rank 1, read FIRST_TP_OPTION_MULTIPLIER (default 1), require positive finite multiplier and positive finite product O*M.
3. Fill futures at stored target, record exchange timestamp/aggregate ID and HedgeFill; remove its open-position row.
4. Credit `(target - F)*Q*d`, rounded to 2 decimals, into wallet and session PnL. Append FUTURES_TP ledger and event carrying role/rank/execution evidence.
5. Rank 1 creates a pending option SELL `OPTION_TARGET` for all remaining Q at O*M. Rank 2 (or any non-1 rank) creates a futures `REENTRY_LIMIT`, described below.
6. Commit, restore slots/rank metadata, return. Newly created follow-up orders are normally evaluated on the next tick.

Rank follows **processing/commit order**, not a cross-slot sort by exchange fill time. If both recover crossings in one tick, slot 1 is processed first. After restart rank labels use event ID order. This distinction can change which role gets an option target versus a re-entry.

### H6. First TP option target

Global `FIRST_TP_OPTION_MULTIPLIER` is a positive finite number; fractional values are allowed. It is unrelated to unused per-role `partial_tp_multiplier`/`partial_profit_ratio` columns. At O=81.31: M=1 -> 81.31, M=1.5 -> 121.965, M=2 -> 162.62. No exchange tick rounding is applied.

The multiplier is read when the futures TP creates the target. A later setting change does not reprice an existing pending target. Trigger when exact held-option mark >= pending price. Then `execute_squareoff` fetches fresh marks, fills that target at the refreshed mark, overwrites order.price, closes all remaining positions of that session and credits newly realized PnL. No partial quantity logic exists.

This remains a **mark-triggered simulated close**, not a resting Binance option limit. It may fill at a different price, including below the target if the quote changes between trigger and close. It has no missed-option-tick recovery. The original target price is not preserved in a separate field after overwrite; original creation time is retained and actual option fill timestamps remain unrecorded.

### H7. Second TP re-entry

Let K be original held option strike, O its original entry premium:

```text
Bullish: BUY futures trigger  = K - O; trigger if futures mark <= level
Bearish: SELL futures trigger = K + O; trigger if futures mark >= level
```

For bullish PUT K=76,500 and O=81.31, re-entry trigger is 76,418.69. Use original full premium, not TV/current premium. `rebuy_mode="tv_based"` is stored but unused.

Re-entry quantity equals held option quantity. Fill at currently observed futures mark, overwrite pending order.price, create LONG/SHORT open-position row with that entry price and option-row leverage, commit. No aggregate-trade replay, partial-fill accounting, new HedgeFill or execution timestamp is recorded. Brief crossings between observations can be missed.

Only one re-entry order is generated by the original TP event. That existing event prevents a new regular futures TP after re-entry. Remaining option and re-entered futures await force-close or manual square-off. Session bull_entry/bear_entry remains the original entry; position.entry_price is the correct basis for the re-entered futures. A final session exit scalar can overwrite the earlier futures exit, so orders/events are necessary for full reconstruction.

### H8. Scheduled/manual exit, recovery and errors

Each active role uses its own configured deadline derived from original session creation. At now >= deadline call manage_slot(tp_only=True, until=deadline), then square-off that session. This can recognize a historical futures TP before force-close. Newly created option/re-entry follow-up orders are not evaluated through their normal paths at this point; scheduled close cancels unfilled orders.

Manual Hedge SQUAREOFF is a durable queued command; it is processed before normal feed/entry work and closes all open sessions. It does not first replay outstanding futures targets. Commands become COMPLETED after successful close. Restart retains queued commands.

Square-off first gathers all requested sessions, positions, role attribution and valid exact-contract exit marks before changing any of them. Missing held option/entry order/required quote blocks processing. Compute each remaining leg's PnL, remove positions, create MARKET close orders (or fill the existing OPTION_TARGET), cancel remaining pending orders, accumulate newly realized PnL into session and wallet, append SESSION_SQUAREOFF ledger entries and commit. A repeated close of already completed sessions does not settle again.

Restore by finding each role's most recent open session with a remaining option position, recovering strike/O/direction from persisted rows, and marking current-expiry traded/completed locks from historical orders. Completed first-trader records still govern second entry direction/clash. If data corruption leaves only a futures position without its option, normal restore cannot fully recover that slot. Per-role management catches ValueError and rolls back/logs; outer loop catches other exceptions and retries. These are fail/defer behaviors, not automated repair.

## 6. Futures replay algorithm and evidence contract

Both strategies share `futures_targets.py`. It applies only to Straddle OCO entries and original futures TP limits in both strategies. It does not implement an order book.

At activation fetch latest aggregate trade (limit=1), then Binance server time. Require valid server integer >= latest trade timestamp. Save ID baseline, last trade timestamp, active_ms and clock_offset_ms = server_ms - local_ms. Record order creation in exchange-aligned IST. Fetching the baseline alone does not imply a fill.

Immutable event terms are symbol, order ID, side, quantity and limit price; OCO also stores counterpart ID/terms. Every replay revalidates them. Only explicit BTC perpetual aliases are accepted. event.payload_json contains:

| Key | Meaning |
|---|---|
| order_id / symbol / limit_price / qty / side | Locked primary order identity |
| active_ms | Earliest eligible activation boundary |
| checked_ms | Recovery-window cursor, not necessarily final completeness proof |
| last_id / last_trade_ms | Last consumed aggregate trade ID/time |
| last_poll_ms | Throttle state |
| clock_offset_ms | Exchange clock minus local clock at activation |
| activation_trade_id | Present for target activated by a recovered entry; permits later IDs at same millisecond |
| other | OCO counterpart terms |
| boundary_ms | Contiguous later trade seen beyond replay boundary |
| hit | order_id, symbol, aggregate_trade_id, trade_time_ms, observed_price, fill_price, processed_time_ms |

Algorithm:

1. Return without fill if order is not PENDING. Validate locked identity. Return previously persisted hit if present.
2. Compute aligned now; end=min(now, deadline) where supplied. Respect activation and proven deadline completion.
3. If aligned now - checked_ms >= 47 hours, raise DATA_GAP/manual-review requirement. This is this tool's limit, not a promise about current Binance retention.
4. Throttle to 5,000ms per target; reset unanchored checked_ms to activation.
5. At most 5 pages of up to 1,000 events per pass. Time windows are 30 minutes; ID-based requests start at last_id+1 and omit time bounds. Bootstrap time request requires 0 <= span <1 hour.
6. Validate API list length, integer nonnegative a/T, finite positive p/q, optional response symbol, request boundaries, consecutive IDs and nondecreasing timestamps. Reject mismatches, do not substitute mark prices.
7. Skip previously consumed IDs. The next new ID must equal last_id+1; timestamps cannot move backward. A later event beyond the window is a boundary witness and is left unconsumed.
8. Evaluate BUY price<=limit / SELL price>=limit. Event must be strictly later than activation, except a later ID in the same millisecond is allowed for entry-anchored TP. Both OCO sides matching one event is invalid.
9. Save first hit with observed price but fill_price fixed at the locked limit. No volume/queue-priority/partial-fill simulation: any qualifying event fills all Q.
10. Persist successful pages/cursors through the caller's transaction even without a hit. Empty bootstrap retains the original interval. A short page is not final cutoff proof. Catch up on subsequent loop passes if page budget exhausted.

`replay_complete` requires a hit, a contiguous later boundary event beyond deadline, or a target with no eligible lifetime before deadline. At cutoff it therefore waits when evidence is unavailable. Failed transactions can refetch events; single-worker state/order status prevents ordinary double settlement. This is not a guarantee of perpetual lossless market-data capture.

Legacy open positions lacking tracking receive a new current anchor; historical fills before that anchor are not invented. Legacy OCO preserves original placement fields. Nullable added execution columns are not backfilled. Recorded processed time is the exchange-offset-adjusted time passed to replay before page fetching, not necessarily database commit time.

## 7. Accounting formulas and worked examples

For this linear paper model, define d=+1 for long and -1 for short, entry E, exit X, mark V, quantity Q:

```text
Realized futures PnL   = d * (X - E) * Q
Unrealized futures PnL = d * (V - E) * Q
Realized long option PnL   = (exit option mark - entry option mark) * Q
Unrealized long option PnL = (current option mark - entry option mark) * Q
```

Both strategies buy options; generic Hedge valuation also supports a short sign if such a row exists. These formulas are not inverse/coin-margined futures formulas. No funding, interest, fees, spread, commissions, liquidation, exercise or exchange settlement debits exist. Recorded replay fill fee is 0. This is a simulator convention, not a statement that maker orders are free on Binance.

### Straddle cash model

For original P=C0+P0, current/exit option sum R=Cx+Px:

```text
Entry debit       = -P*Q
Closing credit    = R*Q + realized futures PnL
Session realized  = (R-P)*Q + realized futures PnL
Cash_end          = Cash_start + sum(ledger.amount)
Live equity       = current cash + held option value + unrealized futures PnL
```

After all sessions close, cash_end = cash_start + sum(session realized), subject to float/rounding differences and external wallet edits. During an open option position, cash_end != cash_start + realized PnL because premium has been paid. Display wallet includes option value. Futures notional is not debited or reserved as margin.

Example: K=85,000, C0=200, P0=150, Q=1, OCO multiplier=1, futures TP multiplier=1. SELL entry=85,350, BUY entry=84,650. SELL crosses first -> short E=85,350, TP=85,000. At TP futures PnL=350. If options now total 220, option PnL=-130, session PnL=220. Starting 100,000 -> entry cash99,650 -> close credit570 -> final100,220. At recovery without futures and option sum227.50, ratio .65 is met, loss122.50 and ending cash99,877.50.

### Hedge realized-balance model

Entry does not debit wallet. Initial TP credits O*Q. A later option exit credits (Ox-O)*Q; later re-entry futures use their own position entry, not the original E. Each settlement's newly realized amount is rounded to cents before wallet/session updates. Wallet shown is realized balance, not a fully funded option cash balance or full marked portfolio equity.

```text
Hedge_balance_end = Hedge_balance_start + sum(new realized ledger amounts)
Session realized  = sum(its FUTURES_TP and SESSION_SQUAREOFF amounts)
```

Example bullish E=76,471.88, O=81.31, Q=1: futures TP=76,553.19, first settlement +81.31. At M=1 and option exits81.31, option settlement0; final wallet100,081.31. At option exit100, extra+18.69; final100,100. Re-entered long at76,410 and closes76,450: additional futures PnL40, separately from original futures profit and option PnL.

### Reconciliation procedure

1. Establish a baseline balance and ledger ID at creation/reset; do not infer it from current wallet alone.
2. In ID order, verify ledger.balance_after against prior balance+amount (cent tolerance for floats).
3. Compare final ledger balance to configured wallet, accounting for audited direct wallet edits; config APIs allow wallet edits without deposit ledger entries.
4. For Hedge, sum realized increments by session and compare to session.realized_pnl. For Straddle, sum entry debits+closing credits by completed session and compare to pnl_realized; account for open premium separately.
5. Reconstruct futures fills and option orders using session/contract/order identity. Do not assume fill tables contain every execution.
6. For an open Straddle, add current option value and held futures unrealized PnL to cash for equity. For Hedge, realized wallet plus remaining position unrealized PnL is a derived PnL-equity view, not premium-funded cash.

There is no deposit/withdrawal journal or daily account-state close in the current implementation. A formula Ending=Starting+Realized+NetDeposits only applies to completed Straddle cycles or the Hedge realized-balance convention, with externally recorded adjustments. The program does **not** implement a zero-error reconciliation enforcement mechanism; binary Float arithmetic and inconsistent rounding preclude claiming one. Daily-state tables mentioned in older blueprints are proposals unless present in this version's schema.

## 8. Dashboard, audit and operational contract

The dashboard polls snapshot every3 seconds; websocket sends prices/states every1 second. These intervals do not drive execution. Snapshot returns last10 sessions per panel, last50 orders per panel, last50 Straddle ledger entries and all Hedge open positions. Latest session is called active_session even if completed; UI checks statuses. API reads can fetch market data and assign Hedge's option_quotes cache, so display reads are not pure in-memory views.

Hedge open-position rows are marked using their exact option symbol or the futures mark; missing options produce null current price and PnL. Active cards use held quantity/basis and omit closed futures from unrealized PnL. Active card PnL percentage uses futures-entry notional E*Q, not margin or option premium. The first TP's already-realized profit is not part of this remaining-position unrealized number. The Hedge top realized figure uses latest session, not sum of both roles. The frontend uses `wallet || 100000`, so a genuine zero Hedge balance can display100000. Some preview/condition labels describe slot1 only or omit the detailed clash cause in the top-level idle reason; contract selection itself uses the clash filter.

Order-time UI: pending/cancelled rows show placement; FILLED shows filled_at or `Not recorded`, followed by placement and processed time (milliseconds where present). Do not substitute placement for unknown fill time. Options and most MARKET/re-entry orders lack actual fill timestamps. Prices display rounded to2 decimals while stored computation can retain more.

Config POSTs apply immediately, not deferred by active positions. Only the new gap/multiplier global settings receive explicit numeric-domain validation; other config keys are arbitrary strings. Hedge role API converts types but lacks comprehensive range/time validation and uses Python bool(payload.enabled), so a string "false" is truthy. Existing pending-config tables/flush code remain, although these current config routes do not enqueue normal updates. Exact endpoints and response fields are in the API reference.

Both reset endpoints reset their own wallet to100000 and delete own trading records, not accounts/global strategy settings. Hedge also deletes queued runtime commands, retaining completed commands; Straddle clears LAST_TRADED_EXPIRY but not its unused runtime-command table. Neither reset automatically changes enabled flags. Resetting while the engine runs has no shared transaction lock with the loop; stop the application service, create a consistent SQLite backup, reset the correct configured database, then start it. Stopping the shared service briefly pauses both engines even when only one panel is cleared.

Production service observed in the user-provided configuration is `hedgesnstraddle.service`, working directory `/home/ubuntu/hedgesnstraddle`, Python `env/bin/python main.py`, PORT=8085, Restart=always. Use systemctl stop/start/restart rather than killing a PID or launching a competing nohup process. `python main.py` enables uvicorn reload; see reproduction reference for a single-worker non-reload launch for a new instance. A Git push does not deploy a service.

## 9. Boundaries that a duplicate must not silently invent

- No live trading, stop-loss/liquidation model, account risk sizing, maker queue simulation, partial executions, fees/funding or exchange reconciliation.
- Futures replay cannot recover outside its local47-hour guard, relies on endpoint availability/continuity, and processes aggregate events rather than every raw fill tick.
- Hedge OPTION_TARGET and REENTRY_LIMIT use marks and can miss between-poll crossings; only original futures targets and Straddle OCO use historical replay.
- First TP ranking is commit order, and manual exits do not replay every pending limit first.
- Existing pending targets keep their stored prices after multiplier changes. New clash restrictions do not retroactively relocate legacy positions.
- Not every config field, database table or diagnostic state is an execution rule. Full field inventory marks storage/display-only features.
- SQLAlchemy models define no actual foreign keys between session/order/fill tables; application queries enforce associations. There is no daily rollup writer for the placeholder snapshot tables.
- Built-in development auto-login, public read endpoints, simple SHA256 password hashing and default secret are current behavior, not hardened access control. Duplicating this behavior on a public host has the same access limitations.
- Historical rows without execution evidence cannot be reconstructed from candle highs alone or filled in with placement times.

Use the acceptance cases and exact implementation appendix to compare a rebuilt tool against these rules before claiming equivalent behavior.
