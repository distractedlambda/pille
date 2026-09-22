#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title(~tag: "Basic_Types_SIMD_Vectors"){SIMD Vectors}

@section{Dense Vectors}

@doc(
  type Simd(element :: Simd.Scalar, length :: pos_int)
){
  A fixed-length array specialized for operations that
  process elements in parallel.

  Uses of @pille_specl_expr(Simd) types, and their
  corresponding methods, serve as non-binding directives for
  code generation to use the target's corresponding
  @wikipedia_simd registers and instructions. It is legal to
  use @pille_specl_expr(Simd) types or operations that the
  target does not natively support, in which case code
  generation will fall back to ``software'' implementations
  (often using smaller vectors or scalars).
}

@doc(
  specl_annot.macro 'Simd.Scalar'
  specl_bind.macro 'Simd.Scalar'
){
  Matches types that are valid as @pille_specl_expr(Simd)
  element types, including:
  @itemlist(
    @item{@pille_specl_expr(Boolean).},
    @item{All @pille_specl_bind(BinaryInteger) types.},
    @item{All @pille_specl_bind(FloatingPoint) types.},
    @item{@pille_specl_expr(RawPtr), and all
          @pille_specl_expr(Ptr) and
          @pille_specl_expr(PtrMut) types.},
    @item{All @pille_specl_expr(Tuple) types where exactly
          one element type is non-erased, and that
          non-erased type is also
          @pille_specl_annot(Simd.Scalar).},
    @item{All @pille_global_defn(struct)-defined types where
          exactly one field type is non-erased, and that
          non-erased type is also
          @pille_specl_annot(Simd.Scalar).})
}

@doc(
  coercion (elem :: Simd.Scalar as α) :: Simd(β, n):
    ~when α coerces_to β

  unify(α :: Simd.Scalar, Simd(β, n)):
    Simd(unify(α, β), n)
){
  Scalars can coerce to @pille_specl_expr(Simd) vectors; the
  resulting vector holds a (possibly-coerced) copy of that
  scalar value in each lane.
}

@doc(
  coercion (src :: Simd(UInt(ws), n)) :: Simd(UInt(wd), n):
    ~when ws < wd

  unify(Simd(UInt(w1), n), Simd(UInt(w2), n)):
    Simd(UInt(max(w1, w2)), n)

  coercion (src :: Simd(UInt(ws), n)) :: Simd(Int(wd), n):
    ~when ws < wd

  unify(Simd(UInt(w1), n), Simd(Int(w2), n)):
    Simd(Int(max(w1 + 1, w2)), n)

  coercion (src :: Simd(Int(ws), n)) :: Simd(Int(wd), n):
    ~when ws < wd

  unify(Simd(Int(w1), n), Simd(Int(w2), n)):
    Simd(Int(max(w1, w2)), n)

  coercion (src :: Simd(Float, n)) :: Simd(Double, n)

  unify(Simd(Float, n), Simd(Double, n)):
    Simd(Double, n)

  coercion (src :: Simd(Int(w) || UInt(w), n)) :: Simd(Float, n):
    ~when w ≤ 24

  unify(Simd(Int(w) || UInt(w), n), Simd(Float, n)):
    ~when w ≤ 24
    Simd(Float, n)

  coercion (src :: Simd(Int(w) || UInt(w), n)) :: Simd(Double, n):
    ~when w ≤ 53

  unify(Simd(Int(w) || UInt(w), n), Simd(Double, n)):
    ~when w ≤ 53
    Simd(Double, n)
){
  Standard arithmetic coercions, but lifted to apply
  lanewise to @pille_specl_expr(Simd) values.
}

@doc(
  property (specl Simd(BinaryInteger as ι, n) as σ).iota :: σ:
    ~when n - 1 ≤ ι.max_value
){
  Produces a @pille_specl_expr(Simd) vector whose lanes
  contain the successive natural numbers up to (but
  excluding) @rhombus(n).
}

@doc(
  method (rhs :: Simd(Bitwise, _) as σ).$not() :: σ

  method (lhs :: Simd(Bitwise, _) as σ).$and(rhs :: σ) :: σ

  method (lhs :: Simd(Bitwise, _) as σ).$or(rhs :: σ) :: σ

  method (lhs :: Simd(Bitwise, _) as σ).$xor(rhs :: σ) :: σ
){}

@doc(
  method (smd :: Simd(Bitwise as α, _)).reduce_and() :: α

  method (smd :: Simd(Bitwise as α, _)).reduce_or() :: α

  method (smd :: Simd(Bitwise as α, _)).reduce_xor() :: α
){
  Parallel reduction operations: these are equivalent to a
  serial reduction that folds over one lane at a time, but
  may be implemented more efficiently.
}

@doc(
  method (smd :: Simd(Boolean, n)).all() :: Boolean

  method (smd :: Simd(Boolean, n)).any() :: Boolean

  method (smd :: Simd(Boolean, n)).parity() :: Boolean
){
  Equivalent to the @tt{reduce_and}, @tt{reduce_or}, and
  @tt{reduce_xor} methods, respectively. These names are
  intended for when @rhombus(smd) represents the result of
  some logical predicate.
}

@doc(
  method (lhs :: Simd(BinaryInteger, _) as σ).$add(rhs :: σ) :: σ
  method (lhs :: Simd(BinaryInteger, _) as σ).$add_wrap(rhs :: σ) :: σ
  method (lhs :: Simd(BinaryInteger, _) as σ).$sub(rhs :: σ) :: σ
  method (lhs :: Simd(BinaryInteger, _) as σ).$sub_wrap(rhs :: σ) :: σ
  method (lhs :: Simd(BinaryInteger, _) as σ).$mul(rhs :: σ) :: σ
  method (lhs :: Simd(BinaryInteger, _) as σ).$mul_wrap(rhs :: σ) :: σ
){}

@doc(
  method (rhs :: Simd(BinaryInteger, _) as σ).$neg() :: σ
  method (rhs :: Simd(BinaryInteger, _) as σ).$neg_wrap() :: σ
){}

@doc(
  method (lhs :: Simd(FloatingPoint, _) as σ).$add(rhs :: σ) :: σ
  method (lhs :: Simd(FloatingPoint, _) as σ).$sub(rhs :: σ) :: σ
  method (lhs :: Simd(FloatingPoint, _) as σ).$mul(rhs :: σ) :: σ
  method (lhs :: Simd(FloatingPoint, _) as σ).$div(rhs :: σ) :: σ
  method (lhs :: Simd(FloatingPoint, _) as σ).$rem_trunc(rhs :: σ) :: σ
  method (lhs :: Simd(FloatingPoint, _) as σ).$pow(rhs :: σ) :: σ
){}

@doc(
  method (x :: Simd(FloatingPoint, _) as σ).$neg() :: σ
  method (x :: Simd(FloatingPoint, _) as σ).$abs() :: σ

  method (x :: Simd(FloatingPoint, _) as σ).$floor() :: σ
  method (x :: Simd(FloatingPoint, _) as σ).$ceil() :: σ
  method (x :: Simd(FloatingPoint, _) as σ).$round() :: σ
  method (x :: Simd(FloatingPoint, _) as σ).$trunc() :: σ

  method (x :: Simd(FloatingPoint, _) as σ).$sqrt() :: σ
  method (x :: Simd(FloatingPoint, _) as σ).$exp() :: σ

  method (x :: Simd(FloatingPoint, _) as σ).$sin() :: σ
  method (x :: Simd(FloatingPoint, _) as σ).$cos() :: σ
  method (x :: Simd(FloatingPoint, _) as σ).$tan() :: σ

  method (x :: Simd(FloatingPoint, _) as σ).$acos() :: σ
  method (x :: Simd(FloatingPoint, _) as σ).$asin() :: σ
){}

@doc(
  method (ptrs :: Simd(RawPtr, n) as φ).$add_wrap(
    offsets :: Simd(BinaryInteger, n),
  ) :: φ

  method (ptrs :: Simd(PtrTo(α), n) as φ).$add_wrap(
    offsets :: Simd(BinaryInteger, n),
  ) :: φ
){}

@doc(
  method (lhs :: Simd(α, n) as σ).$eq(rhs :: Simd(α, n))
    :: Simd(Boolean, n):
      ~where BinaryInteger || FloatingPoint || RawPtr || PtrTo(_) = α

  method (lhs :: Simd(α, n) as σ).$ne(rhs :: Simd(α, n))
    :: Simd(Boolean, n):
      ~where BinaryInteger || FloatingPoint || RawPtr || PtrTo(_) = α

  method (lhs :: Simd(α, n) as σ).$lt(rhs :: Simd(α, n))
    :: Simd(Boolean, n):
      ~where BinaryInteger || FloatingPoint || RawPtr || PtrTo(_) = α

  method (lhs :: Simd(α, n) as σ).$le(rhs :: Simd(α, n))
    :: Simd(Boolean, n):
      ~where BinaryInteger || FloatingPoint || RawPtr || PtrTo(_) = α

  method (lhs :: Simd(α, n) as σ).$gt(rhs :: Simd(α, n))
    :: Simd(Boolean, n):
      ~where BinaryInteger || FloatingPoint || RawPtr || PtrTo(_) = α

  method (lhs :: Simd(α, n) as σ).$ge(rhs :: Simd(α, n))
    :: Simd(Boolean, n):
      ~where BinaryInteger || FloatingPoint || RawPtr || PtrTo(_) = α
){}

@section{Sparse Vectors}

@doc(
  type SparseSimd(element :: type, length :: pos_int)
){
  Models a @pille_specl_expr(Simd) value which is ``sparse''
  in the sense that some lanes might not hold meaningful
  values. More precisely, a @pille_specl_expr(SparseSimd)
  value can have @deftech{undefined lanes}, and any attempt
  to access an undefined lane results in @tech{managed
  undefined behavior}.
}

@doc(
  coercion (src :: σ) :: SparseSimd(α, n):
    ~where CoercesTo(Simd(α, n)) = σ
){
  Coerces @rhombus(src) to a @pille_specl_expr(SparseSimd)
  type whenever it could coerce to (or is) the corresponding
  @pille_specl_expr(Simd) type. The resulting value never
  has @tech{undefined lanes}.
}

@doc(
  coercion (src :: SparseSimd(UInt(ws), n))
    :: SparseSimd(UInt(wd), n):
      ~when ws < wd

  coercion (src :: SparseSimd(UInt(ws), n))
    :: SparseSimd(Int(wd), n):
      ~when ws < wd

  coercion (src :: SparseSimd(Int(ws), n))
    :: SparseSimd(Int(wd), n):
      ~when ws < wd
){
  Standard arithmetic coercions, but lifted to apply
  lanewise to @pille_specl_expr(SparseSimd) values. Each
  @tech{undefined lane} in the @rhombus(src) is also
  undefined in the result.
}

@doc(
  method (mask :: Simd(Boolean, n))
    .sparse_not(smd :: γ && SparseSimd(Bitwise, n)) :: γ

  method (mask :: Simd(Boolean, n))
    .sparse_add(lhs :: α, rhs :: β,) :: γ:
      ~where γ && SparseSimd(Int(_), n) = unify(α, β)

  method (mask :: Simd(Boolean, n))
    .sparse_add(lhs :: α, rhs :: β) :: γ:
      ~where γ && SparseSimd(UInt(_), n) = unify(α, β)

  method (mask :: Simd(Boolean, n))
    .sparse_sub(lhs :: α, rhs :: β,) :: γ:
      ~where γ && SparseSimd(Int(_), n) = unify(α, β)

  method (mask :: Simd(Boolean, n))
    .sparse_sub(lhs :: α, rhs :: β) :: γ:
      ~where γ && SparseSimd(UInt(_), n) = unify(α, β)

  method (mask :: Simd(Boolean, n))
    .sparse_mul(lhs :: α, rhs :: β) :: γ:
      ~where γ && SparseSimd(Int(_), n) = unify(α, β)

  method (mask :: Simd(Boolean, n))
    .sparse_mul(lhs :: α, rhs :: β) :: γ:
      ~where γ && SparseSimd(UInt(_), n) = unify(α, β)

  method (mask :: Simd(Boolean, n))
    .sparse_and(lhs :: α, rhs :: β) :: γ:
      ~where γ && SparseSimd(Bitwise, n) = unify(α, β)

  method (mask :: Simd(Boolean, n))
    .sparse_or(lhs :: α, rhs :: β) :: γ:
      ~where γ && SparseSimd(Bitwise, n) = unify(α, β)

  method (mask :: Simd(Boolean, n))
    .sparse_xor(lhs :: α, rhs :: β) :: γ:
      ~where γ && SparseSimd(Bitwise, n) = unify(α, β)
){
  Sparse lanewise versions of standard arithmetic and
  logical operations: the operation is performed only along
  lanes for which the @rhombus(mask) holds a @rhombus(#true)
  value.

  The @rhombus(mask) must disable (i.e. hold a
  @rhombus(#false) value for) any lanes which are undefined
  in the sparse operand(s), else the operation has
  @tech{managed undefined behavior}. Moreover, the undefined
  lanes in the result are precisely those which the
  @rhombus(mask) disables (even if they were defined the
  operand(s)).

  These operations also inherit the (managed) undefined
  behavior of their scalar counterparts, if any; such
  undefined behavior can only occur on lanes enabled by the
  @rhombus(mask).
}

@doc(
  method (mask :: μ && Simd(Boolean, n))
    .sparse_refine_mask(test :: SparseSimd(Boolean, n)) :: μ
){
  Refines @rhombus(mask) (potentially disabling more lanes)
  according to @rhombus(test); specifically, the
  @rhombus(#true) lanes in the result are exactly those
  which are @rhombus(#true) in both @rhombus(mask) and
  @rhombus(test).

  It is @tech{managed undefined behavior} for the
  @rhombus(mask) to enable any @tech{undefined lane} in
  @rhombus(test).
}

@doc(
  method (mask :: Simd(Boolean, n))
    .sparse_select(
      test :: SparseSimd(Boolean, n),
      fst :: α,
      snd :: β,
    ) :: γ:
      ~where γ && SparseSimd(_, n) = unify(α, β)
){
  Performs sparse lanewise selection between
  @pille_expr(fst :: γ) and @pille_expr(snd :: γ) according
  to @rhombus(test); specifically, each lane in the result
  is equal to the corresponding lane in
  @pille_expr(fst :: γ) if the corresponding lane in
  @rhombus(test) holds @rhombus(#true), else it is equal to
  the corresponding lane in @pille_expr(snd :: γ).

  It is @tech{managed undefined behavior} for the
  @rhombus(mask) to enable ay @tech{undefined lane} in
  @rhombus(test); moreover, any lane that is selected from
  @pille_expr(fst :: γ) or @pille_expr(snd :: γ) must have a
  defined value.
}

@doc(
  method (mask :: Simd(Boolean, n))
    .sparse_assign(
      inout dst :: δ && SparseSimd(_, n),
      src :: CoercesTo(δ),
    ) :: Void
){
  Performs sparse lanewise assignment from
  @pille_expr(src :: δ) to @rhombus(dst); specifically, the
  value of each @rhombus(mask)-enabled lane in @rhombus(dst)
  is set to the value of the corresponding lane in
  @pille_expr(src :: δ), and no change is made for
  mask-disabled lanes.

  It is @tech{managed undefined behavior} for the
  @rhombus(mask) to enable any @tech{undefined lane} in
  @pille_expr(src :: δ). Undefined lanes in @rhombus(dst)
  @italic{do not} cause undefined behavior; on the contrary,
  any lane assigned to in @rhombus(dst) becomes defined if
  it was not previously.
}
