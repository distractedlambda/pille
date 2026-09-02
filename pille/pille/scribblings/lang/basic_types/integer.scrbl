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
  method (lhs :: Int(n)).$add(rhs :: Int(n)) :: Int(n)

  method (lhs :: UInt(n)).$add(rhs :: UInt(n)) :: UInt(n)

  method (lhs :: Int(n)).$sub(rhs :: Int(n)) :: Int(n)

  method (lhs :: UInt(n)).$sub(rhs :: UInt(n)) :: UInt(n)

  method (rhs :: Int(n)).$neg() :: Int(n)

  method (lhs :: Int(n)).$mul(rhs :: Int(n)) :: Int(n)

  method (lhs :: UInt(n)).$mul(rhs :: UInt(n)) :: UInt(n)
){
  Implements the @pille_expr(+), @pille_expr(-), and
  @pille_expr(*) operations on
  @pille_specl_bind(BinaryInteger)s. Overflow/underflow
  arising from any of these operations is @tech{managed
  undefined behavior}.
}

@doc(
  method (lhs :: Int(n)).$add_wrap(rhs :: Int(n)) :: Int(n)

  method (lhs :: UInt(n)).$add_wrap(rhs :: UInt(n)) :: UInt(n)

  method (lhs :: Int(n)).$sub_wrap(rhs :: Int(n)) :: Int(n)

  method (lhs :: UInt(n)).$sub_wrap(rhs :: UInt(n)) :: UInt(n)

  method (rhs :: Int(n)).$neg_wrap() :: Int(n)

  method (rhs :: UInt(n)).$neg_wrap() :: UInt(n)

  method (lhs :: Int(n)).$mul_wrap(rhs :: Int(n)) :: Int(n)

  method (lhs :: UInt(n)).$mul_wrap(rhs :: UInt(n)) :: UInt(n)
){
  Implements the @pille_expr(+%), @pille_expr(-%), and
  @pille_expr(*%) operations on
  @pille_specl_bind(BinaryInteger)s. Overflow/underflow is
  guaranteed to be wrapping, so these methods never have
  undefined behavior.
}

@doc(
  method (lhs :: Int(n)).$div_trunc(rhs :: Int(n)) :: Int(n)

  method (lhs :: Int(n)).$rem_trunc(rhs :: Int(n)) :: Int(n)
){
  Implements the @pille_expr(div_trunc) and
  @pille_expr(rem_trunc) operations on
  @pille_specl_expr(Int)s. It is @tech{managed undefined
  behavior} for the @rhombus(rhs) to be @rhombus(0), or for
  the @rhombus(rhs) to be @rhombus(-1) at the same time that
  the @rhombus(lhs) is @pille_expr(Int(n).min_value).
}

@doc(
  method (lhs :: UInt(n)).$div_trunc(rhs :: UInt(n)) :: UInt(n)

  method (lhs :: UInt(n)).$div_floor(rhs :: UInt(n)) :: UInt(n)
){
  Implements the @pille_expr(div_trunc) and
  @pille_expr(div_floor) operations on
  @pille_specl_expr(UInt)s, with identical behavior. It is
  @tech{managed undefined behavior} for the @rhombus(rhs) to
  be @rhombus(0).
}

@doc(
  method (lhs :: UInt(n)).$rem(rhs :: UInt(n)) :: UInt(n)

  method (lhs :: UInt(n)).$rem_trunc(rhs :: UInt(n)) :: UInt(n)

  method (lhs :: UInt(n)).$rem_floor(rhs :: UInt(n)) :: UInt(n)
){
  Implements the @pille_expr(%), @pille_expr(rem_trunc), and
  @pille_expr(rem_floor) operations on
  @pille_specl_expr(UInt)s, with identical behavior.  It is
  @tech{managed undefined behavior} for the @rhombus(rhs) to
  be @rhombus(0).
}

@doc(
  method (rhs :: α && BinaryInteger).$not() :: α

  method (lhs :: α && BinaryInteger).$and(rhs :: α) :: α

  method (lhs :: α && BinaryInteger).$or(rhs :: α) :: α

  method (lhs :: α && BinaryInteger).$xor(rhs :: α) :: α
){
  Implements the @pille_expr(¬), @pille_expr(∧),
  @pille_expr(∨), and @pille_expr(⊻) operations on
  @pille_specl_bind(BinaryInteger)s. These never have
  undefined behavior.
}

@doc(
  method (lhs :: BinaryInteger as α).$shl(rhs :: Integral) :: α
  method (lhs :: BinaryInteger as α).$shr(rhs :: Integral) :: α
){
  Implements the @pille_expr(<<) and @pille_expr(>>)
  operators for @pille_specl_bind(BinaryInteger)s. The
  @rhombus(rhs) can have any @pille_specl_bind(Integral)
  type, but its value must be between @rhombus(0)
  (inclusive) and the bit-width of @rhombus(α) (exclusive),
  else the operation has @tech{managed undefined behavior}.
}

@doc(
  method (lhs :: Int(n)).$eq(rhs :: Int(n)) :: Boolean

  method (lhs :: UInt(n)).$eq(rhs :: UInt(n)) :: Boolean

  method (lhs :: Int(n)).$ne(rhs :: Int(n)) :: Boolean

  method (lhs :: UInt(n)).$ne(rhs :: UInt(n)) :: Boolean

  method (lhs :: Int(n)).$lt(rhs :: Int(n)) :: Boolean

  method (lhs :: UInt(n)).$lt(rhs :: UInt(n)) :: Boolean

  method (lhs :: Int(n)).$le(rhs :: Int(n)) :: Boolean

  method (lhs :: UInt(n)).$le(rhs :: UInt(n)) :: Boolean

  method (lhs :: Int(n)).$gt(rhs :: Int(n)) :: Boolean

  method (lhs :: UInt(n)).$gt(rhs :: UInt(n)) :: Boolean

  method (lhs :: Int(n)).$ge(rhs :: Int(n)) :: Boolean

  method (lhs :: UInt(n)).$ge(rhs :: UInt(n)) :: Boolean
){
  Implements the @pille_expr(==), @pille_expr(!=),
  @pille_expr(<), @pille_expr(<=), @pille_expr(>), and
  @pille_expr(>=) operations on
  @pille_specl_bind(BinaryInteger)s.
}

@doc(
  method (specl BinaryInteger as δ).cast_exact(src :: Integral) :: δ
){}

@doc(
  method (specl BinaryInteger as δ).cast_wrap(src :: Integral) :: δ
){}
