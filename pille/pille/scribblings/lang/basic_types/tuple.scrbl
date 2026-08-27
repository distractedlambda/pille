#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title(~tag: "Basic_Types_Tuples"){Tuples}

@doc(
  type Tuple(element :: type, ...)
){}

@doc(
  specl_bind.macro 'AnyTuple'
){}

@doc(
  specl.property (AnyTuple as τ).length :: nat
){}

@doc(
  specl.method (AnyTuple as τ).ElementAt(idx :: nat) :: type
){}

@doc(
  expr.macro '#%brackets [$expr, ...]'
){}

@doc(
  method (tup :: AnyTuple as τ).$index_read(specl idx :: nat)
    :: τ.ElementAt(idx)
){}

@doc(
  method (inout tup :: AnyTuple as τ).$index_write(
    specl idx :: nat,
    elem :: CoercesTo(τ.ElementAt(idx)),
  ) :: Void
){}
