#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title{Defining Constants}

@doc(
  global_defn.macro 'const.def $id_name $maybe_annot = $const_expr'

  global_defn.macro 'const.def $id_name $maybe_annot:
                       $const_expr'

  grammar maybe_annot
  | #,(pille_const_expr(::)) $const_annot
  | ε
){
  Defines @rhombus(id_name) as a constant which stands in
  place of @rhombus(const_expr).

  Evaluation of @rhombus(const_expr) is delayed but cached;
  @rhombus(const_expr) will not be evaluated unless and
  until a use of @rhombus(id_name) is evaluated, and from
  then on any additional evaluated uses of @rhombus(id_name)
  will produce the cached value.
}

@doc(
  ~nonterminal:
    name_option: fun ~defn

  global_defn.macro 'const.fun $id_name($const_bind, ...) $maybe_res_annot:
                       $option; ...
                       $const_expr'

  global_defn.macro 'const.fun $id_name
                     | $case
                     | ...'

  global_defn.macro 'const.fun $id_name:
                       $common_option; ...
                     | $case
                     | ...'

  grammar case
  | ($const_bind, ...) $maybe_res_annot:
      $case_option; ...
      $const_expr

  grammar maybe_res_annot
  | #,(pille_const_expr(::)) $const_annot
  | ε

  grammar option
  | $common_option
  | $case_option

  grammar common_option
  | $name_option

  grammar case_option
  | $when_where_option
){}

@doc(
  ~nonterminal:
    maybe_res_annot: const.fun ~defn
    precedence_option: operator ~defn

  global_defn.macro 'const.operator $case'

  global_defn.macro 'const.operator
                     | $case
                     | ...'

  grammar case
  | $pat_maybe_parens $maybe_res_annot:
      $option; ...
      $const_expr

  grammar pat_maybe_parens
  | ($pat)
  | $pat

  grammar pat
  | $id_or_op_name $bind_term
  | $bind_term $id_or_op_name $bind_term
  | $bind_term $id_or_op_name

  grammar bind_term
  | $const_bind

  grammar option
  | $precedence_option
  | $when_where_option
){}
