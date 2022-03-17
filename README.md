# 4rth is a Porth to Wasm compiler with Wasm-4 bindings
## Quick Start

### Bootstrapping

Since Porth is self-hosted you need to bootstrap it first. Follow [Porth](https://gitlab.com/tsoding/porth) bootstrapping instrunctions on how to do that.

Secondly you will need to install:
- [WASM-4](https://wasm4.org/)
- [WABT](https://github.com/WebAssembly/wabt)
- [Binaryen](https://github.com/WebAssembly/binaryen) (optional, for optimized .wasm files)

```console
$ ./porth com 4orth.porth
```

### Compilation

Compilation generates WebAssembly code and compiles it with [WABT](https://github.com/WebAssembly/wabt). So make sure you have it available in your `$PATH`.

```console
$ ./4orth com game.porth
...
... compilation logs ...
...
$ ./w4 run game.wasm
        <or>
$ ./w4 bundle --linux game game.wasm
$ ./game
```

Or you can use the subcommands -b and -r to bundle and run after the compilation. Use 4orth help to view all subcommands. (As porth only supports Linux, the -b (bundle) flag creates an Linux executable. For other options, check `w4 bundle --help`)

```console
$ ./4orth com -b -r game.porth
```

### Status

4rth is not feature complete with the curent open version of Porth and Wasm-4 yet. The curent set of features not supported consists of:

- Int64
- OP_IFSTAR
- OP_BIND_LET
- OP_BIND_PEEK
- OP_PUSH_BIND
- OP_UNBIND
- OP_PUSH_ADDR
- OP_CALL_LIKE

- Floats

### Changes

4rth implement some features not available in Porth to facilitate Wasm and Wasm-4 integration:

- Hexadecimal numbers
- Xor Intrinsic
- Baked in randon number generator (will be removed once there is float and int64 support)
Gets an int from the stack and generates a number bettwen 0 and that number, returning the result:
```porth
20 rnd 
```
- Import proc
```porth
import proc trace ptr in drop end
```
This adds the ability to call wasm-4 functions via the defined proc contract. Anything in the body of the proc will be ignored.

All available functions, memory positions and constants from Wasm-4 are in the [wasm4.porth](./wasm4.porth) library.