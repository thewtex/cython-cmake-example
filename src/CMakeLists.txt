include_directories( ${CMAKE_CURRENT_SOURCE_DIR} )

set_source_files_properties( rectangle.pyx PROPERTIES CYTHON_IS_CXX TRUE )
cython_add_module( rectangle rectangle.pyx Rectangle.cxx )
