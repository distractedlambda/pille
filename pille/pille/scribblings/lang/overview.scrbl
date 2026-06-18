#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title(~tag: "Lang_Overview"){Overview}

@section{Compilation}
Starting from surface syntax (which uses
@docref(@shrubbery_doc)), a Pille program progresses
through:
@itemlist(
  @item{@deftech{Parsing}, which uses a Rhombus-based
  macro-expansion process;},
  @item{@deftech{Concretization}, which determines types,
  evaluates constant expressions, and bakes in
  target-specific information;},
  @item{@deftech{Lowering}, which generates LLVM IR
  for the concretized program;},
  @item{and @deftech{code generation}, which uses LLVM to
  optimize the program and generate target-native machine
  code.})

The combination of these steps is referred to as
@defterm{compilation}, since they comprise the better part
of a traditional static compiler. @italic{Unlike} in a
traditional compiler, the parsing, concretization, and
lowering steps are fully programmable and extensible
(see the dedicated @secref("Metaprogramming") section for
more).

@section{Execution}
There are two ``modes'' of Pille execution:
@itemlist(
  @item{In @seclink("Hosted_Execution"){hosted execution},
  Pille code is executed as part of a larger Rhombus host
  program, and the two languages can interoperate to some
  degree. With the exception of parsing, Pille compilation
  occurs at the @italic{same} @phase_level_tech as
  execution, and dynamic Rhombus values can be promoted to
  Pille @tech{constants}.},
  @item{In @seclink("Standalone_Execution"){standalone
  execution}, Pille code is compiled into a target-native
  object file, which is then linked into a target-native
  executable or library. The resulting artifact has no
  dependency on Racket, Rhombus, or the Pille compiler, and
  may even be destined for a target that the Racket system
  does not otherwise support.})

@section{Constants}
@deftech{Constants} are values that do not directly
represent any machine-level data, but instead serve to
control and guide @tech{concretization}. Concretization is
also the only step which evaluates constant-level constructs
(such as constant expressions).

@tech{Lowering} is able to reference constants
computed by concretization, but does not directly manifest
them in any standard way; in other words, constants are
erased following lowering. This means that they do
not need to be directly machine-representable, let alone
representable in any fixed amount of memory. In practice,
this means that constants are represented during
concretization as Rhombus values.

@section{Dynamic Representations}
Dynamic representations, or @deftech{reprs} for short, are
the formats in which @tech{dynamic values} can manifest in
the lowered program. There are countably-infinite
reprs, but any given repr uses a finite number of bits and
has a fixed memory footprint (byte size and alignment).

@section{Types and Dynamic Values}
A @deftech{type} is a special kind of @tech{constant} that
pairs a @tech{repr} with ``meaning''; a @deftech{dynamic
value} is a type paired with a valid bit pattern for that
type's repr.

The ``meaning'' given by a type is the combination of
behaviors it specifies (methods, coercion rules, etc.), as
well as the ways in which that type might be specially
recognized by other constructs. For instance,
@pille_const_expr(Int(32)) and @pille_const_expr(UInt(32))
are two types with equivalent reprs that nonetheless mean
different things (signed v.s. unsigned integers), and the
distinct meanings are captured in the @italic{behaviors}
that the types specify (e.g. @pille_const_expr(Int(32)) will
sign-extend when coercing to a larger integer type, whereas
@pille_const_expr(UInt(32)) will zero-extend).

@tech{Concretization} performs guaranteed
@defterm{monomorphization} of dynamic expressions, meaning
that a given concretized expression ``has a type'' that will
be the type associated with all dynamic values resulting
from that expression's evaluation; this invariant is
sufficient to know the type of every dynamic value without
manifesting types during execution. In other words, types
are erased during execution, but are morally still
part of each dynamic value; two dynamic values with
differing types cannot be considered identical, even if they
have the same bit-pattern and @tech{repr}.

@section{Type Inference, Coercion, and Unification}
Pille utilizes simple bottom-up type inference during
@tech{concretization} to ascribe a single @tech{type} to
each expression and local binding. With only one exception,
the flow of type information is unidirectional, flowing from
bindings to their uses, and from subexpressions to their
parents.

The exception is @deftech{coercion}, which is the mechanism
that resolves type mismatches by inserting implicit
operations into the program. More specifically, whenever the
type of a concretized expression does not match a particular
expected type (usually from an explicit type annotation),
then concretization attempts to synthesize a valid
@defterm{coercer} (unary function) that will transform
values from that expression's type to the expected type; the
original expression is then wrapped in a call to the
coercer.

@deftech{Unification} is the complementary mechanism that
infers types for ``merge points'' in a program, such as the
result of an @tt{if} expression. More specifically, given
some set of source types, unification attempts to synthesize
a single destination type to which values of each source
type can coerce. This process is merely best-effort: it may
fail to find a destination type even when a valid one
exists.

Both coercion and unification are extensible mechanisms, in
that each type can specify its own coercion and unification
@defterm{rules}.

@section{Syntactic Elements}
@doc(
  ~nonterminal_key: expr ~space
  grammar expr
){
  A @deftech{dynamic expression}, which yields a
  @tech{dynamic value} when evaluated.
}

@doc(
  ~nonterminal_key: local_defn ~space
  grammar local_defn
){
  A @deftech{local definition}, which is allowed to appear
  only in ``local'' positions (such as within the body of a
  function).
}

@doc(
  ~nonterminal_key: global_defn ~space
  grammar global_defn
){
  A @deftech{global definition}, which is allowed to appear
  only in ``global'' positions (more or less the same
  positions as @rhm_ref_tech{nestable declarations}, except
  that @rhm_decl(export)-prefixing is allowed).

  Global definitions actually use the same binding space and
  parsing machinery as Rhombus @rhm_ref_tech{definitions},
  but their use in Pille code is more limited.
}
