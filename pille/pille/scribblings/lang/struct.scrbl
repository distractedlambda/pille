#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title{User-Defined Types}

@doc(
  global_defn.macro 'struct $id_name $maybe_specl_args'
  global_defn.macro 'struct $id_name $maybe_specl_args:
                       $option; ...
                       $field
                       ...'

  grammar option
  | ~name $id_or_op_name
  | ~name: $id_or_op_name

  grammar maybe_specl_args
  | ($specl_bind, ...)
  | ε

  grammar field
  | $member_name #,(pille_expr(::)) $field_type

  grammar field_type
  | $specl_expr
){
  Defines @rhombus(id_name) as a new type product type or
  set of product types. More specifically:
  @itemlist(
    @item{If the @rhombus(maybe_specl_args) are given (even
    as just @rhombus(())), then @rhombus(id_name) is bound
    to a specialization function (as if by
    @pille_global_defn(specl.fun)) that takes as many
    arguments as there are @rhombus(specl_bind)s, and
    returns a @pille_specl_annot(type), such that every
    unique combination of argument values results in a
    unique type. Additionally, the @rhombus(id_name) is
    bound as an appropriate @tech{specialization binding}
    form.},

    @item{Otherwise, @rhombus(id_name) is bound to a
    specialization value (as if by
    @pille_global_defn(specl.def)) that is a unique
    @pille_specl_annot(type).})

  Each @rhombus(field) defines a data member, where the
  respective @rhombus(field_type) computes the field's type
  (potentially using bindings established in the
  @rhombus(specl_bind)s). A @rhombus(field_type) is allowed
  to refer to the @rhombus(id_name), but only in ways that
  do not trigger true dependency cycles during
  concretization.

  Each @rhombus(field) can be accessed by its
  @nontermref(member_name) as an assignable property of the
  new type(s), as if there were corresponding
  @pille_global_defn(property) definitions.

  A definition for the @pille_expr($new) method (usually
  invoked implicitly by the @pille_expr(#%comp) operator) is
  provided for creating instances of the new type(s), where
  the receiver is a @pille_specl_expr(Specl) value wrapping
  the type(s), and each argument gives the value of a single
  @rhombus(field). Coercions are applied whenever an
  argument's type does not match its field's type
  exactly. This @pille_expr($new) definition has an
  automatic priority, so it cannot be superseded.

  A definition for the @pille_expr($assign) method (usually
  invoked implicitly by the @pille_expr(:=) operator) is
  provided for assigning to instances of the new type(s),
  where the RHS of the assignment is coerced to the
  destination type if necessary. The actual assignment is
  carried out field-by-field (after any coercion of the
  RHS), so @pille_expr($assign) methods specific to
  @rhombus(field) types @italic{will} be used (and thus the
  overall assignment may behave differently than a rote
  copy). This @pille_expr($assign) definition has
  @pille_priority(fallback) priority, so it can be
  superseded.
}
