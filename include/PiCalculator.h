#ifndef __PiCalculator_h
#define __PiCalculator_h

class PiCalculator
{
public:
  void calculate(unsigned int terms);

  typedef void (*show_result_callback_type)(double pi);
  void set_show_result_callback(show_result_callback_type f);

private:
  show_result_callback_type show_result_callback;
};

#endif
