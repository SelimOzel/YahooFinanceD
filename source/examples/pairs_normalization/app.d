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

  name = "SLVM";
  simpleMiner.Mine(begin, end, name, intervals.daily);
  Frame[] slvm = simpleMiner.Write!(output.frame, logger.off, Frame[]);

  Frame[][] normalizedToCOIN = NormalizeFrameDates(coin, [btc, slv, slvm]);
}
