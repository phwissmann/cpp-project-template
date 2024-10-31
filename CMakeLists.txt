cmake_minimum_required(VERSION 3.28 FATAL_ERROR)


project(EXAMPLE_PROJECT CXX)


set(VERSION_MAJOR 0)
set(VERSION_MINOR 1)
set(VERSION_PATCH 0)


# Compiler cache to speed up re-compilations
set(USE_CCACHE "ON" CACHE STRING "Use ccache to speed up re-compilations")
if(USE_CCACHE)
  find_program(CCACHE_PROGRAM ccache REQUIRED)
endif()

# Mold, a faster linker: https://github.com/rui314/mold 
set(USE_MOLD "ON" CACHE STRING "Use mold linker")
if(USE_MOLD)
  find_program(MOLD_PROGRAM mold REQUIRED)
endif()

set(USE_IPO "ON" CACHE STRING "Use mold linker")
if(USE_IPO)
  check_ipo_supported(RESULT ipo_supported OUTPUT output)
  if(NOT ipo_supported)
    message(WARNING "IPO is not supported: ${output}")
  endif()
endif()

set(CMAKE_EXPORT_COMPILE_COMMANDS "ON")
set(CMAKE_CXX_STANDARD 17)


if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
  if(USE_MOLD)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fuse-ld=mold")
  endif()

  set(USE_LTO "OFF" CACHE STRING "Use link-time optimization")
  if(USE_LTO)
    set(ADDITIONAL_CXXFLAGS "${ADDITIONAL_CXXFLAGS} -flto=auto")
    set(ADDITIONAL_LDFLAGS "${ADDITIONAL_LDFLAGS} -fuse-linker-plugin")
  endif()

  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${ADDITIONAL_CXXFLAGS}")
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${ADDITIONAL_LDFLAGS}")
endif()


# find_package(Git REQUIRED)

# # Packaging step
# execute_process(
#   COMMAND ${GIT_EXECUTABLE} rev-parse --short HEAD
#   WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
#   OUTPUT_VARIABLE CURRENT_GIT_HASH
#   RESULT_VARIABLE ERROR_CODE
#   OUTPUT_STRIP_TRAILING_WHITESPACE
#   )

# execute_process(
#   COMMAND ${GIT_EXECUTABLE} rev-parse --abbrev-ref HEAD
#   WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
#   OUTPUT_VARIABLE CURRENT_GIT_BRANCH
#   RESULT_VARIABLE ERROR_CODE
#   OUTPUT_STRIP_TRAILING_WHITESPACE
# )

# string(REPLACE "/" "-" SANITIZED_GIT_BRANCH ${CURRENT_GIT_BRANCH})

# set(CPACK_PACKAGE_FILE_NAME "${CMAKE_PROJECT_NAME}-${CMAKE_PROJECT_VERSION}-${SANITIZED_GIT_BRANCH}-${CURRENT_GIT_HASH}")
# set(CPACK_PACKAGE_VENDOR "SLF")

# set(CPACK_INSTALL_PREFIX "${PROJECT_BINARY_DIR}/install")
# set(CPACK_GENERATOR "TGZ")
# set(CPACK_PACKAGE_DIRECTORY "${PROJECT_BINARY_DIR}/package")

