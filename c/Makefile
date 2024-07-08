# Project Name
NAME := memleak

# Compiler and flags
CC := clang
CFLAGS := -Wall -Wextra -Werror
RELEASEFLAGS := -O3 -march=native
DEBUGFLAGS := -g -O0
DEPFLAGS := -MMD -MP

# Directories
SRC_DIRS := $(shell find . -type d -name 'src*')
BUILD_DIR ?= ./build
BIN_DIR := $(BUILD_DIR)/bin

# Source, Object, and Dependency Files
SRCS := $(foreach sdir,$(SRC_DIRS),$(wildcard $(sdir)/*.c))
OBJS := $(SRCS:%.c=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

# Commands
RM := rm -f
RM_RF := rm -rf
MKDIR_P := mkdir -p

# Silence and parallel execution
MAKEFLAGS += --no-print-directory -j8

# Default target
all: CFLAGS += $(RELEASEFLAGS)
all: $(BIN_DIR)/$(NAME)

# Link the binary
$(BIN_DIR)/$(NAME): $(OBJS)
	@$(MKDIR_P) $(BIN_DIR)
	$(CC) $(OBJS) -o $@

# Compile the object files
$(BUILD_DIR)/%.o: %.c
	@$(MKDIR_P) $(@D)
	$(CC) $(CFLAGS) $(DEPFLAGS) -c $< -o $@

# Include dependency files
-include $(DEPS)

# Debug build
debug: CFLAGS := $(filter-out $(RELEASEFLAGS), $(CFLAGS)) $(DEBUGFLAGS)
debug: clean $(BIN_DIR)/$(NAME)
	@gdb $(BIN_DIR)/$(NAME)

# Clean object files
clean:
	$(RM) $(OBJS)
	$(RM) $(DEPS)

# Delete the build directory
fclean: clean
	$(RM_RF) $(BUILD_DIR)

# Rebuild everything
re: fclean all

# Run the binary
run: all
	@$(BIN_DIR)/$(NAME)


# Declare phony targets
.PHONY: all clean fclean re debug run
