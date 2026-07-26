#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@(nonterminal:
    lhs_bind: specl_bind specl_bind ~space
    rhs_bind: specl_bind specl_bind ~space)

@title(~tag: "Specl_Bindings"){Bindings}

@doc(
  ~nonterminal_key: specl_bind ~space
  grammar specl_bind
){
  A @deftech{specialization binding}, which can match a
  @tech{specialization value} of some particular shape, possibly binding
  that value or its constituent parts to identifiers in
  the process.

  These are similar to Rhombus's @rhm_ref_tech{bindings},
  except that an occurrence of an already-bound identifier
  is parsed as a nonlinear pattern.
}

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
  specl_bind.macro '$lhs_bind && $rhs_bind'
  operator_order: ~order: logical_conjunction
){}

@doc(
  specl_bind.macro '$lhs_bind || $rhs_bind'
  operator_order: ~order: logical_disjunction
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
