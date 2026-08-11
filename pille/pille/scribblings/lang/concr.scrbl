#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title{Metaprogramming with Concretization}

@doc(
  expr.macro 'specl.match $specl_expr
              | $specl_bind:
                  $body
              | ...'
){}

@doc(
  specl.fun specl.error(message :: string)
){
  Triggers an immediate (and unrecoverable) concretization
  error with the given @rhombus(message).
}

@doc(
  specl_expr.macro 'specl.assert($specl_expr)'
  expr.macro 'specl.assert($specl_expr)'
){
  Triggers an immediate (and unrecoverable) concretization
  error if @rhombus(specl_expr) evaluates to
  @rhombus(#false).
}

@doc(
  specl_expr.macro 'type_of($expr)'
  expr.macro 'type_of($expr)'
){
  Concretizes @rhombus(expr) to give its type, but without
  including it in the compiled program.
}

@doc(
  expr.macro 'faux($specl_expr)'
){
  Concretizes as having the type resulting from the
  evaluation of @rhombus(specl_expr), but triggers an error
  if it is ever fully compiled.

  The @pille_expr(faux) form is often most useful in
  combination with @pille_specl_expr(type_of), where it can
  safely ``simulate'' a value of any type.
}
