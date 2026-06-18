#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title{Memory Layout}

@doc(
  const_annot.macro 'alignment'
){}

@doc(
  const.fun sizeof(α :: type) :: nat
){}

@doc(
  const.fun alignof(α :: type) :: alignment
){}

@doc(
  const.fun strideof(α :: type) :: nat
){}
