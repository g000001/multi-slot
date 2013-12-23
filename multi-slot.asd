;;;; multi-slot.asd -*- Mode: Lisp;-*- 

(cl:in-package :asdf)

(defsystem :multi-slot
  :serial t
  :depends-on (:fiveam
               :alexandria
               :closer-mop)
  :components ((:file "package")
               (:file "multi-slot")
               (:file "test")))

(defmethod perform ((o test-op) (c (eql (find-system :multi-slot))))
  (load-system :multi-slot)
  (or (flet ((_ (pkg sym)
               (intern (symbol-name sym) (find-package pkg))))
         (let ((result (funcall (_ :fiveam :run) (_ :multi-slot.internal :multi-slot))))
           (funcall (_ :fiveam :explain!) result)
           (funcall (_ :fiveam :results-status) result)))
      (error "test-op failed") ))

