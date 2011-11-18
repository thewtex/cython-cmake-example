from pi_calculator import print_pi

import sys

def test_print_pi():
    for terms in 5, 9, 23, 177, 1111, 33333, 555555:
        sys.stdout.write('{0:10} terms: '.format(terms))
        print_pi(terms)
