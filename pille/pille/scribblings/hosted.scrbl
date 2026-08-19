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
  ~use_sources: lib("pille/hosted.rhm")!pille_ext
  ~open, pille/hosted)

@deftech{Hosted execution} embeds Pille code within a
Rhombus host program, backed by a simple JIT compiler. The
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

  From the perspective of Rhombus, execution of the
  @rhombus(pille_body) occurs within a @rhm_ffi_tech{foreign
  callout} that is @italic{not} @rhombus(~collect_safe);
  moreover, all @rhombus(dyn_arg) values are kept reachable
  to the garbage collector during that time. It is therefore
  safe to pass a pointer to GC-managed memory as a
  @rhombus(dyn_arg), insofar as that it will not be
  collected or moved during the execution of the
  @rhombus(pille_body).
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
