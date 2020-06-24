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
	Frame[] apple = simpleMiner.Write!(output.frame, logger.off, Frame[]); // write to data frame with logging

	for(int i = 0; i<apple.length; i++)
	{
		// Header
		writeln();
		writeln(apple[i].date);

		// Price
		writeln(
			"adj: "~to!string(apple[i].price.adjclose)~
			" close: "~to!string(apple[i].price.close)~
			" high: "~to!string(apple[i].price.high)~
			" low: "~to!string(apple[i].price.low)~
			" open: "~to!string(apple[i].price.high)~
			" volume: "~to!string(apple[i].price.volume));

		// Corporate actions
		if(apple[i].div.amount != 0)
		{
			writeln("div: "~to!string(apple[i].div.amount));
		}
		if(apple[i].split.denominator != 0 || apple[i].split.numerator!= 0)
		{
			writeln(
			"split-denominator: "~to!string(apple[i].split.denominator)~
			" split-numerator: "~to!string(apple[i].split.numerator));
		}
	}
}
