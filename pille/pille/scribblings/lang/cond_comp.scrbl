#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title{Conditional Compilation}

@doc(
  expr.macro 'const.match $const_expr
              | $const_bind:
                  $body
                  ...
              | ...'
){}

@doc(
  const_expr.macro 'const.assert($const_expr)'
  expr.macro 'const.assert($const_expr)'
){}
