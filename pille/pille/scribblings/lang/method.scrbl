#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title{Properties and Methods}

@section{Defining Methods}
@doc(
  global_defn.macro 'method $receiver $dot_member_name ($arg, ...) $maybe_res_type:
                       $option; ...
                       $body
                       ...'

  grammar dot_member_name
  | #,(pille_expr(.)) $member_name
  | #,(pille_expr(.$)) $special_name_id

  grammar member_name
  | $id
  | #,(pille_expr($)) $special_name_id

  grammar receiver
  | ($arg)

  grammar arg
  | $maybe_inout $id
  | $maybe_inout $id #,(pille_expr(::)) $const_bind
  | #,(pille_expr(const)) $const_bind

  grammar maybe_inout
  | #,(pille_expr(inout))
  | ε

  grammar maybe_res_type
  | #,(pille_expr(::)) $const_expr
  | ε

  grammar option
  | $when_where_option

  grammar when_where_option
  | ~when $const_expr
  | ~when:
      $const_expr
      ...
  | ~where $where_bind
  | ~where:
      $where_bind
      ...

  grammar where_bind
  | $const_bind #,(pille_const_expr(=)) $const_expr
  | $const_bind: $const_expr
){}

@section{Defining Properties}
@doc(
  ~nonterminal:
    arg: method ~defn
    receiver: method ~defn

  global_defn.macro 'property $receiver $dot_member_name $maybe_res_type:
                       $option; ...
                       $body
                       ...'

  global_defn.macro 'property $receiver $dot_member_name #,(pille_expr(:=)) ($arg) $maybe_res_type:
                       $option; ...
                       $body
                       ...'

  grammar option
  | $when_where_option
){}

@section{Accessing Members}
@doc(
  expr.macro '$lhs_expr . $member_name ($arg_expr, ...)'
  expr.macro '$lhs_expr . $member_name'
  operator_order: ~order: member_access
){}

@section{Special Names}
@doc(
  global_defn.macro 'special_name.def $special_name_id'

  grammar special_name_id
  | $id
){}

@doc(
  expr.macro '$'
){}

@doc(
  expr.macro '$lhs_expr .$ $special_name_id ($arg_expr, ...)'
  expr.macro '$lhs_expr .$ $special_name_id'
  operator_order: ~order: member_access
){}
