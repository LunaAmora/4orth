# 4orth 
4orth is a [Porth](https://gitlab.com/tsoding/porth) compiler with a [WASM-4](https://wasm4.org/) target.

## Quick Start

You can download the latest [release](https://github.com/FrankWPA/4orth/releases) or [bootstrap](https://github.com/FrankWPA/4orth#bootstrapping) it yourself.

### Bootstrapping

Since Porth is self-hosted you need to bootstrap it first. Follow [Porth](https://gitlab.com/tsoding/porth) bootstrapping instructions on how to do that.

Secondly you will need to install:
- [WASM-4](https://wasm4.org/)
- [WABT](https://github.com/WebAssembly/wabt)
- [Binaryen](https://github.com/WebAssembly/binaryen) (optional, for optimized .wasm files)

```console
$ ./porth com 4orth.porth
```

### Compilation

Compilation generates [WAT](https://developer.mozilla.org/en-US/docs/WebAssembly/Understanding_the_text_format) and converts it to a [WebAssembly Binary Format](https://webassembly.github.io/spec/core/binary/index.html) .wasm file with [WABT](https://developer.mozilla.org/en-US/docs/WebAssembly/Text_format_to_wasm). So make sure you have it available in your `$PATH`.

```console
$ ./4orth com game.porth
...
... compilation logs ...
...
$ w4 run game.wasm
        <or>
$ w4 bundle --linux game game.wasm
$ ./game
```

Or you can use the subcommands `-b` and `-r` to bundle and run after the compilation. (As porth only supports Linux, `-b` creates a Linux executable. For other options, check `w4 bundle --help` or [Wasm-4](https://wasm4.org/docs/guides/distribution) distribution docs)

```console
$ ./4orth com -b -r game.porth
```

Obs: Add `_4ORTH` (and `PORTH`, if bootstrapping) enviroment variable to automatically have the std libraries available in 4orth include path.

### Running options and subcommands

```console
$ ./4orth [OPTIONS] <SUBCOMMAND>

OPTIONS:
    -unsafe              Disable type checking.
    -I <path>            Add <path> to the include paths list.
SUBCOMMANDS:
    com [OPTIONS] <file> Compile the program
        -r               Run the program after successful compilation
        -b               Bundles the program to a linux executable. (If with -r, executes the bundle)
        -opt             Optimize the program with wasm-opt
        -wat             Transforms the stripped program back from the final `.wasm` to `.wat`
        -wasm            Target WASM instead of Wasm4 (doesn't support -b or -r)
        -wasi            Target WASI instead of Wasm4 (doesn't support -b or -r)
        -s               Silent mode. Don't print any info about compilation phases
        -o  <file>       File to write the result to 
    png2src <file>       Uses w4 to convert a png file to Porth code and prints it
        -s               Silent mode. Only print the converted code
    help                 Print this help to stdout and exit with 0 code
```

### Status

4orth is not feature complete with the current open version of Porth. The current set of features not supported consists of:

- Int64 (all numbers are treated as unsigned int 32, if an overflow occurs on const evaluation, the .wat file will contain an error)
- Negative numbers

### Changes

4orth implements some temporary features not available in Porth to facilitate Wasm-4 integration:

- Xor Intrinsic
- Hexadecimal numbers (as `0x` format on numbers, and as `\\` plus 2 digits on strings)
- Null terminated string support in const evaluation (evaluates to a pointer to the string)

- Baked in pseudo random number generator (will be removed once there is int64 support).
```porth
proc rnd-coord -- int int in 20 rnd 20 rnd end
```
This proc for example returns two ints between 0 and 20.

- Imports
```porth
import proc trace ptr in end
```
This adds the ability to call the wasm-4 `trace` function via the defined proc contract. Imported procs must have an empty body and no return type. 
(Porth's `print` intrinsic calls this imported proc, you can use either of them to log to the console)

- Exports
```porth
export main "start"
export update "update"
```

This exports the necessary procs that Wasm4 needs to call when the complied wasm file is executed.

# Others

All available [functions](https://wasm4.org/docs/reference/functions), constants and the [memory map](https://wasm4.org/docs/reference/memory) from Wasm-4 are in the [wasm4.porth](./wasm4.porth) library.

Huge thanks to [Tsoding](https://github.com/tsoding) for all the educational content and for (being in the process of) creating such a fun language to experiment with.\
And Thanks [Aduros](https://github.com/aduros) for the fantastic fantasy console [Wasm4](https://wasm4.org/).

The two projects just seemed so compatible to me that I had to try a way to play with both at the same time!
