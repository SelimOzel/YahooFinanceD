import std.math: sqrt, pow;

double compute_mean(double[] array_IN) pure {
	double sum = 0;
	int n = array_IN.length;
	for(int i = 0; i<n; i++) { sum += array_IN[i]; }
	return sum/n;
}

double compute_std(double[] array_IN, double mean_IN) pure {
	double sum = 0;
	int n = array_IN.length;
	for(int i = 0; i<n; i++) { sum += pow((array_IN[i]-mean_IN),2); }
	return sum/n;	
}