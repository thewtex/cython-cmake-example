#include "PiCalculator.h"

void
PiCalculator
::calculate(unsigned int terms)
{
  double pi = 0.0;
  // Leibniz formula for pi
  double numerator = -1.0;
  double denominator = -1.0;
  for( unsigned int ii = 0; ii < terms; ++ii )
    {
    numerator   *= -1;
    denominator += 2.0;
    pi += numerator / denominator;
    }
  pi *= 4.0;
  this->show_result_callback(pi);
}

void
PiCalculator
::set_show_result_callback(show_result_callback_type f)
{
  this->show_result_callback = f;
}
