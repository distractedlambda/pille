#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title{Ranges}

@doc(
  struct Range(α :: type):
    start :: α
    end :: α

  method (rng :: Range(_)).$contains(val):
    ~transparent
    (val ≥ rng.start) ∧ (val < rng.end)
){}

@doc(
  struct RangeFrom(α :: type):
    start :: α

  method (rng :: RangeFrom(_)).$contains(val):
    ~transparent
    val ≥ rng.start
){}

@doc(
  struct RangeTo(α :: type):
    end :: α

  method (rng :: RangeTo(_)).$contains(val):
    ~transparent
    val < rng.end
){}

@doc(
  struct RangeFull
){}

@doc(
  ~nonterminal:
    start_expr: expr expr ~space
    end_expr: expr expr ~space

  expr.macro '$start_expr .. $end_expr'

  expr.macro '$start_expr ..'

  expr.macro '.. $end_expr'

  expr.macro '..'

  operator_order: ~order: enumeration
){
  Creates a new @pille_specl_expr(Range) (the first case),
  @pille_specl_expr(RangeFrom) (the second case),
  @pille_specl_expr(RangeTo) (the third case), or
  @pille_specl_expr(RangeFull) (the fourth case).
}

@doc(
  property (rng :: Range(Integral as α)).$start_index
    :: RangeIndex(α)

  property (rng :: Range(Integral as α)).$end_index
    :: RangeIndex(α)

  method (rng :: Range(BinaryInteger as α))
    .$next_index(idx :: RangeIndex(α))
    :: RangeIndex(α)

  method (rng :: Range(BinaryInteger as α))
    .$index_read(idx :: RangeIndex(α))
    :: α
){
  Overloads that allow @pille_specl_expr(Range) types to act
  as sequences (and participate in forms like
  @pille_expr(for)).
}

@doc(
  struct RangeIndex(α):
    value :: α

  method (lhs :: RangeIndex(α)).$lt(rhs :: RangeIndex(α)):
    ~transparent
    lhs.value < rhs.value
){
  Represents an index into a @pille_specl_expr(Range). While
  there is no meaningful distinction between indices and
  elements of @pille_specl_expr(Range)s, a separate type
  avoids any type-confusion.
}
