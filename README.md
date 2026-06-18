# Pille: Extensible Low-Level Programming
Pille is a project that seeks to extend the [Rhombus][1] language family with first-class support for low-level and high-performance programming, leveraging a systems-programming discipline and an [LLVM][2]-powered backend to generate competitive machine code.

## Status
Pille is a work-in-progress research prototype, with documentation that is very incomplete and sometimes outdated. Nonetheless, it is already a sizeable (by some definition) example of using Rhombus to build a new language.

In the future, we hope to provide a stable(ish) API surface along with some all-important "getting started" documentation.

## Repository Structure
The code is organized into subdirectories that are each Racket packages:

- `pille`: Umbrella package with tests and Scribble documentation.

- `pille-lib`: The actual implementation of Pille.

- `pille-llvm-lib`: Bespoke Rhombus bindings to the LLVM C API, used by `pille-lib`.

None of these packages are currently on the Racket package index.

[1]: https://rhombus-lang.org
[2]: https://llvm.org
