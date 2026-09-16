#lang racket

(provide ptr_t/gcable-object
         lock-object
         unlock-object)

(define (ptr_t/gcable-object ptr)
  ((#%foreign-inline ftype-scheme-object-pointer-object #:copy*)
   ptr))

(define (lock-object obj)
  ((#%foreign-inline lock-object #:copy)
   obj))

(define (unlock-object obj)
  ((#%foreign-inline unlock-object #:copy)
   obj))
