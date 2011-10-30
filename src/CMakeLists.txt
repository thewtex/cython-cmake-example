include_directories( ${CYTHON_CMAKE_EXAMPLE_SOURCE_DIR}/include )

set_source_files_properties( rectangle.pyx PROPERTIES CYTHON_IS_CXX TRUE )
cython_add_module( rectangle rectangle.pyx Rectangle.cxx )
