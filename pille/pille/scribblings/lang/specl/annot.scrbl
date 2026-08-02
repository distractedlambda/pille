#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title(~tag: "Specl_Annotations"){Annotations}

@doc(
  ~nonterminal_key: specl_annot ~space
  grammar specl_annot
){
  A @deftech{specialization annotation}, which describes a
  (possibly-empty) set of @tech{specialization values}. These are
  analagous to Rhombus's @rhm_guide_tech{predicate
  annotations}, though there is no equivalent notion of
  static information.

  Constant annotations usually use @tt{snake_case} names,
  except that those which are ``type-like'' may use
  @tt{PascalCase} names; the intent is to keep
  @pille_specl_annot(int) distinct from
  @pille_specl_expr(Int), etc., even in cases where there
  would not necessarily be any name collisions.
}

@doc(
  specl_annot.macro 'type'
){}

@doc(
  specl_annot.macro 'any'
  specl_annot.macro 'comparable'

  specl_annot.macro 'function'
  specl_annot.macro 'boolean'
  specl_annot.macro 'string'

  specl_annot.macro 'number'

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
  specl_annot.macro '#%parens ($specl_annot)'
){}

@doc(
  ~nonterminal:
    lhs_annot: specl_annot specl_annot ~space
    rhs_annot: specl_annot specl_annot ~space

  specl_annot.macro '$lhs_annot && $rhs_annot'
  operator_order: ~order: logical_conjunction
){}

@doc(
  ~nonterminal:
    lhs_annot: specl_annot specl_annot ~space
    rhs_annot: specl_annot specl_annot ~space

  specl_annot.macro '$lhs_annot || $rhs_annot'
  operator_order: ~order: logical_disjunction
){}

@doc(
  specl_annot.macro 'matching($specl_bind)'
){}
