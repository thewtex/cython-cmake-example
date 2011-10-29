# Define a function to create Cython modules.
#
# For more information on the Cython project, see http://cython.org/.
# "Cython is a language that makes writing C extensions for the Python language
# as easy as Python itself."
#
# This file defines a CMake function to build a Cython Python module.
# To use it, first include this file.
#
#   include( UseCython )
#
# Then call cython_add_module to create a module.
#
#   cython_add_module( <module_name> <src1> <src2> ... <srcN> )
#
# Where <module_name> is the name of the resulting Python module and
# <src1> <src2> ... are source files to be compiled into the module, e.g. *.pyx,
# *.c, *.cxx, etc.  A CMake target is created with name <module_name>.  This can
# be used for target_link_libraries(), etc.
#
# Cache variables that effect the behavior include:
#
#  CYTHON_ANNOTATE
#  CYTHON_NO_DOCSTRINGS
#  CYTHON_FLAGS
#
# See also FindCython.cmake

#=============================================================================
# Copyright 2011 Kitware, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#=============================================================================

# Configuration options.
set( CYTHON_ANNOTATE OFF
  CACHE BOOL "Create an annotated .html file when compiling *.pyx." )
set( CYTHON_NO_DOCSTRINGS OFF
  CACHE BOOL "Strip docstrings from the compiled module." )
set( CYTHON_FLAGS "" CACHE STRING
  "Extra flags to the cython compiler." )
mark_as_advanced( CYTHON_ANNOTATE CYTHON_NO_DOCSTRINGS CYTHON_FLAGS )

find_package( Cython REQUIRED )
find_package( PythonLibs REQUIRED )

set( CYTHON_CXX_EXTENSION "cxx" )
set( CYTHON_C_EXTENSION "c" )

# Create a *.c or *.cxx file from a *.pyx file.
function( COMPILE_PYX_FILE pyx_file generated_file )
  get_filename_component( pyx_file_basename "${pyx_file}" NAME_WE )

  set( pyx_file_is_cxx FALSE )
  get_source_file_property( property_is_cxx ${pyx_file} CYTHON_IS_CXX )
  if( ${property_is_cxx} )
    set( cxx_arg "--cplus" )
    set( extension ${CYTHON_CXX_EXTENSION} )
    set( comment "Compiling Cython CXX source for ${pyx_file}..." )
  else()
    set( cxx_arg "" )
    set( extension ${CYTHON_C_EXTENSION} )
    set( comment "Compiling Cython C source for ${pyx_file}..." )
  endif()
  set( output_file ${pyx_file_basename}.${extension} )
  set_source_files_properties( ${output_file} PROPERTIES GENERATED TRUE )

  get_source_file_property( pyx_location ${pyx_file} LOCATION )
  get_filename_component( pyx_path ${pyx_location} PATH )
  get_directory_property( cmake_include_directories DIRECTORY ${pyx_path} INCLUDE_DIRECTORIES )
  set( include_directory_arg "" )
  foreach( _include_dir ${cmake_include_directories} )
    set( include_directory_arg ${include_directory_arg} "-I" "${_include_dir}" )
  endforeach()

  if( CYTHON_ANNOTATE )
    set( annotate_arg "--annotate" )
  else()
    set( annotate_arg "" )
  endif()

  if( CYTHON_NO_DOCSTRINGS )
    set( no_docstrings_arg "--no-docstrings" )
  else()
    set( no_docstrings_arg "" )
  endif()

  set( _generated_file "${pyx_file_basename}.${extension}" )
  set( ${generated_file} ${_generated_file} PARENT_SCOPE )
  add_custom_command( OUTPUT ${output_file}
    COMMAND ${CYTHON_EXECUTABLE}
    ARGS ${pyx_location} ${cxx_arg} ${include_directory_arg}
    ${annotate_arg} ${no_docstrings_arg} ${CYTHON_FLAGS} 
    --output-file  ${_generated_file}
    DEPENDS ${pyx_file}
    COMMENT ${comment}
    )
endfunction()

# CYTHON_ADD_MODULE( <name> src1 src2 ... srcN )
# Build the Cython Python module.
function( CYTHON_ADD_MODULE _name )
  set( module_sources "" )
  foreach( _file ${ARGN} )
    if( ${_file} MATCHES ".*\\.pyx$" )
      compile_pyx_file( ${_file} generated_file )
      set( module_sources ${module_sources} ${generated_file} )
    else()
      set( module_sources ${module_sources} ${_file} )
    endif()
  endforeach()
  include_directories( ${PYTHON_INCLUDE_DIRS} )
  python_add_module( ${_name} ${module_sources} )
endfunction()
