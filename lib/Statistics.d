import std.conv: to;
import std.exception: enforce;
import std.math: sqrt, pow;
import std.random: dice;

// (arithmetic) Mean/Average value of a time series
double compute_mean(double[] array_IN) pure {
  double sum = 0;
  int n = to!int(array_IN.length);
  for(int i = 0; i<n; i++) { sum += array_IN[i]; }
  return sum/n;
}

// Standard deviation (sigma) of a time series
double compute_std(double[] array_IN) pure {
  double sum = 0;
  double mean = compute_mean(array_IN);
  int n = to!int(array_IN.length);
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

// Correlation between two time series.
double compute_correlation(double[] array_x_IN, double[] array_y_IN) pure {
  int n = to!int(array_x_IN.length);
  if(to!int(array_y_IN.length) < n) n = to!int(array_y_IN.length);
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
