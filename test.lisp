(cl:in-package :multi-slot.internal)
;; (in-readtable :multi-slot)

(def-suite multi-slot)

(in-suite multi-slot)

;;; "multi-slot" goes here. Hacks and glory await!

(defclass quux () 
  ((x :initform 0 :accessor x)))

(defclass shme () 
  ((x :initform 0 :accessor x)))
(defclass quuxsub (quux) ())
(defclass shmesub (shme) ())
(defslot (y :initform 0) quux shme)
(defslot (y :initform 0) quux shme quuxsub shmesub)


(test multi-slot
  (is (equal (let ((q (make-instance 'quux))
                   (s (make-instance 'shme)))
               (setf (x q) 42)
               (setf (x s) 84)
               (setf (quux-shme-y q s) 168)
               (list (x q)
                     (x s)
                     (quux-shme-y q s)))
             '(42 84 168)))
  (is (equal (let ((q (make-instance 'quux))
                   (s (make-instance 'shme))
                   (qq (make-instance 'quuxsub))
                   (ss (make-instance 'shmesub)))
               (setf (x q) 42)
               (setf (x qq) (* 3 (x q)))
               (setf (x s) 84)
               (setf (x ss) (* 3 (x s)))
               (setf (quux-shme-y q s) 168)
               (setf (quux-shme-y q ss) 
                     (* 50 (quux-shme-y q s)))
               (setf (quux-shme-y qq ss) 
                     (* 100 (quux-shme-y q s)))
               (setf (quux-shme-quuxsub-shmesub-y q s qq ss)
                     :quux-shme-quuxsub-shmesub-y-1)
               (setf (quux-shme-quuxsub-shmesub-y qq ss qq ss)
                     :quux-shme-quuxsub-shmesub-y-2)
               (list (x q)
                     (x s)
                     (x qq)
                     (x ss)
                     (quux-shme-y q s)
                     (quux-shme-y q ss)
                     (quux-shme-y qq ss)
                     (quux-shme-quuxsub-shmesub-y q s qq ss)
                     (quux-shme-quuxsub-shmesub-y qq ss qq ss)))
             '(42 84 126 252 168 8400 16800 :QUUX-SHME-QUUXSUB-SHMESUB-Y-1
               :QUUX-SHME-QUUXSUB-SHMESUB-Y-2))))

;;; *EOF*
