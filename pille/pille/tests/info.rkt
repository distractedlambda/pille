#lang info

;; The modules in "expansion" fail to expand. They're run from
;; "expansion.rhm" instead, so the error doesn't stop the other tests.
(define compile-omit-paths '("expansion"))
(define test-omit-paths '("expansion"))
