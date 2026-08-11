#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title(~tag: "Basic_Types_Control_Related_Types"){Control-Related Types}

@doc(
  type Void
){
  The canonical unit type, useful as the type of
  expressions which yield no interesting results.
}

@doc(
  coercion (val :: _) :: Void
){
  Coerces a @rhombus(val) of any type to
  @pille_specl_expr(Void), by simply discarding
  @rhombus(val) and producing @rhombus(#void).
}

@doc(
  unify(Void, _): Void
){
  Unifies @pille_specl_expr(Void) with any other type by
  picking @pille_specl_expr(Void).
}

@doc(
  type Never
){
  The canonical uninhabited type, useful as the type of
  diverging expressions.
}

@doc(
  coercion (absurd :: Never) :: _
){
  Coerces @rhombus(absurd) to any type; this is allowable
  because @rhombus(absurd) cannot actually exist (due to the
  uninhabitability of @pille_specl_expr(Never)), and so this
  coercion is guaranteed to never execute.
}

@doc(
  unify(Never, α): α
){
  Unifies @pille_specl_expr(Never) with any type @rhombus(α)
  by simply picking @rhombus(α).
}
