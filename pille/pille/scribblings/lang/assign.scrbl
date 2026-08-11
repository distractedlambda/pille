#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title{Assignment and Mutation}

@doc(
  unique_member assign
  expr.macro '$lhs_expr := $rhs_expr'
  operator_order: ~order: assignment
){}

@doc(
  expr.macro 'inout'
){
  Specially recognized in argument specifications, but
  otherwise an error.
}

@doc(
  local_defn.macro 'var $id $maybe_type #,(pille_expr(=)) $expr'

  local_defn.macro 'var $id $maybe_type:
                      $body'

  grammar maybe_type
  | #,(pille_expr(::)) $specl_expr
  | ε
){}
