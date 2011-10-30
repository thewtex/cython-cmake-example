cimport c_rectangle

cdef class Rectangle:
    cdef c_rectangle.Rectangle *thisptr      # hold a C++ instance which we're wrapping
    cpdef getLength(self)
    cpdef getHeight(self)
    cpdef getArea(self)
    cpdef move(self, dx, dy)
