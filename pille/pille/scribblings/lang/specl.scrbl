#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@(nonterminal:
    lhs_specl_expr: specl_expr specl_expr ~space
    rhs_specl_expr: specl_expr specl_expr ~space
    lhs_specl_bind: specl_bind specl_bind ~space
    rhs_specl_bind: specl_bind specl_bind ~space
    lhs_specl_annot: specl_annot specl_annot ~space
    rhs_specl_annot: specl_annot specl_annot ~space)

@title{The Specialization Language}

@//=============================================================================
@section(~tag: "Specl_Definitions"){Definitions}

@doc(
  global_defn.macro 'specl.def $id_name $maybe_annot = $specl_expr'

  global_defn.macro 'specl.def $id_name $maybe_annot:
                       $specl_expr'

  grammar maybe_annot
  | #,(pille_specl_expr(::)) $specl_annot
  | ε
){
  Defines @rhombus(id_name) as a specialization expression
  which stands in place of @rhombus(specl_expr).

  Evaluation of @rhombus(specl_expr) is delayed but cached;
  @rhombus(specl_expr) will not be evaluated unless and
  until a use of @rhombus(id_name) is evaluated, and from
  then on any additional evaluated uses of @rhombus(id_name)
  will produce the cached value.
}

@doc(
  ~nonterminal:
    name_option: fun ~defn

  global_defn.macro 'specl.fun $id_name($specl_bind, ...) $maybe_res_annot:
                       $option; ...
                       $specl_expr'

  global_defn.macro 'specl.fun $id_name
                     | $case
                     | ...'

  global_defn.macro 'specl.fun $id_name:
                       $common_option; ...
                     | $case
                     | ...'

  grammar case
  | ($specl_bind, ...) $maybe_res_annot:
      $case_option; ...
      $specl_expr

  grammar maybe_res_annot
  | #,(pille_specl_expr(::)) $specl_annot
  | ε

  grammar option
  | $common_option
  | $case_option

  grammar common_option
  | $name_option

  grammar case_option
  | $when_where_option
){}

@doc(
  ~nonterminal:
    maybe_res_annot: specl.fun ~defn

  global_defn.macro 'specl.operator $case'

  global_defn.macro 'specl.operator
                     | $case
                     | ...'

  grammar case
  | $pat_maybe_parens $maybe_res_annot:
      $option; ...
      $specl_expr

  grammar pat_maybe_parens
  | ($pat)
  | $pat

  grammar pat
  | $id_or_op_name $bind_term
  | $bind_term $id_or_op_name $bind_term
  | $bind_term $id_or_op_name

  grammar bind_term
  | $specl_bind

  grammar option
  | $precedence_option
  | $when_where_option
){}

@//=============================================================================
@section(~tag: "Specl_Expressions"){Expressions}

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
  specl_expr.macro '='
){
  Specially-recognized by some syntactic forms, but
  otherwise an error.
}

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
  specl_expr.macro 'match $specl_expr
                    | $specl_bind: $specl_expr
                    | $specl_bind: $specl_expr
                    | ...'
){}

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

@//=============================================================================
@section(~tag: "Specl_Bindings"){Bindings}

@doc(
  specl_bind.macro '_'
){}

@doc(
  specl_bind.macro '#%parens ($specl_bind)'
){}

@doc(
  specl_bind.macro '#%literal $specl_literal'
){}

@doc(
  specl_bind.macro 'equal_to($specl_expr)'
){}

@doc(
  specl_bind.macro '$lhs_specl_bind && $rhs_specl_bind'
  operator_order: ~order: logical_conjunction
){}

@doc(
  specl_bind.macro '$lhs_specl_bind || $rhs_specl_bind'
  operator_order: ~order: logical_disjunction
){}

@doc(
  specl_bind.macro '$lhs_specl_bind as $id'

  specl_bind.macro 'as'

  operator_order: ~order: logical_conjunction
){}

@doc(
  specl_bind.macro '$specl_bind :: $specl_annot'
  operator_order:
    ~weaker_than: ~other
    ~associativity: ~none
){}

@doc(
  specl_bind.macro '$specl_bind when $specl_expr'
){}

@doc(
  specl_bind.macro '$specl_bind where $where_bind'

  specl_bind.macro '$specl_bind where:
                      $where_bind
                      ...'

  grammar where_bind
  | $specl_bind #,(pille_specl_expr(=)) $specl_expr
  | $specl_bind: $specl_expr
){}

@section(~tag: "Specl_Annotations"){Annotations}

@doc(
  specl_annot.macro 'any'
  specl_annot.macro 'comparable'
  specl_annot.macro 'function'
  specl_annot.macro 'boolean'
  specl_annot.macro 'string'
  specl_annot.macro 'number'
  specl_annot.macro 'type'
){}

@doc(
  specl_annot.macro '#%parens ($specl_annot)'
){}

@doc(
  specl_annot.macro '$lhs_specl_annot && $rhs_specl_annot'
  operator_order: ~order: logical_conjunction
){}

@doc(
  specl_annot.macro '$lhs_specl_annot || $rhs_specl_annot'
  operator_order: ~order: logical_disjunction
){}

@doc(
  specl_annot.macro 'matching($specl_bind)'
){}

@section(~tag: "Specl_Numerics"){Numerics}

@doc(
  specl_annot.macro 'exact'
  specl_annot.macro 'rational'
  specl_annot.macro 'integral'

  specl_annot.macro 'inexact'
  specl_annot.macro 'flonum'

  specl_annot.macro 'real'
  specl_annot.macro 'neg_real'
  specl_annot.macro 'nonneg_real'
  specl_annot.macro 'pos_real'

  specl_annot.macro 'int'
  specl_annot.macro 'neg_int'
  specl_annot.macro 'nat'
  specl_annot.macro 'pos_int'
){}

@doc(
  specl.operator (lhs :: number) + (rhs :: number) :: number
  specl.operator (lhs :: number) - (rhs :: number) :: number
  operator_order: ~order: addition

  specl.operator - (rhs :: number) :: number
  operator_order: ~order: multiplication
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
  specl.fun min(x :: real, y :: real) :: real
  specl.fun max(x :: real, y :: real) :: real
){}

@section(~tag: "Specl_Bitwise"){Bit-Level Operations}

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

@section(~tag: "Specl_Escaping_to_Rhombus"){Escaping to Rhombus}

@doc(
  specl_annot.macro '#%rhombus ($rhombus_annot)'
){}

@doc(
  specl_expr.macro '#%rhombus $maybe_cross_args ($rhombus_expr)'

  specl_expr.macro '#%rhombus $maybe_cross_args:
                      $rhombus_body
                      ...'

  grammar maybe_cross_args
  | ($cross_arg, ...)
  | ε

  grammar cross_arg
  | $rhombus_bind #,(rhm_expr(=)) $specl_expr
  | $rhombus_bind: $specl_expr
  | $id
){}
