import std.net.curl;
import std.datetime;
import std.file;
import std.conv;
import std.algorithm;
import std.json;

enum output {json, frame, csv} // Feel free to add your own templates here
enum logger {on, off} // Enable/disable logging
enum intervals {daily = "1d", weekly = "1wk", monthly = "1mo"}

struct Frame
{
	Price price;
	Dividend div;
	Split split;
	Date date;
}

struct Price
{
	double adjclose;
	double close;
	double high;
	double low;
	double open;
	long volume;
}

struct Dividend
{
	double amount;
}	

struct Split
{
	long denominator;
	long numerator;
}

// Yahoo finance data scraper written in Dlang. Selim Ozel
struct YahooFinanceD
{
public:
	// Write template
	T Write(output val = output.json, logger log = logger.on, T = bool)(string option = "")
	{
		T result = WriteImpl!val(option);
		if(log == logger.on) WriteLogger!val;
		return result;
	}

	// Write implementation - json
	bool WriteImpl(output val, T = bool)(string option = "")
		if(val == output.json)
	{
		if(_miningDone) 
		{
			if(option == "prices" || option == "") std.file.write(_name~"_"~_beginDate_s~"_"~_endDate_s~"_prices.json", _j["prices"].toPrettyString);
			if(option == "eventsData" || option == "") std.file.write(_name~"_"~_beginDate_s~"_"~_endDate_s~"_events.json", _j["eventsData"].toPrettyString);
			return true;
		}
		else
		{
			return false;
		}
	}

	// Write logger - json
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

	// Write implementation - frame
	Frame[] WriteImpl(output val, T = Frame[])(string option = "")
		if(val == output.frame)
	{
		Frame[] result;
		if(_miningDone) 
		{
			Split s;
			Dividend d;

			for (int i = _j["prices"].array.length-1; i>=0; i--)
			{
				Frame frame;
				string date = to!string(_j["prices"][i]["date"]);
				frame.date = cast(Date)SysTime(unixTimeToStdTime(to!long(date)));

				if("type" in _j["prices"][i])
				{
					string type = to!string(_j["prices"][i]["type"]);
					if(type == "\"SPLIT\"") 
					{
						s.denominator = _j["prices"][i]["denominator"].integer;
						s.numerator = _j["prices"][i]["numerator"].integer;
						_splitsWritten++;
					}
					if(type == "\"DIVIDEND\"") 
					{	
						d.amount = to!double(_j["prices"][i]["amount"].floating);
						_divsWritten++;
					}					
				}
				else
				{
					// Make sure to save div/split with the correct price/date data. 
					frame.div = d;
					frame.split = s;

					d.amount = 0;
					s.denominator = 0;
					s.numerator = 0;

					Price price;

					// adjclose
					if(_j["prices"][i]["adjclose"].type() == JSONType.integer)
					{
						price.adjclose = to!double(_j["prices"][i]["adjclose"].integer);
					}
					else if(_j["prices"][i]["adjclose"].type() == JSONType.float_)
					{
						price.adjclose = _j["prices"][i]["adjclose"].floating;
					}	
					else if(_j["prices"][i]["adjclose"].type() == JSONType.null_)
					{
						continue;
					}		

					// close
					if(_j["prices"][i]["close"].type() == JSONType.integer)
					{
						price.close = to!double(_j["prices"][i]["close"].integer);
					}
					else if(_j["prices"][i]["close"].type() == JSONType.float_)
					{
						price.close = _j["prices"][i]["close"].floating;
					}	
					else if(_j["prices"][i]["close"].type() == JSONType.null_)
					{
						continue;
					}	

					// high
					if(_j["prices"][i]["high"].type() == JSONType.integer)
					{
						price.high = to!double(_j["prices"][i]["high"].integer);
					}
					else if(_j["prices"][i]["high"].type() == JSONType.float_)
					{
						price.high = _j["prices"][i]["high"].floating;
					}	
					else if(_j["prices"][i]["high"].type() == JSONType.null_)
					{
						continue;
					}	

					// low
					if(_j["prices"][i]["low"].type() == JSONType.integer)
					{
						price.low = to!double(_j["prices"][i]["low"].integer);
					}
					else if(_j["prices"][i]["low"].type() == JSONType.float_)
					{
						price.low = _j["prices"][i]["low"].floating;
					}	
					else if(_j["prices"][i]["low"].type() == JSONType.null_)
					{
						continue;
					}

					// open
					if(_j["prices"][i]["open"].type() == JSONType.integer)
					{
						price.open = to!double(_j["prices"][i]["open"].integer);
					}
					else if(_j["prices"][i]["open"].type() == JSONType.float_)
					{
						price.open = _j["prices"][i]["open"].floating;
					}	
					else if(_j["prices"][i]["open"].type() == JSONType.null_)
					{
						continue;
					}

					// volume
					if(_j["prices"][i]["open"].type() != JSONType.null_)
					{
						price.volume = _j["prices"][i]["volume"].integer;
					}
					frame.price = price;
					_pricesWritten++;
					result ~= frame;
				}
			}
		}
		return result;
	}	

	// Write implementation - frame
	void WriteLogger(output val)()
		if(val == output.frame)
	{
		import std.stdio: writeln;

		if(_miningDone) 
		{		
			writeln("Frame generated for "~_name~" with "~to!string(_divsWritten)~ " dividends, " ~to!string(_splitsWritten)~ " splits and "~to!string(_pricesWritten)~ " prices.");
		}
	}	

	// Write implementation - csv
	// Same as https://www.quandl.com/data/EOD-End-of-Day-US-Stock-Prices/
	// Name, Date, Unadjusted Open, Unadjusted High, Unadjusted Low, Unadjusted Close, Unadjusted Volume, Dividends, Splits, Adjusted Open, Adjusted High, Adjusted Low, Adjusted Close, Adjusted Volume	
	string WriteImpl(output val, T = string)(string option = "")
		if(val == output.csv)
	{	
		import std.stdio: writeln;

		string result = "";
		Frame[] data_frame = Write!(output.frame, logger.off, Frame[]); 
		for(int i = 0; i<data_frame.length; i++)
		{
			result~=_name~",";

			// converts yyyymmdd to yyyy-mm-dd
			string date_conversion = data_frame[i].date.toISOString();
			date_conversion = date_conversion[0 .. 4]~"-"~date_conversion[4 .. 6]~"-"~date_conversion[6 .. 8];

			result~=to!string(date_conversion)~",";
			result~=to!string(data_frame[i].price.open)~",";
			result~=to!string(data_frame[i].price.high)~",";
			result~=to!string(data_frame[i].price.low)~",";
			result~=to!string(data_frame[i].price.close)~",";
			result~=to!string(data_frame[i].price.volume)~",";
			result~=to!string(data_frame[i].div.amount)~",";
			if(data_frame[i].split.numerator != 0 && data_frame[i].split.denominator != 0)
			{
				result~=to!string(data_frame[i].split.numerator/data_frame[i].split.denominator)~",";
			}
			else
			{
				result~=to!string("1.0"~",");
			}
			result~="0.0"~","; // Adjusted open n.a. in yahoo finance
			result~="0.0"~","; // Adjusted high n.a. in yahoo finance
			result~="0.0"~","; // Adjusted low n.a. in yahoo finance
			result~=to!string(data_frame[i].price.adjclose)~","; 
			result~="0.0"; // Adjusted volume n.a. in yahoo finance
			result~="\n";
		}		
		return result;
	}

	// Write implementation - csv
	void WriteLogger(output val)()
		if(val == output.csv)
	{
		import std.stdio: writeln;
		writeln("CSV writer executed.");
	}		

	// Mine template
	void Mine(logger log = logger.on)(Date begin, Date end, string name, intervals interval=intervals.daily)
	{
		MineImpl(begin, end, name, interval);
		if(log == logger.on) MineLogger();
	}

	// Mine implementation
	void MineImpl(Date begin, Date end, string name, intervals interval)
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

		// Reset counters
		_divsWritten = 0; 
		_splitsWritten = 0;
		_pricesWritten = 0; 

		// Assemble query. Use unix time.
		_query = "https://finance.yahoo.com/quote/"~name~"/history?period1="~_beginUnix_s~"&period2="~_endUnix_s~"&interval="~interval~"&filter=history&frequency="~interval;

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
	int _lastExceptionIndex = 0; // to print exceptions

	int _divsWritten; // number of data frame divs
	int _splitsWritten; // number of data frame splits
	int _pricesWritten; // number of data frame prices
}

unittest
{
	// Test: Check that lengths are larger than 100. 
	// That's a reasonable expectation the sotcks listed below.

	// A small list of five stocks
	string[6] list = ["AAPL", "MSFT", "TSLA", "F", "BRK-B", "TQQQ"];
	Date begin = Date(1980, 12, 12);
	Date end = Date(2020, 6, 10);

	// Create the miner object
	YahooFinanceD simpleMiner;

	// Mine each item in the list and save them as json
	foreach(string name; list)
	{
		simpleMiner.Mine!(logger.on)(begin, end, name);
		simpleMiner.Write!(output.json, logger.on);	
		assert(simpleMiner.PriceLength() > 100);
		Frame[] frame = simpleMiner.Write!(output.frame, logger.on, Frame[]); 
		assert(frame.length > 100);
	}
}
