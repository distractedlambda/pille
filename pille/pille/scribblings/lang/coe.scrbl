#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title{Casts and Coercions}

@//=============================================================================
@section{Coercions}

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
@section{Casts}

@doc(
  struct CastExact(α :: type):
    src :: α

  method (src :: α).cast_exact() :: CastExact(α)
){}

@doc(
  struct CastWrap(α :: type):
    src :: α

  method (src :: α).cast_wrap() :: CastWrap(α)
){}

@//=============================================================================
@section{Deducing Common Types}

@doc(
  ~nonterminal:
    priority_option: method ~defn

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

  When searching for an applicable unification rule,
  concretization attempts both orderings of input types, so
  it is not necessary to explicitly define ``mirror''
  versions of asymmetric rules. Moreover, concretization
  only signals an ambiguity if multiple rules apply (without
  distinguishing priority) @italic{and} yield different
  resulting types; in other words, it is allowed to have
  overlapping rules as long as they come to the same
  conclusion.
}

@doc(
  specl.fun unify(α :: type, β :: type) :: type
){
  Invokes the @tech{type unification} machinery on
  @rhombus(α) and @rhombus(β), returning the unified type.
}
