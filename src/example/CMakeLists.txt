find_package(TBB REQUIRED)

set(EXECUTABLE_NAME tbb_test)


add_executable(${EXECUTABLE_NAME} main.cpp)
target_link_libraries(${EXECUTABLE_NAME} TBB::tbb)


# Gather the runtime depenencies
# Will also gather the shared libraries from Conan packages
install(TARGETS ${EXECUTABLE_NAME} DESTINATION bin RUNTIME_DEPENDENCY_SET ${EXECUTABLE_NAME}-deps)
install(
  RUNTIME_DEPENDENCY_SET 
    ${EXECUTABLE_NAME}-deps
    PRE_EXCLUDE_REGEXES
    ".*libc\\.so\\..*" # . needs to backslashes to be escaped
)

# Set rpath of the executable
# https://duerrenberger.dev/blog/2021/08/04/understanding-rpath-with-cmake/

set_target_properties(${EXECUTABLE_NAME} PROPERTIES INSTALL_RPATH "$ORIGIN/../lib")

if(USE_IPO AND ipo_supported)
  set_property(TARGET ${EXECUTABLE_NAME} PROPERTY INTERPROCEDURAL_OPTIMIZATION TRUE)
endif()