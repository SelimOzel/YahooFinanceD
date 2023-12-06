import std.stdio;
import std.datetime;
import std.string;
import std.conv;

// Miner class
import YahooFinanceD: 
YahooFinanceD,
output,
logger,
intervals,
Frame,
Price,
Dividend,
Split;

void main() {
	// Example: Mining Apple between December 12, 1980 and Jun 6, 2020
	string name = "AAPL";
	Date begin = Date(1980, 12, 12);
	Date end = Date(2020, 6, 10);

	YahooFinanceD simpleMiner;
	simpleMiner.Mine(begin, end, name); // by default, grabs daily data
	simpleMiner.Write("prices"); // by default writes to json

	simpleMiner.Mine(Date(2017, 12, 12), Date(2020, 6, 10), "TSLA", intervals.weekly); // scrape tsla weekly and use the previous miner with new parameters
	simpleMiner.Write!(output.json, logger.off, bool); // write to json frame without logging, explicitly declare
}