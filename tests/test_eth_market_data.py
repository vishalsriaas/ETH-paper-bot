"""ETH routing and mixed-underlying feed checks without network access."""
import asyncio
import unittest
from unittest.mock import AsyncMock, patch

import httpx

from app.core import binance_client as bc


class EthMarketDataTests(unittest.TestCase):
    def fetch(self, function, payload):
        client = AsyncMock()
        client.get.return_value = httpx.Response(
            200, json=payload, request=httpx.Request('GET', 'https://example.test'))
        context = AsyncMock()
        context.__aenter__.return_value = client
        with patch.object(bc.httpx, 'AsyncClient', return_value=context), \
                patch.dict(bc._price_cache, {}, clear=True), \
                patch.dict(bc._rate_limit_until, {}, clear=True):
            result = asyncio.run(function())
        return result, client.get.call_args

    def test_spot_and_futures_request_ethusdt(self):
        for function, payload in [
                (bc.get_eth_spot_price, {'price': '3000'}),
                (bc.get_eth_futures_mark_price, {'markPrice': '3001'})]:
            with self.subTest(function=function.__name__):
                price, request = self.fetch(function, payload)
                self.assertEqual(request.kwargs['params']['symbol'], 'ETHUSDT')
                self.assertIn(price, (3000, 3001))

    def test_option_feeds_exclude_btc_and_other_assets(self):
        eth = {'symbol': 'ETH-261009-3000-C', 'markPrice': '20'}
        payload = [eth, {'symbol': 'BTC-261009-60000-C', 'markPrice': '500'},
                   {'symbol': 'SOL-261009-200-C', 'markPrice': '5'}]
        for function in (bc.get_eth_options_mark_prices, bc.get_eth_options_tickers):
            with self.subTest(function=function.__name__):
                rows, _ = self.fetch(function, payload)
                self.assertEqual(rows, [eth])


if __name__ == '__main__':
    unittest.main()
