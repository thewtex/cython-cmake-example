cimport c_rectangle

cdef class Rectangle:

    def __cinit__(self, int x0, int y0, int x1, int y1):
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
