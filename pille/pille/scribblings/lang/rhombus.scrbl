#lang rhombus/scribble/manual

@(import:
    "common.rhm" open
    rhombus/meta open
    meta_label:
      ffi open
      rhombus open: only_space annot
      pille/hosted as ~none:
        expose:
          pille)

@title{Rhombus Interoperability}

Most of the functionality described in this section is only
applicable when using @tech{hosted execution}, but the
bindings are available to all @rhombuslangname(pille)
programs.

@section{Detecting Hosted Execution}

@doc(
  specl.def using_hosted_execution :: boolean
){
  @rhombus(#true) if code is being compiled for @tech{hosted
  execution}, and @rhombus(#false) otherwise. This should be
  used to selectively enable code paths or overloads that
  are only applicable when running Pille within a Rhombus
  environment.
}

@section{Calling Rhombus From Pille}

@doc(
  expr.macro 'rhombus($arg, ...) $maybe_res_type:
                $rhombus_body
                ...'

  expr.macro 'rhombus $maybe_res_type:
                $rhombus_body
                ...'

  grammar arg
  | $id #,(pille_expr(=)) $expr
  | $id

  grammar maybe_res_type
  | #,(pille_expr(::)) $specl_expr
  | ε
){
  Executes the @rhombus(rhombus_body) as a Pille
  expression. If @rhombus(arg)s are present, then they
  specify Pille values that should be delivered to Rhombus
  (and bound to their respective @rhombus(id)s within the
  @rhombus(rhombus_body)). The @rhombus(maybe_res_type)
  specifies the Pille type used to capture the result of the
  @rhombus(rhombus_body), with a default of
  @pille_specl_expr(Void). All argument and result types
  must be @tech{interoperable}.

  If the @rhombus(rhombus_body) throws an exception, then
  Pille execution is aborted, and the exception is re-thrown
  from where Pille execution was entered (i.e. the
  dynamically-enclosing @rhm_expr(pille) form). From the
  perspective of Pille, the exception escapes via
  @tt{longjmp}, and the @pille_expr(rhombus) form never
  actually returns.

  From the perspective of Rhombus, the
  @rhombus(rhombus_body) is executed as part of a
  @rhm_ffi_tech{foreign callback}; in particular, this means
  it executes in @rhm_ffi_tech{atomic mode}. Moreover, the
  @rhombus(rhombus_body) is effectively lifted to module
  scope, so it cannot access local Rhombus bindings to the
  extent that its nesting may imply.

  This form will fail to concretize when not compiling for
  hosted execution.
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
  unique_member from_rhombus
  unique_member to_rhombus
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
}
