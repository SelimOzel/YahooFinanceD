import std.net.curl;
import std.datetime;
import std.file;
import std.conv;
import std.algorithm;
import std.json;

enum output {json} // Output templates can be added in the future
enum logger {on, off} // Enable/disable logging

// Yahoo finance data scraper written in Dlang. Selim Ozel
struct YahooFinanceD
{
public:
	// Write template
	void Write(output val = output.json, logger log = logger.on)()
	{
		WriteImpl!val;
		if(log == logger.on) WriteLogger!val;
	}

	// Write implementation
	void WriteImpl(output val)()
		if(val == output.json)
	{
		if(_miningDone) 
		{
			std.file.write(_name~"_"~_beginDate_s~"_"~_endDate_s~"_prices.json", _j["prices"].toPrettyString);
			std.file.write(_name~"_"~_beginDate_s~"_"~_endDate_s~"_events.json", _j["eventsData"].toPrettyString);
		}
	}

	// Write logger
	void WriteLogger(output val)()
		if(val == output.json)
	{
		import std.stdio: writeln;

		if(_miningDone) 
		{
			writeln("Price output written to " ~ _name~"_"~_beginDate_s~"_"~_endDate_s~"_prices.json. ");
			writeln("Event output written to " ~ _name~"_"~_beginDate_s~"_"~_endDate_s~"_events.json. ");
		}
		else
		{
			writeln("Can't write to json. Mining not done.");
		}
	}

	// Mine template
	void Mine(logger log = logger.on)(Date begin, Date end, string name)
	{
		MineImpl(begin, end, name);
		if(log == logger.on) MineLogger();
	}

	// Mine implementation
	void MineImpl(Date begin, Date end, string name)
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
		_query = "https://finance.yahoo.com/quote/"~name~"/history?period1="~_beginUnix_s~"&period2="~_endUnix_s~"&interval=1d&filter=history&frequency=1d";

		// Curl it
		string content;
		try
		{
			content = to!string(get(_query));
		}
		catch (CurlException e)
		{
			_exceptions[_exceptionIndex] = e.msg;
			_exceptionIndex++;
			_miningDone = false;
		}	

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
			_exceptions[_exceptionIndex] = e.msg;
			_exceptionIndex++;
    		_miningDone = false;				
		} 
	}

	// Mine logger
	void MineLogger()
	{
		import std.stdio: writeln;
		
		writeln("Retrieveing "~_name~" between "~_beginUnix_s~" and "~_endUnix_s~".");
		writeln("Using query: "~_query);

		if(_lastExceptionIndex != _exceptionIndex)
		{
			for(int i = _lastExceptionIndex; i<_exceptionIndex; i++)
			{
				writeln(_exceptions[_lastExceptionIndex]);
			}
			_lastExceptionIndex = _exceptionIndex;
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

	string _name; // name of the currently mined stock
	string _query; // url query for the stock

	Date _beginDate; // begin date in date.time
	Date _endDate; // end daye in date.time
	string _beginDate_s; // begin date as string
	string _endDate_s; // end date as string
	string _beginUnix_s; // begin date in unix time. needed to bind to yahoo url
	string _endUnix_s;	// end date in unix time. needed to bind to yahoo url

	bool _miningDone; // detecs if mining is completed
	JSONValue _j; // json collected from yahoo after mining is done

	const int MAXEXCEPTIONS = 100; // maximum allowed number of exceptions
	string[MAXEXCEPTIONS] _exceptions; // exception container.
	int _exceptionIndex = 0; // current exception index.
	int _lastExceptionIndex = 0;
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
		simpleMiner.Mine!(logger.off)(begin, end, name);
		simpleMiner.Write!(output.json, logger.on);	
		assert(simpleMiner.PriceLength() > 100);	
	}
}
