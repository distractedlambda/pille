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
    pille_body: pille.expr body ~space
    pille_specl_bind: pille.specl_bind specl_bind ~space
    pille_specl_expr: pille.specl_expr specl_expr ~space)

@title{Hosted Execution}

@docmodule(~open, pille/hosted)

@section{Embedding Pille within Rhombus}
@doc(
  expr.macro 'pille $maybe_args:
                $pille_body'

  grammar maybe_args
  | ($arg, ...)
  | ε

  grammar arg
  | ~specl $specl_arg
  | $dyn_arg

  grammar specl_arg
  | $pille_specl_bind #,(rhm_expr(=)) $expr
  | $id

  grammar dyn_arg
  | $id #,(pille_expr(::)) $pille_specl_expr #,(rhm_expr(=)) $expr
  | $id #,(pille_expr(::)) $pille_specl_expr
){}
