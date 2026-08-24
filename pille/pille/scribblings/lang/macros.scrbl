#lang rhombus/scribble/manual

@(import:
    "common.rhm" open:
      except:
        ::
        fun
        math
        operator

    meta_label:
      only_meta 0:
        rhombus/static/and_meta open:
          except:
            expr)

@title{Metaprogramming with Macros}

Pille macros are written in Rhombus, and
@rhombuslangname(pille) provides most of the same
@rhm_decl(meta) bindings as
@rhombuslangname(rhombus/static/and_meta) (except those
which pertain to Rhombus-specific macros).

@//=========================================================================
@section{Expression Macros}

@doc(
  space.enforest expr
){}

@doc(
  ~meta
  def expr_meta.space
){}

@doc(
  global_defn.macro 'expr.macro $macro_patterns'

  local_defn.macro 'expr.macro $macro_patterns'
){}

@doc(
  ~meta

  syntax_class expr_meta.Parsed:
    kind: ~group
    fields:
      group

  syntax_class expr_meta.AfterPrefixParsed(op_name):
    kind: ~group
    fields:
      group
      [tail, ...]

  syntax_class expr_meta.AfterInfixParsed(op_name):
    kind: ~group
    fields:
      group
      [tail, ...]

  syntax_class expr_meta.NameStart:
    kind: ~group
    fields:
      name
      [head, ...]
      [tail, ...]

  syntax_class expr_meta.BoundNameStart:
    kind: ~group
    fields:
      name
      [head, ...]
      [tail, ...]
){}

@doc(
  ~meta
  annot.macro 'expr_meta.Packed'
){
  Satisfied by parsed/packed terms for the @rhm_space(expr)
  space.
}

@doc(
  ~meta
  fun expr_meta.pack_concretize(
    rhm_expr :: Group,
  ) :: expr_meta.Packed
){
  Creates an opaque @nontermref(expr) from a
  @italic{Rhombus} expression @rhombus(rhm_expr) which
  performs its concretization.
}

@doc(
  ~meta
  fun expr_meta.unpack_concretize(
    packed :: expr_meta.Packed,
  ) :: Term
){
  Unpacks any opaque @nontermref(expr) as a Rhombus
  expression which performs its concretization. The result
  is always an opaque Rhombus expression term, regardless of
  how @rhombus(packed) was created.
}

@doc(
  ~meta
  fun expr_meta.pack_expr(
    stx :: Group,
  ) :: expr_meta.Packed
){
  Creates an opaque @nontermref(expr) with the same meaning
  as @rhombus(stx).
}

@doc(
  ~meta
  fun expr_meta.pack_body(
    stx :: Syntax,
  ) :: expr_meta.Packed
){
  Creates an opaque @nontermref(expr) that represents the
  interpretation of @rhombus(stx) as a @nontermref(body).
}

@doc(
  ~meta
  fun expr_meta.pack_specl_expr(
    spexp :: specl_expr_meta.Packed,
  ) :: expr_meta.Packed
){}

@doc(
  ~meta
  fun expr_meta.pack_specl_rhombus_expr(
    rhm_expr :: Group,
  ) :: expr_meta.Packed
){}

@doc(
  ~meta
  syntax_class expr_meta.EqualsOp:
    ~kind: ~sequence

  syntax_class expr_meta.AnnotOp:
    ~kind: ~sequence

  syntax_class expr_meta.DotOp:
    ~kind: ~sequence

  syntax_class expr_meta.DollarOp:
    ~kind: ~sequence

  syntax_class expr_meta.DotDollarOp:
    ~kind: ~sequence

  syntax_class expr_meta.InoutOp:
    ~kind: ~sequence
){
  Syntax classes matching bindings in the @rhm_space(expr)
  space that are sometimes recognized as literals within
  other forms. These are provided merely for convenience;
  @rhombus(bound_as, ~unquote_bind) works just as well.
}

@//=========================================================================
@section{Local Definition Macros}

@doc(
  space.transform local_defn
){}

@doc(
  ~meta
  def local_defn_meta.space
){}

@doc(
  global_defn.macro 'local_defn.macro $local_defn_macro_case'

  local_defn.macro 'local_defn.macro $local_defn_macro_case'

  global_defn.macro 'local_defn.macro
                     | $local_defn_macro_case
                     | ...'

  local_defn.macro 'local_defn.macro
                    | $local_defn_macro_case
                    | ...'

  grammar local_defn_macro_case
  | '$defined_name $pattern ...':
      $option; ...
      $rhombus_body
      ...

  grammar option
  | ~op_stx: $id
  | ~op_stx $id
  | ~name_prefix: $id
  | ~name_prefix $id
){
  Defines a new @tech{local definition} macro. The result of
  the @rhombus(rhombus_body) sequence must be a new
  @rhombus(Syntax, ~annot) object that will be spliced in
  place of the macro invocation.
}

@doc(
  global_defn.macro 'local_defn.block_macro $block_macro_case'

  local_defn.macro 'local_defn.block_macro $block_macro_case'

  grammar block_macro_case
  | '$defined_name $pattern ...
     $pattern
     ...':
      $option; ...
      $rhombus_body
      ...

  grammar option
  | ~op_stx: $id
  | ~op_stx $id
  | ~name_prefix: $id
  | ~name_prefix $id
){
  Defines a new @tech{local definition} @deftech{block
  macro}. A block macro consumes the entire
  @nontermref(body) which it heads, and must produce a
  @rhombus(Group, ~annot) syntax object for a Pille
  @italic{expression} which will stand in for that
  @nontermref(body).
}

@//=========================================================================
@section{Specialization Expression Macros}

@doc(
  space.enforest specl_expr
){}

@doc(
  ~meta
  def specl_expr_meta.space
){}

@doc(
  global_defn.macro 'specl_expr.macro $macro_patterns'

  local_defn.macro 'specl_expr.macro $macro_patterns'
){}

@doc(
  ~meta
  syntax_class specl_expr_meta.Parsed:
    kind: ~group
    fields:
      group

  syntax_class specl_expr_meta.AfterPrefixParsed(op_name):
    kind: ~group
    fields:
      group
      [tail, ...]

  syntax_class specl_expr_meta.AfterInfixParsed(op_name):
    kind: ~group
    fields:
      group
      [tail, ...]

  syntax_class specl_expr_meta.NameStart:
    kind: ~group
    fields:
      name
      [head, ...]
      [tail, ...]

  syntax_class specl_expr_meta.BoundNameStart:
    kind: ~group
    fields:
      name
      [head, ...]
      [tail, ...]
){}

@doc(
  ~meta
  annot.macro 'specl_expr_meta.Packed'
){
  Satisfied by parsed/packed terms for the
  @rhm_space(specl_expr) space.
}

@doc(
  ~meta
  syntax_class specl_expr_meta.Literal:
    kind: ~term
){
  Recognizes @nontermref(specl_literal)s.
}

@doc(
  ~meta
  fun specl_expr_meta.pack_rhombus_expr(
    rhm_expr :: Group,
  ) :: specl_expr_meta.Packed
){
  Creates an opaque @nontermref(specl_expr) that is
  implemented by the @italic{Rhombus} expression
  @rhombus(rhm_expr).
}

@doc(
  ~meta
  fun specl_expr_meta.unpack_rhombus_expr(
    packed :: specl_expr_meta.Packed,
  ) :: Term
){
  Unpacks any opaque @nontermref(specl_expr) to its Rhombus
  implementation. The result is always an opaque Rhombus
  expression term, regardless of how @rhombus(packed) was
  created.
}

@doc(
  ~meta
  fun specl_expr_meta.as_rhombus_expr(
    spexp :: Group,
  ) :: Term
){
  Like @rhombus(specl_expr_meta.unpack_rhombus_expr), but
  where parsing of @rhombus(spexp) is delayed until the
  resulting Rhombus expression is ultimately expanded.
}

@doc(
  ~meta
  fun specl_expr_meta.pack_specl_expr(
    spexp :: Group,
  ) :~ specl_expr_meta.Packed
){
  Creates an opaque @nontermref(specl_expr) with the same
  meaning as @rhombus(spexp).
}

@//=========================================================================
@section{Specialization Annotation Macros}

@doc(
  space.enforest specl_annot
){}

@doc(
  ~meta
  def specl_annot_meta.space
){}

@doc(
  global_defn.macro 'specl_annot.macro $macro_patterns'

  local_defn.macro 'specl_annot.macro $macro_patterns'
){}

@doc(
  ~meta
  syntax_class specl_annot_meta.Parsed:
    kind: ~group
    fields:
      group

  syntax_class specl_annot_meta.AfterPrefixParsed(op_name):
    kind: ~group
    fields:
      group
      [tail, ...]

  syntax_class specl_annot_meta.AfterInfixParsed(op_name):
    kind: ~group
    fields:
      group
      [tail, ...]

  syntax_class specl_annot_meta.NameStart:
    kind: ~group
    fields:
      name
      [head, ...]
      [tail, ...]

  syntax_class specl_annot_meta.BoundNameStart:
    kind: ~group
    fields:
      name
      [head, ...]
      [tail, ...]
){}

@doc(
  ~meta
  annot.macro 'specl_annot_meta.Packed'
){
  Satisfied by parsed/packed terms for the
  @rhm_space(specl_annot) space.
}

@doc(
  ~meta
  fun specl_annot_meta.pack_rhombus_predicate(
    pred_expr :: Group,
  ) :: specl_annot_meta.Packed
){
  Creates an opaque @nontermref(specl_annot) term
  implemented by @rhombus(pred_expr) (which must be a
  @italic{Rhombus} expression evaluating to a predicate
  procedure).
}

@doc(
  ~meta
  fun specl_annot_meta.unpack_rhombus_predicate(
    packed :: specl_annot_meta.Packed,
  ) :: Term
){
  Unpacks any opaque @nontermref(specl_annot) to its Rhombus
  implementation (as an opaque expression evaluating to a
  predicate procedure).
}

@//=========================================================================
@section{Specialization Binding Macros}

@doc(
  space.enforest specl_bind
){}

@doc(
  ~meta
  def specl_bind_meta.space
){}

@doc(
  global_defn.macro 'specl_bind.macro $macro_patterns'

  local_defn.macro 'specl_bind.macro $macro_patterns'
){}

@doc(
  ~meta
  syntax_class specl_bind_meta.Parsed:
    kind: ~group
    fields:
      group

  syntax_class specl_bind_meta.AfterPrefixParsed(op_name):
    kind: ~group
    fields:
      group
      [tail, ...]

  syntax_class specl_bind_meta.AfterInfixParsed(op_name):
    kind: ~group
    fields:
      group
      [tail, ...]

  syntax_class specl_bind_meta.NameStart:
    kind: ~group
    fields:
      name
      [head, ...]
      [tail, ...]

  syntax_class specl_bind_meta.BoundNameStart:
    kind: ~group
    fields:
      name
      [head, ...]
      [tail, ...]
){}

@doc(
  ~meta
  annot.macro 'specl_bind_meta.Packed'
){
  Satisfied by parsed/packed terms for the
  @rhm_space(specl_bind) space.
}

@doc(
  ~meta
  fun specl_bind_meta.pack_specl_bind(
    stx :: Group,
  ) :: specl_bind_meta.Packed
){
  Creates an opaque @nontermref(specl_bind) with the same
  meaning as @rhombus(stx).
}

@doc(
  ~meta
  fun specl_bind_meta.pack_metavariable(
    id :: Identifier,
  ) :: specl_bind_meta.Packed
){
  Creates an opaque @nontermref(specl_bind) representing an
  occurrence of @rhombus(id) as a metavariable. Two such
  occurrences with equal @rhombus(id)s (in the sense of
  @rhombus(syntax_meta.equal_name_and_scopes)) are
  considered to refer to the same metavariable.
}

@doc(
  ~meta
  fun specl_bind_meta.pack_conjunction(
    sub_bindings
      :: Listable.to_list
      && NonemptyList.of(specl_bind_meta.Packed) = [],
  ) :: specl_bind_meta.Packed
){
  Creates an opaque @nontermref(specl_bind) representing the
  conjunction of the @rhombus(sub_bindings) (in the same
  sense as the @pille_specl_bind(&&) operator).
}

@doc(
  ~meta
  fun specl_bind_meta.pack_disjunction(
    sub_bindings
      :: Listable.to_list
      && NonemptyList.of(specl_bind_meta.Packed) = [],
  ) :: specl_bind_meta.Packed
){
  Creates an opaque @nontermref(specl_bind) representing the
  disjunction of the @rhombus(sub_bindings) (in the same
  sense as the @pille_specl_bind(||) operator).
}

@doc(
  ~meta
  fun specl_bind_meta.pack_decomposition(
    extractor :: Group,
    sub_bindings
      :: Listable.to_list
      && [specl_bind_meta.Packed, ...] = [],
  ) :: specl_bind_meta.Packed
){
  Creates an opaque @nontermref(specl_bind) representing the
  extraction (and subsequent binding) of sub-components from
  the target value.

  The @rhombus(extractor) must be a @italic{Rhombus}
  expression which evaluates to a function of one argument;
  when the binding is applied, that function will be called
  with the target value as its argument, and it must then
  return exactly as many values as there are
  @rhombus(sub_bindings); each sub-binding is then applied
  with the corresponding return value as its target.

  The @rhombus(extractor) may contain references to prior
  metavariables.

  The exposed metavariables of all @rhombus(sub_bindings)
  are combined to form the exposed metavariables of the
  decomposition.
}

@doc(
  ~meta
  fun specl_bind_meta.pack_equal_to(
    rhm_expr :: Group,
  ) :: specl_bind_meta.Packed
){
  Creates an opaque @nontermref(specl_bind) that matches
  only when the target value is equal (in the sense of
  @pille_specl_expr(==)) to the result of the
  @italic{Rhombus} expression @rhombus(rhm_expr).

  The @rhombus(rhm_expr) may contain references to prior
  metavariables.
}

@doc(
  ~meta
  fun specl_bind_meta.pack_side_condition(
    rhm_expr :: Group,
  ) :: specl_bind_meta.Packed
){
  Creates an opaque @nontermref(specl_bind) that matches
  only when the result of the @italic{Rhombus} expression
  @rhombus(rhm_expr) is not @rhombus(#false) (the target
  value is ignored).

  The @rhombus(rhm_expr) may contain references to prior
  metavariables.
}

@doc(
  ~meta
  fun specl_bind_meta.pack_nested_binding(
    lhs_bind :: specl_bind_meta.Packed,
    rhs_rhm_expr :: Group,
  ) :: specl_bind_meta.Packed
){
  Creates an opaque @nontermref(specl_bind) that ignores the
  target value, and instead attempts to match the
  @rhombus(lhs_bind) to the result of the @italic{Rhombus}
  expression @rhombus(rhs_rhm_expr).

  The @rhombus(rhm_expr) may contain references to prior
  metavariables (not including those only exposed by the
  @rhombus(lhs_bind)). Metavariables exposed by the
  @rhombus(lhs_bind) @italic{are} exposed by the resulting
  form, however.
}

@doc(
  ~meta
  fun specl_bind_meta.pack_parallel_bindings(
    sub_bindings
      :: Listable.to_list
      && [specl_bind_meta.Packed, ...],
  ) :: specl_bind_meta.Packed
){
  Creates an opaque @nontermref(specl_bind) which expects a
  Rhombus @rhombus(List) as the target value, with the same
  number of elements as @rhombus(sub_bindings), and tries to
  match each sub-binding to its respective element from the
  target.
}

@doc(
  ~meta
  fun specl_bind_meta.compile(
    binding :: specl_bind_meta.Packed,
    rhm_target_expr :: Group,
    rhm_body_expr :: Group,
  ) :: Term
){
  ``Compiles'' a complete use-site of a
  @nontermref(specl_bind) to an opaque @italic{Rhombus}
  expression, where:
  @itemlist(
    @item{the @rhombus(binding) is an opaque
    @nontermref(specl_bind),},
    @item{the @rhombus(rhm_target_expr) is a Rhombus
    expression whose result is the target of the binding,},
    @item{and the @rhombus(rhm_body_expr) is a Rhombus
    expression for which the exposed metavariables of the
    @rhombus(binding) (if any) will be in-scope.})
}
