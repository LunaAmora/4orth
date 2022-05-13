# 4orth 
4orth is a [Porth](https://gitlab.com/tsoding/porth) compiler with [WASM](https://webassembly.org/), [WASI](https://wasi.dev/) and [WASM-4](https://wasm4.org/) targets.

## Quick Start

You can download the latest [release](https://github.com/FrankWPA/4orth/releases) or [bootstrap](https://github.com/FrankWPA/4orth#bootstrapping) it yourself.

### Bootstrapping

Since Porth is self-hosted you need to bootstrap it first. Follow [Porth](https://gitlab.com/tsoding/porth) bootstrapping instructions on how to do that.

Secondly you will need to install:
- [WABT](https://github.com/WebAssembly/wabt)
- [Binaryen](https://github.com/WebAssembly/binaryen) (optional, for optimized .wasm files)

```console
$ ./porth com 4orth.porth
```

Then, you are ready to compile and run your Porth programs using the runtime of your choice:
- [WASM-4](https://wasm4.org/)
- [WASMTIME](https://wasmtime.dev/)
- [WASMER](https://wasmer.io/)
- Or load the `.wasm` file yourself with [Javascript](https://developer.mozilla.org/en-US/docs/WebAssembly/Loading_and_running).

### Compilation

Compilation generates [WAT](https://developer.mozilla.org/en-US/docs/WebAssembly/Understanding_the_text_format) and converts it to a [WebAssembly Binary Format](https://webassembly.github.io/spec/core/binary/index.html) `.wasm` file with [WABT](https://developer.mozilla.org/en-US/docs/WebAssembly/Text_format_to_wasm). So make sure you have it available in your `$PATH`.

```console
$ ./4orth com main.porth
$ w4 run main.wasm
        <or>
$ ./4orth com -wasm main.porth
$ wasmtime main.wasm
```

With Wasm-4, you can use the subcommands `-b` and `-r` to bundle and run after the compilation. (As porth only supports Linux, `-b` creates a Linux executable. For other options, check `w4 bundle --help` or [Wasm-4](https://wasm4.org/docs/guides/distribution) distribution docs)

```console
$ ./4orth com -b -r main.porth
```

Tip: Add `_4ORTH` environment variable to automatically have the std libraries available in 4orth include path.

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
        -wasm            Target WASM instead of Wasm-4 (doesn't support -b or -r)
        -s               Silent mode. Don't print any info about compilation phases
        -o  <file>       File to write the result to 
    png2src <file>       Uses w4 to convert a png file to Porth code and prints it
        -s               Silent mode. Only print the converted code
    help                 Print this help to stdout and exit with 0 code
```

### Status

4orth currently only supports 32 bit integers.

### Changes

4orth implements some temporary features not available in Porth to facilitate Wasm integration:

- Xor Intrinsic
- Hexadecimal numbers (as `0x` format on numbers, and as `\\` plus 2 digits on strings)
- Null terminated string support in const evaluation (evaluates to a pointer to the string)

# Importing and exporting procs
4orth introduces two new keywords allowing Porth to interact with the WASM module system:

- Import
```porth
import proc trace ptr in end
```
This adds the ability to call the Wasm-4 `trace` function via the defined proc contract. Imported procs must have an empty body and no return type. 
(Porth's `print` intrinsic calls this imported proc, you can use either of them to log to the console)

- Export
```porth
export main "start"
export update "update"
```

This exports the desired procs to be called by Wasm-4 or other Wasm runtimes.

# Inline WASM code
4orth allows you to inline WASM code into your program by using the `wasm` keyword. Any string inside the `wasm` block will be inlined in the compiled program.

```porth
wasm 
  "\n;; Inlined global rng seed for the Pseudo random number generator."
  "(global $random-state (mut i32) (i32.const 69420))" 
end
```

# Importing modules (for raw WASM and WASI)

The default module name used by Wasm-4 is `dev`. You can include other modules in your program by using the `import` keyword

```porth
import module "my_module"
```
This line changes the current module context to `my_module`. Every imported proc defined after this line will use this context until a new module is imported.

# Others

All available [functions](https://wasm4.org/docs/reference/functions), constants and the [memory map](https://wasm4.org/docs/reference/memory) from Wasm-4 are in the [wasm4.porth](./std/wasm4.porth) library.

The [wasi.porth](./std/wasi.porth) library contains a minimal WASI setup and a imported proc that prints to stdout.

Huge thanks to [Tsoding](https://github.com/tsoding) for all the educational content and for (being in the process of) creating such a fun language to experiment with.\
And Thanks [Aduros](https://github.com/aduros) for the fantastic fantasy console [Wasm-4](https://wasm4.org/).

The two projects just seemed so compatible to me that I had to try a way to play with both at the same time!
