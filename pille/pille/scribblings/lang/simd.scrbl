#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title{SIMD Operations}

@doc(
  coercion (elem :: σ) :: Simd(CoercesFrom(σ), _)
){
  The ``broadcasting'' coercion: the result is a
  @pille_const_expr(Simd) value which holds a copy of
  @rhombus(elem) in each lane.
}

@doc(
  coercion (src :: Simd(UInt(ws), n))
    :: Simd(UInt(wd), n):
      ~when ws < wd

  coercion (src :: Simd(UInt(ws), n))
    :: Simd(Int(wd), n):
      ~when ws < wd

  coercion (src :: Simd(Int(ws), n))
    :: Simd(Int(wd), n):
      ~when ws < wd
){
  Standard arithmetic coercions, but lifted to apply
  lanewise to @pille_const_expr(Simd) values.
}

@doc(
  unify(Simd(α, n), β):
    Simd(unify(α, β), n)

  unify(Simd(α, n), Simd(β, n)):
    Simd(unify(α, β), n)
){
  @tech{Unification} rules to use when at least one of the
  types is a @pille_const_expr(Simd) type. The first rule is
  meant to match the broadcasting coercion, and has lower
  priority than the second.
}

@doc(
  method (rhs :: α && Simd(Bitwise, _)).$not() :: α

  method (lhs :: α && Simd(Bitwise, _)).$and(rhs :: α) :: α

  method (lhs :: α && Simd(Bitwise, _)).$or(rhs :: α) :: α

  method (lhs :: α && Simd(Bitwise, _)).$xor(rhs :: α) :: α
){}

@doc(
  method (smd :: Simd(α && Bitwise, n)).reduce_and() :: α

  method (smd :: Simd(α && Bitwise, n)).reduce_or() :: α

  method (smd :: Simd(α && Bitwise, n)).reduce_xor() :: α
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

@section{Sparse Operations}
@doc(
  type SparseSimd(element :: type, length :: pos_int)
){
  Models a @pille_const_expr(Simd) value which is ``sparse''
  in the sense that some lanes might not hold meaningful
  values. More precisely, a @pille_const_expr(SparseSimd)
  value can have @deftech{undefined lanes}, and any attempt
  to access an undefined lane results in @tech{managed
  undefined behavior}.
}

@doc(
  coercion (src :: σ) :: SparseSimd(α, n):
    ~where CoercesTo(Simd(α, n)) = σ
){
  Coerces @rhombus(src) to a @pille_const_expr(SparseSimd)
  type whenever it could coerce to (or is) the corresponding
  @pille_const_expr(Simd) type. The resulting value never
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
  lanewise to @pille_const_expr(SparseSimd) values. Each
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
