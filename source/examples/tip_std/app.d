import std.stdio;
import std.datetime;
import std.string;
import std.conv;
import std.math: sqrt, pow;

import YahooFinanceD: 
YahooFinanceD,
output,
logger,
intervals,
Frame,
Price,
Dividend,
Split;
import Statistics; // Helper functions

void main() {
  int year_begin = 2019;
  int year_end = 2020;
  Date begin = Date(year_begin, 12, 20);
  Date end = Date(year_end, 12, 20);
  YahooFinanceD simpleMiner;
  
  writeln("Volatility script\n");

  // Standard deviations
  string[1] names = ["TIP"];
  for(int k = 0; k<names.length; k++){
    string name = names[k]; 
    double[] closePrices_perc;
    double std;
    int n = 0;

    simpleMiner.Mine!(logger.off)(begin, end, name, intervals.daily); 
    Frame[] FRAME = simpleMiner.Write!(output.frame, logger.off, Frame[]); 
    n = to!int(FRAME.length);
    for(int i = 0; i<n; i++) { closePrices_perc ~= ((FRAME[i].price.close/FRAME[0].price.close)-1.0) * 100; }
    std = compute_std(closePrices_perc);
    writeln("Yearly volatility of "~ name ~ " between "~to!string(year_begin)~" and "~to!string(year_end)~": "~to!string(std));
    writeln("Monthly volatility of "~ name ~ " between "~to!string(year_begin)~" and "~to!string(year_end)~": "~to!string(std/sqrt(12.0)));   
    writeln("Daily volatility of "~ name ~ " between "~to!string(year_begin)~" and "~to!string(year_end)~": "~to!string(std/sqrt(252.0)));
    writeln();
  }
}
