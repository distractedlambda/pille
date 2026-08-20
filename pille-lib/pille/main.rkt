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
  "private/float.rhm"
  "private/generic_ops.rhm"
  "private/int.rhm"
  "private/iter.rhm"
  "private/loop.rhm"
  "private/misc.rhm"
  "private/never.rhm"
  "private/panic.rhm"
  "private/pointer.rhm"
  "private/range.rhm"
  "private/simd.rhm"
  "private/specl_ops.rhm"
  "private/specl_type.rhm"
  "private/tuple.rhm"
  "private/type_traits.rhm"
  "private/void.rhm"

export:
  all_from(pille/private/kernel):
    except:
      prim
