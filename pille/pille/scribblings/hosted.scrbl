#lang rhombus/scribble/manual

@(import:
    "common.rhm" open
    only_meta 0:
      meta_label:
        pille // FIXME: why need?
        pille/hosted open
        rhombus/and_meta as ~none:
          expose:
            =
            block
            expr)

@(nonterminal:
    expr: block
    id: block
    pille_body: pille.block body ~at pille/expr
    pille_const_bind: pille.const_bind const_bind ~space
    pille_const_expr: pille.const_expr const_expr ~space)

@title{Hosted Execution}

@docmodule(~open, pille/hosted)

@section{Embedding Pille within Rhombus}
@doc(
  expr.macro 'pille $maybe_args:
                $pille_body
                ...'

  grammar maybe_args
  | ($arg, ...)
  | ε

  grammar arg
  | ~const $const_arg
  | $dyn_arg

  grammar const_arg
  | $pille_const_bind #,(rhm_expr(=)) $expr
  | $id

  grammar dyn_arg
  | $id #,(pille_expr(::)) $pille_const_expr #,(rhm_expr(=)) $expr
  | $id #,(pille_expr(::)) $pille_const_expr
){}
