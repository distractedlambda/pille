#lang pille

module reader ~lang rhombus/reader:
  ~lang "spmd.rhm"

import:
  pille

export:
  all_from(pille)

//==============================================================================
decl.macro 'reexport: $path; ...':
  'import:
     $path open
     ...

   export:
     all_from($path)
     ...'

reexport:
  "private/spmd/control.rhm"
  "private/spmd/mask.rhm"
  "private/spmd/varying.rhm"

//==============================================================================
global_defn.macro 'unsupported: $(op :: Name); ...':
  '«expr.macro '($op)':
      ~all_stx: stx
      syntax_meta.error("construct is unsupported within SPMD code", stx)
    ...»'

export unsupported:
  #'
  break
  continue
  for
