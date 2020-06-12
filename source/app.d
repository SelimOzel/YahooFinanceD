import std.stdio;
import std.datetime;
import std.string;

// Miner class
import YahooMinerD;

void main()
{
	// Example: Mining Apple between December 12, 1980 and Jun 6, 2020
	string name = "AAPL";
	Date begin = Date(1980, 12, 12);
	Date end = Date(2020, 6, 10);

	YahooMinerD simpleMiner = new YahooMinerD();
	simpleMiner.Mine(begin, end, name);
	simpleMiner.WriteToJson();
}
