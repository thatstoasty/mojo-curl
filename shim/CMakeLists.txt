cmake_minimum_required(VERSION 3.20...3.27)

project(curl_wrapper VERSION 0.1.0 LANGUAGES C)

# Find the CURL package (libcurl)
set(CURL_LIBRARY "-lcurl")
find_package(CURL REQUIRED)

# Build as a shared library that Mojo can import
add_library(curl_wrapper SHARED curl_wrapper.c)

# Link against the CURL library
# Use CURL::libcurl for modern CMake, which handles include directories and library paths
# target_link_libraries(curl_wrapper PUBLIC CURL::libcurl)
target_link_libraries(curl_wrapper PUBLIC ${CURL_LIBRARIES})

# Make sure curl include directories are available
target_include_directories(curl_wrapper PUBLIC ${CURL_INCLUDE_DIRS})

set_target_properties(curl_wrapper PROPERTIES
    C_STANDARD 11
    C_STANDARD_REQUIRED ON
    POSITION_INDEPENDENT_CODE ON
)

install( 
    TARGETS ${PROJECT_NAME}
    EXPORT ${PROJECT_NAME}Targets
    LIBRARY DESTINATION $ENV{PREFIX}/lib/
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${BINDIR}
)
