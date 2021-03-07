import std.stdio;
import std.datetime;
import std.string;
import std.conv;
import std.math: sqrt, pow;

import YahooFinanceD; // Miner class
import Statistics; // Helper functions

void main() {
	Date begin = Date(2019, 12, 20);
	Date end = Date(2020, 12, 20);
	YahooFinanceD simpleMiner;
	
	writeln("TIP volatility script\n");

	// Standard deviations
	string[1] names = ["TIP"];
	for(int k = 0; k<names.length; k++){
		string name = names[k]; 
		double[] closePrices;
		double std;
		int n = 0;

		simpleMiner.Mine!(logger.off)(begin, end, name, intervals.daily); 
		Frame[] FRAME = simpleMiner.Write!(output.frame, logger.off, Frame[]); 
		n = FRAME.length;
		for(int i = 0; i<n; i++) { closePrices ~= FRAME[i].price.close; }
		std = compute_std(closePrices);
		writeln("Yearly volatility of "~ name ~ " between 2019 and 2020: "~to!string(std));
		writeln("Monthly volatility of "~ name ~ " between 2019 and 2020: "~to!string(std/sqrt(12.0)));		
		writeln();
	}
}
