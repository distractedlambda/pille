#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title(~tag: "Basic_Types_Specialization_Values"){Specialization Values}

@doc(
  type Specl(val :: any)
){
  Represents the @tech{specialization value} @rhombus(val),
  but in a runtime context. All @pille_specl_expr(Specl)
  types have erased representations, so their instances
  carry no actual runtime information.
}

@doc(
  expr.macro 'specl($specl_expr)'
){
  Produces a value of type
  @pille_specl_expr(Specl(specl_expr)).
}

@doc(
  method (specl f :: function).$call(specl v, ...)
    :: Specl(f(v, ...))
){
  Allows calling specialization functions (such as those
  defined by @pille_global_defn(specl.fun)) within
  @nontermref(expr)s, provided that all arguments are
  themselves specialization values.
}

@doc(
  method (specl v1).$add(specl v2)
    :: Specl(v1 + v2)

  method (specl v1).$sub(specl v2)
    :: Specl(v1 - v2)

  method (specl v).$neg()
    :: Specl(-v)

  method (specl v1).$mul(specl v2)
    :: Specl(v1 * v2)

  method (specl v1).$div(specl v2)
    :: Specl(v1 / v2)

  method (specl v1).$div_trunc(specl v2)
    :: Specl(v1 div_trunc v2)

  method (specl v1).$div_floor(specl v2)
    :: Specl(v1 div_floor v2)

  method (specl v1).$div_ceil(specl v2)
    :: Specl(v1 div_ceil v2)

  method (specl v1).$div_floor(specl v2)
    :: Specl(v1 div_floor v2)

  method (specl v1).$rem(specl v2)
    :: Specl(v1 % v2)

  method (specl v1).$rem_trunc(specl v2)
    :: Specl(v1 rem_trunc v2)

  method (specl v1).$rem_floor(specl v2)
    :: Specl(v1 rem_floor v2)

  method (specl v1).$rem_ceil(specl v2)
    :: Specl(v1 rem_ceil v2)

  method (specl v).$not()
    :: Specl(¬v)

  method (specl v1).$and(specl v2)
    :: Specl(v1 ∧ v2)

  method (specl v1).$or(specl v2)
    :: Specl(v1 ∨ v2)

  method (specl v1).$xor(specl v2)
    :: Specl(v1 ⊻ v2)

  method (specl v1).$eq(specl v2)
    :: Specl(v1 == v2)

  method (specl v1).$ne(specl v2)
    :: Specl(v1 != v2)

  method (specl v1).$lt(specl v2)
    :: Specl(v1 < v2)

  method (specl v1).$gt(specl v2)
    :: Specl(v1 > v2)

  method (specl v1).$le(specl v2)
    :: Specl(v1 ≤ v2)

  method (specl v1).$ge(specl v2)
    :: Specl(v1 ≥ v2)
){
  Forwards various generic operators to their
  @nontermref(specl_expr) counterparts when operating on
  @pille_specl_expr(Specl) operands.
}
