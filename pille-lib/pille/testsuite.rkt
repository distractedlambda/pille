#lang rhombus/static/and_meta

module reader ~lang rhombus/reader:
  ~lang "testsuite.rhm"

import:
  "private/util/syntax.rhm" open
  lib("racket/base.rkt")
  lib("raco/testing.rkt")
  pille except #%module_block
  pille/concretize
  pille/hosted

import only_space pille.expr pille.specl_expr:
  pille open

export:
  all_from(.pille) // why can't we `except` here?

//==============================================================================
syntax_parameter.bridge current_test_list_id:
  #false

//==============================================================================
meta:
  syntax_class TestGuard:
    kind: ~group
    fields: [expr, ...]
  | '~when: $expr; ...'
  | '~when $(expr_ :: Group)':
      field [expr, ...] = [expr_]

  syntax_class TestBody:
    kind: ~multi
    fields:
      [guard_expr, ...]
      expect_panic
      expect_concr_fail
      body
  | '$(oab :: OptionsAndBody)':
      def ([guard_opt, ...], [other_opt, ...]):
        [oab.option, ...].partition((_ matches '~when $_ ...'))
      match_def '$(guard :: TestGuard); ...' = '$guard_opt; ...'
      match_def '$(group_option_sequence
                   | '~expect_panic':
                       field expect_panic = #true
                   | '~expect_concr_fail':
                       field expect_concr_fail = #true)':
        '$other_opt; ...'
      when expect_panic && expect_concr_fail
      | syntax_meta.error(
          "~expect_panic and ~expect_concr_fail options are mutually exclusive",
          oab)
      field [guard_expr, ...] = [guard.expr, ..., ...]
      field body = oab.body

export defn.macro 'test: $(_ :: TestBody: open)':
  ~all_stx: stx

  guard.let test_list_id!! = syntax_parameter_meta.lookup('current_test_list_id')
  | syntax_meta.error("illegal use outside testsuite module", stx)

  'block:
     MutableList.add(
       $test_list_id,
       Test(
         $(stx.srcloc()),
         $expect_panic,
         $expect_concr_fail,
         fun():
           all(
             pille.specl_expr.eval($guard_expr),
             ...),
         fun():
           hosted.pille:
             $body))'

//==============================================================================
export pille.expr.macro 'assert($(tst :: pille.expr_meta.Parsed))':
  ~all_stx: stx
  'unless $tst | panic("assertion failed", $(stx.srcloc()))'

//==============================================================================
export decl.macro '#%module_block: $body; ...':
  '«module_block:
      let test_list = MutableList[]

      syntax_parameter.relet current_test_list_id:
        'test_list'

      $body; ...

      block:
        run_tests(test_list.snapshot())»'

//==============================================================================
class Test(
  srcloc :: maybe(Srcloc),
  expect_panic :: Boolean,
  expect_concr_fail :: Boolean,
  eval_guards :: () -> Any,
  run_body :: () -> ~any,
)

fun run_tests(the_tests :: [Test, ...]):
  for:
    each ub_policy in [#'check, #'suppress, #'allow]
    hosted.pille.configure_jit(~ub_policy)

    each test in the_tests
    let src_str = test.srcloc?.to_report_string() || "???"
    let header_str = src_str ++ @str{[ub_policy=@(to_string(ub_policy))]}

    fun display_error(remark, exn :: maybe(Exn.Fail) = #false):
      match exn
      | exn!!:
          base.#{error-display-handler}()(
            @str{@header_str: @remark:} ++ error.reindent(
              ~max_len: 0,
              ~tab: " ",
              exn.message),
            exn)
          println()
      | #false:
          println(@str{@header_str: @remark\n}, ~out: stderr)

    keep_when try:
      test.eval_guards()
      ~catch
      | exn :: Exn.Fail:
          testing.#{test-log!}(#false)
          display_error("error evaluating test guards", exn)
          hosted.pille.configure_jit(~ub_policy)
          #false

    testing.#{test-log!} <| try:
      test.run_body()
      cond
      | test.expect_panic:
          display_error("test was expected to panic, but did not")
          #false
      | test.expect_concr_fail:
          display_error("test was expected to fail concretization, but did not")
          #false
      | ~else:
          #true
      ~catch
      | exn :: concretize.Exn.Fail.Concretize:
          test.expect_concr_fail || block:
            display_error("test failed concretization", exn)
            #false
      | exn :: hosted.pille.Panic:
          test.expect_panic || block:
            display_error("test panicked", exn)
            #false
      | exn :: Exn.Fail:
          display_error("test failed in an unexpected manner", exn)
          hosted.pille.configure_jit(~ub_policy)
          #false
