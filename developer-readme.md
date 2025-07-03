# Complete Raylib/Raygui Setup Guide

This guide will get you set up with raylib and raygui with the portable Makefile on any machine.

## Prerequisites

- Git
- A C compiler (gcc/clang)
- Package manager (brew on macOS, apt on Linux)

## Step 1: Install Raylib

### macOS
```bash
# Install raylib via Homebrew
brew install raylib

# Verify installation
pkg-config --exists raylib && echo "✅ raylib installed" || echo "❌ raylib installation failed"
```

### Ubuntu/Debian Linux
```bash
# Update package list
sudo apt-get update

# Install raylib development package
sudo apt-get install libraylib-dev

# Verify installation
pkg-config --exists raylib && echo "✅ raylib installed" || echo "❌ raylib installation failed"
```

### Other Linux Distributions
```bash
# For Fedora/CentOS/RHEL
sudo dnf install raylib-devel

# For Arch Linux
sudo pacman -S raylib
```

## Step 2: Find Raylib Header Files

Run these commands to locate your raylib installation:

```bash
# Find raylib.h location
find /usr -name "raylib.h" 2>/dev/null
find /opt -name "raylib.h" 2>/dev/null

# Alternative: use pkg-config to show include paths
pkg-config --cflags raylib

# Check common locations
ls -la /opt/homebrew/include/raylib.h    # macOS Homebrew (Apple Silicon)
ls -la /usr/local/include/raylib.h       # macOS Homebrew (Intel) or Linux
ls -la /usr/include/raylib.h             # Linux system install
```

**Expected output locations:**
- macOS (Apple Silicon): `/opt/homebrew/include/raylib.h`
- macOS (Intel): `/usr/local/include/raylib.h`
- Linux: `/usr/include/raylib.h` or `/usr/local/include/raylib.h`

## Step 3: Set Up Raygui

### Clone the raygui repository
```bash
# Clone raygui from GitHub
git clone https://github.com/raysan5/raygui.git
cd raygui
```

### Prepare raygui header
```bash
# Create a C source file from the header (required for compilation)
cp src/raygui.h src/raygui.c
```

### Find the raygui header location
```bash
# You're now in the raygui directory, so:
pwd                    # Shows current directory
ls -la src/raygui.h    # Confirms header exists
```

## Step 4: Set Up Your Project

### Create your project directory
```bash
# Create and navigate to your project
mkdir my-raylib-project
cd my-raylib-project
```

### Copy necessary header files to your project
```bash
# Copy raylib header (adjust path based on Step 2 findings)
# For macOS Apple Silicon:
cp /opt/homebrew/include/raylib.h .

# For macOS Intel:
cp /usr/local/include/raylib.h .

# For Linux:
cp /usr/include/raylib.h .
# OR
cp /usr/local/include/raylib.h .

# Copy raygui header (adjust path to where you cloned raygui)
cp /path/to/raygui/src/raygui.h .

# Example if raygui is in your home directory:
cp ~/raygui/src/raygui.h .
```

### Verify your project structure
```bash
ls -la
# Should show:
# raylib.h
# raygui.h
# (and your main.c file when you create it)
```

## Step 5: Create Your Program

### Create a simple test program
```bash
cat > main.c << 'EOF'
#include "raylib.h"
#define RAYGUI_IMPLEMENTATION
#include "raygui.h"

int main(void)
{
    const int screenWidth = 800;
    const int screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib + raygui example");
    SetTargetFPS(60);

    bool showMessageBox = false;

    while (!WindowShouldClose())
    {
        BeginDrawing();
        ClearBackground(RAYWHITE);
        
        DrawText("Hello raylib + raygui!", 190, 200, 20, LIGHTGRAY);
        
        if (GuiButton((Rectangle){ 320, 250, 120, 30 }, "Click Me!"))
        {
            showMessageBox = true;
        }
        
        if (showMessageBox)
        {
            int result = GuiMessageBox((Rectangle){ 85, 70, 250, 100 },
                "#191#Message Box", "Hello from raygui!", "Nice;Cool");
            
            if (result >= 0) showMessageBox = false;
        }
        
        EndDrawing();
    }

    CloseWindow();
    return 0;
}
EOF
```

### Add the Makefile
Copy the Makefile from the previous artifact into your project directory.

## Step 6: Build and Run

### Test the configuration
```bash
# Check what the Makefile detected
make show-config
```

### Build your program
```bash
make
```

### Run your program
```bash
make run
```

## Troubleshooting

### If raylib is not found:
```bash
# Check if pkg-config can find raylib
pkg-config --modversion raylib

# If not found, manually verify installation
ls -la $(brew --prefix)/include/raylib.h    # macOS
ls -la /usr/include/raylib.h                # Linux
```

### If compilation fails with "raylib.h not found":
```bash
# Make sure you copied the header to your project directory
ls -la raylib.h

# If missing, find and copy it:
find /usr /opt -name "raylib.h" 2>/dev/null
cp [found_path]/raylib.h .
```

### If you get linking errors:
```bash
# Check if raylib library files exist
find /usr /opt -name "libraylib*" 2>/dev/null

# For macOS, check brew installation
brew list raylib
```

### If GuiButton doesn't work:
Make sure you have `#define RAYGUI_IMPLEMENTATION` in your main.c file before including raygui.h.

## For Version Control

### Create a .gitignore file
```bash
cat > .gitignore << 'EOF'
# Compiled binaries
main
*.exe
*.o
*.out

# OS files
.DS_Store
Thumbs.db
EOF
```

### Initialize git repository
```bash
git init
git add main.c Makefile .gitignore
git commit -m "Initial raylib project setup"
```

## Summary

After completing these steps, you should have:
- ✅ Raylib installed system-wide
- ✅ Raygui header available
- ✅ Project with header files copied locally
- ✅ Working Makefile that detects your system
- ✅ A test program that compiles and runs

You can now clone this project to any machine, run the install commands for that platform, and use `make run` to build and execute your raylib programs.

NOTE: LOOK INTO CMAKE FOR THIS PROJECT