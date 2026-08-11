#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title(~tag: "Basic_Types_Booleans"){Booleans}

@doc(
  type Boolean
){
  The canonical type for representing @rhombus(#true) or
  @rhombus(#false).
}

@doc(
  coercion (specl val :: boolean) :: Boolean
){
  Coerces @rhombus(val) to its
  @pille_specl_expr(Boolean) representation.
}

@doc(
  unify(Specl(_ :: boolean), Specl(_ :: boolean)): Boolean
){
  Unifies @pille_specl_expr(Specl) types representing
  @pille_specl_annot(boolean)s to
  @pille_specl_expr(Boolean).
}

@doc(
  unify(Specl(_ :: boolean), Boolean): Boolean
){}

@doc(
  method (rhs :: Boolean).$not() :: Boolean

  method (lhs :: Boolean).$and(rhs :: Boolean) :: Boolean

  method (lhs :: Boolean).$or(rhs :: Boolean) :: Boolean

  method (lhs :: Boolean).$xor(rhs :: Boolean) :: Boolean

  method (lhs :: Boolean).$eq(rhs :: Boolean) :: Boolean

  method (lhs :: Boolean).$ne(rhs :: Boolean) :: Boolean
){}

@doc(
  method (test :: Boolean).select(then :: τ, else :: ε) :: α:
    ~where α = unify(τ, ε)
){
  Returns @pille_expr(then :: α) if @rhombus(test) is
  @rhombus(#true), otherwise @pille_expr(else :: α). Since
  this is an ordinary method, there is no short-circuiting;
  the @rhombus(then) and @rhombus(else) expressions are
  always both evaluated (and coerced to @rhombus(α), if
  necessary) before selecting between their results.

  Compared to an equivalent @pille_expr(if)-based
  construction, a call to this method can bias the compiler
  towards a branchless implementation, possibly using
  ``conditional move'' instructions or similar. This is
  never a guarantee; an @pille_expr(if) may result in
  branchless machine code (if the compiler proves that both
  branches are pure and terminating), and a call to this
  method may result in a branch if the compiler decides it
  would be profitable.
}
