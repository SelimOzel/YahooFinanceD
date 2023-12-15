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
  YahooFinanceD simpleMiner;
  Date begin = Date(2021, 4, 1);
  Date end = Date(2023, 6, 1);
  string name = "";

  name = "BTC-USD";
  simpleMiner.Mine(begin, end, name, intervals.daily);
  Frame[] btc = simpleMiner.Write!(output.frame, logger.off, Frame[]);
  double[] btc_time_series;
  for(int i = 0; i<btc.length; i++)
  {
    writeln(btc[i].date.toString ~ " " ~ to!string(btc[i].price.close));
    btc_time_series ~= to!double(btc[i].price.close);
  }

  name = "COIN";
  simpleMiner.Mine(begin, end, name, intervals.daily);
  Frame[] coin = simpleMiner.Write!(output.frame, logger.off, Frame[]);
  double[] coin_time_series;
  for(int i = 0; i<coin.length; i++)
  {
    writeln(coin[i].date.toString ~ " " ~ to!string(coin[i].price.close));
    coin_time_series ~= to!double(coin[i].price.close);
  }

  name = "SLV";
  simpleMiner.Mine(begin, end, name, intervals.daily);
  Frame[] slv = simpleMiner.Write!(output.frame, logger.off, Frame[]);
  double[] slv_time_series;
  for(int i = 0; i<slv.length; i++)
  {
    writeln(slv[i].date.toString ~ " " ~ to!string(slv[i].price.close));
    slv_time_series ~= to!double(slv[i].price.close);
  }

  name = "SLVM";
  simpleMiner.Mine(begin, end, name, intervals.daily);
  Frame[] slvm = simpleMiner.Write!(output.frame, logger.off, Frame[]);
  double[] slvm_time_series;
  for(int i = 0; i<slvm.length; i++)
  {
    writeln(slvm[i].date.toString ~ " " ~ to!string(slvm[i].price.close));
    slvm_time_series ~= to!double(slvm[i].price.close);
  }
}
