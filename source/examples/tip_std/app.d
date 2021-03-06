import std.stdio;
import std.datetime;
import std.string;
import std.conv;
import std.math: sqrt, pow;

import YahooFinanceD; // Miner class
import Statistics; // Helper functions

void main() {
	// Example: 
	// 1- Mine TIP between September 9, 2019 and September 9, 2020
	// 2- Compute year-to-day standard deviation
	// 3- Obtain monthly standard deviation
	string name = "TIP";
	Date begin = Date(2019, 12, 20);
	Date end = Date(2020, 12, 20);

	YahooFinanceD simpleMiner;
	simpleMiner.Mine(begin, end, name, intervals.daily); 
	Frame[] TIP = simpleMiner.Write!(output.frame, logger.off, Frame[]); 
	
	int n = TIP.length;
	double[] TIPclosePrices;
	for(int i = 0; i<n; i++) { TIPclosePrices ~= TIP[i].price.close; }
	double std = compute_std(TIPclosePrices, compute_mean(TIPclosePrices));

	writeln("Yearly volatility of TIP between 2019 and 2020: "~to!string(std));
	writeln("Monthly volatility of TIP between 2019 and 2020: "~to!string(std/sqrt(12.0)));
}
