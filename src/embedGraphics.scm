(texmacs-module (graphics embeddedGraphics embedGraphics))

(define pi (acos -1))

(tm-define (pt x y)
  `(point ,(number->string x) ,(number->string y)))

(tm-define pA (pt -2 0))

(tm-define pB (pt 2 0))


(tm-define xC (- (* 2 (cos (/ pi 3)))))

(tm-define yC (* 2 (sin (/ pi 3))))

(tm-define pC (pt xC yC))

(tm-define tA (pt -2.3 -0.5))

(tm-define tB (pt 2.1 -0.5))

(tm-define tC (pt (- xC 0.2) (+ yC 0.2)))
