#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title{Implicit Arguments}

@doc(
  global_defn.macro 'implicit $id_name $maybe_indices $maybe_type'

  global_defn.macro 'implicit $id_name $maybe_indices $maybe_type:
                       $option; ...'

  grammar maybe_indices
  | ($specl_bind, ...)
  | ε

  grammar maybe_type
  | #,(pille_expr(::)) $specl_bind
  | ε

  grammar option
  | ~name $id_or_op_name
  | ~name: $id_or_op_name
){}

@doc(
  local_defn.macro 'using $implicit_key $maybe_type #,(pille_expr(=)) $expr'

  local_defn.macro 'using $implicit_key $maybe_type:
                      $body'

  grammar implicit_key
  | $implicit_id_name ($specl_expr, ...)
  | $implicit_id_name

  grammar maybe_type
  | #,(pille_expr(::)) $specl_expr
  | ε
){}
