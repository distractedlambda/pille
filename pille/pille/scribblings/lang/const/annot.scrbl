#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title(~tag: "Const_Annotations"){Annotations}

@doc(
  ~nonterminal_key: const_annot ~space
  grammar const_annot
){
  A @deftech{constant annotation}, which describes a
  (possibly-empty) set of @tech{constants}. These are
  analagous to Rhombus's @rhm_guide_tech{predicate
  annotations}, though there is no equivalent notion of
  static information.

  Constant annotations usually use @tt{snake_case} names,
  except that those which are ``type-like'' may use
  @tt{PascalCase} names; the intent is to keep
  @pille_const_annot(int) distinct from
  @pille_const_expr(Int), etc., even in cases where there
  would not necessarily be any name collisions.
}

@doc(
  const_annot.macro 'type'
){}

@doc(
  const_annot.macro 'any'
  const_annot.macro 'comparable'

  const_annot.macro 'function'
  const_annot.macro 'boolean'
  const_annot.macro 'string'

  const_annot.macro 'number'
  const_annot.macro 'rational'
  const_annot.macro 'integral'

  const_annot.macro 'real'
  const_annot.macro 'neg_real'
  const_annot.macro 'nonneg_real'
  const_annot.macro 'pos_real'

  const_annot.macro 'int'
  const_annot.macro 'neg_int'
  const_annot.macro 'nat'
  const_annot.macro 'pos_int'
){}

@doc(
  const_annot.macro '#%parens ($const_annot)'
){}

@doc(
  ~nonterminal:
    lhs_annot: const_annot const_annot ~space
    rhs_annot: const_annot const_annot ~space

  const_annot.macro '$lhs_annot && $rhs_annot'
  operator_order: ~order: logical_conjunction
){}

@doc(
  ~nonterminal:
    lhs_annot: const_annot const_annot ~space
    rhs_annot: const_annot const_annot ~space

  const_annot.macro '$lhs_annot || $rhs_annot'
  operator_order: ~order: logical_disjunction
){}

@doc(
  const_annot.macro 'matching($const_bind)'
){}
