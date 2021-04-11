import std.math: sqrt, pow;
import std.exception: enforce;
import std.random: dice;

/* 
	Mean value of a time series
*/ 
double compute_mean(double[] array_IN) pure {
	double sum = 0;
	int n = array_IN.length;
	for(int i = 0; i<n; i++) { sum += array_IN[i]; }
	return sum/n;
}

/*
	Standard deviation (sigma) of a time series
*/
double compute_std(double[] array_IN) pure {
	double sum = 0;
	double mean = compute_mean(array_IN);
	int n = array_IN.length;
	for(int i = 0; i<n; i++) { sum += pow((array_IN[i]-mean),2); }
	return sqrt(sum/n);	
}

/*
	Compute variance (sigma^2)
*/
double compute_variance(double[] array_IN) pure {
	double std = compute_std(array_IN);
	return pow(std,2);
}

/* 
	Correlation between two time series.
*/ 
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

/* 
	Compute ordinary least squares estimators for two time series
	y = b1 + b2*x
*/ 
double[2] compute_ordinary_least_squares(double[] array_x_IN, double[] array_y_IN) pure {
	enforce(array_x_IN.length == array_y_IN.length, "compute_ordinary_least_squares: not same length"); 
	int n = array_x_IN.length;
	double x_mean = compute_mean(array_x_IN);
	double y_mean = compute_mean(array_y_IN);
	double numerator = 0.0;
	double denominator = 0.0;
	double b1, b2;
	for(int i = 0; i<n; i++) {
		numerator += (array_x_IN[i]-x_mean)*(array_y_IN[i]-y_mean);
		denominator += pow(array_x_IN[i]-x_mean, 2);
	}
	b2 = numerator/denominator;
	b1 = y_mean - b2*x_mean;
	return [b1, b2];
}

/*
	Generate points from an autoregressive process as a double vector
	y_t = alpha + rho*y_t-1 + e_t
*/
double[] generate_autoregressive_process(double alpha, double rho, double e_t, int n) {
    double y = 0;
    double[] time_series;
    for (int i = 0; i<n; i++) {
        if (dice(0.5, 0.5) == 1) y = alpha + rho*y + e_t;
        else y = alpha + rho*y - e_t;
        time_series ~= y;   	
    }
    return time_series;
}