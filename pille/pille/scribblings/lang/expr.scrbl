#lang rhombus/scribble/manual

@(import:
    "common.rhm" open
    rhombus/meta open
    meta_label:
      pille/hosted open:
        only_space expr)

@title{Expressions and Control}

@//=============================================================================
@section{Basic Constructs}

@doc(
  expr.macro '#%parens ($expr)'
){}

@doc(
  expr.macro '#%literal $specl_literal'
  expr.macro '#%literal #void'
){
  The form @pille_expr(#%literal specl_literal) is
  equivalent to @pille_expr(specl(specl_literal)); this
  means that a literal like @pille_expr(5) has type
  @pille_specl_expr(Specl(5)), as opposed to some
  @pille_specl_expr(Int) or @pille_specl_expr(UInt) type.

  The form @pille_expr(#%literal #void) produces the
  @pille_specl_expr(Void) value.
}

@doc(
  expr.macro 'block:
                $body'
){}

@doc(
  local_defn.macro 'let $id $maybe_type #,(pille_expr(=)) $expr'

  local_defn.macro 'let $id $maybe_type:
                      $body'

  grammar maybe_type
  | #,(pille_expr(::)) $specl_expr
  | ε
){}

@doc(
  operator lhs === rhs
  operator lhs !== rhs
  operator_order: ~order: equivalence
){
  The ``representational-equivalence'' operators;
  @rhombus(lhs) and @rhombus(rhs) are
  @coercion_tech{coerced} to a @unification_tech{unified
  type}, then compared for bitwise (in)equality of their
  runtime representations. This bitwise comparison
  @italic{does not} consider ``padding bits'' that might be
  part of a type's in-memory footprint.

  The result type of an @pille_expr(===) expression may be
  either @pille_specl_expr(Boolean) or
  @pille_specl_expr(Specl(#true)); the latter occurs when
  the unified type is known to have at most one distinct
  inhabitant (as with @pille_specl_expr(Void)), and so the
  comparison is known to always succeed. The result of an
  @pille_expr(!==) expression may be either
  @pille_specl_expr(Boolean) or
  @pille_specl_expr(Specl(#false)), as it is the negation of
  an @pille_expr(===) expression.
}

@doc(
  operator ! (specl rhs :: boolean) :: Specl(!rhs)
  operator ! (rhs :: CoercesTo(Boolean)) :: Boolean
  operator_order: ~order: logical_negation
){}

@doc(
  expr.macro '='
){
  Specially recognized by forms like @pille_local_defn(let),
  but otherwise an error.
}

@//=============================================================================
@section{Generic Operators}

@doc(
  unique_member call

  expr.macro '$callee_expr #%call ($arg_expr, ...)'

  operator_order:
    ~stronger_than: ~other
    ~associativity: ~left
){
  Function calls are shorthand for invocations of @pille_expr($call)
  methods, so
  @rhombusblock(#,(pille_expr(callee_expr(arg_expr, ...))))
  is shorthand for
  @rhombusblock(#,(pille_expr(callee_expr.$call(arg_expr, ...))))
}

@doc(
  unique_member new

  expr.macro '$callee_expr #%comp {$arg_expr, ...}'

  operator_order:
    ~stronger_than: ~other
    ~associativity: ~left
){
  The syntax
  @rhombusblock(#,(pille_expr(callee_expr{arg_expr, ...})))
  is shorthand for
  @rhombusblock(#,(pille_expr(callee_expr.$new(arg_expr, ...))))

  Aside from delegating to @pille_expr($new) methods instead of
  @pille_expr($call) methods, the @pille_expr(#%comp) form behaves essentially
  the same as the @pille_expr(#%call) form. The real difference is one of
  convention; while @pille_expr($call) methods are usually defined on
  ``function-like'' receivers to represent function calls, @pille_expr($new)
  methods are usually defined on ``type-like'' receivers (in particular,
  receiver types of the shape @pille_specl_bind(Specl(_ :: type))) to represent
  construction of new instances.
}

@doc(
  unique_member index_read
  unique_member index_write

  expr.macro '$callee_expr #%index [$arg_expr, ...]'

  operator_order:
    ~stronger_than: ~other
    ~associativity: ~left
){}

@doc(
  unique_member contains

  operator lhs in rhs:
    ~order: equivalence
    ~transparent

  operator lhs ∈ rhs:
    ~order: equivalence
    ~transparent
){
  The membership-test operator, delegating directly to
  @pille_expr(rhs.$contains(lhs)). The two forms are
  equivalent.
}

@doc(
  operator lhs ∉ rhs:
    ~order: equivalence
    ~transparent
    ¬(lhs ∈ rhs)
){
  A negated form of @pille_expr(∈)/@pille_expr(in), for
  convenience.
}

@doc(
  unique_member add
  operator (lhs :: α) + (rhs :: β):
    ~transparent
    ~order: addition
){
  The generic addition operator. A use of the @pille_expr(+)
  operator delegates to the @pille_expr($add) method via the
  following process:
  @itemlist(
    @item{If @pille_expr(lhs.$add(rhs)) is valid, then the
    use of the @pille_expr(+) operator is equivalent to that
    call.},
    @item{Otherwise, the use of the @pille_expr(+) operator
    is equivalent to:
    @rhombusblock(#,(@pille_expr((lhs :: unify(α, β)).$add(rhs :: unify(α, β)))))})
  In other words, homogeneous @pille_expr($add) overloads on
  do not need to implement their own coercion logic.
}

@doc(
  unique_member add_wrap
  operator lhs +% rhs:
    ~transparent
    ~order: addition
){
  Like @pille_expr(+), but for modular or
  ``wrapping'' addition.
}

@doc(
  unique_member sub
  operator lhs - rhs:
    ~transparent
    ~order: addition

  unique_member neg
  operator -rhs:
    ~transparent
    ~order: multiplication
){
  The generic subtraction/negation operator. In its infix
  form, it delegates to the @pille_expr($sub) method in the
  same way as the @pille_expr(+) operator delegates to the
  @pille_expr($add) method. In its prefix form, it delegates
  directly to the @pille_expr($neg) method.
}

@doc(
  unique_member sub_wrap
  operator lhs -% rhs:
    ~transparent
    ~order: addition

  unique_member neg_wrap
  operator -%rhs:
    ~transparent
    ~order: multiplication
){
  Like @pille_expr(-), but for modular or ``wrapping''
  subtraction/negation.
}

@doc(
  unique_member mul
  operator lhs * rhs:
    ~transparent
    ~order: multiplication
){
  Like @pille_expr(+), but for multiplication.
}

@doc(
  unique_member mul_wrap
  operator lhs *% rhs:
    ~transparent
    ~order: multiplication
){
  Like @pille_expr(*), but for modular or ``wrapping''
  multiplication.
}

@doc(
  unique_member div
  operator lhs / rhs:
    ~transparent
    ~order: multiplication
){
  Like @pille_expr(+), but for division.
}

@doc(
  unique_member div_trunc
  operator lhs div_trunc rhs:
    ~transparent
    ~order: multiplication
){
  Like @pille_expr(/), but rounded towards @rhombus(0).
}

@doc(
  unique_member div_floor
  operator lhs div_floor rhs:
    ~transparent
    ~order: multiplication
){
  Like @pille_expr(/), but rounded towards @rhombus(#neginf).
}

@doc(
  unique_member div_ceil
  operator lhs div_ceil rhs:
    ~transparent
    ~order: multiplication
){
  Like @pille_expr(/), but rounded towards @rhombus(#inf).
}

@doc(
  unique_member rem
  operator lhs % rhs:
    ~transparent
    ~order: multiplication
){
  Like @pille_expr(+), but for the ``modulo'' or
  ``remainder'' operation.

  Programming languages have historically been
  @hyperlink("https://en.wikipedia.org/wiki/Modulo#In_programming_languages"){inconsistent}
  in defining this operation, especially for negative
  operands. The @pille_expr(%) operator is therefore
  reserved for operand types where there is only one obvious
  interpretation, whereas the @pille_expr(rem_trunc),
  @pille_expr(rem_floor), and @pille_expr(rem_ceil)
  operators have unambiguous meanings in all cases.
}

@doc(
  unique_member rem_trunc
  operator lhs rem_trunc rhs:
    ~transparent
    ~order: multiplication
){
  Like @pille_expr(%), but specifically the remainder of
  truncating division (as in @pille_expr(div_trunc)).
}

@doc(
  unique_member rem_floor
  operator lhs rem_floor rhs:
    ~transparent
    ~order: multiplication
){
  Like @pille_expr(%), but specifically the remainder of
  floored division (as in @pille_expr(div_floor)).
}

@doc(
  unique_member rem_ceil
  operator lhs rem_ceil rhs:
    ~transparent
    ~order: multiplication
){
  Like @pille_expr(%), but specifically the remainder of
  ceiling division (as in @pille_expr(div_ceil)).
}

@doc(
  unique_member pow
  operator lhs ** rhs:
    ~transparent
    ~order: exponentiation
){
  Like @pille_expr(+), but for the exponentiation or ``power''
  operation.
}

@doc(
  unique_member not

  operator not rhs:
    ~transparent
    ~order: bitwise_negation

  operator ¬ rhs:
    ~transparent
    ~order: bitwise_negation
){
  The logical negation operator (the two forms are
  equivalent), which delegates directly to the
  @pille_expr($not) method.
}

@doc(
  unique_member and

  operator lhs and rhs:
    ~transparent
    ~order: bitwise_conjunction

  operator lhs ∧ rhs:
    ~transparent
    ~order: bitwise_conjunction
){
  Like @pille_expr(+), but for logical or bitwise
  ``and''. The two forms are equivalent.
}

@doc(
  unique_member or

  operator lhs or rhs:
    ~transparent
    ~order: bitwise_disjunction

  operator lhs ∨ rhs:
    ~transparent
    ~order: bitwise_disjunction
){
  Like @pille_expr(+), but for logical or bitwise
  ``or''. The two forms are equivalent.
}

@doc(
  unique_member xor

  operator lhs xor rhs:
    ~transparent
    ~order: bitwise_disjunction

  operator lhs ⊻ rhs:
    ~transparent
    ~order: bitwise_disjunction
){
  Like @pille_expr(+), but for logical or bitwise
  ``exclusive-or''. The two forms are equivalent.
}

@doc(
  unique_member shl

  operator lhs << rhs:
    ~transparent
    ~order: bitwise_shift
){
  Like @pille_expr(+), but for a bitwise left shift.
}

@doc(
  unique_member shr

  operator lhs >> rhs:
    ~transparent
    ~order: bitwise_shift
){
  Like @pille_expr(+), but for a bitwise right shift.
}

@doc(
  unique_member eq
  operator lhs == rhs:
    ~transparent
    ~order: equivalence
){
  Like @pille_expr(+), but for equality tests.
}

@doc(
  unique_member ne

  operator lhs != rhs:
    ~transparent
    ~order: equivalence

  operator lhs ≠ rhs:
    ~transparent
    ~order: equivalence
){
  Like @pille_expr(+), but for inequality tests. The two
  forms are equivalent.
}

@doc(
  unique_member lt
  operator lhs < rhs:
    ~transparent
    ~order: order_comparison
){
  Like @pille_expr(+), but for ``less than'' tests.
}

@doc(
  unique_member gt
  operator lhs > rhs:
    ~transparent
    ~order: order_comparison
){
  Like @pille_expr(+), but for ``greater than'' tests.
}

@doc(
  unique_member le

  operator lhs <= rhs:
    ~transparent
    ~order: order_comparison

  operator lhs ≤ rhs:
    ~transparent
    ~order: order_comparison
){
  Like @pille_expr(+), but for ``less than or equal to''
  tests. The two forms are equivalent.
}

@doc(
  unique_member ge

  operator lhs >= rhs:
    ~transparent
    ~order: order_comparison

  operator lhs ≥ rhs:
    ~transparent
    ~order: order_comparison
){
  Like @pille_expr(+), but for ``greater than or equal to''
  tests. The two forms are equivalent.
}

@//=============================================================================
@section{Generic Math Functions}

@doc(
  unique_member abs

  fun abs(x):
    ~transparent
    x.$abs()
){}

@doc(
  unique_member floor

  fun floor(x):
    ~transparent
    x.$floor()
){}

@doc(
  unique_member ceil

  fun ceil(x):
    ~transparent
    x.$ceil()
){}

@doc(
  unique_member round

  fun round(x):
    ~transparent
    x.$round()
){}

@doc(
  unique_member trunc

  fun trunc(x):
    ~transparent
    x.$trunc()
){}

@doc(
  unique_member sqrt

  fun sqrt(x):
    ~transparent
    x.$sqrt()
){}

@doc(
  unique_member exp

  fun exp(x):
    ~transparent
    x.$exp()
){}

@doc(
  unique_member sin

  fun sin(x):
    ~transparent
    x.$sin()
){}

@doc(
  unique_member cos

  fun cos(x):
    ~transparent
    x.$cos()
){}

@doc(
  unique_member tan

  fun tan(x):
    ~transparent
    x.$tan()
){}

@doc(
  unique_member asin

  fun asin(x):
    ~transparent
    x.$asin()
){}

@doc(
  unique_member acos

  fun acos(x):
    ~transparent
    x.$acos()
){}

@//=============================================================================
@section{Conditionals}

@doc(
  ~nonterminal:
    then_body: expr body ~space
    else_body: expr body ~space

  expr.macro 'if $test_expr
              | $then_body
              | $else_body'
){
  Evaluates @rhombus(test_expr), then based on its result
  evalutes either the @rhombus(then_body) or
  @rhombus(else_body).

  The exact concretization behavior of @pille_expr(if)
  depends on whether the type of the @rhombus(test_expr) is:
  @itemlist(
    @item{exactly @pille_specl_expr(Specl(#true)): then the
          @rhombus(then_body) is always executed (there is
          no actual branch), the @rhombus(else_body) is
          never concretized, and the type of the whole
          @pille_expr(if) form is the type of the
          @rhombus(then_body).},
    @item{exactly @pille_specl_expr(Specl(#false)): then the
          @rhombus(else_body) is always executed (there is
          no actual branch), the @rhombus(then_body) is
          never concretized, and the type of the whole
          @pille_expr(if) form is the type of the
          @rhombus(else_body).},
    @item{any type @coercion_tech{coercible} to
          @pille_specl_expr(Boolean): then both bodies are
          concretized, the one to execute is selected by the
          value of @pille_expr(test_expr :: Boolean) (the
          @rhombus(then_body) if @rhombus(#true), the
          @rhombus(else_body) if @rhombus(#false)), and the
          type of the whole @pille_expr(if) form is the
          @unification_tech{unification} of the types of the
          two bodies.},
    @item{any other type: then concretization fails.})

  In other words, when the @rhombus(test_expr) is
  @pille_specl_expr(Specl), the @pille_expr(if) form behaves
  like a conditional compilation construct; the
  branch-not-taken does not even need to be valid code
  (though it does still need to parse).}

@doc(
  expr.macro 'when $test_expr
              | $body'
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
              | $body'
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
              | $test_expr:
                  $body
              | ...'

  expr.macro 'cond
              | $test_expr:
                  $body
              | ...
              | ~else:
                  $body'
){
  Equivalent to a chain of @pille_expr(if) forms, including
  the special concretization behavior for
  @pille_specl_expr(Specl) conditions.

  If no @rhombus(~else) arm is provided, then the
  @pille_expr(cond) form is only valid if it can be shown to
  be exhaustive during concretization (that is, one of the
  @rhombus(test_expr)s must have type
  @pille_specl_expr(Specl(#true))).
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

@doc(
  expr.macro 'all($expr, $expr, ...)'
){
  Has the same behavior as @pille_expr(expr && expr && ...);
  when there is only one @rhombus(expr), this is an identity
  operation.
}

@doc(
  expr.macro 'any($expr, $expr, ...)'
){
  Has the same behavior as @pille_expr(expr || expr || ...);
  when there is only one @rhombus(expr), this is an identity
  operation.
}

@//=============================================================================
@section{Labels and Jumps}
@doc(
  ~nonterminal_key: #' ~at pille/expr

  expr.macro '#'$label_id $labeled_expr'

  grammar label_id
  | $id

  grammar labeled_expr
  | : $body
  | ($label_arg, ...): $body
  | #,(pille_labeled_expr(while)) $test_expr: $body
  | #,(pille_labeled_expr(until)) $test_expr: $body
  | $other_labeled_expr
){
  An occurence of @pille_expr(#'#,(nontermref(id))) in
  expression position is termed a @deftech{label}, and the
  remainder of the containing @group_tech is parsed as a
  @rhombus(labeled_expr). The exact semantics then depend on
  the particular @rhombus(labeled_expr), but in general the
  @rhombus(label_id) is bound within all or part of the
  @rhombus(labeled_expr), and wherever it is bound it may be
  used with the @pille_expr(break) or @pille_expr(continue)
  forms.
}

@doc(
  expr.macro 'break $label_id $maybe_result'

  grammar maybe_result
  | ($expr)
  | : $body
  | ε
){
  The exact semantics of this form depend on the
  @nontermref(labeled_expr) with which the
  @rhombus(label_id) is associated, but in general, it
  immediately escapes from that @nontermref(labeled_expr)
  with the result value determined by its
  @rhombus(maybe_result).

  An absent @rhombus(maybe_result) is equivalent to
  @pille_expr((#void)).

  The @pille_expr(break) expression itself always has type
  @pille_specl_expr(Never), regardless of the type of the
  @nontermref(labeled_expr) associated with the
  @rhombus(label_id).
}

@doc(
  expr.macro 'continue $label_id $maybe_args'

  grammar maybe_args
  | ($expr, ...)
  | ε
){
  The exact semantics of this form depend on the
  @nontermref(labeled_expr) with which the
  @rhombus(label_id) is associated, but in general, it
  ``restarts'' or ``continues'' the
  @nontermref(labeled_expr)'s execution, supplying zero or
  more arguments to continue with.

  An absent @rhombus(maybe_args) is equivalent to
  @pille_expr(()).

  The @pille_expr(continue) expression itself always has
  type @pille_specl_expr(Never), regardless of the type of
  the @nontermref(labeled_expr) associated with the
  @rhombus(label_id).
}

@doc(
  labeled_expr.macro '#%block:
                        $body'
){
  The associated @nontermref(label_id) is bound within the
  entirety of the @rhombus(body) seqeuence, the
  @pille_expr(break) form immediately escapes from this
  expression with the supplied result, and the
  @pille_expr(continue) form resets control back to the
  beginning of the @rhombus(body) (as though this expression
  were just entered). No @pille_expr(continue) arguments are
  accepted.

  The overall type of the @pille_labeled_expr(#%block)
  expression is the @unification_tech{unification} of the
  type of the @rhombus(body) and the types of all
  @pille_expr(break) results (if any); @tech{coercions} are
  inserted as necessary.
}

@doc(
  ~nonterminal_key:
    #%parens ~at pille/labeled_expr
  ~nonterminal:
    arg_id: rhm.block id
    init_expr: expr expr ~space

  labeled_expr.macro '#%parens ($label_arg, ...):
                        $body'

  grammar label_arg
  | $arg_id #,(pille_expr(=)) $init_expr
  | $arg_id
){
  Like @pille_labeled_expr(#%block), but with ``arguments''
  that can be re-supplied with each execution of a
  @pille_expr(continue) form.

  Each @rhombus(label_arg)'s @rhombus(arg_id) is bound
  within the @rhombus(body) as if by @pille_local_defn(let),
  and initially to the result of each respective
  @rhombus(init_expr) (where ommitting the
  @rhombus(init_expr) is shorthand for using the value of
  the @rhombus(arg_id) in the enclosing scope). Any
  corresponding @pille_expr(continue) form must supply a
  matching number of arguments, which then become the values
  bound to the @rhombus(arg_id)s for the new execution of
  the @rhombus(body).

  The type of each @rhombus(arg_id) is fixed as the type of
  its @rhombus(init_expr), and each corresponding argument
  value from a @pille_expr(continue) form must in turn be
  @coercion_tech{coercible} to that type. There is no
  process that unifies the types of the @rhombus(init_expr)s
  with the types of possible @pille_expr(continue)
  arguments, as this would devolve into a fixed-point
  computation in the general case.
}

@//=============================================================================
@section{Imperative Loops}

@doc(
  expr.macro 'while $test_expr:
                $body'

  labeled_expr.macro 'while $test_expr:
                        $body'
){
  A standard imperative ``while loop''; the @rhombus(body)
  is repeatedly executed for as long as the
  @rhombus(test_expr) continues to evaluate to a true value.

  When used as a @nontermref(labeled_expr), the
  @nontermref(label_id) can be used with @pille_expr(break)
  to immediately exit the @pille_expr(while) expression, or
  with @pille_expr(continue) (without arguments) to
  short-circuit to the @rhombus(test_expr) step of the next
  loop iteration.

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
  This implementation explains some of the subtler
  behaviors, such as the handling of a
  @pille_specl_expr(Specl)-typed @rhombus(test_expr).
}

@doc(
  expr.macro 'until $test_expr:
                $body'

  labeled_expr.macro 'until $test_expr:
                        $body'
){
  Like @pille_expr(while) with a negated
  @rhombus(test_expr).
}

@//=============================================================================
@section{Sequential Iteration}

@doc(
  ~nonterminal:
    elem_id: rhm.block id
    seq_expr: expr expr ~space

  expr.macro 'for ($for_seq, $for_seq, ...):
                $body'

  grammar for_seq
  | $elem_id #,(pille_expr(in)) $seq_expr
){
  Iterates over the @rhombus(for_seq)s in lockstep,
  executing the @rhombus(body) at each step with the element
  values bound to the @rhombus(elem_id)s. Iteration ends as
  soon as any sequence ends; the sequences do not need to be
  of the same length.

  The @rhombus(seq_expr)s are evaluated once prior to the
  first iteration, and the type of each should overload the
  @pille_expr($start_index), @pille_expr($end_index), and
  @pille_expr($next_index) names as described in their
  documentation entry.
}

@doc(
  unique_member start_index
  unique_member end_index
  unique_member next_index
){
  These names can be overloaded to allow a type to act as a
  sequence in forms like @pille_expr(for). Specifically:
  @itemlist(
    @item{The @pille_expr($start_index) property should
    return an ``index'' at which iteration should
    start. There is no constraint on the type of the index,
    except that there should be a corresponding overload of
    the @pille_expr($index_read) method.},
    @item{The @pille_expr($end_index) property should return
    an index ``one past the end'', or in other words the one
    at which iteration should cease (without
    including). This need not have the same type as the
    start index; it only needs to support @pille_expr(<)
    comparisons, as in e.g.
    @pille_expr(#,(pille_expr(seq.$start_index)) < #,(pille_expr(seq.$end_index))).},
    @item{The @pille_expr($next_index) method should take an
    index as an argument (with the sequence as the
    receiver), and return the index which follows.})
}

@//=============================================================================
@section{Aborting Execution}

@doc(
  fun panic() :: Never
){
  Signals an unrecoverable error and aborts execution. This
  is the canonical way to ``abort'' or ``halt and catch
  fire''.

  When using @tech{hosted execution}, this function only
  aborts the active @rhombus(pille) form (causing it to
  throw an exception), and does not prevent subsequent
  execution of Pille code in the same process. This is
  intended mainly as an aid for unit-testing and interactive
  use; panics mean that logical invariants have been
  violated, and they may leave Pille-managed resources in
  inconsistent or broken states.
}
