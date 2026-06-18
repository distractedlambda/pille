#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title(~tag: "Const_Escaping_to_Rhombus"){Escaping to Rhombus}

@doc(
  const_annot.macro '#%rhombus ($rhombus_annot)'
){}

@doc(
  const_expr.macro '#%rhombus $maybe_cross_args ($rhombus_expr)'

  const_expr.macro '#%rhombus $maybe_cross_args:
                      $rhombus_body
                      ...'

  grammar maybe_cross_args
  | ($cross_arg, ...)
  | ε

  grammar cross_arg
  | $rhombus_bind #,(rhm_expr(=)) $const_expr
  | $rhombus_bind: $const_expr
  | $id
){}
