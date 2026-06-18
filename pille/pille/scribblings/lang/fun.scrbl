#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title{Defining Functions and Operators}

@doc(
  ~nonterminal:
    arg: method ~defn

  global_defn.macro 'fun $id_name($arg, ...) $maybe_res_type:
                       $option; ...
                       $body
                       ...'

  global_defn.macro 'fun $id_name
                     | $case
                     | ...'

  global_defn.macro 'fun $id_name:
                       $common_option; ...
                     | $case
                     | ...'

  grammar case
  | ($arg, ...) $maybe_res_type:
      $case_option; ...
      $body
      ...

  grammar option
  | $common_option
  | $case_option

  grammar common_option
  | $name_option

  grammar name_option
  | ~name $id_or_op_name
  | ~name: $id_or_op_name

  grammar case_option
  | $when_where_option
){}

@doc(
  ~nonterminal:
    arg: method ~defn
    assoc: rhm.operator ~defn
    other: rhm.operator ~defn

  global_defn.macro 'operator $case'

  global_defn.macro 'operator
                     | $case
                     | ...'

  grammar case
  | $pat_maybe_parens $maybe_res_type:
      $option; ...
      $body
      ...

  grammar pat_maybe_parens
  | ($pat)
  | $pat

  grammar pat
  | $id_or_op_name $arg_term
  | $arg_term $id_or_op_name $arg_term
  | $arg_term $id_or_op_name

  grammar arg_term
  | $id
  | ($arg)

  grammar option
  | $precedence_option
  | $when_where_option

  grammar precedence_option
  | ~order $name
  | ~order: $name
  | ~stronger_than $other ...
  | ~stronger_than: $other ...; ...
  | ~weaker_than $other ...
  | ~weaker_than: $other ...; ...
  | ~same_as $other ...
  | ~same_as: $other ...; ...
  | ~same_on_left_as $other ...
  | ~same_on_left_as: $other ...; ...
  | ~same_on_right_as $other ...
  | ~same_on_right_as: $other ...; ...
  | ~associativity $assoc
  | ~associativity: $assoc
){}
