<TeXmacs|1.99.15>

<style|<tuple|notes|old-lengths|framed-session>>

<\body>
  <notes-header>

  <chapter*|Composing TeXmacs graphics with Scheme>

  <TeXmacs> provides a set of graphic primitives, which can be accessed in
  several ways: interactively with the Texmacs editor, directly through the
  <TeXmacs> source code (<TeXmacs> trees) or through <name|Scheme> (as
  <name|Scheme> trees). The manual at <menu|Help|Manual|Creating technical
  pictures> describes interactive generation and editing of drawings.

  In this note, we shall step through the generation of a simple drawing
  starting from Scheme code and translating it into a <TeXmacs> tree which
  then displays the graphics. We assume that the reader is familiar with
  simple Scheme syntax. Two possible web resources for learning <name|Scheme>
  are the <name|Wikipedia> book <hlink|Scheme
  programming|https://en.wikibooks.org/wiki/Scheme_Programming> and
  <hlink|Yet Another Scheme Tutorial|http://www.shido.info/lisp/idx_scm_e.html>
  by Takafumi Shido.

  We want to draw a triangle inscribed inside a semicircle, mark its vertices
  with letters and decorate the drawing with the text <TeXmacs>.

  The most comfortable way of generating a drawing with <name|Scheme> is
  within a session, so that is the way we'll take in this note. We'll see in
  other notes how to <hlink|blend seamlessly graphics in a
  document|./scheme-graphics-embedding.tm> and generate it through external
  source files.

  The first step in working with a session is opening it, with
  <menu|Insert|Session|Scheme>. As a side step, it is convenient to select
  <menu|Program bracket matching> in the preferences box under
  <menu|Edit|Preferences|Other>; this helps coding in <name|Scheme> by
  highlighting the parenthesis that matches the one next to the cursor.

  Now we will insert our commands at the prompt. We place small comments
  within text fields inserted by choosing <menu|Insert text field below> in
  the contextual menu, while longer explanations fit better in breaks between
  sessions.

  <\program|scheme|default>
    <\input|Scheme] >
      (define pi (acos -1))
    </input>

    <\textput>
      We will work with a circle so we need \<pi\>!
    </textput>

    <\input|Scheme] >
      (define (pt x y)

      \ \ `(point ,(number-\<gtr\>string x) ,(number-\<gtr\>string y)))
    </input>

    <\input|Scheme] >
      \;
    </input>

    \;
  </program>

  The Scheme function <scm|pt> we just defined generates a TeXmacs graphics
  point parametrized by its <scm|x> and <scm|y> coordinates.

  <markup|point> is a <TeXmacs> graphics primitive that represents a point
  and expects two strings. It is represented in <name|Scheme> with a list of
  three elements, the first element in the list being the symbol <scm|point>
  (since <scm|point> is a <name|Scheme> symbol, it fits well within the
  quasiquote that also defines the list).

  Using the <scm|pt> function we shall now define a few points.

  The <name|Scheme> interpreter expects one expression per prompt (evaluates
  only the first one it finds in each prompt), so we enter the expressions we
  need in separate prompts; the code in external <name|Scheme> programs
  is\Vof course\Vmore compact.

  <\session|scheme|default>
    <\textput>
      First of all, coordinates for the end points of the diameter, which is
      4 units long while the center of the circle is at the origin:
    </textput>

    <\input|Scheme] >
      (define pA (pt -2 0))
    </input>

    <\input|Scheme] >
      (define pB (pt 2 0))
    </input>

    <\textput>
      Then the third point of the triangle, on the circumference, defined
      with the help of two variables <scm|xC> and <scm|yC>:
    </textput>

    <\input|Scheme] >
      (define xC (- (* 2 (cos (/ pi 3)))))
    </input>

    <\input|Scheme] >
      (define yC (* 2 (sin (/ pi 3))))
    </input>

    <\input|Scheme] >
      (define pC (pt xC yC))
    </input>

    <\textput>
      Finally the points at which we will mark the triangle's vertices with
      letters:
    </textput>

    <\input|Scheme] >
      (define tA (pt -2.3 -0.5))
    </input>

    <\input|Scheme] >
      (define tB (pt 2.1 -0.5))
    </input>

    <\input|Scheme] >
      (define tC (pt (- xC 0.2) (+ yC 0.2)))
    </input>

    <\input|Scheme] >
      \;
    </input>
  </session>

  Let us take a look at the points we just defined. To display them as a
  <TeXmacs> graphics, we need to insert them in a canvas with the
  <markup|graphics> primitive, entered in <name|Scheme> as
  <verbatim|graphics>. The <name|Scheme> expression that starts with
  <verbatim|graphics> contains, after the symbol <verbatim|graphics>, a list
  of graphical objects; we will then write the canvas with our points as
  <scm|`(graphics ,pA ,pB ,pC)> with proper quasi- and unquoting (slightly
  different in the final form of the expression). Since <markup|graphics> by
  itself yields a rather large canvas, we size it down enclosing it in a
  <markup|with> primitive which specifies the geometry. The <scm|(with
  <text-dots> (graphics <text-dots>))> construct needs to be quasiquoted as
  <scm|with> and <verbatim|graphics> are Scheme symbols, so that the
  <verbatim|pA>, <verbatim|pB> and <verbatim|pC> variables, which represent
  the points, must be unquoted. Finally, everything has to be wrapped in the
  <verbatim|stree-\<gtr\>tree> function to become a TeXmacs tree. The result
  is a graphical representation of the three points:

  <\session|scheme|default>
    <\unfolded-io|Scheme] >
      (stree-\<gtr\>tree

      `(with "gr-geometry"\ 

      \ \ \ \ \ (tuple "geometry" "400px" "300px" "center")

      \ \ \ \ \ (graphics ,pA ,pB ,pC)))
    <|unfolded-io>
      <text|<with|gr-geometry|<tuple|geometry|400px|300px|center>|<graphics|<point|-2|0>|<point|2|0>|<point|-1.0|1.73205080756888>>>>
    </unfolded-io>

    <\textput>
      We can modify the appearance of the points enclosing each of them in
      the <markup|with> (<name|Scheme> symbol <scm|with>) primitive
    </textput>

    <\unfolded-io|Scheme] >
      (stree-\<gtr\>tree

      \ `(with "gr-geometry"\ 

      \ \ \ \ \ \ (tuple "geometry" "400px" "300px" "center")

      \ \ \ (graphics\ 

      \ \ \ \ \ \ (with "color" "blue" ,pA)

      \ \ \ \ \ \ (with "color" "red" ,pB)

      \ \ \ \ \ \ (with "color" "green" ,pC))))
    <|unfolded-io>
      <text|<with|gr-geometry|<tuple|geometry|400px|300px|center>|<graphics|<with|color|blue|<point|-2|0>>|<with|color|red|<point|2|0>>|<with|color|green|<point|-1.0|1.73205080756888>>>>>
    </unfolded-io>

    <\input|Scheme] >
      \;
    </input>
  </session>

  This example, with constructs boxed inside each other, is typical of
  <name|Scheme>: we compose a list out of other lists. In this case we pass
  then the list, made of lists, symbols and strings, to the function
  <scm|stree-\<gtr\>tree> that turns it into a <TeXmacs> tree.

  The next step is composing more complex graphical objects using the points
  we defined.

  We will use the <TeXmacs> graphical objects <scm|arc>, <scm|line>,
  <scm|cline> and <scm|text-at>. Their meaning and <name|Scheme> syntax is
  described in the following table:

  <tabular|<tformat|<cwith|2|-1|2|2|cell-hyphen|t>|<twith|table-width|1par>|<twith|table-hmode|exact>|<cwith|1|1|1|-1|cell-bsep|3sep>|<cwith|1|1|1|-1|cell-tborder|1ln>|<cwith|1|1|1|-1|cell-bborder|1ln>|<cwith|2|2|1|-1|cell-tborder|1ln>|<cwith|1|1|1|1|cell-lborder|0ln>|<cwith|1|1|3|3|cell-rborder|0ln>|<cwith|1|1|1|-1|cell-tsep|3sep>|<table|<row|<cell|object>|<cell|description>|<cell|Scheme
  syntax>>|<row|<cell|<scm|arc>>|<\cell>
    an arc of circle, defined by three points
  </cell>|<cell|<scm|(arc point<rsub|1> point<rsub|2>
  point<rsub|3>)>>>|<row|<cell|<scm|line>>|<\cell>
    a polyline, defined by two or more points
  </cell>|<cell|<scm|(line point<rsub|1> point<rsub|2> [<text-dots>
  point<rsub|n>])>>>|<row|<cell|<scm|cline>>|<\cell>
    a closed polyline, defined by three or more points
  </cell>|<cell|<scm|(cline point<rsub|1> point<rsub|2> point<rsub|3>
  [<text-dots> point<rsub|n>])>>>|<row|<cell|<scm|text-at>>|<\cell>
    a text box, whose position is defined with a single point
  </cell>|<cell|<scm|(text-at string point)>>>>>>

  Before composing the full drawing, let us take a look at one of the
  constructs; as an example we choose <scm|cline>. We place it as usual
  inside a <scm|with> construct to select the color and we wrap the
  <scm|with> up in the <scm|graphics> primitive, which is in turn enclosed in
  its own <scm|with> which sets the <scm|"gr-geometry"> property of the
  graphics object:\ 

  <\session|scheme|default>
    <\unfolded-io|Scheme] >
      (stree-\<gtr\>tree

      \ `(with "gr-geometry"\ 

      \ \ \ \ \ (tuple "geometry" "400px" "300px" "center")

      \ \ \ \ \ (graphics

      \ \ \ \ \ \ \ \ (with "color" "red" \ \ (cline ,pA ,pB ,pC)))))
    <|unfolded-io>
      <text|<with|gr-geometry|<tuple|geometry|400px|300px|center>|<graphics|<with|color|red|<cline|<point|-2|0>|<point|2|0>|<point|-1.0|1.73205080756888>>>>>>
    </unfolded-io>

    <\input|Scheme] >
      \;
    </input>
  </session>

  We are ready to compose our drawing; as usual the syntax is\ 

  <\scm-code>
    (graphics object_1 object_2 <text-dots> object_n)
  </scm-code>

  properly enclosed in other constructs (we change the linewidth as well as
  the color and we set the font shape for the whole graphics to italics),
  with the appropriate sequence of quasiquoting and unquotings:

  <\session|scheme|default>
    <\unfolded-io|Scheme] >
      (stree-\<gtr\>tree

      \ `(with "gr-geometry"\ 

      \ \ \ \ (tuple "geometry" "400px" "300px" "center")

      \ \ \ \ "font-shape" "italic"

      \ \ \ \ (graphics

      \ \ \ \ \ \ ;; the arc and the line together make the semicircle

      \ \ \ \ \ \ (with "color" "black" \ (arc ,pA ,pC ,pB))

      \ \ \ \ \ \ (with "color" "black" \ (line ,pA ,pB))

      \ \ \ \ \ \ ;; a closed polyline for the triangle

      \ \ \ \ \ \ (with "color" "red" "line-width" "1pt" (cline ,pA ,pB ,pC))

      \ \ \ \ \ \ ;; add letters using text-at

      \ \ \ \ \ \ (with "color" "black" \ (text-at "A" ,tA)) \ 

      \ \ \ \ \ \ (with "color" "black" \ (text-at "B" ,tB)) \ 

      \ \ \ \ \ \ (with "color" "black" \ (text-at "C" ,tC))

      \ \ \ \ \ \ ;; finally decorate with the TeXmacs symbol

      \ \ \ \ \ \ (with "color" "blue" \ "font-shape" "upright"\ 

      \ \ \ \ \ \ \ \ (text-at (TeXmacs) ,(pt -0.55 -0.75))))))\ 

      ;; and close all of the parentheses!!!
    <|unfolded-io>
      <text|<with|gr-geometry|<tuple|geometry|400px|300px|center>|font-shape|italic|<graphics|<with|color|black|<arc|<point|-2|0>|<point|-1.0|1.73205080756888>|<point|2|0>>>|<with|color|black|<line|<point|-2|0>|<point|2|0>>>|<with|color|red|line-width|1pt|<cline|<point|-2|0>|<point|2|0>|<point|-1.0|1.73205080756888>>>|<with|color|black|<text-at|A|<point|-2.3|-0.5>>>|<with|color|black|<text-at|B|<point|2.1|-0.5>>>|<with|color|black|<text-at|C|<point|-1.2|1.93205080756888>>>|<with|color|blue|font-shape|upright|<text-at|<TeXmacs>|<point|-0.55|-0.75>>>>>>
    </unfolded-io>

    <\input|Scheme] >
      \;
    </input>
  </session>

  In follow-up tutorials we will see how to <hlink|embed seamlessly
  <name|Scheme> graphics in a document|./scheme-graphics-embedding.tm> using
  the <menu|Fold|Executable> environment and how to generate them from
  external files.

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
    <associate|auto-6|<tuple|?|?>>
    <associate|auto-7|<tuple|?|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|idx>
      <tuple|<tuple|<with|font-family|<quote|ss>|Help>|<with|font-family|<quote|ss>|Manual>|<with|font-family|<quote|ss>|Creating
      technical pictures>>|<pageref|auto-2>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Insert>|<with|font-family|<quote|ss>|Session>|<with|font-family|<quote|ss>|Scheme>>|<pageref|auto-3>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Program bracket
      matching>>|<pageref|auto-4>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Edit>|<with|font-family|<quote|ss>|Preferences>|<with|font-family|<quote|ss>|Other>>|<pageref|auto-5>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Insert text field
      below>>|<pageref|auto-6>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Fold>|<with|font-family|<quote|ss>|Executable>>|<pageref|auto-7>>
    </associate>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Composing
      TeXmacs graphics with Scheme> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-1><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>