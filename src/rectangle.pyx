cimport c_rectangle

import rectangle_defaults
import rectangle_description

cdef class Rectangle:

    def __cinit__(self, int x0, int y0, x1=None, y1=None):
        if x1 is None:
            x1 = x0 + rectangle_defaults.DEFAULT_LENGTH
        if y1 is None:
            y1 = y0 + rectangle_defaults.DEFAULT_HEIGHT
        self.thisptr = new c_rectangle.Rectangle(x0, y0, x1, y1)

    def __dealloc__(self):
        del self.thisptr

    cpdef getLength(self):
        return self.thisptr.getLength()

    cpdef getHeight(self):
        return self.thisptr.getHeight()

    cpdef getArea(self):
        return self.thisptr.getArea()

    cpdef move(self, dx, dy):
        self.thisptr.move(dx, dy)

    cpdef describe(self):
        print(rectangle_description.description)
