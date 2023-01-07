include(GNUInstallDirs)

message(
  STATUS
    "${PROJECT_NAME} ${PROJECT_VERSION}  CMake ${CMAKE_VERSION}  Toolchain ${CMAKE_TOOLCHAIN_FILE}"
)

if(local)
  get_filename_component(local ${local} ABSOLUTE)

  if(NOT IS_DIRECTORY ${local})
    message(FATAL_ERROR "Local directory ${local} does not exist")
  endif()
endif()

option(build_cblas "Build CBLAS" false)
option(build_lapacke "Build LAPACKE" false)
option(build_xblas "Build extended blas" false)

# --- other options

if(NOT arith)
  set(arith "s;d")
endif()

if(c IN_LIST arith AND NOT s IN_LIST arith)
  list(APPEND arith s)
endif()
if(z IN_LIST arith AND NOT d IN_LIST arith)
  list(APPEND arith d)
endif()

if(build_lapacke)
  if(s IN_LIST arith AND NOT d IN_LIST arith)
    list(APPEND arith d)
  endif()
  if(d IN_LIST arith AND NOT s IN_LIST arith)
    list(APPEND arith s)
  endif()
  if(c IN_LIST arith OR z IN_LIST arith)
    set(arith "s;d;c;z")
  endif()
endif()

set(CMAKE_TLS_VERIFY true)

set(FETCHCONTENT_UPDATES_DISCONNECTED true)

# Rpath options necessary for shared library install to work correctly in user
# projects
set(CMAKE_INSTALL_NAME_DIR ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR})
set(CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR})
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH true)

# Necessary for shared library with Visual Studio / Windows oneAPI
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS true)

# allow CMAKE_PREFIX_PATH with ~ expand
if(CMAKE_PREFIX_PATH)
  set(NEW_CMAKE_PREFIX_PATH)
  foreach(OLD_PATH IN LISTS CMAKE_PREFIX_PATH)
    cmake_path(ABSOLUTE_PATH OLD_PATH OUTPUT_VARIABLE FULL_PATH)
    list(APPEND NEW_CMAKE_PREFIX_PATH ${FULL_PATH})
  endforeach()
  set(CMAKE_PREFIX_PATH ${NEW_CMAKE_PREFIX_PATH})
endif()

# --- auto-ignore build directory
if(NOT EXISTS ${PROJECT_BINARY_DIR}/.gitignore)
  file(WRITE ${PROJECT_BINARY_DIR}/.gitignore "*")
endif()
