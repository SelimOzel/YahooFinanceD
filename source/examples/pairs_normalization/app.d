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
Split,
NormalizeFrameDates;

void main() {
  YahooFinanceD simpleMiner;
  Date begin = Date(2021, 4, 1);
  Date end = Date(2023, 6, 1);
  string name = "";

  name = "BTC-USD";
  simpleMiner.Mine(begin, end, name, intervals.daily);
  Frame[] btc = simpleMiner.Write!(output.frame, logger.off, Frame[]);

  name = "COIN";
  simpleMiner.Mine(begin, end, name, intervals.daily);
  Frame[] coin = simpleMiner.Write!(output.frame, logger.off, Frame[]);

  name = "SLV";
  simpleMiner.Mine(begin, end, name, intervals.daily);
  Frame[] slv = simpleMiner.Write!(output.frame, logger.off, Frame[]);

  name = "SVM";
  simpleMiner.Mine(begin, end, name, intervals.daily);
  Frame[] slvm = simpleMiner.Write!(output.frame, logger.off, Frame[]);

  Frame[][] normalizedToCOIN = NormalizeFrameDates(coin, [btc, slv, slvm]);

  for(int i = 0; i < normalizedToCOIN.length; ++i)
  {
    // Weird break
    writeln();
    writeln("-----::-----::-----::-----::");
    writeln("-----::-----::-----::-----::");
    writeln("Length of " ~ normalizedToCOIN[i][0].name ~ " is " ~  to!string(normalizedToCOIN[i].length));
    writeln("Open, high, low, close, volume");
    for(int j = 0; j < normalizedToCOIN[i].length; ++j)
    {
      writeln(to!string(normalizedToCOIN[i][j].date) ~ ": "~ to!string(normalizedToCOIN[i][j].price.open) ~ ", ", to!string(normalizedToCOIN[i][j].price.high) ~ ", " ~to!string(normalizedToCOIN[i][j].price.low) ~ ", " ~ to!string(normalizedToCOIN[i][j].price.close) ~ ", " ~ to!string(normalizedToCOIN[i][j].price.volume));
    }
  }
}
