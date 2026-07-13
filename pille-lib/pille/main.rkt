#lang pille/private/kernel

module reader ~lang rhombus/reader:
  ~lang "main.rhm"

decl.macro 'reexport:
              $path
              ...':
  'import:
     $path open
     ...

   export:
     all_from($path)
     ...'

reexport:
  "private/boolean.rhm"
  "private/cond.rhm"
  "private/const_ops.rhm"
  "private/const_type.rhm"
  "private/generic_ops.rhm"
  "private/int.rhm"
  "private/loop.rhm"
  "private/never.rhm"
  "private/panic.rhm"
  "private/pointer.rhm"
  "private/range.rhm"
  "private/simd.rhm"
  "private/tuple.rhm"
  "private/type_traits.rhm"
  "private/void.rhm"

export:
  all_from(pille/private/kernel):
    except:
      prim
