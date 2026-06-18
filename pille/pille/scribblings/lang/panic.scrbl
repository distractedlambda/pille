#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title{Panicking}

@doc(
  fun panic() :: Never
){
  Signals an unrecoverable error and aborts execution. This
  is the canonical way to ``abort'' or ``halt and catch
  fire''.

  Currently, this just executes a target-specific trap
  instruction, so effectively debugging programs that
  @pille_expr(panic) requires use of a native debugger than
  can intercept machine-level traps. In the future, this
  function is expected to have richer
  functionality--possibly even gracefully returning control
  to Rhombus in the case of
  @seclink("Hosted_Execution"){hosted execution}.
}
