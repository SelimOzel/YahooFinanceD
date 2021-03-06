import std.file: write;
import std.datetime;
import std.string;
import std.conv;

// Miner class
import YahooFinanceD;

void main() {
	// Example: Mining between December 12, 2018 and Jun 6, 2020 and creating two universes of stocks
	// One for tech the other one for big three car manufacturers
	string name = "";
	Date begin = Date(2018, 12, 12);
	Date end = Date(2020, 6, 10);
	YahooFinanceD simpleMiner;

	// Tech miners
	name = "MSFT";
	simpleMiner.Mine(begin, end, name, intervals.daily); // scrape daily
	string msft_str = simpleMiner.Write!(output.csv, logger.off, string); // write msft as csv to a string with logger off

	name = "AAPL";
	simpleMiner.Mine(begin, end, name, intervals.daily); // scrape daily
	string aapl_str = simpleMiner.Write!(output.csv, logger.off, string); // write aapl as csv to a string with logger off
	
	name = "AMZN";
	simpleMiner.Mine(begin, end, name, intervals.daily); // scrape daily
	string amzn_str = simpleMiner.Write!(output.csv, logger.off, string); // write amzn as csv to a string with logger off

	// Automobile miners
	name = "GM";
	simpleMiner.Mine(begin, end, name, intervals.daily); // scrape daily
	string gm_str = simpleMiner.Write!(output.csv, logger.off, string); // write gm as csv to a string with logger off

	name = "F";
	simpleMiner.Mine(begin, end, name, intervals.daily); // scrape daily
	string f_str = simpleMiner.Write!(output.csv, logger.off, string); // write f as csv to a string with logger off

	name = "FCAU";
	simpleMiner.Mine(begin, end, name, intervals.daily); // scrape daily
	string fcau_str = simpleMiner.Write!(output.csv, logger.off, string); // write fcau as csv to a string with logger off	

	// Integrate data
	string tech_data = msft_str ~ aapl_str ~ amzn_str;
	string automobile_data = gm_str ~ f_str ~ fcau_str;

	// Write outputs to csv files.
	write("tech_"~end.toISOString()~".csv", tech_data);
	write("automobile_"~end.toISOString()~".csv", automobile_data);
}
