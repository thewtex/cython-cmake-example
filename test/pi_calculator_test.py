from pi_calculator import print_pi

import sys
import timeit

def py_print_pi(terms):
    pi = 0.0
    numerator = -1.0;
    denominator = -1.0;
    for ii in range(terms):
        numerator   *= -1;
        denominator += 2.0;
        pi += numerator / denominator;
    pi *= 4.0;
    print(pi)

def test_print_pi():
    print('')
    for terms in 5, 9, 23, 177, 1111, 33333, 555555:
        sys.stdout.write('{0:10} terms: '.format(terms))
        print_pi(terms)

def test_time_print_pi():
    print('')
    print('timing cython print_pi():')
    print(timeit.timeit('print_pi(1000000)', 'from pi_calculator import print_pi', number=5))
    print('')
    print('timing python py_print_pi():')
    print(timeit.timeit('py_print_pi(1000000)', 'from pi_calculator_test import py_print_pi', number=5))
