cmake_minimum_required(VERSION 3.13)

set(CMAKE_C_STANDARD 23)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Target board (override with -DPICO_BOARD=... if needed)
set(PICO_BOARD pico2 CACHE STRING "Board type")

include(pico_sdk_import.cmake)
project(main C CXX ASM)
pico_sdk_init()

add_executable(main main.c lcd.c)

# Optional metadata (used by tools and diagnostic output)
pico_set_program_name(main "main")
pico_set_program_version(main "0.1")

# Enable USB stdio; disable UART to avoid duplicate output
pico_enable_stdio_uart(main 0)
pico_enable_stdio_usb(main 1)
target_compile_options(main PRIVATE -Wno-implicit-function-declaration)
target_link_libraries(main pico_stdlib hardware_i2c)

target_include_directories(main PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}
)

# Generate .elf, .uf2, .bin outputs
pico_add_extra_outputs(main)
