import std.stdio;
import std.datetime;
import std.string;
import std.conv;
import std.math: sqrt, pow;
import std.file: write;

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
import plt = matplotlibd.pyplot; // Charts

void main() {
  Date begin = Date(2019, 12, 20);
  Date end = Date(2020, 12, 20);
  YahooFinanceD simpleMiner;
  string[9] stock_names = ["SOXX", "FZROX", "SOXL", "XSD", "PSI", "GLD", "BND", "SPY", "QQQ"]; 
  string FRAMES_str = "";
  double[] closePrices_SOXX;

  writeln("SOXX script\n");

  // Get SOXX first
  simpleMiner.Mine!(logger.off)(begin, end, stock_names[0], intervals.daily); 
  Frame[] SOXX = simpleMiner.Write!(output.frame, logger.off, Frame[]); 
  for(int i = 0; i<SOXX.length; i++) { closePrices_SOXX ~= SOXX[i].price.close; }

  // Compute correlations, std and save everything as csv
  for(int k = 0; k<stock_names.length; k++){
    string name = stock_names[k]; 
    double[] closePrices;
    double[] closePrices_perc;
    double correlation;
    double std;
    int n = 0;
    string FRAME_str = "";

    // Compute correlations
    simpleMiner.Mine!(logger.off)(begin, end, name, intervals.daily); 
    Frame[] FRAME = simpleMiner.Write!(output.frame, logger.off, Frame[]); 
    FRAME_str = simpleMiner.Write!(output.csv, logger.off, string); // write prices as csv to a string with logger off
    n = to!int(FRAME.length);
    for(int i = 0; i<n; i++) { closePrices ~= FRAME[i].price.close; }
    correlation = compute_correlation(closePrices, closePrices_SOXX);
    writeln("Correlation between SOXX and "~ name ~ " between 2019 and 2020: "~to!string(correlation));   

    // Compute std
    for(int i = 0; i<n; i++) { closePrices_perc ~= ((FRAME[i].price.close/FRAME[0].price.close)-1.0) * 100; }
    std = compute_std(closePrices_perc);
    writeln("Yearly volatility of "~ name ~ " between 2019 and 2020: "~to!string(std));
    writeln("Monthly volatility of "~ name ~ " between 2019 and 2020: "~to!string(std/sqrt(12.0))~"\n");  

    // Save strings to database as csv
    FRAMES_str ~= FRAME_str;
  }

  // Write outputs to csv files.
  write("soxx_analysis_"~end.toISOString()~".csv", FRAMES_str);
}
