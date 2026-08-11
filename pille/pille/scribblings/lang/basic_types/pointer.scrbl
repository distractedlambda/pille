#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title(~tag: "Basic_Types_Pointers"){Pointers}

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
@section{Inspecting Memory Layout}

@doc(
  specl_annot.macro 'alignment'

  specl.fun sizeof(α :: type) :: nat

  specl.fun alignof(α :: type) :: alignment

  specl.fun strideof(α :: type) :: nat
){}
