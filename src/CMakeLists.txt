# If the pyx file is a C++ file, we should specify that here.
set_source_files_properties(
  ${CYTHON_CMAKE_EXAMPLE_SOURCE_DIR}/src/rect.pyx
  ${CYTHON_CMAKE_EXAMPLE_SOURCE_DIR}/src/pi_calculator.pyx
  PROPERTIES CYTHON_IS_CXX TRUE )

# Multi-file cython modules do not appear to be working at the moment.
cython_add_module( rect rect.pyx Rectangle.cxx )

cython_add_module( pi_calculator pi_calculator.pyx PiCalculator.cxx )
