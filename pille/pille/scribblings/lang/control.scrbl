#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@(nonterminal:
    test_expr: expr expr ~space)

@title{Conditionals & Control}

@section{Conditional Forms}

@doc(
  ~nonterminal:
    then_body: block body ~at pille/expr
    else_body: block body ~at pille/expr

  expr.macro 'if $test_expr
              | $then_body
                ...
              | $else_body
                ...'
){
  Evaluates @rhombus(test_expr), then based on its result evalutes either the
  @rhombus(then_body) or @rhombus(else_body) sequences.

  The exact @tech{concretization} behavior of @pille_expr(if) depends on whether
  the type of the @rhombus(test_expr) is:
  @itemlist(
    @item{exactly @pille_const_expr(Const(#true)): then the @rhombus(then_body)
          sequence is always executed (there is no actual branch), the
          @rhombus(else_body) sequence is never concretized, and the type of the
          whole @pille_expr(if) form is the type of the @rhombus(then_body)
          sequence.},
    @item{exactly @pille_const_expr(Const(#false)): then the @rhombus(else_body)
          sequence is always executed (there is no actual branch), the
          @rhombus(then_body) sequence is never concretized, and the type of the
          whole @pille_expr(if) form is the type of the @rhombus(else_body)
          sequence.},
    @item{any type @coercion_tech{coercible} to @pille_const_expr(Boolean): then
          both body sequences are concretized, the one to execute is selected by
          the value of @pille_expr(test_expr :: Boolean) (the
          @rhombus(then_body) sequence if @rhombus(#true), the
          @rhombus(else_body) sequence if @rhombus(#false)), and the type of the
          whole @pille_expr(if) form is the @tech{unification} of the types of
          the two body sequences.},
    @item{any other type: then concretization fails.})

  In other words, when the @rhombus(test_expr) is @pille_const_expr(Const), the
  @pille_expr(if) form behaves like a conditional compilation construct; the
  branch-not-taken does not even need to be valid code (though it does still
  need to @parsing_tech{parse}).}

@doc(
  expr.macro 'when $test_expr
              | $body
                ...'
){
  Equivalent to:
  @rhombusblock(
    #,(pille_expr(if)) test_expr
    | body
      ...
    | #void)
}

@doc(
  expr.macro 'unless $test_expr
              | $body
                ...'
){
  Equivalent to:
  @rhombusblock(
    #,(pille_expr(if)) test_expr
    | #void
    | body
      ...)
}

@doc(
  expr.macro 'cond
              | $test_expr:
                  $body
                  ...
              | $test_expr:
                  $body
                  ...
              | ...'

  expr.macro 'cond
              | $test_expr:
                  $body
                  ...
              | ...
              | ~else:
                  $body
                  ...'
){
  Equivalent to a chain of @pille_expr(if) forms, including the special
  @tech{concretization} behavior for @pille_const_expr(Const) conditions.

  If no @rhombus(~else) arm is provided, then the @pille_expr(cond) form is only
  valid if it can be shown to be exhaustive during concretization (that is, one
  of the @rhombus(test_expr)s must have type @pille_const_expr(Const(#true))).
}

@doc(
  expr.macro '$lhs_expr && $rhs_expr'
  operator_order: ~order: logical_conjunction
){
  Equivalent to:
  @rhombusblock(
    #,(pille_expr(block)):
      #,(pille_local_defn(let)) lhs = lhs_expr
      #,(pille_expr(if)) lhs | rhs_expr | lhs)
}

@doc(
  expr.macro '$lhs_expr || $rhs_expr'
  operator_order: ~order: logical_disjunction
){
  Equivalent to:
  @rhombusblock(
    #,(pille_expr(block)):
      #,(pille_local_defn(let)) lhs = lhs_expr
      #,(pille_expr(if)) lhs | lhs | rhs_expr)
}

@section{Labels and Jumps}
@doc(
  ~nonterminal_key: #' ~at pille/expr

  expr.macro '#'$label_id $labeled_expr'

  grammar label_id
  | $id

  grammar labeled_expr
  | : $body; ...
  | ($label_arg, ...): $body; ...
  | #,(pille_labeled_expr(while)) $test_expr: $body; ...
  | #,(pille_labeled_expr(until)) $test_expr: $body; ...
  | $other_labeled_expr
){
  An occurence of @pille_expr(#'#,(nontermref(id))) in expression position is
  termed a @deftech{label}, and the remainder of the containing @group_tech is
  parsed as a @rhombus(labeled_expr). The exact semantics then depend on the
  particular @rhombus(labeled_expr), but in general the @rhombus(label_id) is
  bound within all or part of the @rhombus(labeled_expr), and wherever it is
  bound it may be used with the @pille_expr(break) or @pille_expr(continue)
  forms.
}

@doc(
  expr.macro 'break $label_id $maybe_result'

  grammar maybe_result
  | ($expr)
  | : $body; ...
  | ε
){
  The exact semantics of this form depend on the @nontermref(labeled_expr) with
  which the @rhombus(label_id) is associated, but in general, it immediately
  escapes from that @nontermref(labeled_expr) with the result value determined
  by its @rhombus(maybe_result).

  An absent @rhombus(maybe_result) is equivalent to @pille_expr((#void)).

  The @pille_expr(break) expression itself always has type
  @pille_const_expr(Never), regardless of the type of the
  @nontermref(labeled_expr) associated with the @rhombus(label_id).
}

@doc(
  expr.macro 'continue $label_id $maybe_args'

  grammar maybe_args
  | ($expr, ...)
  | ε
){
  The exact semantics of this form depend on the @nontermref(labeled_expr) with
  which the @rhombus(label_id) is associated, but in general, it ``restarts'' or
  ``continues'' the @nontermref(labeled_expr)'s execution, supplying zero or
  more arguments to continue with.

  An absent @rhombus(maybe_args) is equivalent to @pille_expr(()).

  The @pille_expr(continue) expression itself always has type
  @pille_const_expr(Never), regardless of the type of the
  @nontermref(labeled_expr) associated with the @rhombus(label_id).
}

@doc(
  labeled_expr.macro '#%block:
                        $body
                        ...'
){
  The associated @nontermref(label_id) is bound within the entirety of the
  @rhombus(body) seqeuence, the @pille_expr(break) form immediately escapes from
  this expression with the supplied result, and the @pille_expr(continue) form
  resets control back to the beginning of the @rhombus(body) sequence (as though
  this expression were just entered). No @pille_expr(continue) arguments are
  accepted.

  The overall type of the @pille_labeled_expr(#%block) expression is the
  @tech{unification} of the type of the @rhombus(body) sequence and the types of
  all @pille_expr(break) results (if any); @tech{coercions} are inserted as
  necessary.
}

@doc(
  ~nonterminal_key:
    #%parens ~at pille/labeled_expr
  ~nonterminal:
    arg_id: rhm.block id
    init_expr: expr expr ~space

  labeled_expr.macro '#%parens ($label_arg, ...):
                        $body
                        ...'

  grammar label_arg
  | $arg_id #,(pille_expr(=)) $init_expr
  | $arg_id
){
  Like @pille_labeled_expr(#%block), but with ``arguments'' that can be
  re-supplied with each execution of a @pille_expr(continue) form.

  Each @rhombus(label_arg)'s @rhombus(arg_id) is bound within the @rhombus(body)
  sequence as if by @pille_local_defn(let), and initially to the result of each
  respective @rhombus(init_expr) (where ommitting the @rhombus(init_expr) is
  shorthand for using the value of the @rhombus(arg_id) in the enclosing
  scope). Any corresponding @pille_expr(continue) form must supply a matching
  number of arguments, which then become the values bound to the
  @rhombus(arg_id)s for the new execution of the @rhombus(body) sequence.

  The type of each @rhombus(arg_id) is fixed as the type of its
  @rhombus(init_expr), and each corresponding argument value from a
  @pille_expr(continue) form must in turn be @coercion_tech{coercible} to that
  type. There is no process that unifies the types of the @rhombus(init_expr)s
  with the types of possible @pille_expr(continue) arguments, as this would
  devolve into a fixed-point computation in the general case.
}

@section{Looping Forms}
@doc(
  expr.macro 'while $test_expr:
                $body
                ...'

  labeled_expr.macro 'while $test_expr:
                        $body
                        ...'
){
  A standard imperative ``while loop''; the @rhombus(body) sequence is
  repeatedly executed for as long as the @rhombus(test_expr) continues to
  evaluate to a true value.

  When used as a @nontermref(labeled_expr), the @nontermref(label_id) can be
  used with @pille_expr(break) to immediately exit the @pille_expr(while)
  expression, or with @pille_expr(continue) (without arguments) to short-circuit
  to the @rhombus(test_expr) step of the next loop iteration.

  This is implemented as a derived form, where:
  @rhombusblock(
    #,(pille_expr(#'))#,(nontermref(label_id)) #,(pille_expr(while)) test_expr:
      body
      ...)
  is equivalent to:
  @rhombusblock(
    #,(pille_expr(#'))#,(nontermref(label_id)):
      #,(pille_expr(if)) test_expr
      | #,(pille_expr(block)): body; ...
        #,(pille_expr(continue)) #,(nontermref(label_id))
      | #,(pille_expr(break)) #,(nontermref(label_id)))
  This implementation explains some of the subtler behaviors, such as the
  handling of a @pille_const_expr(Const)-typed @rhombus(test_expr).
}

@doc(
  expr.macro 'until $test_expr:
                $body
                ...'

  labeled_expr.macro 'until $test_expr:
                        $body
                        ...'
){
  Like @pille_expr(while) with a negated @rhombus(test_expr).
}
