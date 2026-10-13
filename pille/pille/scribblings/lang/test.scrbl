#lang rhombus/scribble/manual

@(import:
    "common.rhm" open
    meta_label:
      pille/testsuite as ~none:
        expose:
          assert
          test)

@title(~style: #'toc){Testing}

@docmodule(~lang, pille/testsuite)

The @rhombuslangname(pille/testsuite) language provides a
dedicated way to define test suites (that is, modules full
of tests). It re-exports all of @rhombuslangname(pille),
while providing the additional bindings documented below.

@doc(
  global_defn.macro 'test:
                       $option; ...
                       $body'

  grammar option
  | ~when $specl_expr
  | ~when: $specl_expr; ...
  | ~expect_panic
  | ~expect_concr_fail
){
  Defines a test for the testsuite, where @rhombus(~when)
  options (which can be supplied any number of times) guard
  whether or not the test is included.

  The @rhombus(~expect_panic) and
  @rhombus(~expect_concr_fail) options are
  mutually-exclusive. If neither are supplied, then the test
  is considered to have passed iff the @rhombus(body)
  concretizes successfully and executes without
  panicking. If @rhombus(~expect_panic) is supplied, then
  the @rhombus(body) must still concretize, but it is
  expected to panic during its execution (and the test fails
  if it does not). If @rhombus(~expect_concr_fail) is
  supplied, then the @rhombus(body) is expected to fail to
  concretize (and the test fails if it concretizes
  successfully).

  When running the testsuite, each @pille_global_defn(test)
  is run once for each @tech{undefined behavior policy} (so,
  each test is run three times). If a test only makes sense
  in some subset of policies (usually, because it is testing
  the panicking behavior of a check that is only present
  when @pille_specl_expr(ub.checked)), then it should be
  appropriately guarded with a @rhombus(~when) option.
}

@doc(
  expr.macro 'assert($expr)'
){
  Evaluates @rhombus(expr) and panics if it is not
  @rhombus(#true) (in the sense of @pille_expr(if)).
}
