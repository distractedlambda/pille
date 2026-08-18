#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title{Assignment and Mutation}

An @deftech{assignable} expression is one which can be on
the left-hand-side of the @pille_expr(:=) operator or passed
as an @pille_expr(inout) argument; morally, it represents a
way to reach some mutable data.

Assignable expressions can be decomposed into
@deftech{coordinate subexpressions}, a read operation, and a
write operation. Coordinate subexpressions are those whose
evaluation is common between reads and writes, such as
the @rhombus(key, ~var) in
@pille_expr(ptr[#,(@rhombus(key, ~var))]), or the
@rhombus(obj, ~var) in
@pille_expr(#,(@rhombus(obj, ~var)).prop); the read
operation consumes the coordinate values to produce a value
of the expression's type; and the write operation consumes
the coordinate values, along with a value of the
expression's type, and (usually) performs some mutation-like
side-effect. In cases where both the read and write
operation are employed for the same dynamic expression (such
as when used as an @pille_expr(inout) argument), the
coordinate subexpressions are only evaluated once.

Assignability is not a syntactic category; an expression can
only be determined assignable or not as part of
concretization.

@doc(
  expr.macro '$lhs_expr := $rhs_expr'
  operator_order: ~order: assignment
){
  The assignment operator, whose behavior depends on whether
  there is an applicable overload of the
  @pille_expr($assign) method.

  In the absense of an applicable @pille_expr($assign)
  overload, the @rhombus(lhs_expr) must be
  @tech{assignable}; its @tech{coordinate subexpressions}
  are evaluated, followed by evaluating the
  @rhombus(rhs_expr), whose resulting value is then written
  via the write operation of the @rhombus(lhs_expr).

  If there @italic{is} an overload matching the call
  signature @pille_expr(lhs_expr.$assign(rhs_expr)), then
  the behavior of the @pille_expr(:=) operator is the same
  as that call, except that the @rhombus(rhs_expr) cannot be
  passed as @pille_expr(inout), and the result type of the
  @pille_expr(:=) expression is always
  @pille_specl_expr(Void) (regardless of the return type of
  the @pille_expr($assign) overload).
}

@doc(
  unique_member assign
){
  The @pille_expr($assign) method can be overloaded to
  change the behavior of the @pille_expr(:=) operator; see
  that operator's doc entry for more details.
}

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
){
  Like @pille_local_defn(let), but declares @rhombus(id) as
  a @italic{mutable} local variable (that is therefore
  @tech{assignable}).
}
