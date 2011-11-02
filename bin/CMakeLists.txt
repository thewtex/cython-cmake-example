cython_add_standalone_executable( rectangle-props MAIN_MODULE rectangle_props.py
  ${CYTHON_CMAKE_EXAMPLE_SOURCE_DIR}/src/rectangle.pyx
  rectangle_props.py
  ${CYTHON_CMAKE_EXAMPLE_SOURCE_DIR}/Rectangle.cxx
  )
