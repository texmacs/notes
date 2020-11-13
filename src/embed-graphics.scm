(texmacs-module (graphics embedded-graphics embed-graphics))
;;; module to support our example of Scheme graphics embedding

(define pi (acos -1))

;; a function for generating point primitives
(tm-define (pt x y)
  `(point ,(number->string x) ,(number->string y)))

;; define points for the triangle
(tm-define pA (pt -2 0))
(tm-define pB (pt 2 0))

(tm-define xC (- (* 2 (cos (/ pi 3)))))
(tm-define yC (* 2 (sin (/ pi 3))))
(tm-define pC (pt xC yC))

;; define points for the letters
(tm-define tA (pt -2.3 -0.5))
(tm-define tB (pt 2.1 -0.5))
(tm-define tC (pt (- xC 0.2) (+ yC 0.2)))
