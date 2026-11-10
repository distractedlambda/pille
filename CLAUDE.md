# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Pille extends the Rhombus language family with low-level, high-performance programming. Pille code is type-checked and specialized at compile time and then compiled to machine code through LLVM. It is a research prototype, and the Scribble docs under `pille/pille/scribblings/` are incomplete and sometimes out of date. Trust the code over the docs.

Almost everything is written in Rhombus (`.rhm`, mostly `#lang rhombus/static` or `#lang rhombus/static/and_meta`). The few `.rkt` files are either `#lang rhombus/lang_bridge` stubs that make a `.rhm` module usable as a `#lang`, or Racket code that talks to the FFI.

## Setup

Pille often depends on unreleased Racket and Rhombus changes, so use a Racket built from Git or a recent snapshot. In the ccpod container, that means the `/cracket` build described in the container instructions.

The four directories at the top level are Racket packages. Install them together:

```sh
raco pkg install pille-llvm-lib/ pille-lib/ pille-spmd-lib/ pille/
```

LLVM is not bundled. Set `PILLE_LLVM_PREFIX` to the root of an LLVM 23.1 installation that includes the LLVM shared library. `pille-llvm-lib/pille/private/llvm/llvm_c.rkt` refuses to load with any other major version. The official LLVM release builds for Linux leave out the shared library, so they don't work.

## Commands

```sh
raco setup --pkgs pille-llvm-lib pille-lib pille-spmd-lib pille   # compile everything and build the docs
raco test pille/pille/tests                                      # run all tests
raco test pille/pille/tests/range.rhm                            # run one test file
PILLE_UB_POLICY=allow raco test pille/pille/tests/collatz.rhm    # pick the undefined behavior policy
```

`PILLE_UB_POLICY` is `check` (the default), `suppress`, or `allow`. It controls how code generation handles "managed" undefined behavior such as overflow. `check` panics at run time, `suppress` makes the result defined but unspecified, and `allow` leaves it undefined.

## Tests

All tests live in `pille/pille/tests/` and need LLVM, because they JIT-compile Pille code. There are two styles.

- `#lang pille/testsuite` files (`range.rhm`, `assign.rhm`, ...) contain `test:` blocks written in Pille itself, with `assert(...)`. A test can take `~when <specl_expr>` guards, `~expect_panic`, or `~expect_concr_fail`. The module body runs every test once under each UB policy (`check`, `suppress`, `allow`), so a single failure may be reported up to three times. The implementation is in `pille-lib/pille/testsuite.rhm`.
- Plain `#lang rhombus/static` files (`collatz.rhm`, `interop.rhm`, `spmd/*.rhm`) import `pille/hosted` and `ffi`. They define functions with `pille.fun`, call into Pille with `pille(arg :: Type, ...): body`, and compare results using Rhombus `check` forms.

## Architecture

A Pille program goes through these stages, roughly one directory each in `pille-lib/pille/private/`.

1. **Kernel (`kernel/`, `kernel.rhm`).** This is the core `#lang` that `pille` is written in. It defines Pille's own syntax spaces with `space.enforest`. Expressions live in `pille_expr` (`pille/expr`). There are also `specl_expr`, `specl_bind`, `specl_annot`, `labeled_expr`, `local_defn`, `priority`, `unique_member`, and others. Macro expansion in these spaces does not produce Racket code that runs. It produces Rhombus code that, when run at compile time, builds concretized expressions. `kernel/prim/` holds the primitive operations (arithmetic, casts, memory, SIMD, and so on), which kernel-language modules reach through the `prim` namespace. `pille` itself does not export `prim`.
2. **Specialization language ("specl").** `specl_*` forms are a compile-time language for computing with types and other static values. Generic functions, overloads, `type_of`, `specl.match`, and `~when` guards are all evaluated in specl. Types such as `UInt(_)` in parameter annotations are specl patterns.
3. **Concretization (`concretize/`, re-exported by `pille/concretize`).** Concretization turns expressions into typed `Expr` objects (`Expr.Rvalue` and `Expr.Lvalue`). Each one carries its `Type` and closures that lower it to LLVM IR. Overload resolution, implicit arguments, memory layout, and type representation all happen here. Failures raise `Exn.Fail.Concretize`. Results are cached in `concretize/caches.rhm`.
4. **Lowering (`pille/lowering.rhm`).** This module provides the helpers that the lowering closures use. They include the current LLVM builder (a parameter), escapes for block terminators, and value naming.
5. **Runtime (`runtime/`).** `Compiler` turns concretized functions into LLVM modules and object code and can disassemble them using `llvm-objdump` from `PILLE_LLVM_PREFIX`. `JitLinker` links them with ORC for hosted execution. `ub_policy.rhm` reads `PILLE_UB_POLICY`.

The user-facing library is built on top of the kernel. `pille-lib/pille/main.rhm` is `#lang pille/private/kernel` and re-exports the modules in `private/` (`int.rhm`, `float.rhm`, `pointer.rhm`, `range.rhm`, `slice.rhm`, `simd.rhm`, `loop.rhm`, and so on). That's where most language features are defined, so adding a feature usually means writing kernel-level macros and specl code rather than changing the compiler.

Pille code runs in one of two modes. **Hosted execution** (`pille/hosted`) embeds Pille in a Rhombus program and JIT-compiles it with a shared global `JitLinker`. Pille can call back into Rhombus with the `rhombus` form, and `using_hosted_execution` tells code which mode it is in. **Standalone execution** is not documented yet.

The other packages:

- `pille-llvm-lib` contains hand-written Rhombus bindings to the LLVM C API, imported as `pille/llvm`. Raw FFI declarations are in `private/llvm/llvm_c.rkt`, with a Rhombus wrapper class for each LLVM concept next to it. When Pille needs an LLVM function that isn't bound yet, add it here.
- `pille-spmd-lib` implements `#lang pille/spmd` and `pille/spmd/embedded`. They provide `spmd(width):` blocks, `par_for`, and `Varying` values that are lowered to SIMD with masks.
- `pille` holds the tests and the Scribble manual. The docs use a custom set of doc forms in `scribblings/common/pille/`.

## Documentation

Don't edit the documentation. Everything under `pille/pille/scribblings/` and the README must stay entirely human-written. That includes small fixes, such as correcting a typo or updating a signature that your change made stale.

Instead, when your work changes the public API in a way that the docs should reflect, say so when you report back. Name each affected binding and what changed about it, such as an added or removed form, a renamed operator, or a new option. If you can tell which `.scrbl` file covers it, point to that file too. Mention these changes in the commit message as well.

## Conventions

- Files divide top-level sections with `//====...` comment lines.
- Commit subjects are short and imperative. "Repair ..." is used for bug fixes.
