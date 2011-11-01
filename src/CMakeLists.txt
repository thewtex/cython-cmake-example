include_directories( ${CYTHON_CMAKE_EXAMPLE_SOURCE_DIR}/include )

# If the pyx file is a C++ file, we should specify that here.
set_source_files_properties( rectangle.pyx PROPERTIES CYTHON_IS_CXX TRUE )

# Multi-file cython modules do not appear to be working at the moment.
cython_add_module( rectangle rectangle.pyx Rectangle.cxx )

cython_add_standalone_executable( rectangle-props MAIN_MODULE rectangle_props.py rectangle.pyx
  rectangle_props.py Rectangle.cxx )
