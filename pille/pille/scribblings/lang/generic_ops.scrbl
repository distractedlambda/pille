#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title{Generic Operators}

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
  operator lhs === rhs
  operator lhs !== rhs
  operator_order: ~order: equivalence
){
  The ``@tech{repr}-equivalence'' operators; @rhombus(lhs) and @rhombus(rhs) are
  @coercion_tech{coerced} to a @unification_tech{unified} type, then compared
  for bitwise (in)equality of their runtime representations. This bitwise
  comparison @italic{does not} consider ``padding bits'' that might be part of a
  type's in-memory footprint.

  The result type of an @pille_expr(===) expression may be either
  @pille_specl_expr(Boolean) or @pille_specl_expr(Specl(#true)); the latter
  occurs when the unified type is known to have at most one distinct inhabitant
  (as with @pille_specl_expr(Void)), and so the comparison is known to always
  succeed. The result of an @pille_expr(!==) expression may be either
  @pille_specl_expr(Boolean) or @pille_specl_expr(Specl(#false)), as it is the
  negation of an @pille_expr(===) expression.
}

@doc(
  struct CastExact(α :: type):
    src :: α
){}

@doc(
  method (src :: α).cast_exact() :: CastExact(α)
){}

@doc(
  struct CastWrap(α :: type):
    src :: α
){}

@doc(
  method (src :: α).cast_wrap() :: CastWrap(α)
){}

@doc(
  unique_member add
  operator lhs + rhs
  operator_order: ~order: addition
){}

@doc(
  unique_member add_wrap
  operator lhs +% rhs
  operator_order: ~order: addition
){}

@doc(
  unique_member sub
  operator lhs - rhs

  unique_member neg
  operator -rhs

  operator_order: ~order: addition
){}

@doc(
  unique_member sub_wrap
  operator lhs -% rhs

  unique_member neg_wrap
  operator -%rhs

  operator_order: ~order: addition
){}

@doc(
  unique_member mul
  operator lhs * rhs
  operator_order: ~order: multiplication
){}

@doc(
  unique_member mul_wrap
  operator lhs *% rhs
  operator_order: ~order: multiplication
){}

@doc(
  unique_member div
  operator lhs / rhs
  operator_order: ~order: multiplication
){}

@doc(
  unique_member div_trunc
  operator lhs div_trunc rhs
  operator_order: ~order: multiplication
){}

@doc(
  unique_member div_floor
  operator lhs div_floor rhs
  operator_order: ~order: multiplication
){}

@doc(
  unique_member div_ceil
  operator lhs div_ceil rhs
  operator_order: ~order: multiplication
){}

@doc(
  unique_member rem
  operator lhs % rhs
  operator_order: ~order: multiplication
){}

@doc(
  unique_member rem_trunc
  operator lhs rem_trunc rhs
  operator_order: ~order: multiplication
){}

@doc(
  unique_member rem_floor
  operator lhs rem_floor rhs
  operator_order: ~order: multiplication
){}

@doc(
  unique_member rem_ceil
  operator lhs rem_ceil rhs
  operator_order: ~order: multiplication
){}

@doc(
  operator ! (specl rhs :: boolean) :: Specl(!rhs)
  operator ! (rhs :: CoercesTo(Boolean)) :: Boolean
  operator_order: ~order: logical_negation
){}

@doc(
  unique_member not
  operator not rhs
  operator ¬ rhs
  operator_order: ~order: bitwise_negation
){}

@doc(
  unique_member and
  operator lhs and rhs
  operator lhs ∧ rhs
  operator_order: ~order: bitwise_conjunction
){}

@doc(
  unique_member or
  operator lhs or rhs
  operator lhs ∨ rhs
  operator_order: ~order: bitwise_disjunction
){}

@doc(
  unique_member xor
  operator lhs xor rhs
  operator lhs ⊻ rhs
  operator_order: ~order: bitwise_disjunction
){}

@doc(
  unique_member eq
  operator lhs == rhs
  operator_order: ~order: equivalence
){}

@doc(
  unique_member ne
  operator lhs != rhs
  operator lhs ≠ rhs
  operator_order: ~order: equivalence
){}

@doc(
  unique_member lt
  operator lhs < rhs
  operator_order: ~order: order_comparison
){}

@doc(
  unique_member gt
  operator lhs > rhs
  operator_order: ~order: order_comparison
){}

@doc(
  unique_member le
  operator lhs <= rhs
  operator lhs ≤ rhs
  operator_order: ~order: order_comparison
){}

@doc(
  unique_member ge
  operator lhs >= rhs
  operator lhs ≥ rhs
  operator_order: ~order: order_comparison
){}
