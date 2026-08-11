#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title{Syntactic Categories}

In addition to the categories described in this section,
Pille inherits the @nontermref(decl) and
@nontermref(nestable_decl) categories from Rhombus, albeit
with a reduced set of bindings. In particular, the
@rhm_decl(export), @rhm_decl(meta), and @rhm_decl(module)
declaration forms are also available in Pille.

@doc(
  ~nonterminal_key: expr ~space
  grammar expr
){
  An @deftech{expression}, which represents some computation
  to be carried out at runtime by the target machine (though
  the particular computation may not be clear until the
  expression has been concretized).

  When an @nontermref(id_name) has no @rhm_space(expr)
  binding, but does have a @rhm_space(specl_expr) binding,
  and it is parsed as an expression, Pille treats it as
  though it had been wrapped with the @pille_expr(specl)
  form--that is, @rhm_space(specl_expr) identifier bindings
  are often usable directly as expressions.
}

@doc(
  ~nonterminal_key: global_defn ~space
  grammar global_defn
){
  A @deftech{global definition}, which is a definition-like
  form that may appear only in ``top-level'' positions
  (roughly, the same positions as those in which a
  @nontermref(nestable_decl) would be allowed).

  Unlike Rhombus definitions, Pille's global definitions
  never represent @italic{immediate} runtime computation for
  the target machine; correspondingly, they are also
  generally order-independent (to the extent compatible with
  the order of macro expansion).

  Global definitions are currently implemented as Rhombus
  @rhm_ref_tech{definitions}, and Pille inherits some forms
  from Rhombus (notably, @pille_global_defn(import) and
  @pille_global_defn(namespace)).
}

@doc(
  ~nonterminal_key: local_defn ~space
  grammar local_defn
){
  A @deftech{local definition}, which is a definition-like
  form that may appear intermixed with @tech{expressions} in
  a @nontermref(body).
}

@doc(
  ~nonterminal_key: expr ~space

  grammar body
  | «$body_prefix
     ...
     $expr»

  grammar body_prefix
  | $local_defn
  | $expr
){
  A sequence of one or more groups, where each prefix group
  is either a @nontermref(local_defn) or an
  @nontermref(expr), and where the final group must be an
  @nontermref(expr).

  With the exception of the final group, the decision for
  whether to parse a group as a @nontermref(local_defn) or
  an @nontermref(expr) is made based on the binding of the
  group's leading @nontermref(id_name), if any. That is, if
  there is a leading @nontermref(id_name) with a
  @rhm_space(local_defn) binding, then the whole group is
  parsed as a @nontermref(local_defn), otherwise the whole
  group is parsed as an @nontermref(expr).

  As a whole, a @nontermref(body) acts as an
  @nontermref(expr) whose result is the same as that of the
  final group, but where @rhombus(body_prefix)
  @nontermref(local_defn)s contribute bindings for the
  groups which follow them, and where @rhombus(body_prefix)
  @nontermref(expr)s are executed sequentially for their
  side-effects.
}

@doc(
  ~nonterminal_key: specl_expr ~space
  grammar specl_expr
){
  A @deftech{specialization expression}, which yields a
  @deftech{specialization value} when evaluated.
}

@doc(
  ~nonterminal_key: specl_bind ~space
  grammar specl_bind
){
  A @deftech{specialization binding}, which can match a
  @tech{specialization value} of some particular shape,
  possibly binding that value or its constituent parts in
  the process.

  When an @nontermref(id_name) has no @rhm_space(specl_bind)
  binding, but does have a @rhm_space(specl_expr) binding,
  and it is parsed as a specialization binding, Pille treats
  it as though it had been wrapped with the
  @pille_specl_bind(equal_to) form--that is, existing
  @rhm_space(specl_expr) identifier bindings create equality
  constraints when used in specialization bindings, rather
  than creating new bindings.

  When a truly-free @nontermref(id) (that is, free in both
  the @rhm_space(specl_bind) @italic{and}
  @rhm_space(specl_expr) spaces) is parsed as a
  specialization binding, it becomes a
  @deftech{specialization metavariable}. Unlike Rhombus's
  @rhm_ref_tech{bindings}, specialization bindings support
  nonlinear patterns: repeat occurrences of the same
  identifier are treated as multiple occurrences of a single
  metavariable, and therefore are constrained to bind equal
  values.
}

@doc(
  ~nonterminal_key: specl_annot ~space
  grammar specl_annot
){
  A @deftech{specialization annotation}, which describes a
  (possibly-empty) set of @tech{specialization
  values}. These are analagous to Rhombus's
  @rhm_guide_tech{predicate annotations}, though there is no
  equivalent notion of static information.

  Unlike Rhombus annotations, identifier bindings for
  specialization annotations usually use @tt{snake_case}
  names.
}
