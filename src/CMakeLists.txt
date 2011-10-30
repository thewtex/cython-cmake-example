include_directories( ${CYTHON_CMAKE_EXAMPLE_SOURCE_DIR}/include )

set_source_files_properties( rectangle.pyx PROPERTIES CYTHON_IS_CXX TRUE )
# note that current cython behavior seems to set the module name according to
# the last listed .pyx file.
cython_add_module( rectangle rectangle_defaults.pyx rectangle_description.py rectangle.pyx Rectangle.cxx )
