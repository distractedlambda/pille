#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title{Coercions}

@//=============================================================================
@doc(
  ~nonterminal:
    dst_specl_bind: specl_bind specl_bind ~space

  unique_member coerce_to

  global_defn.macro 'coercion $receiver #,(pille_expr(::)) $dst_specl_bind:
                       $method_option; ...
                       $body'
){
  Defines a @deftech{coercion} rule, which enables implicit
  conversions from a matching @rhombus(receiver) to a type
  matching the @rhombus(dst_specl_bind).

  A coercion rule is equivalent to an overload of the
  @pille_expr($coerce_to) method, and the
  @pille_global_defn(coercion) form is merely sugar for the
  corresponding @pille_global_defn(method) definition.

  Coercion rules are always resolved with an empty implicit
  environment, so they cannot take @tech{implicit
  arguments}.
}

@doc(
  specl_bind.macro 'CoercesFrom($specl_expr)'
){
  Matches types which are valid coercion targets of the
  source type given by @rhombus(specl_expr).
}

@doc(
  specl_bind.macro 'CoercesTo($specl_expr)'
){
  Matches types which can coerce to the type given by
  @rhombus(specl_expr).
}

@doc(
  specl.operator (σ :: type) coerces_to (δ :: type) :: boolean
  operator_order:
    ~order: equivalence
    ~associativity: ~none
){}

@doc(
  expr.macro '$expr :: $specl_expr'
){}

@//=============================================================================
@section{Deducing Common Types}

@doc(
  ~nonterminal:
    priority_option: method ~defn

  unique_member unify_with

  global_defn.macro 'unify($specl_bind, $specl_bind):
                       $option; ...
                       $unified_type'

  grammar option
  | $when_where_option
  | $priority_option

  grammar unified_type
  | $specl_expr
){
  Defines a rule for @deftech{type unification}, which is
  the concretization-time process that picks ``common
  types'', such as when determining the type of an
  @pille_expr(if) expression with differing branch
  types. The @rhombus(specl_bind)s bind two input types to
  be unified, and the @rhombus(unified_type) should evaluate
  to a type that both input types can coerce to.

  A unification rule is equivalent to an overload of the
  @pille_specl_expr($unify_with)
  @tech{specialization-language method}, and the
  @pille_global_defn(unify) form is merely sugar for the
  corresponding @pille_global_defn(specl.method) definition.

  When searching for an applicable unification rule,
  concretization attempts both orderings of input types, so
  it is not necessary to explicitly define ``mirror''
  versions of asymmetric rules. If both orderings resolve to
  viable overloads, however, then they must yield the same
  resulting type.

  Unification rules are always resolved (and evaluated) with
  an empty implicit environment.
}

@doc(
  specl.fun unify(α :: type, β :: type) :: type
){
  Invokes the @tech{type unification} machinery on
  @rhombus(α) and @rhombus(β), returning the unified type.
}
