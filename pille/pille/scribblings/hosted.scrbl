#lang rhombus/scribble/manual

@(import:
    "common.rhm" open
    "common/pille/doc_forms.rhm" as pille
    "common/pille/spacers.rhm" as ~none:
      expose:
        $
    only_meta 0:
      meta_label:
        ffi open
        pille/hosted open
        rhombus/and_meta open
        rhombus/delay open)

@(nonterminal:
    expr: block
    id: block
    pille_body: pille.expr body ~space
    pille_specl_bind: pille.specl_bind specl_bind ~space
    pille_specl_expr: pille.specl_expr specl_expr ~space)

@title{Hosted Execution}

@docmodule(
  ~use_sources:
    lib("pille/private/runtime/ub_policy.rhm")
    lib("pille/hosted.rhm")!global_jit,
  ~open, pille/hosted)

Hosted execution embeds Pille code within a Rhombus host
program, backed by a simple JIT compiler. The
@rhombusmodname(pille/hosted) module re-exports all bindings
from @rhombuslangname(pille) that are in Pille-specific
spaces, and additionally exports @rhombuslangname(pille)
itself (for qualified access to everything else).

@section{Calling Pille From Rhombus}

@doc(
  expr.macro 'pille:
                $pille_body'

  expr.macro 'pille($arg, ...):
                $pille_body'

  grammar arg
  | #,(pille_expr(specl)) $specl_arg
  | $dyn_arg

  grammar specl_arg
  | $pille_specl_bind #,(rhm_expr(=)) $expr
  | $id

  grammar dyn_arg
  | $id #,(pille_expr(::)) $pille_specl_expr #,(rhm_expr(=)) $expr
  | $id #,(pille_expr(::)) $pille_specl_expr
){
  Executes the @rhombus(pille_body) as a Rhombus expression,
  possibly with @rhombus(arg)s that pass values from Rhombus
  into Pille. A @rhombus(specl_arg) passes a Rhombus value
  into Pille as a specialization value, while a
  @rhombus(dyn_arg) passes a Rhombus value into Pille as an
  ordinary runtime value; in the latter case, a Pille type
  must be specified, and that type must be
  @tech{interoperable}. In any case, the result of the
  @rhombus(pille_body) must be of an interoperable type, and
  it becomes the result of the @rhombus(pille) expression.

  The compilation of the @rhombus(pille_body) (including
  concretization) is deferred until the first time the
  @rhombus(pille) expression is executed; moreover, each
  unique combination of @rhombus(specl_arg) values results
  in a unique compilation. All such compilations are cached
  at module scope, regardless of where the @rhombus(pille)
  expression occurs.

  From the perspective of the Rhombus runtime, execution of
  the @rhombus(pille_body) occurs within a foreign call that
  is @italic{not} @rhombus(~collect_safe); moreover, all
  @rhombus(dyn_arg) values are kept reachable to the garbage
  collector during that time. It is therefore safe to pass a
  pointer to GC-managed memory as a @rhombus(dyn_arg),
  insofar as that it will not be collected or moved during
  the execution of the @rhombus(pille_body).
}

@section{Interoperable Types}
In order for values of a Pille type to cross a boundary with
Rhombus, they must be @deftech{interoperable}. Many of
Pille's basic types are interoperable, and user-defined
types can be made interoperable by appropriate overloads of
the @pille_expr($from_rhombus) and @pille_expr($to_rhombus)
methods.

The interoperable basic types are as follow:
@itemlist(
  @item{@pille_specl_expr(Void): represented in Rhombus as
  @rhombus(#void).},

  @item{@pille_specl_expr(Boolean): represented in Rhombus
  as @rhombus(Boolean, ~annot)s.},

  @item{@pille_specl_expr(Int) and @pille_specl_expr(UInt):
  represented in Rhombus as @rhombus(Int, ~annot)s. When
  passing from Rhombus to Pille, the Rhombus value must be
  representable by the Pille type.}

  @item{@pille_specl_expr(Float) and
  @pille_specl_expr(Double): represented in Rhombus as
  @rhombus(Real, ~annot)s. When passing from Rhombus to
  Pille, any @rhombus(Real, ~annot) is accepted and coerced
  to its floating-point representation; when passing from
  Pille to Rhombus, the Rhombus representation is always a
  @rhombus(Flonum, ~annot).},

  @item{@pille_specl_expr(Tuple): interoperable iff all
  element types are interoperable, and represented in
  Rhombus as a @rhombus(List, ~annot).},

  @item{@pille_specl_expr(RawPtr), @pille_specl_expr(Ptr),
  and @pille_specl_expr(PtrMut): represented in Rhombus as
  @rhombus(ptr_t, ~annot) values. Pointee type information
  is ignored when passing from Rhombus to Pille, and lost
  when passing from Pille to Rhombus.},

  @item{@pille_specl_expr(Specl): represented in Rhombus as
  the particular specialization value. When passing from
  Rhombus to Pille, the value supplied by Rhombus must match
  the one embedded in the @pille_specl_expr(Specl) type;
  when passing from Pille to Rhombus, the specialization
  value is returned.})

@doc(
  pille.unique_member from_rhombus
  pille.unique_member to_rhombus
){
  The @pille_expr($from_rhombus) and
  @pille_expr($to_rhombus) methods can be overloaded to make
  a user-defined type @tech{interoperable}, by way of appeal
  to another type that already is. Specifically, in order
  for some type @rhombus(α, ~var) to be made interoperable
  via this mechanism:

  @itemlist(
    @item{There must be an overload of the
    @pille_expr($to_rhombus) method, with receiver type
    @rhombus(α, ~var), no arguments, and a return type
    @rhombus(β, ~var) that is interoperable; and},
    @item{there must be a corresponding overload of the
    @pille_expr($from_rhombus) method, with receiver type
    @pille_specl_expr(Specl(#,(@rhombus(α, ~var)))) and a
    single argument of type @rhombus(β, ~var), whose return
    type is coercible to @rhombus(α, ~var).})

  When converting a Rhombus value to @rhombus(α, ~var), it
  is first converted to @rhombus(β, ~var), then the
  @pille_expr($from_rhombus) method is called (and a
  coercion potentially applied to its result) to produce a
  value of type @rhombus(α, ~var). Conversely, when
  converting a Pille value of type @rhombus(α, ~var) to
  Rhombus, the @pille_expr($to_rhombus) method is called to
  first convert it to type @rhombus(β, ~var), and then from
  there it is converted to Rhombus.

  These bindings are also provided by
  @rhombuslangname(pille), so importing
  @rhombusmodname(pille/hosted) is not necessary to define
  overloads.
}

@section{Configuring the JIT}

@doc(
  fun pille.configure_jit(
    ~ub_policy:
      ub_policy :: pille.UbPolicy:
        pille.UbPolicy.from_env.force(),
  ) :: Void
){
  (Re)Configures the JIT used for hosted execution, while
  also resetting its state (including discarding any
  compiled code).

  If this function is not called prior to executing a
  @rhombus(pille) expression, then it is as though it were
  called at that point with default values for all
  arguments.

  The JIT does not currently resolve method overloads or
  unification rules that were defined since the last
  (possibly-implicit) call to this function; thus, calling
  this function is currently necessary to ensure that
  newly-defined overloads or unification rules take effect
  for subsequent evaluations of @rhombus(pille)
  expressions. This is considered a bug, and should
  eventually be fixed.
}

@doc(
  enum pille.UbPolicy
  | check
  | suppress
  | allow
){
  Models @tech{undefined behavior policies}.
}

@doc(
  def pille.UbPolicy.from_env
    :: Delay.assume_of(pille.UbPolicy)
){
  Resolves to the @tech{undefined behavior policy} implied
  by the @tt{PILLE_UB_POLICY} environment variable.
}
