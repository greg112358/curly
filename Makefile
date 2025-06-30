# Makefile for raylib/raygui projects
# Works on macOS, Linux, and Windows (with minor tweaks)

# Project settings
PROJECT_NAME = main
SOURCE_FILES = main.c
COMPILER = gcc

# Platform detection
UNAME_S := $(shell uname -s)

# Common compiler flags
CFLAGS = -std=c99 -Wall -Wextra -O2

# Try to find raylib using pkg-config first, fallback to common paths
ifeq ($(shell pkg-config --exists raylib && echo yes),yes)
    # pkg-config found raylib
    RAYLIB_FLAGS = $(shell pkg-config --libs --cflags raylib)
else
    # Fallback to common installation paths
    ifeq ($(UNAME_S),Darwin)
        # macOS - check common brew locations
        ifneq ($(wildcard /opt/homebrew/include/raylib.h),)
            RAYLIB_INCLUDE = -I/opt/homebrew/include
            RAYLIB_LIB = -L/opt/homebrew/lib
        else ifneq ($(wildcard /usr/local/include/raylib.h),)
            RAYLIB_INCLUDE = -I/usr/local/include
            RAYLIB_LIB = -L/usr/local/lib
        endif
        PLATFORM_LIBS = -framework OpenGL -framework Cocoa -framework IOKit -framework CoreVideo
    else ifeq ($(UNAME_S),Linux)
        # Linux
        RAYLIB_INCLUDE = -I/usr/local/include
        RAYLIB_LIB = -L/usr/local/lib
        PLATFORM_LIBS = -lGL -lm -lpthread -ldl -lrt -lX11
    endif
    
    RAYLIB_FLAGS = $(RAYLIB_INCLUDE) $(RAYLIB_LIB) -lraylib $(PLATFORM_LIBS)
endif

# Build target
$(PROJECT_NAME): $(SOURCE_FILES)
	$(COMPILER) $(CFLAGS) -o $(PROJECT_NAME) $(SOURCE_FILES) $(RAYLIB_FLAGS)

# Clean build files
clean:
	rm -f $(PROJECT_NAME) $(PROJECT_NAME).exe

# Run the program
run: $(PROJECT_NAME)
	./$(PROJECT_NAME)

# Install dependencies (macOS)
install-deps-mac:
	brew install raylib

# Install dependencies (Ubuntu/Debian)
install-deps-linux:
	sudo apt-get update
	sudo apt-get install libraylib-dev

# Show detected configuration
show-config:
	@echo "Platform: $(UNAME_S)"
	@echo "Compiler: $(COMPILER)"
	@echo "Raylib flags: $(RAYLIB_FLAGS)"
	@echo "Source files: $(SOURCE_FILES)"

# Help
help:
	@echo "Available targets:"
	@echo "  make              - Build the project"
	@echo "  make run          - Build and run the project"
	@echo "  make clean        - Clean build files"
	@echo "  make show-config  - Show detected configuration"
	@echo "  make help         - Show this help"

.PHONY: clean run install-deps-mac install-deps-linux show-config help