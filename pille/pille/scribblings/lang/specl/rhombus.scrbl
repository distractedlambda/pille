#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title(~tag: "Specl_Escaping_to_Rhombus"){Escaping to Rhombus}

@doc(
  specl_annot.macro '#%rhombus ($rhombus_annot)'
){}

@doc(
  specl_expr.macro '#%rhombus $maybe_cross_args ($rhombus_expr)'

  specl_expr.macro '#%rhombus $maybe_cross_args:
                      $rhombus_body
                      ...'

  grammar maybe_cross_args
  | ($cross_arg, ...)
  | ε

  grammar cross_arg
  | $rhombus_bind #,(rhm_expr(=)) $specl_expr
  | $rhombus_bind: $specl_expr
  | $id
){}
