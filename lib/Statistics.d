import std.math: sqrt, pow;
import std.exception: enforce;

double compute_mean(double[] array_IN) pure {
	double sum = 0;
	int n = array_IN.length;
	for(int i = 0; i<n; i++) { sum += array_IN[i]; }
	return sum/n;
}

double compute_std(double[] array_IN) pure {
	double sum = 0;
	int n = array_IN.length;
	for(int i = 0; i<n; i++) { sum += pow((array_IN[i]-compute_mean(array_IN)),2); }
	return sum/n;	
}

double compute_correlation(double[] array_x_IN, double[] array_y_IN) pure {
	enforce(array_x_IN.length == array_y_IN.length, "compute_correlation: not same length"); 
	int n = array_x_IN.length;
	double x_mean = compute_mean(array_x_IN);
	double y_mean = compute_mean(array_y_IN);
	double numerator = 0.0;
	double denominator = 0.0;
	for (int i = 0; i<n; i++) {
		numerator += (array_x_IN[i]-x_mean)*(array_y_IN[i]-y_mean);
		denominator += sqrt(pow(array_x_IN[i]-x_mean, 2)*pow(array_y_IN[i]-y_mean, 2));
	}
	return numerator/denominator;
}