#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title(~tag: "Basic_Types_Integers"){Integers}

@doc(
  type Int(width :: pos_int)
){
  A signed two's-complement binary integer, represented
  using @rhombus(width) bits.
}

@doc(
  type NativeInt
){
  An alias for the @pille_specl_expr(Int) type with the same
  number of bits as a pointer.
}

@doc(
  type UInt(width :: pos_int)
){
  An unsigned binary integer, represented using
  @rhombus(width) bits.
}

@doc(
  type NativeUInt
){
  An alias for the @pille_specl_expr(UInt) type with the
  same number of bits as a pointer.
}

@doc(
  specl_bind.macro 'BinaryInteger'
){
  Matches all @pille_specl_expr(Int) and
  @pille_specl_expr(UInt) types.
}

@doc(
  specl_bind.macro 'Bitwise'
){
  Matches all @pille_specl_bind(BinaryInteger) and
  @pille_specl_bind(Boolean) types.
}

@doc(
  specl_bind.macro 'Integral'
){
  Matches all @pille_specl_expr(Int),
  @pille_specl_expr(UInt), and
  @pille_specl_bind(Specl(_ :: int)) types.
}

@doc(
  specl.property (Int(w)).min_value:
    -(2**(w - 1))

  specl.property (Int(w)).max_value:
    2**(w - 1) - 1

  specl.property (UInt(w)).min_value:
    0

  specl.property (UInt(w)).max_value:
    2**w - 1
){}

@doc(
  coercion (int :: Int(src_width)) :: Int(dst_width):
    ~when dst_width > src_width
){
  Coerces @rhombus(int) to any @pille_specl_expr(Int) type
  of greater width, by sign-extension.
}

@doc(
  unify(Int(m), Int(n)): Int(max(m, n))
){
  Unifies two @pille_specl_expr(Int) types by picking the
  one of greater width.
}

@doc(
  coercion (specl val :: int) :: Int(dst_width):
    ~when dst_width > val.bit_length
){
  Coerces @rhombus(val) to any
  @pille_specl_expr(Int) type which can represent it.
}

@doc(
  unify(Specl(v :: int), Int(w)):
    Int(max(v.bit_length + 1, w))
){}

@doc(
  coercion (uint :: UInt(src_width)) :: UInt(dst_width):
    ~when dst_width > src_width
){
  Coerces @rhombus(uint) to any @pille_specl_expr(UInt) type
  of greater width, by zero-extension.
}

@doc(
  unify(UInt(m), UInt(n)): UInt(max(m, n))
){
  Unifies two @pille_specl_expr(UInt) types by picking the
  one of greater width.
}

@doc(
  coercion (specl val :: nat) :: UInt(dst_width):
    ~when dst_width ≥ val.bit_length
){
  Coerces @rhombus(val) to any
  @pille_specl_expr(UInt) type which can represent it.
}

@doc(
  unify(Specl(v :: nat), UInt(w)):
    UInt(max(v.bit_length, w))
){}

@doc(
  coercion (uint :: UInt(src_width)) :: Int(dst_width):
    ~when dst_width > src_width
){
  Coerces @rhombus(uint) to any @pille_specl_expr(Int) type
  of greater width, by zero-extension.
}

@doc(
  unify(UInt(m), Int(n)): Int(max(m + 1, n))
){
  Unifies an @pille_specl_expr(Int) type with a
  @pille_specl_expr(UInt) type by picking the narrowest
  @pille_specl_expr(Int) type that can represent any value
  of either.
}

@doc(
  unify(Specl(v1 :: int), Specl(v2 :: int)):
    ~when v1 < 0 || v2 < 0
    Int(max(v1.bit_length, v2.bit_length) + 1)
){
  Unifies two @pille_specl_expr(Specl) types representing
  @pille_specl_annot(int)s (that are not both also
  @pille_specl_annot(nat)s) to the narrowest
  @pille_specl_expr(Int) type which can represent both.
}

@doc(
  unify(Specl(v1 :: nat), Specl(v2 :: nat)):
    UInt(max(v1, v2).bit_length)
){
  Unifies two @pille_specl_expr(Specl) types representing
  @pille_specl_annot(nat)s to the narrowest
  @pille_specl_expr(UInt) type which can represent both.
}

@doc(
  method (lhs :: BinaryInteger as α).$add(rhs :: α) :: α
  method (lhs :: BinaryInteger as α).$sub(rhs :: α) :: α
  method (lhs :: BinaryInteger as α).$mul(rhs :: α) :: α
  method (rhs :: Int(_) as α).$neg() :: α
){
  Overloads the @pille_expr(+), @pille_expr(-), and
  @pille_expr(*) operators for
  @pille_specl_bind(BinaryInteger)s. Overflow/underflow
  arising from any of these operations is @tech{managed
  undefined behavior}.
}

@doc(
  method (lhs :: BinaryInteger as α).$add_wrap(rhs :: α) :: α
  method (lhs :: BinaryInteger as α).$sub_wrap(rhs :: α) :: α
  method (lhs :: BinaryInteger as α).$mul_wrap(rhs :: α) :: α
  method (rhs :: BinaryInteger as α).$neg_wrap() :: α
){
  Overloads the @pille_expr(+%), @pille_expr(-%), and
  @pille_expr(*%) operators for
  @pille_specl_bind(BinaryInteger)s. Overflow/underflow is
  guaranteed to be wrapping.
}

@doc(
  method (lhs :: BinaryInteger as α).$add_unchecked(rhs :: α) :: α
  method (lhs :: BinaryInteger as α).$sub_unchecked(rhs :: α) :: α
  method (lhs :: BinaryInteger as α).$mul_unchecked(rhs :: α) :: α
  method (rhs :: Int(_) as α).$neg_unchecked() :: α
){
  Overloads the @pille_expr(+!), @pille_expr(-!), and
  @pille_expr(*!) operators for
  @pille_specl_bind(BinaryInteger)s. Overflow/underflow is
  always undefined behavior.
}

@doc(
  method (lhs :: Int(_) as α).$div_trunc(rhs :: α) :: α
  method (lhs :: Int(_) as α).$rem_trunc(rhs :: α) :: α
){
  Overloads the @pille_expr(/←) and @pille_expr(%←)
  operators for @pille_specl_expr(Int)s. It is
  @tech{managed undefined behavior} for the @rhombus(rhs) to
  be @rhombus(0), or for the @rhombus(rhs) to be
  @rhombus(-1) at the same time that the @rhombus(lhs) is
  @pille_expr(α.min_value).
}

@doc(
  method (lhs :: Int(_) as α).$div_trunc_unchecked(rhs :: α) :: α
  method (lhs :: Int(_) as α).$rem_trunc_unchecked(rhs :: α) :: α
){
  Overloads the @pille_expr(/←!) and @pille_expr(%←!)
  operators for @pille_specl_expr(Int)s. It is always
  undefined behavior for the @rhombus(rhs) to be
  @rhombus(0), or for the @rhombus(rhs) to be @rhombus(-1)
  at the same time that the @rhombus(lhs) is
  @pille_expr(α.min_value).
}

@doc(
  method (lhs :: UInt(_) as α).$div(rhs :: α) :: α
  method (lhs :: UInt(_) as α).$div_trunc(rhs :: α) :: α
  method (lhs :: UInt(_) as α).$div_floor(rhs :: α) :: α
){
  Overloads the @pille_expr(/), @pille_expr(/←), and
  @pille_expr(/↓) operators for @pille_specl_expr(UInt)s,
  with identical behavior. It is @tech{managed undefined
  behavior} for the @rhombus(rhs) to be @rhombus(0).
}

@doc(
  method (lhs :: UInt(_) as α).$div_unchecked(rhs :: α) :: α
  method (lhs :: UInt(_) as α).$div_trunc_unchecked(rhs :: α) :: α
  method (lhs :: UInt(_) as α).$div_floor_unchecked(rhs :: α) :: α
){
  Overloads the @pille_expr(/!), @pille_expr(/←!), and
  @pille_expr(/↓!) operators for @pille_specl_expr(UInt)s,
  with identical behavior. It is always undefined behavior
  for the @rhombus(rhs) to be @rhombus(0).
}

@doc(
  method (lhs :: UInt(_) as α).$rem(rhs :: α) :: α
  method (lhs :: UInt(_) as α).$rem_trunc(rhs :: α) :: α
  method (lhs :: UInt(_) as α).$rem_floor(rhs :: α) :: α
){
  Overloads the @pille_expr(%), @pille_expr(%←), and
  @pille_expr(%↓) operators for @pille_specl_expr(UInt)s,
  with identical behavior. It is @tech{managed undefined
  behavior} for the @rhombus(rhs) to be @rhombus(0).
}

@doc(
  method (lhs :: UInt(_) as α).$rem_unchecked(rhs :: α) :: α
  method (lhs :: UInt(_) as α).$rem_trunc_unchecked(rhs :: α) :: α
  method (lhs :: UInt(_) as α).$rem_floor_unchecked(rhs :: α) :: α
){
  Overloads the @pille_expr(%!), @pille_expr(%←!), and
  @pille_expr(%↓!) operators for @pille_specl_expr(UInt)s,
  with identical behavior. It is always undefined behavior
  for the @rhombus(rhs) to be @rhombus(0).
}

@doc(
  method (rhs :: BinaryInteger as α).$not() :: α
  method (lhs :: BinaryInteger as α).$and(rhs :: α) :: α
  method (lhs :: BinaryInteger as α).$or(rhs :: α) :: α
  method (lhs :: BinaryInteger as α).$xor(rhs :: α) :: α
){
  Overloads the @pille_expr(¬), @pille_expr(∧),
  @pille_expr(∨), and @pille_expr(⊻) operators for
  @pille_specl_bind(BinaryInteger)s. These never have
  undefined behavior.
}

@doc(
  method (lhs :: BinaryInteger as α).$shl(rhs :: Integral) :: α
  method (lhs :: BinaryInteger as α).$shr(rhs :: Integral) :: α
){
  Overloads the @pille_expr(<<) and @pille_expr(>>)
  operators for @pille_specl_bind(BinaryInteger)s. The
  @rhombus(rhs) can have any @pille_specl_bind(Integral)
  type, but its value must be between @rhombus(0)
  (inclusive) and the bit-width of @rhombus(α) (exclusive),
  else the operation has @tech{managed undefined behavior}.
}

@doc(
  method (lhs :: BinaryInteger as α).$shl_wrap(rhs :: BinaryInteger) :: α
  method (lhs :: BinaryInteger as α).$shr_wrap(rhs :: BinaryInteger) :: α
){
  Overloads the @pille_expr(<<%) and @pille_expr(>>%)
  operators for @pille_specl_bind(BinaryInteger)s, with
  guaranteed wrapping behavior.
}

@doc(
  method (lhs :: BinaryInteger as α).$shl_unchecked(rhs :: BinaryInteger) :: α
  method (lhs :: BinaryInteger as α).$shr_unchecked(rhs :: BinaryInteger) :: α
){
  Overloads the @pille_expr(<<!) and @pille_expr(>>!)
  operators for @pille_specl_bind(BinaryInteger)s, with
  guaranteed wrapping behavior.
}

@doc(
  method (lhs :: BinaryInteger as α).$eq(rhs :: α) :: Boolean
  method (lhs :: BinaryInteger as α).$ne(rhs :: α) :: Boolean
  method (lhs :: BinaryInteger as α).$lt(rhs :: α) :: Boolean
  method (lhs :: BinaryInteger as α).$gt(rhs :: α) :: Boolean
  method (lhs :: BinaryInteger as α).$le(rhs :: α) :: Boolean
  method (lhs :: BinaryInteger as α).$ge(rhs :: α) :: Boolean
){
  Overloads the @pille_expr(==), @pille_expr(!=),
  @pille_expr(<), @pille_expr(<=), @pille_expr(>), and
  @pille_expr(>=) operators for
  @pille_specl_bind(BinaryInteger)s.
}

@doc(
  method (specl BinaryInteger as δ).cast_exact(src :: Integral) :: δ
){
  Casts @rhombus(src) to @rhombus(δ), while asserting that
  @rhombus(δ) can represent the value of @rhombus(src); it
  is @tech{managed undefined behavior} if this assumption
  does not hold.
}

@doc(
  method (specl BinaryInteger as δ).cast_exact_unchecked(src :: BinaryInteger) :: δ
){
  Casts @rhombus(src) to @rhombus(δ), while asserting that
  @rhombus(δ) can represent the value of @rhombus(src); it
  is always undefined behavior if this assumption does not
  hold.
}

@doc(
  method (specl BinaryInteger as δ).cast_wrap(src :: Integral) :: δ
){
  Casts @rhombus(src) to @rhombus(δ), with guaranteed
  wrapping in the case that @rhombus(δ) cannot represent the
  value of @rhombus(src).
}
