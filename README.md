# YahooMinerD
Yahoo finance scraper written in D.

| Development Environment 	| DMD	| DUB
| ------------- 			| ------------- | -----
| Windows 10     			| v2.091.1 | v1.20.1

Obtains financial data from Yahoo based on stock's name between a begin and an end date. The unit test is based on scraping five stocks in a row. The utility function `WriteToJson()` converts the mined data into two json files: one of them containing corporate events (splits & dividends) and the other one contains historial OHLC data.

Example: On Windows run `dub run -a x86_mscoff`. You should get the following files in the project folder:
- AAPL_1980-Dec-12_2020-Jun-10_events
- AAPL_1980-Dec-12_2020-Jun-10_prices

Test: On Windows run `dub test -a x86_mscoff`. You should get the following files in the project folder:
- AAPL_1980-Dec-12_2020-Jun-10_events
- AAPL_1980-Dec-12_2020-Jun-10_prices
- BRK-B_1980-Dec-12_2020-Jun-10_events
- BRK-B_1980-Dec-12_2020-Jun-10_prices
- F_1980-Dec-12_2020-Jun-10_events
- F_1980-Dec-12_2020-Jun-10_prices
- MSFT_1980-Dec-12_2020-Jun-10_events
- MSFT_1980-Dec-12_2020-Jun-10_prices
- TSLA_1980-Dec-12_2020-Jun-10_events
- TSLA_1980-Dec-12_2020-Jun-10_prices
