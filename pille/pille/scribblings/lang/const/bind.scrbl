#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@(nonterminal:
    lhs_bind: const_bind const_bind ~space
    rhs_bind: const_bind const_bind ~space)

@title(~tag: "Const_Bindings"){Bindings}

@doc(
  ~nonterminal_key: const_bind ~space
  grammar const_bind
){
  A @deftech{constant binding}, which can match a
  @tech{constant} of some particular shape, possibly binding
  that constant or its constituent parts to identifiers in
  the process.

  These are similar to Rhombus's @rhm_ref_tech{bindings},
  except that an occurrence of an already-bound identifier
  is parsed as a nonlinear pattern.
}

@doc(
  const_bind.macro '_'
){}

@doc(
  const_bind.macro '#%parens ($const_bind)'
){}

@doc(
  const_bind.macro '#%literal $const_literal'
){}

@doc(
  const_bind.macro 'equal_to($const_expr)'
){}

@doc(
  const_bind.macro '$lhs_bind && $rhs_bind'
  operator_order: ~order: logical_conjunction
){}

@doc(
  const_bind.macro '$lhs_bind || $rhs_bind'
  operator_order: ~order: logical_disjunction
){}

@doc(
  const_bind.macro '$const_bind :: $const_annot'
  operator_order:
    ~weaker_than: ~other
    ~associativity: ~none
){}

@doc(
  const_bind.macro '$const_bind when $const_expr'
){}

@doc(
  const_bind.macro '$const_bind where $where_bind'

  const_bind.macro '$const_bind where:
                      $where_bind
                      ...'

  grammar where_bind
  | $const_bind #,(pille_const_expr(=)) $const_expr
  | $const_bind: $const_expr
){}
