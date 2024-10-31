find_package(TBB REQUIRED)



add_executable(${PROJECT_NAME} main.cpp)
target_link_libraries(${PROJECT_NAME} TBB::tbb)

install(TARGETS ${PROJECT_NAME} DESTINATION bin RUNTIME_DEPENDENCY_SET ${PROJECT_NAME}-deps)
install(RUNTIME_DEPENDENCY_SET ${PROJECT_NAME}-deps)

set_target_properties(${PROJECT_NAME} PROPERTIES INSTALL_RPATH "$ORIGIN/../lib")

if(USE_IPO AND ipo_supported)
  set_property(TARGET ${PROJECT_NAME} PROPERTY INTERPROCEDURAL_OPTIMIZATION TRUE)
endif()