#lang pille

module reader ~lang rhombus/reader:
  ~lang "spmd.rhm"

import:
  pille

export:
  all_from(pille):
    except:
      #'
      break
      continue
      for

//==============================================================================
export implicit program_mask :: Simd(Boolean, _) || Unmasked(_)

export struct Unmasked(pc :: pos_int)

fun simd_program_mask
| (using program_mask :: Unmasked(pc)):
    #true :: Simd(Boolean, pc)
| (using program_mask):
    program_mask

//==============================================================================
export const_expr.macro 'program_count':
  'match type_of(program_mask)
   | Simd(_, pc): pc
   | Unmasked(pc): pc'

export const_bind.macro 'program_count':
  'equal_to(program_count)'

export expr.macro 'program_count':
  'const(program_count)'

//==============================================================================
special_name.def varying_simd

export struct #%Varying(α :: type, pc :: pos_int):
  $varying_simd :: SparseSimd(α, pc)

coercion (src :: α) :: δ && #%Varying(β, pc):
  ~when !(α matches #%Varying(_, _))
  ~when α coerces_to β
  #%Varying(β, pc){src :: β}

coercion (src :: #%Varying(α, pc)) :: δ && #%Varying(β, pc):
  ~when SparseSimd(α, pc) coerces_to SparseSimd(β, pc)
  δ{src.$varying_simd}

unify(α, #%Varying(β, pc)):
  ~when !(α matches #%Varying(_, _))
  #%Varying(unify(α, β), pc)

unify(#%Varying(α, pc), #%Varying(β, pc)):
  #%Varying(unify(α, β), pc)

//==============================================================================
export const_expr.macro 'Varying($α)':
  '#%Varying($α, program_count)'

export expr.macro 'Varying($α)':
  'const(Varying($α))'

export const_bind.macro 'Varying($α)':
  '#%Varying($α, program_count)'

//==============================================================================
export expr.macro 'program_index':
  'get_program_index()'

fun get_program_index(using program_mask) :: Varying(ι):
  ~where ι = UInt(bit_length(program_count - 1))
  Varying(ι){iota}

//==============================================================================
method (lhs :: α).$add(rhs :: α, using program_mask) :: α:
  ~where Varying(BinaryInteger) = α
  α{simd_program_mask().sparse_add(lhs.$varying_simd, rhs.$varying_simd)}

method (lhs :: α).$sub(rhs :: α, using program_mask) :: α:
  ~where Varying(BinaryInteger) = α
  α{simd_program_mask().sparse_sub(lhs.$varying_simd, rhs.$varying_simd)}

method (lhs :: α).$mul(rhs :: α, using program_mask) :: α:
  ~where Varying(BinaryInteger) = α
  α{simd_program_mask().sparse_mul(lhs.$varying_simd, rhs.$varying_simd)}

method (lhs :: α).$div_trunc(rhs :: α, using program_mask) :: α:
  ~where Varying(BinaryInteger) = α
  α{simd_program_mask().sparse_div_trunc(lhs.$varying_simd, rhs.$varying_simd)}

method (lhs :: α).$rem_trunc(rhs :: α, using program_mask) :: α:
  ~where Varying(BinaryInteger) = α
  α{simd_program_mask().sparse_rem_trunc(lhs.$varying_simd, rhs.$varying_simd)}

//==============================================================================
method (lhs :: α).$eq(rhs :: α, using program_mask) :: Varying(Boolean):
  ~where Varying(Bitwise || RawPtr || PtrTo(_)) = α
  Varying(Boolean){simd_program_mask().sparse_eq(lhs.$varying_simd, rhs.$varying_simd)}

method (lhs :: α).$ne(rhs :: α, using program_mask) :: Varying(Boolean):
  ~where Varying(Bitwise || RawPtr || PtrTo(_)) = α
  Varying(Boolean){simd_program_mask().sparse_ne(lhs.$varying_simd, rhs.$varying_simd)}

method (lhs :: α).$lt(rhs :: α, using program_mask) :: Varying(Boolean):
  ~where Varying(BinaryInteger || RawPtr || PtrTo(_)) = α
  Varying(Boolean){simd_program_mask().sparse_lt(lhs.$varying_simd, rhs.$varying_simd)}

method (lhs :: α).$le(rhs :: α, using program_mask) :: Varying(Boolean):
  ~where Varying(BinaryInteger || RawPtr || PtrTo(_)) = α
  Varying(Boolean){simd_program_mask().sparse_le(lhs.$varying_simd, rhs.$varying_simd)}

method (lhs :: α).$gt(rhs :: α, using program_mask) :: Varying(Boolean):
  ~where Varying(BinaryInteger || RawPtr || PtrTo(_)) = α
  Varying(Boolean){simd_program_mask().sparse_lt(lhs.$varying_simd, rhs.$varying_simd)}

method (lhs :: α).$ge(rhs :: α, using program_mask) :: Varying(Boolean):
  ~where Varying(BinaryInteger || RawPtr || PtrTo(_)) = α
  Varying(Boolean){simd_program_mask().sparse_le(lhs.$varying_simd, rhs.$varying_simd)}

//==============================================================================
method (lhs :: φ).$add(using program_mask, rhs :: Varying(BinaryInteger)) :: φ:
  ~where Varying(PtrTo(_)) = φ
  φ{simd_program_mask().sparse_add(lhs.$varying_simd, rhs.$varying_simd)}

method (lhs :: φ).$add(using program_mask, rhs :: ρ && BinaryInteger) :: φ:
  ~where Varying(PtrTo(_)) = φ
  φ{simd_program_mask().sparse_add(
      lhs.$varying_simd,
      (rhs :: Varying(ρ)).$varying_simd)}

method (lhs :: φ).$add(using program_mask, const rhs :: int) :: φ:
  ~where Varying(PtrTo(_)) = φ
  φ{simd_program_mask().sparse_add(lhs.$varying_simd, rhs)}

method (lhs :: φ && PtrTo(_)).$add(using program_mask, rhs :: Varying(BinaryInteger)) :: Varying(φ):
  Varying(φ){
    simd_program_mask().sparse_add(
      (lhs :: Varying(φ)).$varying_simd,
      rhs.$varying_simd)}

//==============================================================================
method (lhs :: φ).$sub(using program_mask, rhs :: Varying(BinaryInteger)) :: φ:
  ~where Varying(PtrTo(_)) = φ
  φ{simd_program_mask().sparse_sub(lhs.$varying_simd, rhs.$varying_simd)}

method (lhs :: φ).$sub(using program_mask, rhs :: ρ && BinaryInteger) :: φ:
  ~where Varying(PtrTo(_)) = φ
  φ{simd_program_mask().sparse_sub(
      lhs.$varying_simd,
      (rhs :: Varying(ρ)).$varying_simd)}

method (lhs :: φ).$sub(using program_mask, const rhs :: int) :: φ:
  ~where Varying(PtrTo(_)) = φ
  φ{simd_program_mask().sparse_sub(lhs.$varying_simd, rhs)}

method (lhs :: φ && PtrTo(_)).$sub(using program_mask, rhs :: Varying(BinaryInteger)) :: Varying(φ):
  Varying(φ){
    simd_program_mask().sparse_sub(
      (lhs :: Varying(φ)).$varying_simd,
      rhs.$varying_simd)}

//==============================================================================
method (ptrs :: φ).$index_read(using program_mask) :: Varying(α):
  ~where Varying(PtrTo(α)) = φ
  Varying(α){simd_program_mask().sparse_load(ptrs.$varying_simd)}

method (ptrs).$index_read(using program_mask, idx) :: Varying(α):
  ~where Varying(PtrTo(α)) = type_of(ptrs + idx)
  (ptrs + idx)[]

method (ptrs :: φ).$index_write(using program_mask, value :: β) :: Void:
  ~where Varying(PtrMut(α)) = φ
  ~when β coerces_to Varying(α)
  simd_program_mask().sparse_store(
    ptrs.$varying_simd,
    (value :: Varying(α)).$varying_simd)

method (ptrs).$index_write(using program_mask, idx, value :: β) :: Void:
  ~where Varying(PtrMut(α)) = type_of(ptrs + idx)
  ~when β coerces_to Varying(α)
  (ptrs + idx)[] := value

//==============================================================================
method (inout lhs :: α).$assign(rhs :: β, using program_mask) :: Void:
  ~where Varying(_) = α
  ~when β coerces_to α
  simd_program_mask().sparse_assign(lhs.$varying_simd, (rhs :: α).$varying_simd)

//==============================================================================
export expr.macro 'if $(test :: expr_meta.Parsed)
                   | $then
                   | $else':
  'block:
     expr.preparse then: $then
     expr.preparse else: $else
     let test = $test
     const.match type_of(test)
     | CoercesTo(Boolean):
         pille.if test
         | then
         | else
     | _:
         let test :: Varying(Boolean) = test
         let then_mask = make_then_mask(test)
         pille.when then_mask.any()
         | using program_mask = then_mask
           then
         let else_mask = make_else_mask(test)
         pille.when else_mask.any()
         | using program_mask = else_mask
           else
     #void'

fun make_then_mask(using program_mask, test :: Varying(Boolean)):
  simd_program_mask().sparse_refine_mask(test.$varying_simd)

fun make_else_mask(using program_mask, test :: Varying(Boolean)):
  let m = simd_program_mask()
  m.sparse_refine_mask(m.sparse_not(test.$varying_simd))

//==============================================================================
export expr.macro 'while $(test :: expr_meta.Parsed): $body':
  'block:
     expr.preparse body: $body
     #'loop(mask = simd_program_mask()):
       using program_mask = mask
       let test = $test
       const.match type_of(test)
       | CoercesTo(Boolean):
           pille.if test
           | body
             continue loop(mask)
           | break loop
       | _:
           let test :: Varying(Boolean) = test
           let new_mask = mask.sparse_refine_mask(test.$varying_simd)
           pille.unless new_mask.any() | break loop
           using program_mask = new_mask
           body
           continue loop(new_mask)'
