<TeXmacs|1.99.15>

<style|<tuple|notes|old-lengths|framed-session>>

<\body>
  <notes-header>

  <chapter*|Embedding graphics composed with Scheme into documents>

  In a <hlink|previous note|./scheme-graphics.tm>, we have shown an example
  of <TeXmacs> native graphics generated with <name|Scheme>, a triangle
  inscribed in a half-circle.

  Now let us see how to embed it seamlessly in a document. Our work is based
  on <name|Fold> <name|Executable> environments, available under
  <menu|Insert|Fold|Executable> (and then choose the <name|Scheme> option).

  Since in each <name|Executable> environment it is possible to execute one
  <name|Scheme> instruction only, we will wrap all of the code inside a
  <scm|begin> form.

  For more complex drawings users may feel the need of more efficient
  facilities to compose, test and deploy into TeXmacs their code. We are
  going to discuss some available tools in a future post.

  A synthetic discussion of <TeXmacs> graphics primitives and how to code
  them in <name|Scheme> is in the <hlink|previous note|./scheme-graphics.tm>
  (see also the manual, in <menu|Help|Manual|Creating technical pictures>).
  Here let us just remind that <TeXmacs> graphics are composed by listing
  graphical objects, each made by the application of a graphical primitive,
  inside a <markup|graphics> primitive.

  In the code we ue in this note, we introduce a function <scm|pt> that
  generates <markup|point> primitives, (which are parametrized by two
  numbers, expressed as strings), and with it we generate points that we will
  use to build other primitives (<markup|arc>, <markup|line>, <markup|cline>
  and <markup|text-at>).

  In turn, <TeXmacs> will use the primitives to represent the triangle, the
  half-circle and the decorations, that is the drawing that we will embed in
  the document.

  We open the environment with <menu|Insert|Fold|Executable|Scheme> and we
  obtain the yellow box we got used to in the note on <hlink|embedding TikZ
  graphics|./embedding-tikz-figures-short.tm>, in this case introduced by a
  <samp|Scheme> title on a gray background:

  <script-input|scheme|default||>

  Press <key|S-Return> and type or paste the graphics command; in this note
  let us copy the same commands that generate the drawing in the
  <hlink|previous note|./scheme_graphics.tm>, wrapping everything in a
  <scm|begin> form as we already said:

  <\script-input|scheme|default>
    (begin

    (define pi (acos -1))

    \;

    ;; a function for generating TeXmacs points

    (define (pt x y)

    \ \ `(point ,(number-\<gtr\>string x) ,(number-\<gtr\>string y)))

    \;

    ;; points for the triangle

    (define pA (pt -2 0))

    (define pB (pt 2 0))

    (define xC (- (* 2 (cos (/ pi 3))))); x-coordinate for point C

    (define yC (* 2 (sin (/ pi 3)))); y-coordinate for point C

    (define pC (pt xC yC))

    \;

    ;; points for the letters

    (define tA (pt -2.3 -0.5))

    (define tB (pt 2.1 -0.5))

    (define tC (pt (- xC 0.2) (+ yC 0.2)))

    \;

    (stree-\<gtr\>tree

    `(with "gr-geometry" (tuple "geometry" "400px" "300px" "center")

    \ \ \ (graphics

    \ \ ;; the arc and the line together make the semicircle

    \ \ (with "color" "black" (arc ,pA ,pC ,pB))

    \ \ (with "color" "black" (line ,pA ,pB))

    \ \ ;; a closed polyline for the triangle

    \ \ (with "color" "red" \ \ (cline ,pA ,pB ,pC))

    \ \ ;; add letters using text-at

    \ \ (with "color" "black" (text-at "A" ,tA)) \ 

    \ \ (with "color" "black" (text-at "B" ,tB)) \ 

    \ \ (with "color" "black" (text-at "C" ,tC))

    \ \ ;; finally decorate with the TeXmacs symbol

    \ \ ;; and close all of the parentheses!!!

    \ \ (with "color" "blue" \ (text-at (TeXmacs) ,(pt -0.55 -0.75)))))))
  </script-input|<text|<with|gr-geometry|<tuple|geometry|400px|300px|center>|<graphics|<with|color|black|<arc|<point|-2|0>|<point|-1.0|1.73205080756888>|<point|2|0>>>|<with|color|black|<line|<point|-2|0>|<point|2|0>>>|<with|color|red|<cline|<point|-2|0>|<point|2|0>|<point|-1.0|1.73205080756888>>>|<with|color|black|<text-at|A|<point|-2.3|-0.5>>>|<with|color|black|<text-at|B|<point|2.1|-0.5>>>|<with|color|black|<text-at|C|<point|-1.2|1.93205080756888>>>|<with|color|blue|<text-at|<TeXmacs>|<point|-0.55|-0.75>>>>>>>

  The last step is pressing <key|S-Return> to execute the code and generate
  the drawing. We do it in a <markup|big-figure> environment
  (<menu|Insert|Image|Big figure>) to demonstrate seamless embedding:

  <\big-figure>
    <\script-output|scheme|default>
      (begin

      (define pi (acos -1))

      \;

      ;; a function for generating TeXmacs points

      (define (pt x y)

      \ \ `(point ,(number-\<gtr\>string x) ,(number-\<gtr\>string y)))

      \;

      ;; points for the triangle

      (define pA (pt -2 0))

      (define pB (pt 2 0))

      (define xC (- (* 2 (cos (/ pi 3))))); x-coordinate for point C

      (define yC (* 2 (sin (/ pi 3)))); y-coordinate for point C

      (define pC (pt xC yC))

      \;

      ;; points for the letters

      (define tA (pt -2.3 -0.5))

      (define tB (pt 2.1 -0.5))

      (define tC (pt (- xC 0.2) (+ yC 0.2)))

      \;

      (stree-\<gtr\>tree

      `(with "gr-geometry" (tuple "geometry" "400px" "300px" "center")

      \ \ \ (graphics

      ;; the arc and the line together make the semicircle

      (with "color" "black" (arc ,pA ,pC ,pB))

      (with "color" "black" (line ,pA ,pB))

      ;; a closed polyline for the triangle

      (with "color" "red" \ \ (cline ,pA ,pB ,pC))

      ;; add letters using text-at

      (with "color" "black" (text-at "A" ,tA)) \ 

      (with "color" "black" (text-at "B" ,tB)) \ 

      (with "color" "black" (text-at "C" ,tC))

      ;; finally decorate with the TeXmacs symbol

      (with "color" "blue" \ (text-at (TeXmacs) ,(pt -0.55 -0.75))))))) ; and
      close all of the parentheses!!!
    </script-output|<text|<with|gr-geometry|<tuple|geometry|400px|300px|center>|<graphics|<with|color|black|<arc|<point|-2|0>|<point|-1.0|1.73205080756888>|<point|2|0>>>|<with|color|black|<line|<point|-2|0>|<point|2|0>>>|<with|color|red|<cline|<point|-2|0>|<point|2|0>|<point|-1.0|1.73205080756888>>>|<with|color|black|<text-at|A|<point|-2.3|-0.5>>>|<with|color|black|<text-at|B|<point|2.1|-0.5>>>|<with|color|black|<text-at|C|<point|-1.2|1.93205080756888>>>|<with|color|blue|<text-at|<TeXmacs>|<point|-0.55|-0.75>>>>>>>

    \;
  <|big-figure>
    A drawing generated with <name|Scheme>, embedded in a <markup|big-figure>
    environment
  </big-figure>

  The drawing we generated is editable in two different ways.

  Placing the cursor at the drawing (just after or just before, the drawing
  is then surrounded by a thin cyan frame) and pressing <key|Return> brings
  back the yellow edit window, where the code can be changed and re-executed
  into a new drawing.

  <\script-input|scheme|default>
    (begin

    (define pi (acos -1))

    \;

    ;; a function for generating TeXmacs points

    (define (pt x y)

    \ \ `(point ,(number-\<gtr\>string x) ,(number-\<gtr\>string y)))

    \;

    ;; points for the triangle

    (define pA (pt -2 0))

    (define pB (pt 2 0))

    (define xC (- (* 2 (cos (/ pi 3))))); x-coordinate for point C

    (define yC (* 2 (sin (/ pi 3)))); y-coordinate for point C

    (define pC (pt xC yC))

    \;

    ;; points for the letters

    (define tA (pt -2.3 -0.5))

    (define tB (pt 2.1 -0.5))

    (define tC (pt (- xC 0.2) (+ yC 0.2)))

    \;

    (stree-\<gtr\>tree

    `(with "gr-geometry" (tuple "geometry" "400px" "300px" "center")

    \ \ \ (graphics

    \ \ ;; the arc and the line together make the semicircle

    \ \ (with "color" "black" (arc ,pA ,pC ,pB))

    \ \ (with "color" "black" (line ,pA ,pB))

    \ \ ;; a closed polyline for the triangle

    \ \ (with "color" "red" \ \ (cline ,pA ,pB ,pC))

    \ \ ;; add letters using text-at

    \ \ (with "color" "black" (text-at "A" ,tA)) \ 

    \ \ (with "color" "black" (text-at "B" ,tB)) \ 

    \ \ (with "color" "black" (text-at "C" ,tC))

    \ \ ;; finally decorate with the TeXmacs symbol

    \ \ ;; and close all of the parentheses!!!

    \ \ (with "color" "blue" \ (text-at (TeXmacs) ,(pt -0.55 -0.75)))))))
  </script-input|<text|<with|gr-geometry|<tuple|geometry|400px|300px|center>|<graphics|<with|color|black|<arc|<point|-2|0>|<point|-1.0|1.73205080756888>|<point|2|0>>>|<with|color|black|<line|<point|-2|0>|<point|2|0>>>|<with|color|red|<cline|<point|-2|0>|<point|2|0>|<point|-1.0|1.73205080756888>>>|<with|color|black|<text-at|A|<point|-2.3|-0.5>>>|<with|color|black|<text-at|B|<point|2.1|-0.5>>>|<with|color|black|<text-at|C|<point|-1.2|1.93205080756888>>>|<with|color|blue|<text-at|<TeXmacs>|<point|-0.55|-0.75>>>>>>>

  \;

  It is also possible to edit the drawing with the interactive (point and
  click) facilities. In this case too it is always possible to return to the
  text-editing mode of the <name|Executable> environment by pressing
  <key|Return> with the cursor at the drawing, but if one does that, the
  interactive modifications are lost, i.e. one gets back to the <name|Scheme>
  code one had typed into the <name|Executable> environment.
</body>

<\initial>
  <\collection>
    <associate|page-screen-margin|false>
    <associate|preamble|false>
    <associate|src-compact|normal>
    <associate|src-style|functional>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|auto-1|<tuple|?|?>>
    <associate|auto-2|<tuple|?|?>>
    <associate|auto-3|<tuple|?|?>>
    <associate|auto-4|<tuple|?|?>>
    <associate|auto-5|<tuple|?|?>>
    <associate|auto-6|<tuple|1|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|figure>
      <tuple|normal|<\surround|<hidden-binding|<tuple>|1>|>
        A drawing generated with <with|font-shape|<quote|small-caps>|Scheme>,
        embedded in a <with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|big-figure>
        environment
      </surround>|<pageref|auto-6>>
    </associate>
    <\associate|idx>
      <tuple|<tuple|<with|font-family|<quote|ss>|Insert>|<with|font-family|<quote|ss>|Fold>|<with|font-family|<quote|ss>|Executable>>|<pageref|auto-2>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Help>|<with|font-family|<quote|ss>|Manual>|<with|font-family|<quote|ss>|Creating
      technical pictures>>|<pageref|auto-3>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Insert>|<with|font-family|<quote|ss>|Fold>|<with|font-family|<quote|ss>|Executable>|<with|font-family|<quote|ss>|Scheme>>|<pageref|auto-4>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Insert>|<with|font-family|<quote|ss>|Image>|<with|font-family|<quote|ss>|Big
      figure>>|<pageref|auto-5>>
    </associate>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Embedding
      graphics composed with Scheme into documents>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-1><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>