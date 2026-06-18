#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title{Pille: Extensible Low-Level Programming}
@// TODO: have this reviewed by a native French speaker
@// @italic{Or: @bold{P}ille @bold{I}ntègre @bold{L}LVM avec un @bold{L}angage @bold{E}xtensible}

@margin_note{This is a research project and a
work-in-progress; exploration is welcome, but expect bugs,
sharp edges, and frequent breaking changes!}

Pille is a project that seeks to extend the @docref(rhm_doc)
language family with first-class support for low-level and
high-performance programming, leveraging a
systems-programming discipline and an
@(llvm_project)-powered backend to generate competitive
machine code.

Pille is also a @language_tech, employing primitives and
semantics modeled after production systems-programming
languages, but architected with extension and customization
in mind.

@table_of_contents()
@include_section("lang.scrbl")
@include_section("hosted.scrbl")
@include_section("standalone.scrbl")
@include_section("meta.scrbl")
@include_section("llvm_bindings.scrbl")
