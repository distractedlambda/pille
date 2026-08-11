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
  specl.fun tuple_length(τ && AnyTuple) :: nat
){}

@doc(
  specl.fun TupleElement(τ && AnyTuple, idx :: nat) :: type
){}

@doc(
  expr.macro '#%brackets [$expr, ...]'
){}

@doc(
  method (tup :: τ && AnyTuple).$index_read(specl idx :: nat)
    :: TupleElement(τ, idx)
){}

@doc(
  method (inout tup :: τ && AnyTuple).$index_write(
    specl idx :: nat,
    elem :: equal_to(TupleElement(τ, idx)),
  ) :: Void
){}
