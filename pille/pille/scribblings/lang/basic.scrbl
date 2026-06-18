#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title{Basic Constructs}

@doc(
  expr.macro '#%parens ($expr)'
){}

@doc(
  expr.macro '#%literal $const_literal'
  expr.macro '#%literal #void'
){
  The form @pille_expr(#%literal const_literal) is
  equivalent to @pille_expr(const(const_literal)); this
  means that a literal like @pille_expr(5) has type
  @pille_const_expr(Const(5)), as opposed to some
  @pille_const_expr(Int) or @pille_const_expr(UInt) type.

  The form @pille_expr(#%literal #void) produces the
  @pille_const_expr(Void) value.
}

@doc(
  ~nonterminal_key: block ~at pille/expr

  expr.macro 'block:
                $body
                ...'

  grammar body
  | $local_defn
  | $expr
){}

@doc(
  local_defn.macro 'let $id $maybe_type $init'

  local_defn.macro 'var $id $maybe_type $init'

  grammar maybe_type
  | #,(pille_expr(::)) $const_expr
  | ε

  grammar init
  | #,(pille_expr(=)) $expr
  | : $body; ...
){}

@doc(
  ~nonterminal:
    type_expr: const_expr const_expr ~space

  expr.macro 'faux($type_expr)'
){
  @tech(~key: "concretization"){Concretizes} as having the
  type resulting from @rhombus(type_expr), but triggers an
  error if it is ever subject to @tech{lowering}.

  The @pille_expr(faux) form is most useful in combination
  with @pille_const_expr(type_of), where it can safely
  ``simulate'' a value of any type.
}

@doc(
  expr.macro '='
){}

@doc(
  expr.macro 'inout'
){}

@doc(
  expr.macro ':='
){}
