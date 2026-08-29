#lang rhombus/scribble/manual

@(import:
    "common.rhm" open)

@title{Complex Numbers}

@doc(
  struct Complex(ρ :: type, ι :: type):
    real_part :: ρ
    imag_part :: ι
){}

@doc(
  specl.fun complex(real_part :: real, imag_part :: real)
    :: number

  fun complex(specl real_part :: real, specl imag_part :: real)
    :: Specl(complex(real_part, imag_part))

  fun complex(real_part :: ρ, imag_part :: ι)
    :: Complex(ρ, ι)
){
  Creates a new complex number from real and imaginary
  parts. This is defined for both @nontermref(specl_expr) as
  well as @nontermref(expr) contexts, and in the latter case
  it will still produce @pille_specl_expr(Specl) results
  given @pille_specl_expr(Specl) inputs.
}

@doc(
  specl.property (z :: number).real_part :: real
  specl.property (z :: number).imag_part :: real
){
  Specialization-language properties that mirror those of
  @pille_expr(Complex) types.
}

@doc(
  specl.def complex.i :: number

  property (specl Complex(ρ, ι)).i :: Complex(ρ, ι):
    ~when Specl(0) coerces_to ρ
    ~when Specl(1) coerces_to ι
){}

@doc(
  coercion (z :: Complex(ρ₁, ι₁)) :: Complex(ρ₂, ι₂):
    ~when ρ₁ coerces_to ρ₂
    ~when ι₁ coerces_to ι₂

  unify(Complex(ρ₁, ι₁), Complex(ρ₂, ι₂)):
    Complex(unify(ρ₁, ρ₂), unify(ι₁, ι₂))
){
  Allows part-wise coercion between
  @pille_specl_expr(Complex) types.
}

@doc(
  coercion (src :: α) :: Complex(ρ, ι):
    ~priority fallback
    ~when α coerces_to ρ
    ~when Specl(0) coerces_to ι

  unify(α, Complex(ρ, ι)):
    ~priority fallback
    Complex(unify(α, ρ), unify(α, ι))
){
  Allows any @rhombus(src) to coerce to a
  @pille_specl_expr(Complex) type by treating the
  @rhombus(src) as a real number (and producing a complex
  number with a @rhombus(0) imaginary part).
}

@doc(
  coercion (specl z :: number) :: Complex(ρ, ι):
    ~when Specl(z.real_part) coerces_to ρ
    ~when Specl(z.imag_part) coerces_to ι

  unify(Specl(z :: number), Complex(ρ, ι)):
    Complex(
      unify(Specl(z.real_part), ρ),
      unify(Specl(z.imag_part), ι))
){}

@doc(
  specl.property (z :: number).magnitude_squared :: real

  specl.property (z :: number).magnitude :: real

  property (z :: Complex(_, _)).magnitude_squared:
    ~transparent
    (z.real_part * z.real_part) + (z.imag_part * z.imag_part)

  property (z :: Complex(_, _)).magnitude:
    ~transparent
    sqrt(z.magnitude_squared)
){}

@doc(
  method (lhs :: Complex(_, _)).$add(rhs :: Complex(_, _)):
    ~transparent
    complex(
      lhs.real_part + rhs.real_part,
      lhs.imag_part + rhs.imag_part)

  method (lhs :: Complex(_, _)).$sub(rhs :: Complex(_, _)):
    ~transparent
    complex(
      lhs.real_part - rhs.real_part,
      lhs.imag_part - rhs.imag_part)

  method (rhs :: Complex(_, _)).$neg():
    ~transparent
    complex(-rhs.real_part, -rhs.imag_part)

  method (lhs :: Complex(_, _)).$mul(rhs :: Complex(_, _)):
    ~transparent
    complex(
      lhs.real_part * rhs.real_part - lhs.imag_part * rhs.imag_part,
      lhs.real_part * rhs.imag_part + lhs.imag_part * rhs.real_part)
){}
