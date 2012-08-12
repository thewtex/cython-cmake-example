# If the pyx file is a C++ file, we should specify that here.
set_source_files_properties( ${CYTHON_CMAKE_EXAMPLE_SOURCE_DIR}/src/rect.pyx PROPERTIES CYTHON_IS_CXX TRUE )

cython_add_standalone_executable( rectangle-props MAIN_MODULE rectangle_props.py
  ${CYTHON_CMAKE_EXAMPLE_SOURCE_DIR}/src/rect.pyx
  rectangle_props.py
  ${CYTHON_CMAKE_EXAMPLE_SOURCE_DIR}/src/Rectangle.cxx
  )
