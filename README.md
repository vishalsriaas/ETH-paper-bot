# ETH paper bot

FastAPI dashboard with straddle and hedge paper-trading engines using Binance
ETH options and ETHUSDT futures market data.

The ETH conversion follows `PAPER TESTING SYSTEM(For ETHUSD).docx`: ETH underlying,
minimum hedge strike gaps of 10, 20, or 30 (default 10), and a configurable maximum
strike gap. Other strategy mechanisms remain unchanged.

## Run locally or on Linux

Requires Python 3.10 or newer.

```sh
python3 -m venv .venv
.venv/bin/python -m pip install -r requirements.txt
.venv/bin/python -m uvicorn main:app --host 127.0.0.1 --port 8086 --workers 1
```

On Windows, use `.venv\Scripts\python.exe` instead of `.venv/bin/python`.
Open http://127.0.0.1:8086/. Starting the server also starts the paper engines.

The default database is `hedgesnstraddle_eth.db` in the project directory. A new
checkout creates a fresh database on first startup; local databases and saved
settings are not included in Git. Set the maximum hedge strike gap in Hedge
configuration before Trader 2 can enter. No default maximum was specified.

## Alongside the existing BTC bot

Use a separate checkout, virtual environment, ETH database, Linux service, and
unused port. Do not reuse the BTC database or its `DATABASE_URL` environment
variable. Use one Uvicorn worker and omit `--reload` for the Linux service.
Port 8086 above is an example; check that it is free on the server first.

## Offline tests

```sh
.venv/bin/python -m pip install -r requirements-mcp.txt
.venv/bin/python -m unittest discover -s tests -v
```

These tests use isolated databases and mocked market data. `run_test_suite.py`
is a separate integration script that changes settings and requests square-offs;
use it only against a disposable instance.

See `MCP_README.md` for read-only MCP access. Older documents describe the BTC
system and its history; the ETH requirements document defines this conversion.
