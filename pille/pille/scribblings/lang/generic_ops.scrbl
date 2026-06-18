#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title{Generic Operators}

@doc(
  special_name.def call

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
  special_name.def new

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
  receiver types of the shape @pille_const_bind(Const(_ :: type))) to represent
  construction of new instances.
}

@doc(
  special_name.def index_read
  special_name.def index_write

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
  @pille_const_expr(Boolean) or @pille_const_expr(Const(#true)); the latter
  occurs when the unified type is known to have at most one distinct inhabitant
  (as with @pille_const_expr(Void)), and so the comparison is known to always
  succeed. The result of an @pille_expr(!==) expression may be either
  @pille_const_expr(Boolean) or @pille_const_expr(Const(#false)), as it is the
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
  special_name.def add
  operator lhs + rhs
  operator_order: ~order: addition
){}

@doc(
  special_name.def add_wrap
  operator lhs +% rhs
  operator_order: ~order: addition
){}

@doc(
  special_name.def sub
  operator lhs - rhs

  special_name.def neg
  operator -rhs

  operator_order: ~order: addition
){}

@doc(
  special_name.def sub_wrap
  operator lhs -% rhs

  special_name.def neg_wrap
  operator -%rhs

  operator_order: ~order: addition
){}

@doc(
  special_name.def mul
  operator lhs * rhs
  operator_order: ~order: multiplication
){}

@doc(
  special_name.def mul_wrap
  operator lhs *% rhs
  operator_order: ~order: multiplication
){}

@doc(
  special_name.def div
  operator lhs / rhs
  operator_order: ~order: multiplication
){}

@doc(
  special_name.def div_trunc
  operator lhs div_trunc rhs
  operator_order: ~order: multiplication
){}

@doc(
  special_name.def div_floor
  operator lhs div_floor rhs
  operator_order: ~order: multiplication
){}

@doc(
  special_name.def div_ceil
  operator lhs div_ceil rhs
  operator_order: ~order: multiplication
){}

@doc(
  special_name.def rem
  operator lhs % rhs
  operator_order: ~order: multiplication
){}

@doc(
  special_name.def rem_trunc
  operator lhs rem_trunc rhs
  operator_order: ~order: multiplication
){}

@doc(
  special_name.def rem_floor
  operator lhs rem_floor rhs
  operator_order: ~order: multiplication
){}

@doc(
  special_name.def rem_ceil
  operator lhs rem_ceil rhs
  operator_order: ~order: multiplication
){}

@doc(
  operator ! (const rhs :: boolean) :: Const(!rhs)
  operator ! (rhs :: CoercesTo(Boolean)) :: Boolean
  operator_order: ~order: logical_negation
){}

@doc(
  special_name.def not
  operator not rhs
  operator ¬ rhs
  operator_order: ~order: bitwise_negation
){}

@doc(
  special_name.def and
  operator lhs and rhs
  operator lhs ∧ rhs
  operator_order: ~order: bitwise_conjunction
){}

@doc(
  special_name.def or
  operator lhs or rhs
  operator lhs ∨ rhs
  operator_order: ~order: bitwise_disjunction
){}

@doc(
  special_name.def xor
  operator lhs xor rhs
  operator lhs ⊻ rhs
  operator_order: ~order: bitwise_disjunction
){}

@doc(
  special_name.def eq
  operator lhs == rhs
  operator_order: ~order: equivalence
){}

@doc(
  special_name.def ne
  operator lhs != rhs
  operator lhs ≠ rhs
  operator_order: ~order: equivalence
){}

@doc(
  special_name.def lt
  operator lhs < rhs
  operator_order: ~order: order_comparison
){}

@doc(
  special_name.def gt
  operator lhs > rhs
  operator_order: ~order: order_comparison
){}

@doc(
  special_name.def le
  operator lhs <= rhs
  operator lhs ≤ rhs
  operator_order: ~order: order_comparison
){}

@doc(
  special_name.def ge
  operator lhs >= rhs
  operator lhs ≥ rhs
  operator_order: ~order: order_comparison
){}
