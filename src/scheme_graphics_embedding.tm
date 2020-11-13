<TeXmacs|1.99.14>

<style|<tuple|notes|old-lengths|framed-session>>

<\body>
  <\hide-preamble>
    <use-module|(graphics embeddedGraphics embedGraphics)>
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
  introduced by a <scm|texmacs-module> command which makes the module
  available to <TeXmacs>:

  <\scm-code>
    (texmacs-module (graphics embeddedGraphics embedGraphics))

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

    (tm-define xC (- (* 2 (cos (/ pi 3)))));x-coordinate for point C

    (tm-define yC (* 2 (sin (/ pi 3))));y-coordinate for point C

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
  graphical objects, each made by the application of a graphics primitive,
  inside a <markup|graphics> primitive.

  In the code in the module we introduce a function <scm|pt> that generates
  <markup|point> primitives, (which are parametrized by two numbers,
  expressed as strings), and we use it to generate points that we will use in
  the <name|Executable> to build other primitives (<markup|arc>,
  <markup|line>, <markup|cline> and <markup|text-at>).

  In turn, <TeXmacs> will use the primitives to represent the triangle, the
  half-circle and the decorations, that is the drawing that we will embed in
  the document.

  In the module, we have used <scm|tm-define> rather than <scm|define> so
  that functions and variables may be imported from a <TeXmacs> document.

  We make the module available to TeXmacs by executing the primitive
  <markup|use-module> parametrized with the path of our <name|Scheme> module,
  in the case of this document

  <markup|use-module(<scm|(graphics embeddedGraphics embedGraphics)>)>

  where <verbatim|graphics/embeddedGraphics/embedGraphics.scm> is the path of
  the module.

  The <markup|use-module> primitive can be conveniently placed in the
  document preamble (<menu|Document|Part|Create preamble>) so as to be
  invisible when writing the document and generating a printable copy.

  We did that in\ 

  <\session|scheme|default>
    <\input|Scheme] >
      (use-modules (graphics embeddedGraphics embedGraphics))
    </input>

    <\unfolded-io|Scheme] >
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
    <|unfolded-io>
      <text|<with|gr-geometry|<tuple|geometry|400px|300px|center>|<graphics|<with|color|black|<arc|<point|-2|0>|<point|-1.0|1.73205080756888>|<point|2|0>>>|<with|color|black|<line|<point|-2|0>|<point|2|0>>>|<with|color|red|<cline|<point|-2|0>|<point|2|0>|<point|-1.0|1.73205080756888>>>|<with|color|black|<text-at|A|<point|-2.3|-0.5>>>|<with|color|black|<text-at|B|<point|2.1|-0.5>>>|<with|color|black|<text-at|C|<point|-1.2|1.93205080756888>>>|<with|color|blue|<text-at|<TeXmacs>|<point|-0.55|-0.75>>>>>>
    </unfolded-io>

    <\input|Scheme] >
      \;
    </input>
  </session>

  In follow-up tutorials we will see how to embed seamlessly <name|Scheme>
  graphics in a document using the <menu|Fold|Executable> environment and how
  to generate them from external files.

  As a conclusion of this note, here is a collection of <TeXmacs> graphical
  objects, illustrating a few possibilities:

  <with|gr-mode|<tuple|group-edit|edit-props>|gr-frame|<tuple|scale|1cm|<tuple|0.5gw|0.5gh>>|gr-geometry|<tuple|geometry|1par|0.6par>45|<graphics|<\document-at>
    <rotate|45|lines>

    in a multiline

    text
  </document-at|<point|3.91686187855536|2.66778808493186>>|<point|-5.81987|3.09112>|<line|<point|-5.81220898678082|1.98182238174751>|<point|-3.44152757389552|1.98182423913605>|<point|-1.79051553526607|2.5109947643378>>|<with|color|red|<cline|<point|-5.69287|0.318263>|<point|-4.06302090223575|-0.295574811483>|<point|-5.2906965207038|-0.930579441725096>|<point|-6.22203664505887|-0.761244873660537>>>|<with|color|blue|<spline|<point|-5.50236|-1.84075>|<point|-2.58134343167086|-1.58675089297526>|<point|-1.71350377033999|-0.210907527450721>|<point|-1.45950191824315|-0.295574811483>>>|<with|color|orange|fill-color|yellow|line-width|2ln|<cspline|<point|0.640072419501616|2.97694937121585>|<point|0.44063081569717|0.83552077293348>|<point|1.7500743167287|1.74000719130103>|<point|2.48612943100676|1.96478314344897>>>|<with|dash-style|zigzag|color|magenta|<arc|<point|-0.231826|-2.49692>|<point|0.382011509458923|-1.54441725095912>|<point|-0.274159941791242|-1.14224765180579>>>|<with|color|green|line-width|2ln|<carc|<point|1.3133556158222|-1.33274516920228>|<point|2.13886073951581|-2.07358797645192>|<point|3.40887|-0.888246>>>|<text-at|<rotate|45|text>text|<point|-5.5447|-3.2166>>|<math-at|<rotate|45|\<alpha\>+\<beta\>=\<gamma\>>\<alpha\>+\<beta\>=\<gamma\>|<point|-2.81418|-3.25893>>>>
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
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|idx>
      <tuple|<tuple|<with|font-family|<quote|ss>|Insert>|<with|font-family|<quote|ss>|Fold>|<with|font-family|<quote|ss>|Executable>>|<pageref|auto-2>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Help>|<with|font-family|<quote|ss>|Manual>|<with|font-family|<quote|ss>|Creating
      technical pictures>>|<pageref|auto-3>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Fold>|<with|font-family|<quote|ss>|Executable>>|<pageref|auto-4>>
    </associate>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Embedding
      graphics composed with Scheme into documents>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-1><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>