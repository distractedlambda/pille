#lang rhombus/scribble/manual

@import(
  "common.rhm" open)

@title{Coercion and Unification}

@section{Coercion}
@doc(
  special_name.def coerce_to
){}

@doc(
  expr.macro '$expr :: $const_expr'
){}

@doc(
  global_defn.macro 'coercion $receiver #,(pille_expr(::)) $const_bind:
                       $option; ...
                       $body
                       ...'

  grammar option
  | $when_where_option
){}

@doc(
  const_bind.macro 'CoercesFrom($const_expr)'
){
  Matches types which are valid coercion targets of the
  source type given by @rhombus(const_expr).
}

@doc(
  const_bind.macro 'CoercesTo($const_expr)'
){
  Matches types which can coerce to the type given by
  @rhombus(const_expr).
}

@section{Unification}
@doc(
  const.fun unify(α :: type, β :: type) :: type
){}

@doc(
  global_defn.macro 'unify($const_bind, $const_bind):
                       $option; ...
                       $const_expr'

  grammar option
  | $when_where_option
){}
