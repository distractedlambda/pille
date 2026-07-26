#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title{Memory Layout}

@doc(
  specl_annot.macro 'alignment'
){}

@doc(
  specl.fun sizeof(α :: type) :: nat
){}

@doc(
  specl.fun alignof(α :: type) :: alignment
){}

@doc(
  specl.fun strideof(α :: type) :: nat
){}
