cmake_minimum_required(VERSION 3.30 FATAL_ERROR)


project(Example CXX)


set(VERSION_MAJOR 0)
set(VERSION_MINOR 1)
set(VERSION_PATCH 0)

set(VERSION_STRING "${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}" CACHE STRING "VERSION STRING")


# Compiler cache to speed up re-compilations
set(USE_CCACHE "ON" CACHE STRING "Use ccache to speed up re-compilations")
if(USE_CCACHE)
  find_program(CCACHE_PROGRAM ccache REQUIRED)
  set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ${CCACHE_PROGRAM})
endif()

# C++ standard
set(CMAKE_CXX_STANDARD 20)

# Disable module parsing:
# cmake generates compile commands with @*.modmap paramaters which are not valid clang syntax
set(CMAKE_CXX_SCAN_FOR_MODULES "OFF")

# Compiler commands used by tools like clangd
set(CMAKE_EXPORT_COMPILE_COMMANDS "ON")



set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${ADDITIONAL_CXXFLAGS}")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${ADDITIONAL_LDFLAGS}")

# Detect Linker
# If Mold is found, it will be used else LLD

# Mold, a faster linker: https://github.com/rui314/mold 
find_program(MOLD mold NO_CACHE)
find_program(LLD lld NO_CACHE)
if(MOLD)
  message("Using mold linker: ${MOLD}")
  if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    if(CMAKE_C_COMPILER_VERSION VERSION_LESS 12.1)
      set(CMAKE_C_USING_LINKER_mold -B${MOLD})
    else()
      set (CMAKE_LINKER_TYPE "MOLD" )
    endif()
  else()
    set (CMAKE_LINKER_TYPE "MOLD" )
  endif()
elseif(LLD)
  message("Using lld linker: ${LLD}")
  set (CMAKE_LINKER_TYPE "LLD" )
else()
  message(FATAL_ERROR "no compatible linker found")
endif()

# Link-time optimization
set(USE_LTO "OFF" CACHE STRING "Use link-time optimization")
if(USE_LTO)
  find_package(CheckIPOSupported)
  include(CheckIPOSupported)
  check_ipo_supported()
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fuse-linker-plugin")
endif()

# Add the actual code in subdirectories
add_subdirectory(example)

# Define variables used in packages
# https://cmake.org/cmake/help/book/mastering-cmake/chapter/Packaging%20With%20CPack.html
set(PACKAGE_SUFFIX "${VERSION_STRING}")

set(CPACK_PACKAGE_FILE_NAME "${CMAKE_PROJECT_NAME}.${PACKAGE_SUFFIX}.${CMAKE_BUILD_TYPE}")
set(CPACK_PACKAGE_VENDOR "")
set(CPACK_INSTALL_PREFIX "${PROJECT_BINARY_DIR}/install")
set(CPACK_GENERATOR "TGZ")
set(CPACK_PACKAGE_DIRECTORY "${PROJECT_BINARY_DIR}/package")

include(CPack)