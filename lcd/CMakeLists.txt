cmake_minimum_required(VERSION 3.13)

find_program(PICOTOOL_PATH picotool REQUIRED)

add_executable(picotool IMPORTED GLOBAL)
set_target_properties(picotool PROPERTIES IMPORTED_LOCATION "${PICOTOOL_PATH}")
option(CMAKE_BUILD_TYPE "Build type" Release)
set(CMAKE_C_STANDARD 23)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
add_compile_options(-Wall -Wextra -Werror)

# Target board (override with -DPICO_BOARD=... if needed)

set(VALID_PICO_BOARDS pico2 pico2_w)
set(PICO_BOARD_DEFAULT pico2_w)
set(PICO_BOARD ${PICO_BOARD_DEFAULT} CACHE STRING ...)

list(FIND VALID_PICO_BOARDS "${PICO_BOARD}" BOARD_INDEX)
if(BOARD_INDEX EQUAL -1)
  message(FATAL_ERROR
          "Invalid PICO_BOARD: ${PICO_BOARD}. Must be one of: ${VALID_PICO_BOARDS}")
endif()

include(pico_sdk_import.cmake)
project(main C CXX ASM)
pico_sdk_init()

set(MAIN_SRC "main.c")
add_executable(main ${MAIN_SRC} lcd.c led.c)

# Optional metadata (used by tools and diagnostic output)
pico_set_program_name(main "main")
pico_set_program_version(main "0.1")

# Enable USB stdio; disable UART to avoid duplicate output
pico_enable_stdio_uart(main 0)
pico_enable_stdio_usb(main 1)
target_compile_options(main PRIVATE -Wno-unused-parameter)
target_link_libraries(main pico_stdlib hardware_i2c pico_cyw43_arch_none)

target_include_directories(main PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}
)

# Generate .elf, .uf2, .bin outputs
pico_add_extra_outputs(main)
