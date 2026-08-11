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
