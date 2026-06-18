#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title{Defining New Types}

@doc(
  global_defn.macro 'struct $id_name $maybe_const_args $maybe_fields'
  global_defn.macro 'struct $id_name $maybe_const_args $maybe_fields:
                       $option; ...
                       $struct_body
                       ...'

  grammar option
  | ~name $id_or_op_name
  | ~name: $id_or_op_name

  grammar maybe_const_args
  | ($const_bind, ...)
  | ε

  grammar maybe_fields
  | {$id #,(pille_expr(::)) $const_expr, ...}
  | ε

  grammar struct_body
  | $struct_clause
  | $global_defn
  | $export
){}
