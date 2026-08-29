#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title{Initializer Expressions}

@doc(
  non_target: expr.macro '. $member_name'
  non_target: expr.macro '. $member_name($expr, ...)'
  non_target: expr.macro '. ($expr, ...)'
  non_target: expr.macro '. {$expr, ...}'
  non_target: expr.macro '.$ $unique_member_id'
  non_target: expr.macro '.$ $unique_member_id($expr, ...)'
  operator_order: ~order: member_access
){
  The various forms of initializer expressions; the
  construction @pille_expr(.(expr, ...)) is equivalent to
  @pille_expr(.$call(expr, ...)), while
  @pille_expr(.{expr, ...}) is equivalent to
  @pille_expr(.$new(expr, ...)).
}

@doc(
  specl_expr.macro '«InitExpr'$sig'»'
  expr.macro '«InitExpr'$sig'»'
  specl_bind.macro '«InitExpr'$sig_bind'»'

  grammar sig
  | $dot_member_name
  | $dot_member_name($specl_expr, ...)
  | #,(pille_expr(.))($specl_expr, ...)
  | #,(pille_expr(.)){$specl_expr, ...}

  grammar sig_bind
  | #,(pille_specl_bind(_))
  | $dot_member_name
  | $dot_member_name($specl_bind, ...)
  | #,(pille_expr(.))($specl_bind, ...)
  | #,(pille_expr(.)){$specl_bind, ...}
){
  Forms for expressing and binding the types of initializer
  expressions.

  The binding construction @pille_specl_bind(InitExpr'_') is
  handled specially: it matches any initializer expression
  type, regardless of the member name or argument types
  used.
}

@doc(
  coercion (init :: InitExpr'_') :: δ
){
  Completes the initializer expression @rhombus(init) by
  invoking the corresponding method or property accessor on
  @rhombus(δ). If the result of the method call or property
  access does not have type @rhombus(δ), it is
  @coercion_tech{coerced} to @rhombus(δ).
}
