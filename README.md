# Morph Pack

**Zig** · **v0.1.0**

_Conway's Game of Life with a glider seed, rendered to the terminal_

---

## Features

- 30x15 toroidal-free grid with standard Game of Life rules
- Seeded with a classic glider pattern
- Configurable number of generations via command line

## Installation

```bash
git clone https://github.com/DevCode01/morph-pack.git
cd morph-pack
```

## Usage

```bash
zig build run -- 10
```

## How it works

Implements Conway's Game of Life on a fixed 30x15 grid seeded with a glider. Each generation counts each cell's 8 neighbors; a live cell survives with 2-3 neighbors, a dead cell becomes alive with exactly 3, every other cell dies or stays dead.

## Options

- `<generations>` - how many generations to simulate and print (default 10)

## Example

```bash
$ zig build run -- 0
Generation 0 (alive: 5)
..............................
..#...........................
...#..........................
.###..........................
..............................
(remaining rows omitted)
```

## Testing

```bash
bash tests/run.sh
```

Includes a functional check against real captured output, plus the build/syntax check.

## License

MIT
