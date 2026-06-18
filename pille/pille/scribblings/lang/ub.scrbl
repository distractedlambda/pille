#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title{Managing Undefined Behavior}

Many operations in Pille have the potential to trigger
undefined behavior. Some causes of undefined behavior are
relatively easy to guard against with local runtime checks,
but not all use-cases may be tolerant of the overhead that
such checks introduce.

@margin_note{Programs should not rely on the @tt{suppress}
             or @tt{check} policies for correctness; a Pille
             program that would exhibit undefined behavior
             when run under the @tt{allow} policy is
             @italic{incorrect}, full stop. The ability to
             @tt{check} or @tt{suppress} managed undefined
             behavior should be viewed as a mitigation tool
             and debugging aid, not as a way to reduce the
             undefined behavior in the language.}

Accordingly, Pille defines a subset of undefined behavior as
@deftech{managed undefined behavior}, where code generation
changes depending on the policy selected by the
@tt{PILLE_UB_POLICY} environment variable:
@itemlist(
  @item{@tt{PILLE_UB_POLICY=allow}: Treat managed undefined
        behavior just as any other kind, meaning that no
        guarantees are given for programs that exhibit it.},
  @item{@tt{PILLE_UB_POLICY=suppress}: Make managed
        undefined behavior @italic{defined}, but without any
        guarantees as to the actual definition. This intends
        to mitigate some of the most insidious aspects of
        true undefined behavior (its nonlocal and
        nondeterministic effects) with minimal overhead.},
  @item{@tt{PILLE_UB_POLICY=check}: Perform runtime checks
        and @pille_expr(panic) whenever managed undefined
        behavior would otherwise be triggered.})

If the @tt{PILLE_UB_POLICY} environment variable is not set,
then the default policy is @tt{check}.

For some causes of undefined behavior, runtime checks are
impractical, but suppression is still possible; this is
termed @deftech{suppressible undefined behavior}, for which
the @tt{suppress} and @tt{check} policies are essentially
the same.

@doc(
  const.def ub.checked :: boolean
  const.def ub.suppressed :: boolean
  const.def ub.allowed :: boolean
){
  Constants which surface the active undefined behavior
  policy; exactly @italic{one} of them will be
  @rhombus(#true) in any given concretization.
}
