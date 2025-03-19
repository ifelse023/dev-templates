cmake_minimum_required(VERSION 3.13)

# Set C/C++ standards
set(CMAKE_C_STANDARD 23)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Set the target board
set(PICO_BOARD pico2 CACHE STRING "Board type")
# Import and initialize the Pico SDK
include(pico_sdk_import.cmake)
project(hey C CXX ASM)
pico_sdk_init()

# Add the executable
add_executable(hey hey.c)

# Set program metadata
pico_set_program_name(hey "hey")
pico_set_program_version(hey "0.1")

# Configure stdio
pico_enable_stdio_uart(hey 0)
pico_enable_stdio_usb(hey 1)

# Add libraries and include directories
target_link_libraries(hey pico_stdlib)
target_include_directories(hey PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}
)

# Generate additional files (.uf2, etc.)
pico_add_extra_outputs(hey)
