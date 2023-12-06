# YahooFinanceD
Yahoo finance scraper written in D.

| Development Environment 	| DMD	| DUB
| ------------- 			| ------------- | -----
| Ubuntu 22.04     			| v2.104.0 | v1.33.0

This library obtains financial data from Yahoo based on stock's name between a begin and an end date. It has three time intervals: monthly, weely and daily. The unit test is based on scraping five stocks in a row. The implementation can be found under the [library folder](https://github.com/SelimOzel/YahooFinanceD/blob/master/lib/). I provide six examples to help new users: [csv writer](https://github.com/SelimOzel/YahooFinanceD/blob/master/source/examples/csv/app.d), [data frame](https://github.com/SelimOzel/YahooFinanceD/tree/master/source/examples/dataframe/app.d), [gold](https://github.com/SelimOzel/YahooFinanceD/tree/master/source/examples/gold/app.d), [json writer](https://github.com/SelimOzel/YahooFinanceD/tree/master/source/examples/json/app.d), [SOXX analysis](https://github.com/SelimOzel/YahooFinanceD/tree/master/source/examples/soxx_analysis/app.d) and [TIP std](https://github.com/SelimOzel/YahooFinanceD/tree/master/source/examples/tip_std/app.d). The dataframe allows users to access OHLC, dividend and split data on program runtime. Whereas, json and csv writers output them to external files. Gold, SOXX and TIP examples show how different names can be grabbed from Yahoo Finance.

**Examples:** On Windows use `dub run -a x86_mscoff yahoofinanced:example-json` to compile the json writer, `dub run -a x86_mscoff yahoofinanced:example-csv` to create two baskets of stocks and use `dub run -a x86_mscoff yahoofinanced:example-dataframe` to compile the dataframe.

**Test:** On Windows run `dub test -a x86_mscoff yahoofinanced:unittest`. 
