#lang rhombus/scribble/manual

@import(
  "common.rhm" open)

@title{Coercion and Unification}

@section{Coercion}
@doc(
  special_name.def coerce_to
){}

@doc(
  expr.macro '$expr :: $specl_expr'
){}

@doc(
  global_defn.macro 'coercion $receiver #,(pille_expr(::)) $specl_bind:
                       $option; ...
                       $body
                       ...'

  grammar option
  | $when_where_option
){}

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

@section{Unification}
@doc(
  specl.fun unify(α :: type, β :: type) :: type
){}

@doc(
  global_defn.macro 'unify($specl_bind, $specl_bind):
                       $option; ...
                       $specl_expr'

  grammar option
  | $when_where_option
){}
