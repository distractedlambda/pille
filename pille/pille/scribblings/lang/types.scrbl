#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title{Basic Types}

@//=============================================================================
@section(~tag: "Basic_Types_Specl"){Wrapping Specialization Values}

@doc(
  type Specl(val :: any)
){
  Represents the @tech{specialization value} @rhombus(val), but as a
  first-class @tech{dynamic value}. All
  @pille_specl_expr(Specl) types have erased
  representations, so their instances carry no actual
  information during execution.
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
  Allows calling specialization functions (such as those defined by
  @pille_global_defn(specl.fun)) within ordinary expressions, provided that all
  arguments are themselves specialization values.
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
  Forwards various generic operators to their specialization counterparts when
  operating on @pille_specl_expr(Specl) operands.
}

@//=============================================================================
@section{Booleans}

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

@//=============================================================================
@section{Integers}

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
  property (specl Int(w)).min_value :: Specl(-(2**(w - 1)))

  property (specl Int(w)).max_value :: Specl(2**(w - 1) - 1)

  property (specl UInt(w)).min_value :: Specl(0)

  property (specl UInt(w)).max_value :: Specl(2**w - 1)
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
    ~when dst_width > bit_length(val)
){
  Coerces @rhombus(val) to any
  @pille_specl_expr(Int) type which can represent it.
}

@doc(
  unify(Specl(v :: int), Int(w)):
    Int(max(bit_length(v) + 1, w))
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
    ~when dst_width ≥ bit_length(val)
){
  Coerces @rhombus(val) to any
  @pille_specl_expr(UInt) type which can represent it.
}

@doc(
  unify(Specl(v :: nat), UInt(w)):
    UInt(max(bit_length(v), w))
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
    Int(max(bit_length(v1), bit_length(v2)) + 1)
){
  Unifies two @pille_specl_expr(Specl) types representing
  @pille_specl_annot(int)s (that are not both also
  @pille_specl_annot(nat)s) to the narrowest
  @pille_specl_expr(Int) type which can represent both.
}

@doc(
  unify(Specl(v1 :: nat), Specl(v2 :: nat)):
    UInt(bit_length(max(v1, v2)))
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
  coercion (cast :: CastExact(σ && Specl(_ :: int)))
    :: CoercesFrom(σ) && BinaryInteger
){
  Implements value-preserving casts from
  @pille_specl_bind(Specl(_ :: int)) types to
  @pille_specl_bind(BinaryInteger)s, which are the same as
  coercions from the source type.
}

@doc(
  coercion (cast :: CastExact(Int(_))) :: Int(_)

  coercion (cast :: CastExact(Int(_))) :: UInt(_)

  coercion (cast :: CastExact(UInt(_))) :: UInt(_)

  coercion (cast :: CastExact(UInt(_))) :: Int(_)
){
  Implements value-preserving casts between
  @pille_specl_bind(BinaryInteger)s, where it is
  @tech{managed undefined behavior} if the destination type
  is unable to represent the source value.
}

@doc(
  coercion (cast :: CastWrap(Specl(_ :: int))) :: BinaryInteger

  coercion (cast :: CastWrap(Int(_))) :: Int(_)

  coercion (cast :: CastWrap(Int(_))) :: UInt(_)

  coercion (cast :: CastWrap(UInt(_))) :: UInt(_)

  coercion (cast :: CastWrap(UInt(_))) :: Int(_)
){
  Implements wrapping casts between
  @pille_specl_bind(BinaryInteger)s, and from
  @pille_specl_bind(Specl(_ :: int)) types to
  @pille_specl_bind(BinaryInteger)s, where an out-of-range
  source value silently wraps to the range of the
  destination type. This never has undefined behavior.
}

@//=============================================================================
@section{Machine-Precision Real Numbers}

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

@//=============================================================================
@section{Tuples}

@doc(
  type Tuple(element :: type, ...)
){}

@doc(
  specl_bind.macro 'AnyTuple'
){}

@doc(
  specl.fun tuple_length(τ && AnyTuple) :: nat
){}

@doc(
  specl.fun TupleElement(τ && AnyTuple, idx :: nat) :: type
){}

@doc(
  expr.macro '#%brackets [$expr, ...]'
){}

@doc(
  method (tup :: τ && AnyTuple).$index_read(specl idx :: nat)
    :: TupleElement(τ, idx)
){}

@doc(
  method (inout tup :: τ && AnyTuple).$index_write(
    specl idx :: nat,
    elem :: equal_to(TupleElement(τ, idx)),
  ) :: Void
){}

@//=============================================================================
@section{SIMD Vectors}

@doc(
  type Simd(element :: type, length :: pos_int)
){
  A fixed-length array specialized for operations that
  process elements in parallel.

  Uses of @pille_specl_expr(Simd) types, and their
  corresponding methods, serve as non-binding directives for
  @tech{code generation} to use the target's corresponding
  @wikipedia_simd registers and instructions. It is legal to
  use @pille_specl_expr(Simd) types or operations that the
  target does not natively support, in which case code
  generation will fall back to ``software'' implementations
  (often using smaller vectors or scalars).

  The available operations on @pille_specl_expr(Simd) types
  are described in @seclink("SIMD_Operations"){their own
  section}.
}

@//=============================================================================
@section{Untyped Pointers}

@doc(
  type RawPtr
){
  A byte-oriented native pointer with few guarantees. A
  @pille_specl_expr(RawPtr) may or may not refer to
  validly-dereferencable memory.

  In some regards a @pille_specl_expr(RawPtr) is like a
  @pille_specl_expr(NativeUInt) representing a memory
  address, but arithmetic on @pille_specl_expr(RawPtr)s
  carries additional restrictions to allow optimizers to
  better reason about aliasing.
}

@doc(
  method (ptr :: RawPtr).load(specl α :: type) :: α

  method (ptr :: RawPtr).load(
    specl α :: type,
    specl align :: alignment,
  ) :: α
){
  Loads a value of type @rhombus(α) from the memory at
  @rhombus(ptr), with an assumed alignment of
  @rhombus(align) (which defaults to
  @pille_specl_expr(alignof(α))).

  It is @tech{managed undefined behavior} for @rhombus(ptr)
  to not have at least the alignment given by
  @rhombus(align).
}

@doc(
  method (ptr :: RawPtr).store(value :: α) :: Void

  method (ptr :: RawPtr).store(
    value :: α,
    specl align :: alignment,
  ) :: Void
){
  Stores @rhombus(value) to the memory at @rhombus(ptr),
  with an assumed alignment of @rhombus(align) (which
  defaults to @pille_specl_expr(alignof(α))).

  It is @tech{managed undefined behavior} for @rhombus(ptr)
  to not have at least the alignment given by
  @rhombus(align).
}

@doc(
  method (ptr :: RawPtr).$add(offset :: Integral) :: RawPtr
){
  Forms a new @pille_specl_expr(RawPtr) by applying a
  byte-scale @rhombus(offset) to @rhombus(ptr).

  It is @tech{managed undefined behavior} for arithmetic
  overflow to occur in calculating the address of the
  resulting pointer; that is, for a positive
  @rhombus(offset) to displace @rhombus(ptr) ``backwards'',
  or for a negative @rhombus(offset) to displace
  @rhombus(ptr) ``forwards''.

  It is @tech{suppressible undefined behavior} for the
  result to point outside of the allocation pointed into by
  @rhombus(ptr), except that pointing to the first byte
  following the allocation (i.e. to the allocation's
  ``end'') is allowed. For instance, it is not legal to
  offset a @rhombus(ptr) that points into one allocation
  such that the result points into another, even if the
  distance between the two allocations is knowable. This
  restriction permits an optimizer to make stronger
  assumptions about pointer aliasing.
}

@doc(
  method (ptr :: RawPtr).$sub(amount :: BinaryInteger) :: RawPtr
){
  Equivalent to:
  @rhombusblock(#,(pille_expr(ptr + (-(amount.cast_exact() :: NativeInt)))))
}

@doc(
  method (ptr :: RawPtr).$sub(specl amount :: int) :: RawPtr
){
  Equivalent to:
  @rhombusblock(#,(pille_expr(ptr + (-amount))))
}

@doc(
  method (ptr :: RawPtr).$eq(other :: RawPtr) :: Boolean
  method (ptr :: RawPtr).$ne(other :: RawPtr) :: Boolean
  method (ptr :: RawPtr).$lt(other :: RawPtr) :: Boolean
  method (ptr :: RawPtr).$le(other :: RawPtr) :: Boolean
  method (ptr :: RawPtr).$gt(other :: RawPtr) :: Boolean
  method (ptr :: RawPtr).$ge(other :: RawPtr) :: Boolean
){
  Provides the @pille_expr(==), @pille_expr(!=),
  @pille_expr(<), @pille_expr(<=), @pille_expr(>), and
  @pille_expr(>=) operations for @pille_specl_expr(RawPtr)s.

  These operations never have undefined behavior, though the
  results of order comparisons between pointers into
  different allocations are not generally well-specified.
}

@//=============================================================================
@section{Typed Pointers}

@doc(
  type Ptr(α :: type)
){
  A native pointer providing read-only acccess to instances
  of @rhombus(α).

  In contrast to a @pille_specl_expr(RawPtr), a
  @pille_specl_expr(Ptr) is guaranteed to be aligned to at
  least @pille_specl_expr(alignof(α)). There are no
  additional guarantees, however; a @pille_specl_expr(Ptr)
  may or may not point to dereferencable memory, and even if
  it does, it might not point to valid instances of
  @rhombus(α). A @pille_specl_expr(Ptr) is therefore more a
  declaration of intent than a semantic guarantee.
}

@doc(
  type PtrMut(α :: type)
){
  A native pointer providing read-write acccess to instances
  of @rhombus(α).

  In contrast to a @pille_specl_expr(RawPtr), a
  @pille_specl_expr(PtrMut) is guaranteed to be aligned to
  at least @pille_specl_expr(alignof(α)). There are no
  additional guarantees, however; a
  @pille_specl_expr(PtrMut) may or may not point to
  dereferencable memory, and even if it does, it might not
  point to valid instances of @rhombus(α). A
  @pille_specl_expr(PtrMut) is therefore more a declaration
  of intent than a semantic guarantee.
}

@doc(
  specl_bind.macro 'PtrTo($specl_bind)'
){
  Matches both @pille_specl_bind(Ptr(specl_bind)) and
  @pille_specl_bind(PtrMut(specl_bind)).
}

@doc(
  coercion (ptr :: PtrMut(α)) :: Ptr(α)
  unify(PtrMut(α), Ptr(α)): Ptr(α)
){
  A @pille_specl_expr(PtrMut(α)) can coerce to a
  @pille_specl_expr(Ptr(α)), dropping the ``write access''
  of the original @rhombus(ptr).
}

@doc(
  method (specl PtrTo(α)).from_raw(raw :: RawPtr)
){
  Creates a new @pille_specl_expr(Ptr) or
  @pille_specl_expr(PtrMut) from a
  @pille_specl_expr(RawPtr). It is @tech{managed undefined
  behavior} for @rhombus(raw) to not be aligned to at least
  @pille_specl_expr(alignof(α)).
}

@doc(
  property (ptr :: PtrTo(α)).raw :: RawPtr
  property (inout ptr :: PtrTo(α)).raw := (new_raw :: RawPtr)
){
  Provides access to the @pille_specl_expr(RawPtr)
  underlying a @pille_specl_expr(Ptr) or
  @pille_specl_expr(PtrMut).

  When assigning, it is @tech{managed undefined behavior}
  for @rhombus(new_raw) to not be aligned to at least
  @pille_specl_expr(alignof(α)).
}

@doc(
  method (ptr :: φ && PtrTo(α)).$add(offset :: Integral) :: φ

  method (ptr :: φ && PtrTo(α)).$sub(amount :: Integral) :: φ
){
  Like the @pille_expr($add) and @pille_expr($sub) methods
  on @pille_specl_expr(RawPtr), except that the
  @rhombus(offset) or @rhombus(amount) is scaled by
  @pille_specl_expr(strideof(α)).
}

@doc(
  method (ptr :: PtrTo(α)).$index_read() :: α
){
  Implements @pille_expr(ptr[]) as equivalent to
  @pille_expr(ptr.raw.load(α)).
}

@doc(
  method (ptr :: PtrTo(α)).$index_read(idx :: Integral) :: α
){
  Implements @pille_expr(ptr[idx]) as equivalent to
  @pille_expr((ptr + idx).raw.load(α)).
}

@doc(
  method (ptr :: PtrMut(α)).$index_write(value :: α) :: Void
){
  Implements @pille_expr(ptr[] := value) as equivalent to
  @pille_expr(ptr.raw.store(value)).
}

@doc(
  method (ptr :: PtrMut(α)).$index_write(idx :: Integral, value :: α)
    :: Void
){
  Implements @pille_expr(ptr[idx] := value) as equivalent to
  @pille_expr((ptr + idx).raw.store(value)).
}

@doc(
  method (ptr :: φ && PtrTo(α)).$eq(other :: φ) :: Boolean
  method (ptr :: φ && PtrTo(α)).$ne(other :: φ) :: Boolean
  method (ptr :: φ && PtrTo(α)).$lt(other :: φ) :: Boolean
  method (ptr :: φ && PtrTo(α)).$le(other :: φ) :: Boolean
  method (ptr :: φ && PtrTo(α)).$gt(other :: φ) :: Boolean
  method (ptr :: φ && PtrTo(α)).$ge(other :: φ) :: Boolean
){
  Like the corresponding methods on
  @pille_specl_expr(RawPtr).
}

@//=============================================================================
@section{Unitary Results}

@doc(
  type Void
){
  The canonical unit type.
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

@//=============================================================================
@section{Diverging Expressions}

@doc(
  type Never
){
  The canonical uninhabited type.
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
