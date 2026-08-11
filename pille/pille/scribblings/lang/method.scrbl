#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title{Properties and Methods}

@doc(
  global_defn.macro 'method $receiver $dot_member_name ($arg, ...) $maybe_res_type:
                       $method_option; ...
                       $body'

  grammar dot_member_name
  | #,(pille_expr(.)) $member_name
  | #,(pille_expr(.$)) $unique_member_id

  grammar member_name
  | $id
  | #,(pille_expr($)) $unique_member_id

  grammar receiver
  | ($arg)

  grammar arg
  | #,(pille_local_defn(using)) $implicit_key $maybe_implicit_alias $maybe_type_bind
  | #,(pille_expr(specl)) $specl_bind
  | $maybe_inout $id $maybe_type_bind

  grammar maybe_implicit_alias
  | ~as $id
  | ε

  grammar maybe_type_bind
  | #,(pille_expr(::)) $specl_bind
  | ε

  grammar maybe_inout
  | #,(pille_expr(inout))
  | ε

  grammar maybe_res_type
  | #,(pille_expr(::)) $specl_expr
  | ε

  grammar method_option
  | $when_where_option
  | $srcloc_option
  | $priority_option
  | ~transparent

  grammar when_where_option
  | ~when $specl_expr
  | ~when:
      $specl_expr
      ...
  | ~where $where_bind
  | ~where:
      $where_bind
      ...

  grammar where_bind
  | $specl_bind #,(pille_specl_expr(=)) $specl_expr
  | $specl_bind: $specl_expr

  grammar srcloc_option
  | ~srcloc $srcloc_val
  | ~srcloc: $srcloc_val

  grammar srcloc_val
  | $srcloc
  | #false

  grammar priority_option
  | ~priority $priority_id_name
  | ~priority: $priority_id_name
){
  Defines an overload for the @deftech{method} with the
  given @nontermref(member_name).

  All methods calls must have at least one argument, and the
  first argument is distinguished syntactically as the
  @deftech{receiver} of the call. Unlike in some
  object-oriented systems, the receiver is not actually
  privelaged in any semantic way (e.g. it does not have any
  special role in overload resolution), and there is no
  implied dynamic dispatch (a single overload is always
  chosen during concretization, and it becomes a direct and
  inlinable call).

  Each @rhombus(arg) can take one of several forms:
  @itemlist(
    @item{An @rhombus(arg) that does not begin with
    @pille_local_defn(using), @pille_expr(specl), or
    @pille_expr(inout) is an ordinary positional argument,
    where the @rhombus(maybe_type_bind) (if present) binds
    the argument's type during concretization.},

    @item{An @rhombus(arg) that begins with
    @pille_expr(inout) is like an ordinary positional
    argument, except that its @rhombus(id) becomes
    assignable; at a call site, the corresponding argument
    expression must also be assignable.

    @pille_expr(inout) arguments use
    ``call-by-value-result'' semantics, not
    call-by-reference semantics; assignments to the
    @rhombus(id) are visible @italic{only} through the
    @rhombus(id) until the call returns, at which point the
    final value is written back through the corresponding
    call-site argument expression.}

    @item{An @rhombus(arg) that begins with
    @pille_local_defn(using) is an @deftech{implicit
    argument}, and both its type and its value are sourced
    from the implicit environment of the call site; it is
    never provided explicitly as a positional argument.

    Each implicit argument contributes to the implicit
    environment of the @rhombus(body) (and of expressions
    nested within @pille_specl_expr(type_of) in subsequent
    parts of the overload's signature). The optional
    @rhombus(~as id) clause binds the value to @rhombus(id)
    for convenience.

    The @rhombus(receiver) cannot be specified as an
    implicit argument.},

    @item{An @rhombus(arg) of the form
    @rhombus(specl specl_bind) is shorthand for
    @rhombus(id :: Specl(specl_bind)) with a fresh
    @rhombus(id).})

  During concretization, @rhombus(arg)s are matched from
  left to right, such that any bindings established by an
  earlier @rhombus(arg) (including its @nontermref(id) and
  any @nontermref(specl_bind)) are in-scope for subsequent
  arguments; moreover, the bindings from @italic{all}
  arguments are in-scope for the
  @rhombus(when_where_option)s, the @rhombus(maybe_res_type),
  and the @rhombus(body).

  Any number of @rhombus(when_where_option)s can be given,
  with each serving as an auxiliary condition on the
  overload's applicability to a given call site; a
  @rhombus(~when) option adds one or more
  @nontermref(specl_expr) predicates that must yield
  non-@rhombus(#false) values, while a @rhombus(~where)
  option adds one or more @nontermref(specl_bind)s of
  arbitrary @nontermref(specl_expr)s that must
  succeed. Moreover, the bindings from each
  @rhombus(where_bind) are in-scope for each subsequent
  @rhombus(where_bind) or @rhombus(~when) option, as well as
  for the @rhombus(maybe_res_type) and the @rhombus(body).

  If the @rhombus(maybe_res_type) is empty, then the
  behavior is as though it was given as
  @pille_specl_expr(type_of(body)). This can be useful when
  the @rhombus(body) is trivial, or when failure to
  concretize the @rhombus(body) should merely disqualify the
  overload (rather than aborting compilation).

  If the @rhombus(~transparent) option is given, the
  overload is defined as a @deftech{transparent overload},
  which is something like a concretization-time macro: the
  @rhombus(body) is spliced directly into the call site
  during concretization (while retaining
  call-by-value-result semantics). In particular, a
  transparent overload inherits the call site's implicit
  environment, allowing its @rhombus(body) (and any other
  @nontermref(expr)s embedded in its signature) to resolve
  implicit values without needing a corresponding
  @pille_local_defn(using) argument.

  If the @rhombus(~priority) option is given, then the
  overload is given the priority named by the
  @nontermref(priority_id_name). Otherwise, the overload is
  given an @deftech{automatic priority}, which is equivalent
  to a new unique priority declared with an unexposed name
  (and no @rhombus(~lower_than) or @rhombus(~higher_than)
  options).

  If the @rhombus(~srcloc) option is given, it associates
  the overload with the given source location (expressed
  directly as either a @rhombus(Srcloc, ~annot) or a literal
  @rhombus(#false)); otherwise, the overload is associated
  with the source location of the entire
  @pille_global_defn(method) form. This option is intended
  for macro-generated @pille_global_defn(method) forms,
  where the generating macro may have better knowledge of a
  useful source location.

  When choosing the overload that best matches a call site,
  concretization first determines which overloads are
  candidates, where an overload is a candidate if all
  argument types can be matched to their respective
  @nontermref(specl_bind)s, all @rhombus(~when) and
  @rhombus(~where) clauses are satisfied, all implicit
  arguments are available at the call site, and the
  (possibly-implied) @rhombus(res_type_expr) evaluates
  successfully to a @pille_specl_annot(type). Concretization
  then selects the candidate with the strictly-highest
  priority; if there is no such candidate, concretization
  fails at the call site.

  An absense of candidates in overload selection is a
  @deftech{recoverable concretization failure}:
  concretization may continue, depending on the context in
  which the failure occurs. An @italic{ambiguity} between
  candidates, meanwhile, is an @deftech{aborting
  concretization failure}, and halts compilation entirely.
}

@doc(
  ~nonterminal:
    arg: method ~defn

  global_defn.macro 'property $receiver $dot_member_name $maybe_res_type:
                       $method_option; ...
                       $body'

  global_defn.macro 'property $receiver $dot_member_name #,(pille_expr(:=)) ($arg) $maybe_res_type:
                       $method_option; ...
                       $body'
){
  Defines an overload for read access (the first form) or
  write access (the second form) to the @deftech{property}
  with the given @nontermref(member_name).
}

@doc(
  expr.macro '$lhs_expr . $member_name ($arg_expr, ...)'
  expr.macro '$lhs_expr . $member_name'
  operator_order: ~order: member_access
){
  Performs a method call (the first form) or a property
  access (the second form).

  In the case of a method call, the @rhombus(arg_expr)s
  supply the positional arguments, and a given
  @rhombus(arg_expr) must be assignable if the call resolves
  to an overload in which its position is
  @pille_expr(inout).

  In the case of a property access, the property must have a
  read-accessor, and the type of the @pille_expr(.)
  expression becomes the result type of the
  read. Additionally, if the property has a write-accessor
  for that same type, and the assignability of the
  @rhombus(lhs_expr) is compatible with the receiver
  argument of that write-accessor (that is, the
  @rhombus(lhs_expr) is assignable when the receiver of the
  write-accessor is @pille_expr(inout)), then the
  @pille_expr(.) expression becomes assignable.
}

@section{Unique Member Names}

@doc(
  global_defn.macro 'unique_member $id'
){
  Defines @rhombus(id) as a @deftech{unique member name},
  referenceable with the @pille_expr($) and @pille_expr(.$)
  operators. A unique member name is distinct from all
  others, and is resolved by binding rather than by symbol.
}

@doc(
  expr.macro '$'
){
  Recognized specially in the syntax of
  @nontermref(member_name), but otherwise an error.
}

@doc(
  expr.macro '$lhs_expr .$ $unique_member_id ($arg_expr, ...)'
  expr.macro '$lhs_expr .$ $unique_member_id'
  operator_order: ~order: member_access
){
  Provides a single-operator shorthand for using
  @pille_expr(.) with a @tech{unique member name}.
}

@section{Overload Priorities}

@doc(
  global_defn.macro 'priority $id_name'

  global_defn.macro 'priority $id_name:
                       $option; ...'

  grammar option
  | ~lower_than $priority_id_name
  | ~lower_than: $priority_id_name; ...
  | ~higher_than $priority_id_name
  | ~higher_than: $priority_id_name; ...
){}

@doc(
  priority fallback
){}
