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
# The sample paths set with the CMake include_directories() command will be used
# for include directories to search for *.pxd when running the Cython complire.
#
# Cache variables that effect the behavior include:
#
#  CYTHON_ANNOTATE
#  CYTHON_NO_DOCSTRINGS
#  CYTHON_FLAGS
#
# Source file properties that effect the build process are
#
#  CYTHON_IS_CXX
#
# If this is set of a *.pyx file with CMake set_source_files_properties()
# command, the file will be compiled as a C++ file.
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
# Input the target *.pyx file.  The generate file will put into the variable
# placed in the "generated_file" argument.
function( COMPILE_PYX_FILE pyx_file generated_file )
  get_filename_component( pyx_file_basename "${pyx_file}" NAME_WE )

  # Determine if it is a C or C++ file.
  set( pyx_file_is_cxx FALSE )
  get_source_file_property( property_is_cxx ${pyx_file} CYTHON_IS_CXX )
  if( ${property_is_cxx} )
    set( cxx_arg "--cplus" )
    set( extension ${CYTHON_CXX_EXTENSION} )
    set( pyx_lang "CXX" )
    set( comment "Compiling Cython CXX source for ${pyx_file}..." )
  else()
    set( cxx_arg "" )
    set( extension ${CYTHON_C_EXTENSION} )
    set( pyx_lang "C" )
    set( comment "Compiling Cython C source for ${pyx_file}..." )
  endif()
  set( _generated_file "${pyx_file_basename}.${extension}" )
  set_source_files_properties( ${_generated_file} PROPERTIES GENERATED TRUE )
  set( ${generated_file} ${_generated_file} PARENT_SCOPE )

  # Get the include directories.
  get_source_file_property( pyx_location ${pyx_file} LOCATION )
  get_filename_component( pyx_path ${pyx_location} PATH )
  get_directory_property( cmake_include_directories DIRECTORY ${pyx_path} INCLUDE_DIRECTORIES )
  set( include_directory_arg "" )
  foreach( _include_dir ${cmake_include_directories} )
    set( include_directory_arg ${include_directory_arg} "-I" "${_include_dir}" )
  endforeach()

  # Determine dependencies.
  set( pxd_dependencies "" )
  # Add the pxd file will the same name as the given pyx file.
  find_file( corresponding_pxd_file ${pyx_file_basename}.pxd
    PATHS "${pyx_path}" ${cmake_include_directories} 
    NO_DEFAULT_PATH )
  if( corresponding_pxd_file )
    set( pxd_dependencies "${corresponding_pxd_file}" )
  endif()

  # pxd files to check for additional dependencies.
  set( pxds_to_check "${pyx_file}" "${pxd_dependencies}" )
  set( pxds_checked "" )
  set( c_header_dependencies "" )
  set( number_pxds_to_check 1 )
  while( ${number_pxds_to_check} GREATER 0 )
    foreach( pxd ${pxds_to_check} )
      list( APPEND pxds_checked "${pxd}" )
      list( REMOVE_ITEM pxds_to_check "${pxd}" )

      # check for C header dependencies
      file( STRINGS ${pxd} extern_from_statements
        REGEX "cdef[ ]+extern[ ]+from.*$" )
      foreach( statement ${extern_from_statements} )
        # Had trouble getting the quote in the regex
        string( REGEX REPLACE "cdef[ ]+extern[ ]+from[ ]+[\"]([^\"]+)[\"].*" "\\1" header "${statement}" )
        find_file( header_location ${header} PATHS ${cmake_include_directories} )
        if( header_location )
          list( FIND c_header_dependencies "${header_location}" header_idx )
          if( ${header_idx} LESS 0 )
            list( APPEND c_header_dependencies "${header_location}" )
          endif()
        endif()
      endforeach()

      # check for pxd dependencies

      # Look for cimport statements.
      set( module_dependencies "" )
      file( STRINGS ${pxd} cimport_statements REGEX cimport )
      foreach( statement ${cimport_statements} )
        if( ${statement} MATCHES from )
          string( REGEX REPLACE "from[ ]+([^ ]+).*" "\\1" module "${statement}" )
        else()
          string( REGEX REPLACE "cimport[ ]+([^ ]+).*" "\\1" module "${statement}" )
        endif()
        list( APPEND module_dependencies ${module} )
      endforeach()
      list( REMOVE_DUPLICATES module_dependencies )
      # Add the module to the files to check, if appropriate.
      foreach( module ${module_dependencies} )
        find_file( pxd_location ${module}.pxd
          PATHS "${pyx_path}" ${cmake_include_directories} NO_DEFAULT_PATH )
        if( pxd_location )
          list( FIND pxds_checked ${pxd_location} pxd_idx )
          if( ${pxd_idx} LESS 0 )
            list( FIND pxds_to_check ${pxd_location} pxd_idx )
            if( ${pxd_idx} LESS 0 )
              list( APPEND pxds_to_check ${pxd_location} )
              list( APPEND pxd_dependencies ${pxd_location} )
            endif() # if it is not already going to be checked
          endif() # if it has not already been checked
        endif() # if pxd file can be found
      endforeach() # for each module dependency discovered
    endforeach() # for each pxd file to check
    list( LENGTH pxds_to_check number_pxds_to_check )
  endwhile()

  # Set additional flags.
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

  # Add the command to run the compiler.
  add_custom_command( OUTPUT ${_generated_file}
    COMMAND ${CYTHON_EXECUTABLE}
    ARGS ${pyx_location} ${cxx_arg} ${include_directory_arg}
    ${annotate_arg} ${no_docstrings_arg} ${CYTHON_FLAGS} 
    --output-file  ${_generated_file}
    DEPENDS ${pyx_file} ${pxd_dependencies}
    IMPLICIT_DEPENDS ${pyx_lang} ${c_header_dependencies}
    COMMENT ${comment}
    )
endfunction()

# cython_add_module( <name> src1 src2 ... srcN )
# Build the Cython Python module.
function( cython_add_module _name )
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
