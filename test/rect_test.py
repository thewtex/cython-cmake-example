from unittest import TestCase
from nose.tools import assert_equal

from rect import Rectangle

class RectangleTest(TestCase):

    def setUp(self):
        self.rectangle = Rectangle(1, 2, 3, 4)

    def test_getLength(self):
        assert_equal(self.rectangle.getLength(), 2)

    def test_getHeight(self):
        assert_equal(self.rectangle.getHeight(), 2)

    def test_getArea(self):
        assert_equal(self.rectangle.getArea(), 4)

    def test_move(self):
        self.rectangle.move(4, 8)
        self.test_getLength()
        self.test_getHeight()
        self.test_getArea()
