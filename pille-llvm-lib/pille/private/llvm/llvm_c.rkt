#lang racket

(require
  ffi/unsafe
  ffi/unsafe/define
  ffi/vector
  racket/treelist
  threading
  (for-syntax
   racket/list
   racket/syntax
   syntax/parse))

(define-ffi-definer define-llvm
  (ffi-lib
   (or (getenv "PILLE_LIBLLVM_PATH")
       (error "environment variable PILLE_LIBLLVM_PATH is not set"))
   '())
  #:provide provide-protected)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-llvm LLVMGetVersion
  (_fun [major : (_ptr o _uint)] [minor : (_ptr o _uint)] [patch : (_ptr o _uint)]
        -> _void
        -> (values major minor patch)))

(define-values (major-version minor-version patch-version)
  (LLVMGetVersion))

(unless (and (= major-version 21) (>= minor-version 1))
  (error "unsupported LLVM version"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-fun-syntax _string/symbol/utf-8
  (make-set!-transformer
   (syntax-parser
     [_:id
      #'(type: _string/utf-8
         pre: (s => (if (symbol? s) (symbol->string s) s)))])))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define _LLVMBool _bool)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-syntax (define-ref-type stx)
  (syntax-parse stx
    [(_ base-id:id)
     #:with ctype-id (format-id #'base-id "_LLVM~aRef" #'base-id)
     #:with pred-id (format-id #'base-id "LLVM~aRef?" #'base-id)
     #'(begin
         (provide pred-id)
         (define-cpointer-type ctype-id))]))

(define-syntax-rule (define-ref-types id ...)
  (begin (define-ref-type id)
         ...))

(define-ref-types
  Attribute
  BasicBlock
  Builder
  Comdat
  Context
  DiagnosticInfo
  Error
  MemoryBuffer
  Metadata
  Module
  ModuleProvider
  NamedMDNode
  OperandBundle
  OrcExecutionSession
  OrcJITDylib
  OrcJITTargetMachineBuilder
  OrcLLJIT
  OrcLLJITBuilder
  OrcThreadSafeContext
  OrcThreadSafeModule
  PassBuilderOptions
  PassManager
  Target
  TargetData
  TargetLibraryInfo
  TargetMachine
  TargetMachineOptions
  Type
  Use
  Value)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-syntax (define-value-subclass stx)
  (syntax-parse stx
    [(_ base-id:id)
     #:with pred-id (format-id #'base-id "LLVMIsA~a" #'base-id)
     #'(begin
         (define-llvm pred-id
           (_fun _LLVMValueRef -> _LLVMBool)))]))

(define-syntax-rule (define-value-subclasses id ...)
  (begin (define-value-subclass id)
         ...))

(define-value-subclasses
  AddrSpaceCastInst
  AllocaInst
  Argument
  AtomicCmpXchgInst
  AtomicRMWInst
  BasicBlock
  BinaryOperator
  BitCastInst
  BlockAddress
  BranchInst
  CallBrInst
  CallInst
  CastInst
  CatchPadInst
  CatchReturnInst
  CatchSwitchInst
  CleanupPadInst
  CleanupReturnInst
  CmpInst
  Constant
  ConstantAggregateZero
  ConstantArray
  ConstantDataArray
  ConstantDataSequential
  ConstantDataVector
  ConstantExpr
  ConstantFP
  ConstantInt
  ConstantPointerNull
  ConstantPtrAuth
  ConstantStruct
  ConstantTokenNone
  ConstantVector
  DbgDeclareInst
  DbgInfoIntrinsic
  DbgLabelInst
  DbgVariableIntrinsic
  ExtractElementInst
  ExtractValueInst
  FCmpInst
  FPExtInst
  FPToSIInst
  FPToUIInst
  FPTruncInst
  FenceInst
  FreezeInst
  FuncletPadInst
  Function
  GetElementPtrInst
  GlobalAlias
  GlobalIFunc
  GlobalObject
  GlobalValue
  GlobalVariable
  ICmpInst
  IndirectBrInst
  InlineAsm
  InsertElementInst
  InsertValueInst
  Instruction
  IntToPtrInst
  IntrinsicInst
  InvokeInst
  LandingPadInst
  LoadInst
  MemCpyInst
  MemIntrinsic
  MemMoveInst
  MemSetInst
  PHINode
  PoisonValue
  PtrToIntInst
  ResumeInst
  ReturnInst
  SExtInst
  SIToFPInst
  SelectInst
  ShuffleVectorInst
  StoreInst
  SwitchInst
  TruncInst
  UIToFPInst
  UnaryInstruction
  UnaryOperator
  UndefValue
  UnreachableInst
  User
  VAArgInst
  ZExtInst)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define _LLVMByteOrdering _int)
(define _LLVMCallConv _int)
(define _LLVMCodeGenOptLevel _int)
(define _LLVMCodeModel _int)
(define _LLVMDLLStorageClass _int)
(define _LLVMLinkage _int)
(define _LLVMRelocMode _int)
(define _LLVMTypeKind _int)
(define _LLVMUnnamedAddr _int)
(define _LLVMVisibility _int)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-cpointer-type _message)

(define-llvm LLVMCreateMessage
  (_fun _string/symbol/utf-8 -> _message))

(define-llvm LLVMDisposeMessage
  (_fun _message -> _void))

(define _string/message
  (make-ctype
   _message
   LLVMCreateMessage
   (λ (msg)
     (begin0 (cast msg _message _string/utf-8)
             (LLVMDisposeMessage msg)))))

(define _string/message/null
  (make-ctype
   _message/null
   (λ (str) (and str (LLVMCreateMessage str)))
   (λ (msg) (and msg (begin0 (cast msg _message _string/utf-8)
                             (LLVMDisposeMessage msg))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-llvm LLVMCreateMemoryBufferWithMemoryRangeCopy
  (_fun [input : _bytes] [_size = (bytes-length input)] _string/symbol/utf-8
        -> _LLVMMemoryBufferRef))

(define-llvm LLVMGetBufferStart
  (_fun _LLVMMemoryBufferRef -> _pointer))

(define-llvm LLVMGetBufferSize
  (_fun _LLVMMemoryBufferRef -> _size))

(define-llvm LLVMDisposeMemoryBuffer
  (_fun _LLVMMemoryBufferRef -> _void))

(define _bytes/LLVMMemoryBufferRef
  (make-ctype
   _LLVMMemoryBufferRef
   (λ (bs) (LLVMCreateMemoryBufferWithMemoryRangeCopy bs #f))
   (λ (mbuf) (let ([bs (make-bytes (LLVMGetBufferSize mbuf))])
               (memcpy bs (LLVMGetBufferStart mbuf) (bytes-length bs))
               (LLVMDisposeMemoryBuffer mbuf)
               bs))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-fun-syntax _treelist
  (syntax-rules ()
    [(_treelist . opts)
     (type: (_vector . opts)
      pre: (tl => (treelist->vector tl))
      post: (v => (vector->treelist v)))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-llvm LLVMContextCreate
  (_fun -> _LLVMContextRef))

(define-llvm LLVMContextDispose
  (_fun _LLVMContextRef -> _void))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-llvm LLVMModuleCreateWithNameInContext
  (_fun _string/symbol/utf-8 _LLVMContextRef -> _LLVMModuleRef))

(define-llvm LLVMGetModuleContext
  (_fun _LLVMModuleRef -> _LLVMContextRef))

(define-llvm LLVMCloneModule
  (_fun _LLVMModuleRef -> _LLVMModuleRef))

(define-llvm LLVMDisposeModule
  (_fun _LLVMModuleRef -> _void))

(define-llvm LLVMPrintModuleToString
  (_fun _LLVMModuleRef -> _string/message))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-llvm LLVMGetTypeKind
  (_fun _LLVMTypeRef -> _LLVMTypeKind))

(define-llvm LLVMGetTypeContext
  (_fun _LLVMTypeRef -> _LLVMContextRef))

(define-llvm LLVMTypeIsSized
  (_fun _LLVMTypeRef -> _LLVMBool))

(define-llvm LLVMIntTypeInContext
  (_fun _LLVMContextRef _uint -> _LLVMTypeRef))

(define-llvm LLVMGetIntTypeWidth
  (_fun _LLVMTypeRef -> _uint))

(define-llvm LLVMHalfTypeInContext
  (_fun _LLVMContextRef -> _LLVMTypeRef))

(define-llvm LLVMFloatTypeInContext
  (_fun _LLVMContextRef -> _LLVMTypeRef))

(define-llvm LLVMDoubleTypeInContext
  (_fun _LLVMContextRef -> _LLVMTypeRef))

(define-llvm LLVMFunctionType
  (_fun _LLVMTypeRef [params : (_treelist i _LLVMTypeRef)] [_uint = (treelist-length params)] _LLVMBool
        -> _LLVMTypeRef))

(define-llvm LLVMIsFunctionVarArg
  (_fun _LLVMTypeRef -> _LLVMBool))

(define-llvm LLVMGetReturnType
  (_fun _LLVMTypeRef -> _LLVMTypeRef))

(define-llvm LLVMCountParamTypes
  (_fun _LLVMTypeRef -> _uint))

(define-llvm LLVMGetParamTypes
  (_fun [type : _LLVMTypeRef] [params : (_vector o _LLVMTypeRef (LLVMCountParamTypes type))]
        -> _void
        -> (vector->treelist params)))

(define-llvm LLVMStructTypeInContext
  (_fun _LLVMContextRef [elems : (_treelist i _LLVMTypeRef)] [_uint = (treelist-length elems)] _LLVMBool
        -> _LLVMTypeRef))

(define-llvm LLVMIsPackedStruct
  (_fun _LLVMTypeRef -> _LLVMBool))

(define-llvm LLVMIsOpaqueStruct
  (_fun _LLVMTypeRef -> _LLVMBool))

(define-llvm LLVMCountStructElementTypes
  (_fun _LLVMTypeRef -> _uint))

(define-llvm LLVMGetStructElementTypes
  (_fun [type : _LLVMTypeRef] [elements : (_vector o _LLVMTypeRef (LLVMCountStructElementTypes type))]
        -> _void
        -> (vector->treelist elements)))

(define-llvm LLVMArrayType2
  (_fun _LLVMTypeRef _uint64 -> _LLVMTypeRef))

(define-llvm LLVMGetElementType
  (_fun _LLVMTypeRef -> _LLVMTypeRef))

(define-llvm LLVMGetArrayLength2
  (_fun _LLVMTypeRef -> _uint64))

(define-llvm LLVMPointerTypeInContext
  (_fun _LLVMContextRef _uint -> _LLVMTypeRef))

(define-llvm LLVMGetPointerAddressSpace
  (_fun _LLVMTypeRef -> _uint))

(define-llvm LLVMVectorType
  (_fun _LLVMTypeRef _uint -> _LLVMTypeRef))

(define-llvm LLVMGetVectorSize
  (_fun _LLVMTypeRef -> _uint))

(define-llvm LLVMVoidTypeInContext
  (_fun _LLVMContextRef -> _LLVMTypeRef))

(define-llvm LLVMLabelTypeInContext
  (_fun _LLVMContextRef -> _LLVMTypeRef))

(define-llvm LLVMTokenTypeInContext
  (_fun _LLVMContextRef -> _LLVMTypeRef))

(define-llvm LLVMMetadataTypeInContext
  (_fun _LLVMContextRef -> _LLVMTypeRef))

(define-llvm LLVMPrintTypeToString
  (_fun _LLVMTypeRef -> _string/message))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-llvm LLVMTypeOf
  (_fun _LLVMValueRef -> _LLVMTypeRef))

(define-llvm LLVMGetValueContext
  (_fun _LLVMValueRef -> _LLVMContextRef))

(define-llvm LLVMGetValueName2
  (_fun _LLVMValueRef [len : (_ptr o _size)] ;; uggghgh wut up w/ _bytes?
        -> [name-utf8-ptr : _pointer]
        -> (let ([buf (make-bytes len)])
             (memcpy buf name-utf8-ptr len)
             (bytes->string/utf-8 buf))))

(define-llvm LLVMSetValueName2
  (_fun _LLVMValueRef
        [name : _?]
        [name-utf8 : _bytes = (cond
                                [(symbol? name) (~> name symbol->string string->bytes/utf-8)]
                                [else (string->bytes/utf-8 name)])]
        [_size = (bytes-length name-utf8)]
        -> _void))

(define-llvm LLVMPrintValueToString
  (_fun _LLVMValueRef -> _string/message))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-llvm LLVMGetUndef
  (_fun _LLVMTypeRef -> _LLVMValueRef))

(define-llvm LLVMGetPoison
  (_fun _LLVMTypeRef -> _LLVMValueRef))

(define-llvm LLVMConstNull
  (_fun _LLVMTypeRef -> _LLVMValueRef))

(define-llvm LLVMConstPointerNull
  (_fun _LLVMTypeRef -> _LLVMValueRef))

(define-llvm LLVMConstIntOfArbitraryPrecision
  (_fun [type : _LLVMTypeRef]
        [val : _?]
        [num-words : _uint = (ceiling (/ (LLVMGetIntTypeWidth type) 64))]
        [_u64vector = (let ([words (make-u64vector num-words)])
                        (for ([i (in-range num-words)])
                          (~> (bitwise-bit-field val (* i 64) (* (add1 i) 64))
                              (u64vector-set! words i _)))
                        words)]
        -> _LLVMValueRef))

(define-llvm LLVMConstReal
  (_fun _LLVMTypeRef _double* -> _LLVMValueRef))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-llvm LLVMGetGlobalParent
  (_fun _LLVMValueRef -> _LLVMModuleRef/null))

(define-llvm LLVMIsDeclaration
  (_fun _LLVMValueRef -> _LLVMBool))

(define-llvm LLVMGlobalGetValueType
  (_fun _LLVMValueRef -> _LLVMTypeRef))

(define-llvm LLVMGetLinkage
  (_fun _LLVMValueRef -> _LLVMLinkage))

(define-llvm LLVMSetLinkage
  (_fun _LLVMValueRef _LLVMLinkage -> _void))

(define-llvm LLVMGetSection
  (_fun _LLVMValueRef -> _string/utf-8))

(define-llvm LLVMSetSection
  (_fun _LLVMValueRef _string/symbol/utf-8 -> _void))

(define-llvm LLVMGetVisibility
  (_fun _LLVMValueRef -> _LLVMVisibility))

(define-llvm LLVMSetVisibility
  (_fun _LLVMValueRef _LLVMVisibility -> _void))

(define-llvm LLVMGetDLLStorageClass
  (_fun _LLVMValueRef -> _LLVMDLLStorageClass))

(define-llvm LLVMSetDLLStorageClass
  (_fun _LLVMValueRef _LLVMDLLStorageClass -> _void))

(define-llvm LLVMGetUnnamedAddress
  (_fun _LLVMValueRef -> _LLVMUnnamedAddr))

(define-llvm LLVMSetUnnamedAddress
  (_fun _LLVMValueRef _LLVMUnnamedAddr -> _void))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-llvm LLVMGetAlignment
  (_fun _LLVMValueRef -> _uint))

(define-llvm LLVMSetAlignment
  (_fun _LLVMValueRef _uint -> _void))

(define-llvm LLVMGetVolatile
  (_fun _LLVMValueRef -> _LLVMBool))

(define-llvm LLVMSetVolatile
  (_fun _LLVMValueRef _LLVMBool -> _void))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-llvm LLVMCreateBuilderInContext
  (_fun _LLVMContextRef -> _LLVMBuilderRef))

(define-llvm LLVMDisposeBuilder
  (_fun _LLVMBuilderRef -> _void))

(define-llvm LLVMPositionBuilderBefore
  (_fun _LLVMBuilderRef _LLVMValueRef -> _void))

(define-llvm LLVMPositionBuilderAtEnd
  (_fun _LLVMBuilderRef _LLVMBasicBlockRef -> _void))

(define-llvm LLVMGetInsertBlock
  (_fun _LLVMBuilderRef -> _LLVMBasicBlockRef/null))

(define-llvm LLVMClearInsertionPosition
  (_fun _LLVMBuilderRef -> _void))

(define-llvm LLVMGetBuilderContext
  (_fun _LLVMBuilderRef -> _LLVMContextRef))

(define-llvm LLVMBuildRetVoid
  (_fun _LLVMBuilderRef -> _LLVMValueRef))

(define-llvm LLVMBuildRet
  (_fun _LLVMBuilderRef _LLVMValueRef -> _LLVMValueRef))

(define-llvm LLVMBuildBr
  (_fun _LLVMBuilderRef _LLVMBasicBlockRef -> _LLVMValueRef))

(define-llvm LLVMBuildCondBr
  (_fun _LLVMBuilderRef _LLVMValueRef _LLVMBasicBlockRef _LLVMBasicBlockRef -> _LLVMValueRef))

(define-llvm LLVMBuildUnreachable
  (_fun _LLVMBuilderRef -> _LLVMValueRef))

(define-syntax-rule (define-unop-builders id ...)
  (begin
    (define-llvm id
      (_fun _LLVMBuilderRef
            _LLVMValueRef
            _string/symbol/utf-8
            -> _LLVMValueRef))
    ...))

(define-unop-builders
  LLVMBuildNeg
  LLVMBuildNSWNeg
  LLVMBuildNot)

(define-syntax-rule (define-binop-builders id ...)
  (begin
    (define-llvm id
      (_fun _LLVMBuilderRef
            _LLVMValueRef
            _LLVMValueRef
            _string/symbol/utf-8
            -> _LLVMValueRef))
    ...))

(define-binop-builders
  LLVMBuildAdd
  LLVMBuildNSWAdd
  LLVMBuildNUWAdd
  LLVMBuildSub
  LLVMBuildNSWSub
  LLVMBuildNUWSub
  LLVMBuildMul
  LLVMBuildNSWMul
  LLVMBuildNUWMul
  LLVMBuildUDiv
  LLVMBuildExactUDiv
  LLVMBuildSDiv
  LLVMBuildExactSDiv
  LLVMBuildURem
  LLVMBuildSRem
  LLVMBuildShl
  LLVMBuildLShr
  LLVMBuildAShr
  LLVMBuildAnd
  LLVMBuildOr
  LLVMBuildXor)

(define-llvm LLVMBuildArrayAlloca
  (_fun _LLVMBuilderRef
        _LLVMTypeRef
        _LLVMValueRef/null
        _string/symbol/utf-8
        -> _LLVMValueRef))

(define-llvm LLVMBuildLoad2
  (_fun _LLVMBuilderRef
        _LLVMTypeRef
        _LLVMValueRef
        _string/symbol/utf-8
        -> _LLVMValueRef))

(define-llvm LLVMBuildStore
  (_fun _LLVMBuilderRef
        _LLVMValueRef
        _LLVMValueRef
        -> _LLVMValueRef))

(define-llvm LLVMBuildGEPWithNoWrapFlags
  (_fun _LLVMBuilderRef
        _LLVMTypeRef
        _LLVMValueRef
        [indices : (_treelist i _LLVMValueRef)]
        [_uint = (treelist-length indices)]
        _string/symbol/utf-8
        _uint
        -> _LLVMValueRef))

(define-syntax-rule (define-cast-builders id ...)
  (begin
    (define-llvm id
      (_fun _LLVMBuilderRef
            _LLVMValueRef
            _LLVMTypeRef
            _string/symbol/utf-8
            -> _LLVMValueRef))
    ...))

(define-cast-builders
  LLVMBuildTrunc
  LLVMBuildZExt
  LLVMBuildSExt
  LLVMBuildFPToUI
  LLVMBuildFPToSI
  LLVMBuildUIToFP
  LLVMBuildSIToFP
  LLVMBuildFPTrunc
  LLVMBuildFPExt
  LLVMBuildPtrToInt
  LLVMBuildIntToPtr
  LLVMBuildBitCast
  LLVMBuildAddrSpaceCast)

(define-llvm LLVMBuildPhi
  (_fun _LLVMBuilderRef
        _LLVMTypeRef
        _string/symbol/utf-8
        -> _LLVMValueRef))

(define-llvm LLVMAddIncoming
  (_fun _LLVMValueRef
        (_ptr i _LLVMValueRef)
        (_ptr i _LLVMBasicBlockRef)
        [_uint = 1]
        -> _void))

(define-llvm LLVMBuildCall2
  (_fun _LLVMBuilderRef
        _LLVMTypeRef
        _LLVMValueRef
        [args : (_treelist i _LLVMValueRef)]
        [_uint = (treelist-length args)]
        _string/symbol/utf-8
        -> _LLVMValueRef))

(define-llvm LLVMGetInstructionCallConv
  (_fun _LLVMValueRef -> _uint))

(define-llvm LLVMSetInstructionCallConv
  (_fun _LLVMValueRef _uint -> _void))

(define-llvm LLVMBuildSelect
  (_fun _LLVMBuilderRef
        _LLVMValueRef
        _LLVMValueRef
        _LLVMValueRef
        _string/symbol/utf-8
        -> _LLVMValueRef))

(define-llvm LLVMBuildExtractElement
  (_fun _LLVMBuilderRef
        _LLVMValueRef
        _LLVMValueRef
        _string/symbol/utf-8
        -> _LLVMValueRef))

(define-llvm LLVMBuildInsertElement
  (_fun _LLVMBuilderRef
        _LLVMValueRef
        _LLVMValueRef
        _LLVMValueRef
        _string/symbol/utf-8
        -> _LLVMValueRef))

(define-llvm LLVMBuildExtractValue
  (_fun _LLVMBuilderRef
        _LLVMValueRef
        _uint
        _string/symbol/utf-8
        -> _LLVMValueRef))

(define-llvm LLVMBuildInsertValue
  (_fun _LLVMBuilderRef
        _LLVMValueRef
        _LLVMValueRef
        _uint
        _string/symbol/utf-8
        -> _LLVMValueRef))

(define-llvm LLVMBuildShuffleVector
  (_fun _LLVMBuilderRef
        _LLVMValueRef
        _LLVMValueRef
        _LLVMValueRef
        _string/symbol/utf-8
        -> _LLVMValueRef))

(define-llvm LLVMBuildICmp
  (_fun _LLVMBuilderRef
        _int
        _LLVMValueRef
        _LLVMValueRef
        _string/symbol/utf-8
        -> _LLVMValueRef))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-syntax (define-target-initialization-function stx)
  (syntax-parse stx
    [(_ fun-id:id)
     #'(define-llvm fun-id
         (_fun -> _void)
         #:fail (λ () #f))]))

(define-syntax (define-target-initialization-functions stx)
  (syntax-parse stx
    [(_ target-id:id ...)
     #:do [(define target-ids
             (syntax->list #'(target-id ...)))
           (define (derive-ids fmt)
             (map (λ (id) (format-id id fmt id))
                  target-ids))]
     #:with (initialize-target-info-id ...) (derive-ids "LLVMInitialize~aTargetInfo")
     #:with (initialize-target-id ...) (derive-ids "LLVMInitialize~aTarget")
     #:with (initialize-target-mc-id ...) (derive-ids "LLVMInitialize~aTargetMC")
     #:with (initialize-asm-printer-id ...) (derive-ids "LLVMInitialize~aAsmPrinter")
     #:with (initialize-asm-parser-id ...) (derive-ids "LLVMInitialize~aAsmParser")
     #:with (initialize-disassembler-id ...) (derive-ids "LLVMInitialize~aDisassembler")
     #'(begin
         (define-target-initialization-function initialize-target-info-id) ...
         (define-target-initialization-function initialize-target-id) ...
         (define-target-initialization-function initialize-target-mc-id) ...
         (define-target-initialization-function initialize-asm-printer-id) ...
         (define-target-initialization-function initialize-asm-parser-id) ...
         (define-target-initialization-function initialize-disassembler-id) ...

         (provide LLVMInitializeAllTargetInfos)
         (define (LLVMInitializeAllTargetInfos)
           (and initialize-target-info-id (initialize-target-info-id))
           ...
           (void))

         (provide LLVMInitializeAllTargets)
         (define (LLVMInitializeAllTargets)
           (and initialize-target-id (initialize-target-id))
           ...
           (void))

         (provide LLVMInitializeAllTargetMCs)
         (define (LLVMInitializeAllTargetMCs)
           (and initialize-target-mc-id (initialize-target-mc-id))
           ...
           (void))

         (provide LLVMInitializeAllAsmPrinters)
         (define (LLVMInitializeAllAsmPrinters)
           (and initialize-asm-printer-id (initialize-asm-printer-id))
           ...
           (void))

         (provide LLVMInitializeAllAsmParsers)
         (define (LLVMInitializeAllAsmParsers)
           (and initialize-asm-parser-id (initialize-asm-parser-id))
           ...
           (void))

         (provide LLVMInitializeAllDisassemblers)
         (define (LLVMInitializeAllDisassemblers)
           (and initialize-disassembler-id (initialize-disassembler-id))
           ...
           (void)))]))

(define-target-initialization-functions
  AArch64
  AMDGPU
  ARM
  AVR
  BPF
  Hexagon
  Lanai
  LoongArch
  Mips
  MSP430
  NVPTX
  PowerPC
  RISCV
  Sparc
  SPIRV
  SystemZ
  VE
  WebAssembly
  X86
  XCore)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-llvm LLVMGetErrorMessage
  (_fun _LLVMErrorRef -> _pointer))

(define-llvm LLVMDisposeErrorMessage
  (_fun _pointer -> _void))

(define-llvm LLVMCreateStringError
  (_fun _string/symbol/utf-8 -> _LLVMErrorRef))

(define _string/LLVMErrorRef/null
  (make-ctype
   _LLVMErrorRef/null
   (λ (msg) (and msg (LLVMCreateStringError msg)))
   (λ (err) (and err (let ([msg-p (LLVMGetErrorMessage err)])
                       (begin0 (cast msg-p _pointer _string/utf-8)
                               (LLVMDisposeErrorMessage msg-p)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-llvm LLVMGetFirstTarget
  (_fun -> _LLVMTargetRef/null))

(define-llvm LLVMGetNextTarget
  (_fun _LLVMTargetRef -> _LLVMTargetRef/null))

(define-llvm LLVMGetTargetFromName
  (_fun _string/symbol/utf-8 -> _LLVMTargetRef/null))

(define-llvm LLVMGetTargetFromTriple
  (_fun _string/symbol/utf-8
        [tgt : (_ptr o _LLVMTargetRef/null)]
        [(_or-null _pointer) = #false]
        -> [failed : _LLVMBool]
        -> (and (not failed) tgt)))

(define-llvm LLVMNormalizeTargetTriple
  (_fun _string/symbol/utf-8 -> _string/message))

(define-llvm LLVMGetTargetName
  (_fun _LLVMTargetRef -> _string/utf-8))

(define-llvm LLVMGetTargetDescription
  (_fun _LLVMTargetRef -> _string/utf-8))

(define-llvm LLVMTargetHasJIT
  (_fun _LLVMTargetRef -> _LLVMBool))

(define-llvm LLVMTargetHasTargetMachine
  (_fun _LLVMTargetRef -> _LLVMBool))

(define-llvm LLVMTargetHasAsmBackend
  (_fun _LLVMTargetRef -> _LLVMBool))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-llvm LLVMCreateTargetMachine
  (_fun _LLVMTargetRef
        _string/symbol/utf-8
        _string/symbol/utf-8
        _string/symbol/utf-8
        _LLVMCodeGenOptLevel
        _LLVMRelocMode
        _LLVMCodeModel
        -> _LLVMTargetMachineRef/null))

(define-llvm LLVMDisposeTargetMachine
  (_fun _LLVMTargetMachineRef -> _void))

(define-llvm LLVMCreateTargetDataLayout
  (_fun _LLVMTargetMachineRef -> _LLVMTargetDataRef))

(define-llvm LLVMTargetMachineEmitToMemoryBuffer
  (_fun _LLVMTargetMachineRef
        _LLVMModuleRef
        _int
        [msg-p : (_ptr o _pointer)] ; <- pointer will be garbage unless there's an error (*sigh*)
        [buf-p : (_ptr o _pointer)] ; <- just being defensive here
        -> [err : _LLVMBool]
        -> (cond
             [err (error (cast msg-p _pointer _string/message))]
             [else (cast buf-p _pointer _bytes/LLVMMemoryBufferRef)])))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-llvm LLVMGetModuleDataLayout
  (_fun _LLVMModuleRef -> _LLVMTargetDataRef))

(define-llvm LLVMSetModuleDataLayout
  (_fun _LLVMModuleRef _LLVMTargetDataRef -> _void))

(define-llvm LLVMSetDataLayout
  (_fun _LLVMModuleRef _string/symbol/utf-8 -> _void))

(define-llvm LLVMCreateTargetData
  (_fun _string/symbol/utf-8 -> _LLVMTargetDataRef))

(define-llvm LLVMDisposeTargetData
  (_fun _LLVMTargetDataRef -> _void))

(define-llvm LLVMCopyStringRepOfTargetData
  (_fun _LLVMTargetDataRef -> _string/message))

(define-llvm LLVMByteOrder
  (_fun _LLVMTargetDataRef -> _LLVMByteOrdering))

(define-llvm LLVMIntPtrTypeForASInContext
  (_fun _LLVMContextRef _LLVMTargetDataRef _uint -> _LLVMTypeRef))

(define-llvm LLVMSizeOfTypeInBits
  (_fun _LLVMTargetDataRef _LLVMTypeRef -> _ullong))

(define-llvm LLVMStoreSizeOfType
  (_fun _LLVMTargetDataRef _LLVMTypeRef -> _ullong))

(define-llvm LLVMABISizeOfType
  (_fun _LLVMTargetDataRef _LLVMTypeRef -> _ullong))

(define-llvm LLVMABIAlignmentOfType
  (_fun _LLVMTargetDataRef _LLVMTypeRef -> _ullong))

(define-llvm LLVMPreferredAlignmentOfType
  (_fun _LLVMTargetDataRef _LLVMTypeRef -> _ullong))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-llvm LLVMGetDefaultTargetTriple
  (_fun -> _string/message))

(define-llvm LLVMGetHostCPUName
  (_fun -> _string/message))

(define-llvm LLVMGetHostCPUFeatures
  (_fun -> _string/message))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-llvm LLVMParseBitcodeInContext2
  (_fun _LLVMContextRef
        [bs : _?]
        [mbuf : _LLVMMemoryBufferRef = (LLVMCreateMemoryBufferWithMemoryRangeCopy bs #f)]
        [mod : (_ptr o _LLVMModuleRef/null)]
        -> [failed : _LLVMBool]
        -> (begin
             (LLVMDisposeMemoryBuffer mbuf)
             (and (not failed) mod))))

(define-llvm LLVMGetBitcodeModuleInContext2
  (_fun _LLVMContextRef
        [bs : _?]
        [mbuf : _LLVMMemoryBufferRef = (LLVMCreateMemoryBufferWithMemoryRangeCopy bs #f)]
        [mod : (_ptr o _LLVMModuleRef/null)]
        -> [failed : _LLVMBool]
        -> (cond
             [failed (LLVMDisposeMemoryBuffer mbuf)
                     #f]
             [else mod])))

(define-llvm LLVMWriteBitcodeToMemoryBuffer
  (_fun _LLVMModuleRef -> _bytes/LLVMMemoryBufferRef))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define _LLVMVerifierFailureAction _int)
(define LLVMAbortProcessAction 0)
(define LLVMPrintMessageAction 1)
(define LLVMReturnStatusAction 2)

(define-llvm LLVMVerifyModule
  (_fun _LLVMModuleRef
        [_LLVMVerifierFailureAction = LLVMReturnStatusAction]
        [msg : (_ptr o _string/message/null)]
        -> [failed : _LLVMBool]
        -> (and failed (or msg "verification failed"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-llvm LLVMCreatePassBuilderOptions
  (_fun -> _LLVMPassBuilderOptionsRef))

(define-llvm LLVMDisposePassBuilderOptions
  (_fun _LLVMPassBuilderOptionsRef -> _void))

(define-llvm LLVMRunPasses
  (_fun _LLVMModuleRef
        _string/symbol/utf-8
        _LLVMTargetMachineRef/null
        _LLVMPassBuilderOptionsRef
        -> [msg : _string/LLVMErrorRef/null]
        -> (or (and msg (error msg))
               (void))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-llvm LLVMAddGlobalInAddressSpace
  (_fun _LLVMModuleRef
        _LLVMTypeRef
        _string/symbol/utf-8
        _uint
        -> _LLVMValueRef))

(define-llvm LLVMGetNamedGlobal
  (_fun _LLVMModuleRef _string/symbol/utf-8 -> _LLVMValueRef/null))

(define-llvm LLVMGetFirstGlobal
  (_fun _LLVMModuleRef -> _LLVMValueRef/null))

(define-llvm LLVMGetLastGlobal
  (_fun _LLVMModuleRef -> _LLVMValueRef/null))

(define-llvm LLVMGetNextGlobal
  (_fun _LLVMValueRef -> _LLVMValueRef/null))

(define-llvm LLVMGetPreviousGlobal
  (_fun _LLVMValueRef -> _LLVMValueRef/null))

(define-llvm LLVMDeleteGlobal
  (_fun _LLVMValueRef -> _void))

(define-llvm LLVMGetInitializer
  (_fun _LLVMValueRef -> _LLVMValueRef/null))

(define-llvm LLVMSetInitializer
  (_fun _LLVMValueRef _LLVMValueRef/null -> _void))

(define-llvm LLVMIsGlobalConstant
  (_fun _LLVMValueRef -> _LLVMBool))

(define-llvm LLVMSetGlobalConstant
  (_fun _LLVMValueRef _LLVMBool -> _void))

(define-llvm LLVMIsExternallyInitialized
  (_fun _LLVMValueRef -> _LLVMBool))

(define-llvm LLVMSetExternallyInitialized
  (_fun _LLVMValueRef _LLVMBool -> _void))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-llvm LLVMAddAlias2
  (_fun _LLVMModuleRef
        _LLVMTypeRef
        _uint
        _LLVMValueRef
        _string/symbol/utf-8
        -> _LLVMValueRef))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-llvm LLVMAddFunction
  (_fun _LLVMModuleRef _string/symbol/utf-8 _LLVMTypeRef
        -> _LLVMValueRef))

(define-llvm LLVMGetNamedFunction
  (_fun _LLVMModuleRef _string/symbol/utf-8
        -> _LLVMValueRef/null))

(define-llvm LLVMGetFirstFunction
  (_fun _LLVMModuleRef -> _LLVMValueRef/null))

(define-llvm LLVMGetLastFunction
  (_fun _LLVMModuleRef -> _LLVMValueRef/null))

(define-llvm LLVMGetNextFunction
  (_fun _LLVMValueRef -> _LLVMValueRef/null))

(define-llvm LLVMGetPreviousFunction
  (_fun _LLVMValueRef -> _LLVMValueRef/null))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-llvm LLVMDeleteFunction
  (_fun _LLVMValueRef -> _void))

(define-llvm LLVMGetFunctionCallConv
  (_fun _LLVMValueRef -> _uint))

(define-llvm LLVMSetFunctionCallConv
  (_fun _LLVMValueRef _uint -> _void))

(define-llvm LLVMGetParamParent
  (_fun _LLVMValueRef -> _LLVMValueRef))

(define-llvm LLVMCountParams
  (_fun _LLVMValueRef -> _uint))

(define-llvm LLVMGetParam
  (_fun _LLVMValueRef _uint -> _LLVMValueRef))

(define-llvm LLVMGetFirstParam
  (_fun _LLVMValueRef -> _LLVMValueRef/null))

(define-llvm LLVMGetLastParam
  (_fun _LLVMValueRef -> _LLVMValueRef/null))

(define-llvm LLVMGetNextParam
  (_fun _LLVMValueRef -> _LLVMValueRef/null))

(define-llvm LLVMGetPreviousParam
  (_fun _LLVMValueRef -> _LLVMValueRef/null))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-llvm LLVMGetBasicBlockName
  (_fun _LLVMBasicBlockRef -> _string/utf-8))

(define-llvm LLVMGetBasicBlockParent
  (_fun _LLVMBasicBlockRef -> _LLVMValueRef/null))

(define-llvm LLVMGetBasicBlockTerminator
  (_fun _LLVMBasicBlockRef -> _LLVMValueRef/null))

(define-llvm LLVMGetFirstBasicBlock
  (_fun _LLVMValueRef -> _LLVMBasicBlockRef/null))

(define-llvm LLVMGetLastBasicBlock
  (_fun _LLVMValueRef -> _LLVMBasicBlockRef/null))

(define-llvm LLVMGetNextBasicBlock
  (_fun _LLVMBasicBlockRef -> _LLVMBasicBlockRef/null))

(define-llvm LLVMGetPreviousBasicBlock
  (_fun _LLVMBasicBlockRef -> _LLVMBasicBlockRef/null))

(define-llvm LLVMAppendBasicBlockInContext
  (_fun _LLVMContextRef _LLVMValueRef _string/symbol/utf-8
        -> _LLVMBasicBlockRef))

(define-llvm LLVMGetFirstInstruction
  (_fun _LLVMBasicBlockRef -> _LLVMValueRef/null))

(define-llvm LLVMGetLastInstruction
  (_fun _LLVMBasicBlockRef -> _LLVMValueRef/null))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-llvm LLVMGetInstructionParent
  (_fun _LLVMValueRef -> _LLVMBasicBlockRef/null))

(define-llvm LLVMGetNextInstruction
  (_fun _LLVMValueRef -> _LLVMValueRef/null))

(define-llvm LLVMGetPreviousInstruction
  (_fun _LLVMValueRef -> _LLVMValueRef/null))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-llvm LLVMLookupIntrinsicID
  (_fun [name : _?]
        [name-bytes : _bytes = (string->bytes/utf-8
                                (if (symbol? name)
                                    (symbol->string name)
                                    name))]
        [_size = (bytes-length name-bytes)]
        -> [res : _uint]
        -> (and (not (zero? res)) res)))

(define-llvm LLVMGetIntrinsicDeclaration
  (_fun _LLVMModuleRef
        _uint
        [param-types : (_treelist i _LLVMTypeRef)]
        [_size = (treelist-length param-types)]
        -> _LLVMValueRef))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-llvm LLVMGetNUW
  (_fun _LLVMValueRef -> _LLVMBool))

(define-llvm LLVMSetNUW
  (_fun _LLVMValueRef _LLVMBool -> _void))

(define-llvm LLVMGetNSW
  (_fun _LLVMValueRef -> _LLVMBool))

(define-llvm LLVMSetNSW
  (_fun _LLVMValueRef _LLVMBool -> _void))

(define-llvm LLVMGetExact
  (_fun _LLVMValueRef -> _LLVMBool))

(define-llvm LLVMSetExact
  (_fun _LLVMValueRef _LLVMBool -> _void))

(define-llvm LLVMGetNNeg
  (_fun _LLVMValueRef -> _LLVMBool))

(define-llvm LLVMSetNNeg
  (_fun _LLVMValueRef _LLVMBool -> _void))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-llvm LLVMLinkModules2
  (_fun _LLVMModuleRef _LLVMModuleRef
        -> [err : _LLVMBool]
        -> (when err (error "failed to link modules"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-llvm LLVMOrcCreateNewThreadSafeContextFromLLVMContext
  (_fun _LLVMContextRef -> _LLVMOrcThreadSafeContextRef))

(define-llvm LLVMOrcDisposeThreadSafeContext
  (_fun _LLVMOrcThreadSafeContextRef -> _void))

(define-llvm LLVMOrcCreateNewThreadSafeModule
  (_fun _LLVMModuleRef _LLVMOrcThreadSafeContextRef
        -> _LLVMOrcThreadSafeModuleRef))

(define-llvm LLVMOrcDisposeThreadSafeModule
  (_fun _LLVMOrcThreadSafeModuleRef -> _void))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-llvm LLVMOrcJITTargetMachineBuilderDetectHost
  (_fun [res : (_ptr o _LLVMOrcJITTargetMachineBuilderRef/null)]
        -> [msg : _string/LLVMErrorRef/null]
        -> (or (and msg (error msg))
               res)))

(define-llvm LLVMOrcJITTargetMachineBuilderCreateFromTargetMachine
  (_fun _LLVMTargetMachineRef -> _LLVMOrcJITTargetMachineBuilderRef))

(define-llvm LLVMOrcDisposeJITTargetMachineBuilder
  (_fun _LLVMOrcJITTargetMachineBuilderRef -> _void))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-llvm LLVMOrcCreateLLJITBuilder
  (_fun -> _LLVMOrcLLJITBuilderRef))

(define-llvm LLVMOrcLLJITBuilderSetJITTargetMachineBuilder
  (_fun _LLVMOrcLLJITBuilderRef
        _LLVMOrcJITTargetMachineBuilderRef
        -> _void))

(define-llvm LLVMOrcDisposeLLJITBuilder
  (_fun _LLVMOrcLLJITBuilderRef -> _void))

(define-llvm LLVMOrcCreateLLJIT
  (_fun [jit : (_ptr o _LLVMOrcLLJITRef/null)]
        _LLVMOrcLLJITBuilderRef/null
        -> [msg : _string/LLVMErrorRef/null]
        -> (or (and msg (error msg))
               jit)))

(define-llvm LLVMOrcDisposeLLJIT
  (_fun _LLVMOrcLLJITRef
        -> [msg : _string/LLVMErrorRef/null]
        -> (or (and msg (error msg))
               (void))))

(define-llvm LLVMOrcLLJITGetExecutionSession
  (_fun _LLVMOrcLLJITRef -> _LLVMOrcExecutionSessionRef))

(define-llvm LLVMOrcLLJITGetMainJITDylib
  (_fun _LLVMOrcLLJITRef -> _LLVMOrcJITDylibRef))

(define-llvm LLVMOrcLLJITAddObjectFile
  (_fun _LLVMOrcLLJITRef
        _LLVMOrcJITDylibRef
        _bytes/LLVMMemoryBufferRef
        -> [msg : _string/LLVMErrorRef/null]
        -> (or (and msg (error msg))
               (void))))

(define-llvm LLVMOrcLLJITAddLLVMIRModule
  (_fun _LLVMOrcLLJITRef
        _LLVMOrcJITDylibRef
        _LLVMOrcThreadSafeModuleRef
        -> [msg : _string/LLVMErrorRef/null]
        -> (or (and msg (error msg))
               (void))))

(define-llvm LLVMOrcLLJITLookup
  (_fun _LLVMOrcLLJITRef
        [addr : (_ptr o _uint64)]
        _string/symbol/utf-8
        -> [msg : _string/LLVMErrorRef/null]
        -> (or (and msg (error msg))
               (cast addr _size _pointer))))

(define-llvm LLVMOrcLLJITGetDataLayoutStr
  (_fun _LLVMOrcLLJITRef -> _string/utf-8))
