#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title{Conditional Compilation}

@doc(
  expr.macro 'specl.match $specl_expr
              | $specl_bind:
                  $body
                  ...
              | ...'
){}

@doc(
  specl_expr.macro 'specl.assert($specl_expr)'
  expr.macro 'specl.assert($specl_expr)'
){}
