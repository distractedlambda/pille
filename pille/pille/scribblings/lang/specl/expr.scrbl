#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title(~tag: "Specl_Expressions"){Expressions}

@doc(
  ~nonterminal_key: specl_expr ~space
  grammar specl_expr
){
  A @deftech{specialization expression}, which yields a
  @tech{specialization value} when evaluated (and is only ever evaluated
  during @tech{concretization}).
}

@doc(
  specl_expr.macro '='
){
  Specially-recognized by some syntactic forms, but
  otherwise an error.
}

@doc(
  specl_expr.macro '#%parens ($specl_expr)'
){}

@doc(
  ~nonterminal_key: #%literal ~at pille/specl_expr

  specl_expr.macro '#%literal $specl_literal'

  grammar specl_literal
  | $number
  | $boolean
  | $string
){}

@doc(
  specl_expr.macro '$specl_expr #%call ($specl_expr, ...)'
  operator_order:
    ~stronger_than: ~other
    ~associativity: ~left
){}

@doc(
  specl_expr.macro '$specl_expr :: $specl_annot'
  operator_order:
    ~weaker_than: ~other
    ~associativity: ~none
){}

@doc(
  specl_expr.macro '$specl_expr is_a $specl_annot'
  operator_order:
    ~order: equivalence
    ~associativity: ~none
){}

@doc(
  specl_expr.macro '$specl_expr matches $specl_bind'
  operator_order:
    ~order: equivalence
    ~associativity: ~none
){}

@doc(
  specl_expr.macro 'if $specl_expr
                    | $specl_expr
                    | $specl_expr'
){}

@doc(
  specl_expr.macro 'type_of($expr)'
  expr.macro 'type_of($expr)'
){
  @tech(~key: "concretization"){Concretizes} @rhombus(expr)
  @italic{without} @tech(~key: "lowering"){lowering}
  it, and evaluates to the type of @rhombus(expr) as
  determined by concretization.
}

@doc(
  specl.operator ! (rhs :: any) :: boolean
  operator_order: ~order: logical_negation
){}

@doc(
  specl_expr.macro '$specl_expr && $specl_expr'
  operator_order: ~order: logical_conjunction
){}

@doc(
  specl_expr.macro '$specl_expr || $specl_expr'
  operator_order: ~order: logical_disjunction
){}

@doc(
  specl_expr.macro 'any($specl_expr, ...)'
  specl_expr.macro 'all($specl_expr, ...)'
){}

@doc(
  specl.operator (lhs :: number) + (rhs :: number) :: number
  specl.operator (lhs :: number) - (rhs :: number) :: number
  specl.operator - (rhs :: number) :: number
  operator_order: ~order: addition
){}

@doc(
  specl.operator (lhs :: number) * (rhs :: number) :: number
  specl.operator (lhs :: number) / (rhs :: number) :: number
  operator_order: ~order: multiplication
){}

@doc(
  specl.operator (lhs :: real) div_trunc (rhs :: real) :: real
  specl.operator (lhs :: real) div_floor (rhs :: real) :: real
  specl.operator (lhs :: real) div_ceil (rhs :: real) :: real
  operator_order: ~order: multiplication
){}

@doc(
  specl.operator (lhs :: real) rem_trunc (rhs :: real) :: real
  specl.operator (lhs :: real) rem_floor (rhs :: real) :: real
  specl.operator (lhs :: real) rem_ceil (rhs :: real) :: real
  operator_order: ~order: multiplication
){}

@doc(
  specl.operator (lhs :: nonneg_real) % (rhs :: nonneg_real) :: nonneg_real
  operator_order: ~order: multiplication
){}

@doc(
  specl.operator (lhs :: number) ** (rhs :: number) :: number
  operator_order: ~order: exponentiation
){}

@doc(
  specl.operator (lhs :: any) == (rhs :: any) :: boolean
  specl.operator (lhs :: any) != (rhs :: any) :: boolean
  specl.operator (lhs :: any) ≠ (rhs :: any) :: boolean
  operator_order: ~order: equivalence
){}

@doc(
  specl.operator (lhs :: comparable) < (rhs :: comparable)
    :: boolean
  specl.operator (lhs :: comparable) <= (rhs :: comparable)
    :: boolean
  specl.operator (lhs :: comparable) ≤ (rhs :: comparable)
    :: boolean
  specl.operator (lhs :: comparable) > (rhs :: comparable)
    :: boolean
  specl.operator (lhs :: comparable) >= (rhs :: comparable)
    :: boolean
  specl.operator (lhs :: comparable) ≥ (rhs :: comparable)
    :: boolean
  operator_order: ~order: order_comparison
){}

@doc(
  specl.fun min(x :: real, y :: real) :: real
  specl.fun max(x :: real, y :: real) :: real
){}

@doc(
  specl.operator not (rhs :: boolean) :: boolean
  specl.operator not (rhs :: int) :: int
  specl.operator ¬ (rhs :: boolean) :: boolean
  specl.operator ¬ (rhs :: int) :: int
  operator_order: ~order: bitwise_negation
){}

@doc(
  specl.operator (lhs :: boolean) and (rhs :: boolean) :: boolean
  specl.operator (lhs :: int) and (rhs :: int) :: int
  specl.operator (lhs :: boolean) ∧ (rhs :: boolean) :: boolean
  specl.operator (lhs :: int) ∧ (rhs :: int) :: int
  operator_order: ~order: bitwise_conjunction
){}

@doc(
  specl.operator (lhs :: boolean) or (rhs :: boolean) :: boolean
  specl.operator (lhs :: int) or (rhs :: int) :: int
  specl.operator (lhs :: boolean) ∨ (rhs :: boolean) :: boolean
  specl.operator (lhs :: int) ∨ (rhs :: int) :: int
  operator_order: ~order: bitwise_disjunction
){}

@doc(
  specl.operator (lhs :: boolean) xor (rhs :: boolean) :: boolean
  specl.operator (lhs :: int) xor (rhs :: int) :: int
  specl.operator (lhs :: boolean) ⊻ (rhs :: boolean) :: boolean
  specl.operator (lhs :: int) ⊻ (rhs :: int) :: int
  operator_order: ~order: bitwise_disjunction
){}

@doc(
  specl.fun bit_length(n :: int) :: nat
){}

@doc(
  specl.fun specl.error(message :: string)
){}
