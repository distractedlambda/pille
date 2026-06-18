#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title(~tag: "Const_Expressions"){Expressions}

@doc(
  ~nonterminal_key: const_expr ~space
  grammar const_expr
){
  A @deftech{constant expression}, which yields a
  @tech{constant} when evaluated (and is only ever evaluated
  during @tech{concretization}).
}

@doc(
  const_expr.macro '='
){
  Specially-recognized by some syntactic forms, but
  otherwise an error.
}

@doc(
  const_expr.macro '#%parens ($const_expr)'
){}

@doc(
  ~nonterminal_key: #%literal ~at pille/const_expr

  const_expr.macro '#%literal $const_literal'

  grammar const_literal
  | $number
  | $boolean
  | $string
){}

@doc(
  const_expr.macro '$const_expr #%call ($const_expr, ...)'
  operator_order:
    ~stronger_than: ~other
    ~associativity: ~left
){}

@doc(
  const_expr.macro '$const_expr :: $const_annot'
  operator_order:
    ~weaker_than: ~other
    ~associativity: ~none
){}

@doc(
  const_expr.macro '$const_expr is_a $const_annot'
  operator_order:
    ~order: equivalence
    ~associativity: ~none
){}

@doc(
  const_expr.macro '$const_expr matches $const_bind'
  operator_order:
    ~order: equivalence
    ~associativity: ~none
){}

@doc(
  const_expr.macro 'if $const_expr
                    | $const_expr
                    | $const_expr'
){}

@doc(
  const_expr.macro 'type_of($expr)'
  expr.macro 'type_of($expr)'
){
  @tech(~key: "concretization"){Concretizes} @rhombus(expr)
  @italic{without} @tech(~key: "lowering"){lowering}
  it, and evaluates to the type of @rhombus(expr) as
  determined by concretization.
}

@doc(
  const.operator ! (rhs :: any) :: boolean
  operator_order: ~order: logical_negation
){}

@doc(
  const_expr.macro '$const_expr && $const_expr'
  operator_order: ~order: logical_conjunction
){}

@doc(
  const_expr.macro '$const_expr || $const_expr'
  operator_order: ~order: logical_disjunction
){}

@doc(
  const_expr.macro 'any($const_expr, ...)'
  const_expr.macro 'all($const_expr, ...)'
){}

@doc(
  const.operator (lhs :: number) + (rhs :: number) :: number
  const.operator (lhs :: number) - (rhs :: number) :: number
  const.operator - (rhs :: number) :: number
  operator_order: ~order: addition
){}

@doc(
  const.operator (lhs :: number) * (rhs :: number) :: number
  const.operator (lhs :: number) / (rhs :: number) :: number
  operator_order: ~order: multiplication
){}

@doc(
  const.operator (lhs :: real) div_trunc (rhs :: real) :: real
  const.operator (lhs :: real) div_floor (rhs :: real) :: real
  const.operator (lhs :: real) div_ceil (rhs :: real) :: real
  operator_order: ~order: multiplication
){}

@doc(
  const.operator (lhs :: real) rem_trunc (rhs :: real) :: real
  const.operator (lhs :: real) rem_floor (rhs :: real) :: real
  const.operator (lhs :: real) rem_ceil (rhs :: real) :: real
  operator_order: ~order: multiplication
){}

@doc(
  const.operator (lhs :: nonneg_real) % (rhs :: nonneg_real) :: nonneg_real
  operator_order: ~order: multiplication
){}

@doc(
  const.operator (lhs :: number) ** (rhs :: number) :: number
  operator_order: ~order: exponentiation
){}

@doc(
  const.operator (lhs :: any) == (rhs :: any) :: boolean
  const.operator (lhs :: any) != (rhs :: any) :: boolean
  const.operator (lhs :: any) ≠ (rhs :: any) :: boolean
  operator_order: ~order: equivalence
){}

@doc(
  const.operator (lhs :: comparable) < (rhs :: comparable)
    :: boolean
  const.operator (lhs :: comparable) <= (rhs :: comparable)
    :: boolean
  const.operator (lhs :: comparable) ≤ (rhs :: comparable)
    :: boolean
  const.operator (lhs :: comparable) > (rhs :: comparable)
    :: boolean
  const.operator (lhs :: comparable) >= (rhs :: comparable)
    :: boolean
  const.operator (lhs :: comparable) ≥ (rhs :: comparable)
    :: boolean
  operator_order: ~order: order_comparison
){}

@doc(
  const.fun min(x :: real, y :: real) :: real
  const.fun max(x :: real, y :: real) :: real
){}

@doc(
  const.operator not (rhs :: boolean) :: boolean
  const.operator not (rhs :: int) :: int
  const.operator ¬ (rhs :: boolean) :: boolean
  const.operator ¬ (rhs :: int) :: int
  operator_order: ~order: bitwise_negation
){}

@doc(
  const.operator (lhs :: boolean) and (rhs :: boolean) :: boolean
  const.operator (lhs :: int) and (rhs :: int) :: int
  const.operator (lhs :: boolean) ∧ (rhs :: boolean) :: boolean
  const.operator (lhs :: int) ∧ (rhs :: int) :: int
  operator_order: ~order: bitwise_conjunction
){}

@doc(
  const.operator (lhs :: boolean) or (rhs :: boolean) :: boolean
  const.operator (lhs :: int) or (rhs :: int) :: int
  const.operator (lhs :: boolean) ∨ (rhs :: boolean) :: boolean
  const.operator (lhs :: int) ∨ (rhs :: int) :: int
  operator_order: ~order: bitwise_disjunction
){}

@doc(
  const.operator (lhs :: boolean) xor (rhs :: boolean) :: boolean
  const.operator (lhs :: int) xor (rhs :: int) :: int
  const.operator (lhs :: boolean) ⊻ (rhs :: boolean) :: boolean
  const.operator (lhs :: int) ⊻ (rhs :: int) :: int
  operator_order: ~order: bitwise_disjunction
){}

@doc(
  const.fun bit_length(n :: int) :: nat
){}

@doc(
  const.fun const.error(message :: string)
){}
