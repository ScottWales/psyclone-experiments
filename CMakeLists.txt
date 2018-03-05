# Minimum tested version
cmake_minimum_required (VERSION 3.5)
project (psclone-experiments)
enable_language (Fortran)

# Download from https://puma.nerc.ac.uk/svn/GOcean_svn/GOcean/trunk/api_v1.0
set( GOCEAN_API_SOURCEDIR ${CMAKE_SOURCE_DIR}/api_v1.0 )

set( PSYCLONE_SOURCEDIR ~/PSyclone )


if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "DEBUG" CACHE STRING
        "Choose the type of build, options are: Debug Release"
        FORCE)
endif(NOT CMAKE_BUILD_TYPE)


# FFLAGS depend on the compiler
get_filename_component (Fortran_COMPILER_NAME ${CMAKE_Fortran_COMPILER} NAME)
message("Compiler " ${Fortran_COMPILER_NAME})

if (Fortran_COMPILER_NAME MATCHES "gfortran.*")
    # gfortran
    set (CMAKE_Fortran_FLAGS_RELEASE "-Wall -O2 -g")
    set (CMAKE_Fortran_FLAGS_DEBUG   "-Wall -fcheck=all -O0 -g")
endif ()


string(REPLACE ':' ';' SYSTEM_LIBRARY_PATH $ENV{LD_LIBRARY_PATH})
string(REPLACE ':' ';' SYSTEM_INCLUDE_PATH $ENV{CPATH})

list(APPEND CMAKE_LIBRARY_PATH ${SYSTEM_LIBRARY_PATH})
list(APPEND CMAKE_INCLUDE_PATH ${SYSTEM_INCLUDE_PATH})

include(FindPackageHandleStandardArgs)
find_library(SQLITE_LIBRARY
    NAMES
        sqlite3
    )
find_path(SQLITE_INCLUDE_DIR
    NAMES
        sqlite3.h
    )
find_package_handle_standard_args(sqlite3  DEFAULT_MSG
                                  SQLITE_LIBRARY SQLITE_INCLUDE_DIR)



add_subdirectory(gocean_api)
# add_subdirectory(psyclone_example)
add_subdirectory(fields)
