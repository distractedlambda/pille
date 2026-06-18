#lang rhombus/scribble/manual

@(import:
    "common.rhm" open
    meta_label:
      pille/llvm open
      rhombus open:
        except:
          Function)

@title{LLVM Bindings}

@docmodule(pille/llvm)

@section{Overview}

Pille maintains its own bespoke Rhombus bindings to
@llvm_project's C API; an ``ordinary'' Pille user should not
need to worry about these, but they become necessary when
e.g. implementing custom IR generation for a construct.

@subsection{Finding and Loading LLVM}
@margin_note{When writing code that uses these bindings (or
altering the bindings themselves), it's recommended to use a
local debug build of LLVM with assertions enabled; this
makes it @italic{much} easier to catch and diagnose API
mis-use.}

At import time, the bindings load the library referred to by
the value of the @tt{PILLE_LIBLLVM_PATH} environment
variable (which must be set), and check that it is of a
compatible LLVM version (@bold{@llvm_version}). Users are
otherwise responsible for installing this version of LLVM
themselves.

In the future, we intend to bundle compatible versions of
LLVM with these bindings.

@subsection{Conventions and Safety}
As the @tt{unsafe} part of the name implies, these bindings
do not fully paper over the unsafeties of the LLVM API:
@itemlist(
  ~style: #'ordered,
  @item{LLVM will readily trigger undefined behavior
  whenever API contracts (however trivial) are violated, and
  these bindings make no comprehensive attempt to enforce
  all such contracts themselves.},
  @item{Like LLVM's C API, these bindings expect
  @bold{manual memory management}; they do not attempt to
  place any LLVM objects under the management of the garbage
  collector.})

@// TODO describe veneer convention

@section{API}
@doc(
  veneer Context

  fun Context() :: Context

  method (ctx :: Context).dispose() :: Void
){}

@doc(
  veneer Module

  fun Module(
    context :: Context,
    name :: ReadableString || Symbol,
  ) :: Module

  fun Module.from_bitcode(
    context :: Context,
    bitcode :: Bytes,
  ) :: maybe(Module)

  property (mod :: Module).context :: Context

  property
  | (mod :: Module).data_layout :: DataLayout
  | (mod :: Module).data_layout := (dl :: DataLayout)

  method (mod :: Module).set_data_layout_string(
    layout_string :: ReadableString,
  ) :: Void

  method (mod :: Module).dispose() :: Void

  method (mod :: Module).clone() :: Module

  method (mod :: Module).verify() :: Void

  method (mod :: Module).to_ir() :: String

  method (mod :: Module).to_bitcode() :: ImmutableBytes

  method (mod :: Module).link_in(other :: Module) :: Void

  method (mod :: Module).run_passes(
    ~target_machine: target_machine :: maybe(TargetMachine) = #false,
    pipeline :: NonemptyList,
  ) :: Void

  method (mod :: Module).compile(
    target_machine :: TargetMachine,
    file_type :: CodegenFileType = CodegenFileType.obj,
  ) :: ImmutableBytes
){}

@doc(
  veneer Module.Functions

  property (mod :: Module).functions :: Module.Functions

  property (fns :: Module.Functions).first :: maybe(Function)

  property (fns :: Module.Functions).last :: maybe(Function)

  method (fns :: Module.Functions).add(
    name :: ReadableString || Symbol,
    type :: FunctionType,
  ) :: Function

  method (fns :: Module.Functions).find(
    name :: ReadableString || Symbol,
  ) :: maybe(Function)

  method (fns :: Module.Functions).get_intrinsic(
    name :: ReadableString || Symbol,
    param_types :: Listable.to_list && [Type, ...] = [],
  ) :: Function
){}

@doc(
  veneer DataLayout

  fun DataLayout(string_rep :: ReadableString) :: DataLayout

  method (dl :: DataLayout).dispose() :: Void

  method (dl :: DataLayout).to_string() :: String

  property (dl :: DataLayout).byte_order :: ByteOrdering

  method (dl :: DataLayout).intptr_type(
    context :: Context,
    ~address_space: address_space :: NonnegInt = 0,
  ) :: IntType

  method (dl :: DataLayout).bit_size_of(
    type :: SizedType,
  ) :: PosInt

  method (dl :: DataLayout).store_size_of(
    type :: SizedType,
  ) :: PosInt

  method (dl :: DataLayout).abi_size_of(
    type :: SizedType,
  ) :: PosInt

  method (dl :: DataLayout).abi_alignment_of(
    type :: SizedType,
  ) :: PosInt

  method (dl :: DataLayout).preferred_alignment_of(
    type :: SizedType,
  ) :: PosInt
){}

@doc(
  veneer Type

  property (ty :: Type).kind :: Type.Kind

  property (ty :: Type).context :: Context

  method (ty :: Type).to_string() :: String
){}

@doc(
  veneer VoidType:
    extends Type

  fun VoidType(context :: Context) :: VoidType
){}

@doc(
  veneer LabelType:
    extends Type

  fun LabelType(context :: Context) :: LabelType
){}

@doc(
  veneer TokenType:
    extends Type

  fun TokenType(context :: Context) :: TokenType
){}

@doc(
  veneer MetadataType:
    extends Type

  fun MetadataType(context :: Context) :: MetadataType
){}

@doc(
  veneer SizedType:
    extends Type
){}

@doc(
  veneer IntType:
    extends SizedType

  fun IntType(context :: Context, width :: PosInt) :: IntType

  property (ty :: IntType).width :: PosInt
){}

@doc(
  veneer HalfType:
    extends SizedType

  fun HalfType(context :: Context) :: HalfType
){}

@doc(
  veneer FloatType:
    extends SizedType

  fun FloatType(context :: Context) :: FloatType
){}

@doc(
  veneer DoubleType:
    extends SizedType

  fun DoubleType(context :: Context) :: DoubleType
){}

@doc(
  veneer FunctionType:
    extends Type

  fun FunctionType(
    return_type :: Type,
    param_types :: Listable.to_list && [Type, ...],
    ~is_var_arg: is_var_arg :: Any = #false,
  ) :: FunctionType

  property (ty :: FunctionType).is_var_arg :: Boolean

  property (ty :: FunctionType).return_type :: Type

  property (ty :: FunctionType).param_types :: [Type, ...]
){}

@doc(
  veneer StructType:
    extends SizedType

  fun StructType(
    context :: Context,
    element_types :: Listable.to_list && [SizedType, ...],
    ~packed: packed :: Any = #false,
  ) :: StructType

  property (ty :: StructType).is_packed :: Boolean

  property (ty :: StructType).element_types :: [SizedType, ...]
){}

@doc(
  veneer ArrayType:
    extends SizedType

  fun ArrayType(
    element_type :: SizedType,
    length :: NonnegInt,
  ) :: ArrayType

  property (ty :: ArrayType).element_type :: SizedType

  property (ty :: ArrayType).length :: NonnegInt
){}

@doc(
  veneer PointerType:
    extends SizedType

  fun PointerType(
    context :: Context,
    ~address_space: address_space :: NonnegInt = 0,
  ) :: PointerType

  property (ty :: PointerType).address_space :: NonnegInt
){}

@doc(
  veneer VectorType:
    extends SizedType

  fun VectorType(
    element_type :: SizedType,
    length :: PosInt,
  ) :: VectorType

  property (ty :: VectorType).element_type :: SizedType

  property (ty :: VectorType).length :: PosInt
){}

@doc(
  veneer Value

  property (val :: Value).type :: Type

  property (val :: Value).context :: Context

  property
  | (val :: Value).name :: String
  | (val :: Value).name := (nm :: ReadableString || Symbol)

  method (val :: Value).to_string() :: String
){}

@doc(
  veneer Argument:
    extends Value

  property (arg :: Argument).parent :: Function

  property (arg :: Argument).next :: maybe(Argument)

  property (arg :: Argument).previous :: maybe(Argument)
){}

@doc(
  veneer Constant:
    extends Value
){}

@doc(
  veneer UndefValue:
    extends Constant

  fun UndefValue(type :: Type) :: UndefValue
){}

@doc(
  veneer PoisonValue:
    extends UndefValue

  fun PoisonValue(type :: Type) :: PoisonValue
){}

@doc(
  veneer ConstantPointerNull:
    extends Constant

  fun ConstantPointerNull(
    type :: PointerType,
  ) :: ConstantPointerNull
){}

@doc(
  veneer ConstantInt:
    extends Constant

  fun ConstantInt(type :: IntType, value :: Int) :: ConstantInt
){}

@doc(
  veneer ConstantFp:
    extends Constant

  fun ConstantFp(
    type :: HalfType || FloatType || DoubleType,
    value :: Real,
  ) :: ConstantFp
){}

@doc(
  veneer GlobalValue:
    extends Constant

  property (gv :: GlobalValue).parent :: maybe(Module)
){}
