# Pille: Extensible Low-Level Programming
Pille is a project that seeks to extend the [Rhombus][1] language family with first-class support for low-level and high-performance programming, leveraging a systems-programming discipline and an [LLVM][2]-powered backend to generate competitive machine code.

## Status
Pille is a work-in-progress research prototype, with documentation that is very incomplete and sometimes outdated. Nonetheless, it is already a sizeable (by some definition) example of using Rhombus to build a new language.

In the future, we hope to provide a stable(ish) API surface along with some all-important "getting started" documentation.

## Installation
1. Install the Racket packages in this repository (they are not yet on the package index):
   ```sh
   raco pkg install pille-llvm-lib/ pille-lib/ pille-spmd-lib/ pille/
   ```
2. Set the `PILLE_LLVM_PREFIX` environment variable to the root of an LLVM 23.1 installation:
   - LLVM is _not_ currently provided by any of Pille's Racket packages.
   - On macOS with Homebrew, `brew install llvm@23`, then set `PILLE_LLVM_PREFIX=$(brew --prefix llvm@23)`.
   - On Linux, the official LLVM builds will not work (because they do not include the LLVM shared library). If your package manager does not supply a compatible version, you may need to build LLVM from source.

### Platform Support
Most development and testing of Pille occurs on aarch64 macOS and x86_64 Linux systems; your mileage may vary on other host platforms.

## Repository Structure
The code is organized into subdirectories that are each Racket packages:

- `pille`: Umbrella package with tests and Scribble documentation.

- `pille-lib`: The actual implementation of Pille.

- `pille-spmd-lib`: The (WIP) implementation of `#lang pille/spmd`.

- `pille-llvm-lib`: Bespoke Rhombus bindings to the LLVM C API, used by `pille-lib`.

[1]: https://rhombus-lang.org
[2]: https://llvm.org
