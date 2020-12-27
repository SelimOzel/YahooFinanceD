import std.stdio;
import std.datetime;
import std.string;
import std.conv;

// Miner class
import YahooFinanceD;

void main()
{
	// Example: Mining Apple between December 12, 1980 and Jun 6, 2020
	string name = "MSFT";
	Date begin = Date(1980, 12, 12);
	Date end = Date(2020, 6, 10);

	YahooFinanceD simpleMiner;
	simpleMiner.Mine(begin, end, name, intervals.monthly); // scrape monthly
}
