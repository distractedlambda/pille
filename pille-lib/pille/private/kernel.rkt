#lang rhombus/static

module reader ~lang rhombus/reader:
  ~lang "kernel.rhm"

import:
  "kernel/cond_comp.rhm" open
  "kernel/const_annot.rhm" open
  "kernel/const_annot_forms.rhm" open
  "kernel/const_bind.rhm" open
  "kernel/const_bind_forms.rhm" open
  "kernel/const_def.rhm" open
  "kernel/const_expr.rhm" open
  "kernel/const_expr_forms.rhm" open
  "kernel/const_fun.rhm" open
  "kernel/const_operator.rhm" open
  "kernel/core_type_forms.rhm" open
  "kernel/core_type_ops.rhm" open
  "kernel/expr.rhm" open
  "kernel/expr_forms.rhm" open
  "kernel/fun.rhm" open
  "kernel/if.rhm" open
  "kernel/implicit.rhm" open
  "kernel/labeled_expr.rhm" open
  "kernel/labeled_expr_forms.rhm" open
  "kernel/local_defn.rhm" open
  "kernel/local_defn_forms.rhm" open
  "kernel/method.rhm" open
  "kernel/operator.rhm" open
  "kernel/special_name.rhm" open
  "kernel/struct.rhm" open
  "kernel/ub_policy.rhm" open
  "kernel/unify.rhm" open

  "kernel/prim.rhm" // not opened

  rhombus/static/meta as rhm_meta

  rhombus/static/meta as ~none:
    expose:
      decl
      decl_meta
      defn as global_defn
      defn_meta as global_defn_meta
      expo
      expo_meta
      impo
      impo_meta
      meta
      namespace
      namespace_meta
      operator_order
      space
      space_clause
      space_meta_clause
      syntax_meta
      syntax_parameter
      syntax_parameter_meta

  rhombus/static/meta open:
    only_meta 1
    except_space namespace

  meta -1: // HACK
    rhombus/static/meta as unmeta

  rhombus/static/meta open:
    only_space impo expo operator_order space_clause unmeta.space_meta_clause

export:
  all_from(rhombus/static/meta)

  #{#%module-begin}
  #%module_block

  alias
  export
  import
  module
  namespace

  prim

  // FIXME: restrict these to the modpath space once that's exposed
  except_space rhm_meta.annot rhm_meta.bind rhm_meta.expr:
    / ! #%literal

  only_space global_defn:
    coercion
    implicit
    method
    property
    struct
    unify

  only_space impo expo operator_order:
    all_from(rhombus/static)

  only_space namespace:
    const
    ub

  only_space namespace space:
    const_annot
    const_bind
    const_expr
    implicit
    labeled_expr
    local_defn
    special_name

  rename:
    pille_expr as expr
    pille_fun as fun
    pille_operator as operator

  only_space const_annot const_bind const_expr pille_expr labeled_expr local_defn special_name:
    all_from("kernel/cond_comp.rhm")
    all_from("kernel/const_annot_forms.rhm")
    all_from("kernel/const_bind.rhm")
    all_from("kernel/const_bind_forms.rhm")
    all_from("kernel/const_expr_forms.rhm")
    all_from("kernel/core_type_forms.rhm")
    all_from("kernel/core_type_ops.rhm")
    all_from("kernel/expr_forms.rhm")
    all_from("kernel/fun.rhm")
    all_from("kernel/if.rhm")
    all_from("kernel/implicit.rhm")
    all_from("kernel/labeled_expr.rhm")
    all_from("kernel/labeled_expr_forms.rhm")
    all_from("kernel/local_defn.rhm")
    all_from("kernel/local_defn_forms.rhm")
    all_from("kernel/method.rhm")
    all_from("kernel/special_name.rhm")
    all_from("kernel/struct.rhm")
    all_from("kernel/ub_policy.rhm")

  meta:
    only_space namespace:
      const_annot_meta
      const_bind_meta
      const_expr_meta
      implicit_meta
      local_defn_meta

    rename:
      pille_expr_meta as expr_meta
