import std.stdio;
import std.net.curl;
import std.datetime;
import std.file;
import std.conv;
import std.algorithm;
import std.json;

// Yahoo finance data scraper written in Dlang. Selim Ozel
struct YahooFinanceD
{
public:
	// Write output to json
	void WriteToJson()
	{
		if(_miningDone) 
		{
			std.file.write(_name~"_"~_beginDate_s~"_"~_endDate_s~"_prices.json", _j["prices"].toPrettyString);
			writeln("Price output written to " ~ _name~"_"~_beginDate_s~"_"~_endDate_s~"_prices.json. ");
			std.file.write(_name~"_"~_beginDate_s~"_"~_endDate_s~"_events.json", _j["eventsData"].toPrettyString);
			writeln("Event output written to " ~ _name~"_"~_beginDate_s~"_"~_endDate_s~"_events.json. ");
		}
		else
		{
			writeln("Can't write to json. Mining not done.");
		}
	}

	// Miner
	void Mine(Date begin, Date end, string name)
	{
		// Copy begin/end dates and stock name to private
		_beginDate = begin;
		_endDate = end;
		_name = name;
		_miningDone = false;

		// Generate unix times and date times
		auto est = new immutable SimpleTimeZone(hours(-7));
		_beginDate_s = to!string(_beginDate);
		_endDate_s = to!string(_endDate);
		_beginUnix_s = to!string( SysTime(_beginDate, est).toUnixTime() );
		_endUnix_s = to!string( SysTime(_endDate, est).toUnixTime() );

		// Assemble query. Use unix time.
		string dataQuery = "https://finance.yahoo.com/quote/"~name~"/history?period1="~_beginUnix_s~"&period2="~_endUnix_s~"&interval=1d&filter=history&frequency=1d";
		
		// Debug
		writeln("Retrieveing "~name~" between "~_beginUnix_s~" and "~_endUnix_s~".");
		writeln("Using query: "~dataQuery);

		try
		{
			// Curl it
			string content = to!string(get(dataQuery));

			// Get the raw string between root.App.main and (this)
			string output = CutString(content, "root.App.main = ", "(this));");

			// Convert raw string to json
			try
			{
				_j = parseJSON(output);
				_j = _j["context"]["dispatcher"]["stores"]["HistoricalPriceStore"];	
				_miningDone = true;	    
			}
			catch (JSONException e)
			{
		    		writeln(e.msg); 
		    		_miningDone = false;				
			}
		}
		catch (CurlException e)
		{
			writeln(e.msg); 
			_miningDone = false;
		}		
	}

	int PriceLength()
	{
		if(_miningDone) return _j["prices"].array.length;
		else return -1; 
	}

	int EventsLength()
	{
		if(_miningDone) return _j["eventsData"].array.length;
		else return -1; 
	}	

private:
	// Returns everything from str between begin and end
	string CutString(string str, string begin, string end)
	{
		auto result = str.findSplit(begin);
		result = to!string(result[2]).findSplit(end);
		return result[0];
	}

	// Name of the currently mined stock
	string _name;

	// Same dates in unix, date and string formats
	Date _beginDate;
	Date _endDate;
	string _beginDate_s;
	string _endDate_s;
	string _beginUnix_s;
	string _endUnix_s;	

	// Flag gets set and _j gets filled after mining
	bool _miningDone;
	JSONValue _j;
}

unittest
{
	// Test: Check that lengths are larger than 100. 
	// That's a reasonable expectation the sotcks listed below.

	// A small list of five stocks
	string[5] list = ["AAPL", "MSFT", "TSLA", "F", "BRK-B"];
	Date begin = Date(1980, 12, 12);
	Date end = Date(2020, 6, 10);

	// Create the miner object
	YahooFinanceD simpleMiner;

	// Mine each item in the list and save them as json
	foreach(string name; list)
	{
		simpleMiner.Mine(begin, end, name);
		simpleMiner.WriteToJson();	
		assert(simpleMiner.PriceLength() > 100);	
	}
}
