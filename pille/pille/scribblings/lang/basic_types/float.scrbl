#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title(~tag: "Basic_Types_Floating_Point_Numbers"){Floating-Point Numbers}

@doc(
  type Float
){
  An IEEE 754 single-precision (``binary32'') floating-point
  number.
}

@doc(
  type Double
){
  An IEEE 754 double-precision (``binary64'') floating-point
  number.
}

@doc(
  specl_bind.macro 'FloatingPoint'
){
  Matches both @pille_specl_bind(Float) and
  @pille_specl_bind(Double).
}

@doc(
  specl_annot.macro 'Float.constant'

  coercion (specl src :: Float.constant) :: Float

  unify(Specl(_ :: Float.constant), Float): Float
){
  A @pille_specl_annot(Float.constant) is a
  @pille_specl_annot(real) that is either
  @pille_specl_annot(inexact), or both
  @pille_specl_annot(exact) and exactly representable as
  some @pille_specl_expr(Float) value.
}

@doc(
  specl_annot.macro 'Double.constant'

  coercion (specl src :: Double.constant) :: Double

  unify(Specl(_ :: Double.constant), Double): Double
){
  A @pille_specl_annot(Double.constant) is a
  @pille_specl_annot(real) that is either
  @pille_specl_annot(inexact), or both
  @pille_specl_annot(exact) and exactly representable as
  some @pille_specl_expr(Double) value.
}

@doc(
  coercion (src :: UInt(w)) :: Float:
    ~when w ≤ 24

  coercion (src :: Int(w)) :: Float:
    ~when w ≤ 24

  unify(UInt(w), Float):
    ~when w ≤ 24
    Float

  unify(Int(w), Float):
    ~when w ≤ 24
    Float
){
  Integers represented with @rhombus(24) bits or less can
  coerce to @pille_specl_expr(Float), since such a
  conversion is always exact.
}

@doc(
  coercion (src :: UInt(w)) :: Double:
    ~when w ≤ 53

  coercion (src :: Int(w)) :: Double:
    ~when w ≤ 53

  unify(UInt(w), Double):
    ~when w ≤ 53
    Double

  unify(Int(w), Double):
    ~when w ≤ 53
    Double
){
  Integers represented with @rhombus(53) bits or less can
  coerce to @pille_specl_expr(Double), since such a
  conversion is always exact.
}

@doc(
  coercion (src :: Float) :: Double

  unify(Float, Double): Double
){
  @pille_specl_expr(Float) values can coerce to
  @pille_specl_expr(Double).
}

@doc(
  method (rhs :: FloatingPoint as α).$neg() :: α
  method (lhs :: FloatingPoint as α).$add(rhs :: α) :: α
  method (lhs :: FloatingPoint as α).$sub(rhs :: α) :: α
  method (lhs :: FloatingPoint as α).$mul(rhs :: α) :: α
  method (lhs :: FloatingPoint as α).$div(rhs :: α) :: α
  method (lhs :: FloatingPoint as α).$rem_trunc(rhs :: α) :: α
){
  Method that implement basic math operators for
  @pille_specl_bind(FloatingPoint) values. These never cause
  undefined behavior.
}

@doc(
  method (lhs :: FloatingPoint as α).$eq(rhs :: α) :: Boolean
  method (lhs :: FloatingPoint as α).$ne(rhs :: α) :: Boolean
  method (lhs :: FloatingPoint as α).$lt(rhs :: α) :: Boolean
  method (lhs :: FloatingPoint as α).$le(rhs :: α) :: Boolean
  method (lhs :: FloatingPoint as α).$gt(rhs :: α) :: Boolean
  method (lhs :: FloatingPoint as α).$ge(rhs :: α) :: Boolean
){
  Methods that implement the comparison operators for
  @pille_specl_bind(FloatingPoint) values. These return
  @rhombus(#false) when either @rhombus(lhs) or
  @rhombus(rhs) is a @rhombus(#nan) value. They never cause
  undefined behavior.
}
