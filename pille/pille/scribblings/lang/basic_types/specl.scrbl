#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title(~tag: "Basic_Types_Specialization_Values"){Specialization Values}

@doc(
  type Specl(val :: any)
){
  Represents the @tech{specialization value} @rhombus(val),
  but in a runtime context. All @pille_specl_expr(Specl)
  types have erased representations, so their instances
  carry no actual runtime information.

  @pille_specl_expr(Specl) types are treated specially when
  they participate in method calls (and read-mode property
  accesses): when the receiver type and all argument types
  are @pille_specl_expr(Specl) types, @italic{and} there is
  an applicable @pille_global_defn(specl.method) (resp.
  @pille_global_defn(specl.property)), then the call
  (resp. property access) is evaluated within the
  specialization language, and the result is wrapped back up
  in a @pille_specl_expr(Specl) type.
}

@doc(
  expr.macro 'specl($specl_expr)'
){
  Produces a value of type
  @pille_specl_expr(Specl(specl_expr)).
}
