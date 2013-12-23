;;;; multi-slot.lisp

(cl:in-package :multi-slot.internal)


(defclass multi-slot-generic-function-class (standard-generic-function)
  ((vslots :initform (make-hash-table :weakness :value)))
  (:metaclass c2mop:funcallable-standard-class))


(defmethod vslot-value ((gf multi-slot-generic-function-class) key)
  (gethash key (slot-value gf 'vslots)))


(defmethod (setf vslot-value) (val (gf multi-slot-generic-function-class) key)
  (setf (gethash key (slot-value gf 'vslots)) val))


(defmacro defslot ((slot-name &rest slot-spec) &rest classes)
  (let* ((accessor-name
          (alexandria:format-symbol *package* "~{~A~^-~}-~A" classes slot-name))
         (args (mapcar (lambda (x) (list x x)) classes))
         (initform (getf slot-spec :initform))
         (vslotv `(vslot-value #',accessor-name (sxhash (list ,@classes)))))
    `(progn
       (defgeneric ,accessor-name (,@classes)
         (:generic-function-class multi-slot-generic-function-class))
       (defmethod ,accessor-name (,@args)
         (or ,vslotv ,initform))
       (defmethod (setf ,accessor-name) (new-val ,@args)
         (setf ,vslotv new-val)))))


;;; *EOF*
