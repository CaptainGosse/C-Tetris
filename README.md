# Terminal Tetris
A minimalist Tetris clone written in pure C that runs entirely inside your terminal. No graphics libraries. No dependencies. Just your compiler and a shell.                             


---

## Preview

```
..........
..........
..........
....##....
.....#....
.....#....
..........
..........
..........
..........
..........
##........
##........
.####.....
#####.....
#####.....
#####.....
######....
#######...
#######...
015
```

---

## Features

- Classic Tetris gameplay
- Lightweight binary (~14–16 KB)
- Bitwise grid storage
- Zero external dependencies
- Works in any Unix-like terminal

---

## Requirements

- Linux, macOS, or any Unix-like system  
- GCC or Clang

---

## Build and Run

### Standard Build (~16 KB)

```bash
git clone https://github.com/yourusername/terminal-tetris.git
cd terminal-tetris
gcc main.c -o tetris
./tetris
```

### Optimized Build (~14 KB)

```bash
gcc -Os -s -ffunction-sections -fdata-sections -Wl,--gc-sections \
    -fno-unwind-tables -fno-asynchronous-unwind-tables \
    -fno-stack-protector -fomit-frame-pointer -flto \
    -Wl,--strip-all -Wl,--build-id=none \
    main.c -o tetris
```

---

## Controls

```
a        move left
d        move right
w        rotate
Ctrl+C   quit
```

- Pieces fall automatically.  
- Complete full lines to score points.  
- Game ends when blocks reach the top.

---

## How It Works

Each row of the board is stored as a single **16-bit integer**.

Each bit represents one cell:

```
0 = empty
1 = block
```

### Example

Visual row:

```
....###...
```

Stored in memory as:

```
0000000000111000
```

---

## Binary Size

```
Standard build   ~16 KB
Optimized build  ~14 KB
```

---

## License

MIT
