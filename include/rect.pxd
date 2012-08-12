cimport c_rectangle
from c_rectangle cimport Rectangle as CRectangle

cdef class Rectangle:
    cdef c_rectangle.Rectangle *thisptr      # hold a C++ instance which we're wrapping
    cpdef getLength(self)
    cpdef getHeight(self)
    cpdef getArea(self)
    cpdef move(self, dx, dy)
