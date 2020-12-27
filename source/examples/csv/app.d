import std.stdio;
import std.datetime;
import std.string;
import std.conv;

// Miner class
import YahooFinanceD;

void main()
{
	// Example: Mining Apple between December 12, 2018 and Jun 6, 2020
	string name = "MSFT";
	Date begin = Date(2018, 12, 12);
	Date end = Date(2020, 6, 10);

	YahooFinanceD simpleMiner;
	simpleMiner.Mine(begin, end, name, intervals.monthly); // scrape daily

	string msft_str = simpleMiner.Write!(output.csv, logger.off, string); // write msft as csv to a string with logger off
}
