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
	
	writeln("Golden script\n");

	string[6] gold_names = ["GOLD", "NEM", "KL", "GLD", "BRK-B", "TIP"]; // Barrick's, Newmont, Kirkland Lake Gold, Gold ETF, Berkshire, TIP
	simpleMiner.Mine!(logger.off)(begin, end, gold_names[3], intervals.daily); 
	Frame[] GOLD = simpleMiner.Write!(output.frame, logger.off, Frame[]); 
	double[] closePrices_GOLD;
	for(int i = 0; i<GOLD.length; i++) { closePrices_GOLD ~= GOLD[i].price.close; }

	// Correlations of gold mining companies versus gold etf
	for(int k = 0; k<gold_names.length; k++){
		string name = gold_names[k]; 
		double[] closePrices;
		double correlation;
		int n = 0;

		simpleMiner.Mine!(logger.off)(begin, end, name, intervals.daily); 
		Frame[] FRAME = simpleMiner.Write!(output.frame, logger.off, Frame[]); 
		n = FRAME.length;
		for(int i = 0; i<n; i++) { closePrices ~= FRAME[i].price.close; }
		correlation = compute_correlation(closePrices, closePrices_GOLD);
		writeln("Correlation between GLD and "~ name ~ " between 2019 and 2020: "~to!string(correlation));		
		writeln();
	}
}
