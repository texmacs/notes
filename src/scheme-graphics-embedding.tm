<TeXmacs|1.99.15>

<style|<tuple|notes|old-lengths|framed-session>>

<\body>
  <\hide-preamble>
    <use-module|(graphics embedded-graphics embed-graphics)>
  </hide-preamble>

  <notes-header>

  <chapter*|Embedding graphics composed with Scheme into documents>

  <hlink|In a previous note|./scheme_graphics.tm>, we have shown an example
  of <TeXmacs> native graphics generated with <name|Scheme>, a triangle
  inscribed in a half-circle.

  Now let us see how to embed it seamlessly in a document. Our work is based
  on <name|Fold> <name|Executable> environments, available under
  <menu|Insert|Fold|Executable> (and then choose the <name|Scheme> option).

  Since in each <name|Executable> environment it is possible to execute one
  Scheme instruction only, we shall combine it with a <name|Scheme> module
  (that is realized in a <verbatim|.scm> file), which we will import through
  the <markup|use-module> primitive.

  For reading convenience, let us list here all of the code we will use in
  the module in a code box. It is the code that in the <hlink|previous
  note|./scheme_graphics.tm> defines the points, with small modifications and
  introduced by a <scm|texmacs-module> command which <TeXmacs> needs for
  interfacing with it:

  <\scm-code>
    (texmacs-module (graphics embedded-graphics embed-graphics))

    \;

    (define pi (acos -1))

    \;

    ;; a function for generating TeXmacs points

    (tm-define (pt x y)

    \ \ `(point ,(number-\<gtr\>string x) ,(number-\<gtr\>string y)))

    \;

    ;; points for the triangle

    (tm-define pA (pt -2 0))

    (tm-define pB (pt 2 0))

    (tm-define xC (- (* 2 (cos (/ pi 3))))); x-coordinate for point C

    (tm-define yC (* 2 (sin (/ pi 3)))); y-coordinate for point C

    (tm-define pC (pt xC yC))

    \;

    ;; points for the letters

    (tm-define tA (pt -2.3 -0.5))

    (tm-define tB (pt 2.1 -0.5))

    (tm-define tC (pt (- xC 0.2) (+ yC 0.2)))
  </scm-code>

  A synthetic discussion of <TeXmacs> graphics primitives and how to code
  them in <name|Scheme> is in the <hlink|previous note|./scheme_graphics.tm>
  (see also the manual, in <menu|Help|Manual|Creating technical pictures>).
  Here let us just remind that <TeXmacs> graphics are composed by listing
  graphical objects, each made by the application of a graphical primitive,
  inside a <markup|graphics> primitive.

  In the code in the module we introduce a function <scm|pt> that generates
  <markup|point> primitives, (which are parametrized by two numbers,
  expressed as strings), and with it we generate points that we will use in
  the <name|Executable> to build other primitives (<markup|arc>,
  <markup|line>, <markup|cline> and <markup|text-at>).

  In turn, <TeXmacs> will use the primitives to represent the triangle, the
  half-circle and the decorations, that is the drawing that we will embed in
  the document.

  In the module, we have used <scm|tm-define> rather than <scm|define> so
  that functions and variables may be imported from a <TeXmacs> document.

  We make the module available to TeXmacs by executing the primitive
  <markup|use-module> parametrized with the path of our <name|Scheme> module
  relative to the <verbatim|.TeXmacs> directory, in the case of this document

  <markup|use-module(<scm|(graphics embedded-graphics embed-graphics)>)>

  where <verbatim|graphics/embedded-graphics/embed-graphics.scm> is the path
  of the module (relative to the <verbatim|.TeXmacs> directory) I have used
  when writing the document (please substitute your path for that); the same
  path, with the same syntax, should be present as an argument of the initial
  <scm|texmacs-module> function in the <name|Scheme> module.

  The <markup|use-module> primitive can be conveniently placed in the
  document preamble (<menu|Document|Part|Create preamble>) so as to be
  invisible when writing the document and generating a printable copy. We did
  that in this document when composing it with <TeXmacs> and now the points
  <scm|pA>, <scm|pB>, <scm|pC>, <scm|tA>, <scm|tB> and <scm|tC> are
  available: we can use them inside a <name|Scheme> <name|Executable>
  environment.

  We open the environment with <menu|Insert|Fold|Executable|Scheme> and we
  obtain the yellow box we got used to in the note on <hlink|embedding TikZ
  graphics|./embedding-tikz-figures-short.tm>, in this case introduced by a
  <samp|Scheme> title on a gray background:

  <script-input|scheme|default||>

  Press <key|S-Return> and type or paste the graphics command (in this note
  let us copy the same command that generates the drawing in the
  <hlink|previous note|./scheme_graphics.tm>):

  <\script-input|scheme|default>
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

    (with "color" "blue" \ (text-at (TeXmacs) ,(pt -0.55 -0.75)))))) ; and
    close all of the parentheses!!!
  </script-input|>

  Scheme will execute only one command and because of this we placed all of
  the other commands in the external module.

  The last step is pressing <key|S-Return> to execute the code and generate
  the drawing. We do it in a <markup|big-figure> environment
  (<menu|Insert|Image|Big figure>) to demonstrate seamless embedding:

  <\big-figure>
    <\script-output|scheme|default>
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

      (with "color" "blue" \ (text-at (TeXmacs) ,(pt -0.55 -0.75)))))) ; and
      close all of the parentheses!!!
    </script-output|<text|<with|gr-geometry|<tuple|geometry|400px|300px|center>|<graphics|<with|color|black|<arc|<point|-2|0>|<point|-1.0|1.73205080756888>|<point|2|0>>>|<with|color|black|<line|<point|-2|0>|<point|2|0>>>|<with|color|red|<cline|<point|-2|0>|<point|2|0>|<point|-1.0|1.73205080756888>>>|<with|color|black|<text-at|A|<point|-2.3|-0.5>>>|<with|color|black|<text-at|B|<point|2.1|-0.5>>>|<with|color|black|<text-at|C|<point|-1.2|1.93205080756888>>>|<with|color|blue|<text-at|<TeXmacs>|<point|-0.55|-0.75>>>>>>>

    \;
  <|big-figure>
    A drawing generated with <name|Scheme>, embedded in a <markup|big-figure>
    <inactive|<compound|>>environment
  </big-figure>

  The drawing we generated is editable in two different ways. Placing the
  cursor at the drawing (just after or just before, the drawing is then
  surrounded by a thin cyan frame) and pressing <key|Return> brings back the
  yellow edit window, where the code can be changed and re-executed into a
  new drawing.

  <\big-figure>
    <\script-input|scheme|default>
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

      (with "color" "blue" \ (text-at (TeXmacs) ,(pt -0.55 -0.75)))))) ; and
      close all of the parentheses!!!
    </script-input|<text|<with|gr-geometry|<tuple|geometry|400px|300px|center>|<graphics|<with|color|black|<arc|<point|-2|0>|<point|-1.0|1.73205080756888>|<point|2|0>>>|<with|color|black|<line|<point|-2|0>|<point|2|0>>>|<with|color|red|<cline|<point|-2|0>|<point|2|0>|<point|-1.0|1.73205080756888>>>|<with|color|black|<text-at|A|<point|-2.3|-0.5>>>|<with|color|black|<text-at|B|<point|2.1|-0.5>>>|<with|color|black|<text-at|C|<point|-1.2|1.93205080756888>>>|<with|color|blue|<text-at|<TeXmacs>|<point|-0.55|-0.75>>>>>>>

    \;
  <|big-figure>
    The code re-opened after compilation and ready for re-editing.
  </big-figure>

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
    <associate|auto-6|<tuple|?|?>>
    <associate|auto-7|<tuple|1|?>>
    <associate|auto-8|<tuple|2|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|figure>
      <tuple|normal|<\surround|<hidden-binding|<tuple>|1>|>
        A drawing generated with <with|font-shape|<quote|small-caps>|Scheme>,
        embedded in a <with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|big-figure>
        <mark|<arg|body>|<inline-tag|<with|mode|<quote|src>|color|<quote|dark
        green>|font-shape|<quote|italic>|>>>environment
      </surround>|<pageref|auto-7>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|2>|>
        The code re-opened after compilation and ready for re-editing.
      </surround>|<pageref|auto-8>>
    </associate>
    <\associate|idx>
      <tuple|<tuple|<with|font-family|<quote|ss>|Insert>|<with|font-family|<quote|ss>|Fold>|<with|font-family|<quote|ss>|Executable>>|<pageref|auto-2>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Help>|<with|font-family|<quote|ss>|Manual>|<with|font-family|<quote|ss>|Creating
      technical pictures>>|<pageref|auto-3>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Document>|<with|font-family|<quote|ss>|Part>|<with|font-family|<quote|ss>|Create
      preamble>>|<pageref|auto-4>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Insert>|<with|font-family|<quote|ss>|Fold>|<with|font-family|<quote|ss>|Executable>|<with|font-family|<quote|ss>|Scheme>>|<pageref|auto-5>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Insert>|<with|font-family|<quote|ss>|Image>|<with|font-family|<quote|ss>|Big
      figure>>|<pageref|auto-6>>
    </associate>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Embedding
      graphics composed with Scheme into documents>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-1><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>