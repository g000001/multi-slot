;;;; package.lisp

(cl:in-package :cl-user)

(defpackage :multi-slot
  (:use)
  (:export :defslot
           :multi-slot-generic-function-class))

(defpackage :multi-slot.internal
  (:use :multi-slot :cl :fiveam))

