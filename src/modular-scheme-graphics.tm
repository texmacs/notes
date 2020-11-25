<TeXmacs|1.99.16>

<style|<tuple|notes|framed-session>>

<\body>
  <notes-header>

  <chapter*|Modular graphics with <name|Scheme>>

  <TeXmacs> graphics provide a set of elementary objects (points, polylines,
  splines and so on). It would be nice to have at hand functions to deal with
  complex objects, which can be seen as unions of elementary objects: for
  example, \ a triangle in a half-circle is the union of a polyline (to
  represent the triangle) with the half-circle, which in turn is the union of
  a polyline (the diameter of the half-circle) and an arc.

  We would like to name complex objects and to transform them as units: for
  example translate them or change the line style or the color for all of the
  object components; naming complex objects will make our code clearer when
  we deal with them\Vand for example we use them as building blocks of even
  more complex objects.

  In this post, we show how to compose and use in a drawing complex graphical
  objects, how to shift them and how to set properties of already-existing
  complex objects.

  <section|Composing complex objects>

  In <name|Scheme>, a natural way of composing complex objects is joining the
  building blocks into a list. To get <TeXmacs> to draw the objects
  represented by our (possibly nested) lists, we need to transform them into
  lists that conform to the <TeXmacs> graphical input.

  The input for graphics in <TeXmacs> <name|Scheme> is a list which starts
  with the symbol <scm|graphics>, whose elements are elementary graphical
  objects. Each elementary graphical object is a list, which starts with one
  of these symbols: <scm|point>, <scm|line>, <scm|cline>, <scm|spline>,
  <scm|cspline>, <scm|arc>, <scm|carc>, <scm|text-at>, <scm|math-at>,
  <scm|document-at>, and can be optionally wrapped in a list starting with
  the symbol <scm|with> that sets properties.

  One possible way to turn an arbitrarily nested list of elementary objects
  (a complex object, that is) into the flat list of lists that <TeXmacs>
  expects is flattening it recursively, stopping the recursive flattening
  every time we find one of the symbols that indicate the start of a
  graphical object (including the symbol <scm|with>).

  The following group of three functions does that. The main function is
  adapted from <hlink|one of the answers|https://stackoverflow.com/a/33338401>
  to this <hlink|Stack Overflow question|https://stackoverflow.com/questions/33338078/flattening-a-list-in-scheme>.

  <paragraph|Flattening nested lists of graphical objects>

  <\session|scheme|default>
    <\textput>
      <scm|denest-test> is a test to stop denestification when one finds one
      of the symbols in the list <scm|objects-list> or the symbol <scm|with>.

      We build it up from an <scm|object-test>, which check membership in
      <scm|object-list>. <scm|object-test> itself will help later too, in a
      function that applies properties to all of the elementary components of
      an object.\ 
    </textput>

    <\input|Scheme] >
      (define objects-list '(point line cline spline arc\ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ carc text-at math-at
      document-at))
    </input>

    <\input|Scheme] >
      (define (object-test expr)\ 

      \ \ (not (equal?

      \ \ \ \ \ \ \ \ (filter (lambda (x) (equal? x expr)) objects-list)

      \ \ \ \ \ \ \ \ '())))
    </input>

    <\input|Scheme] >
      (define (denest-test expr)

      \ \ (or

      \ \ \ (object-test expr)

      \ \ \ (equal? expr 'with)))
    </input>

    <\textput>
      <scm|denestify-conditional> flattens a list recursively, stopping the
      recursion if it meets one of the symbols in <scm|objects-list> or the
      symbol <scm|with>.<marginal-note|normal|c|<small|<with|color|red|make
      sure that <scm|denestify-conditional> is not redundant; if <scm|(car
      lst)> is an atom perhaps I do not need to check that it stops
      flattening, but I need just to <scm|cons> it. Need to check corner
      cases (if it is the first element of the top list for example)>>>

      <scm|denestify-conditional> is not tail-recursive; we write it in this
      way as it is simpler than the tail-recursive version and it will work
      fairly, as in these examples we will apply it to short lists.

      A tail-recursive version of the function is given in <hlink|another
      answer|https://stackoverflow.com/a/33338608> to the same StackExchange
      question which we used as starting point.
    </textput>

    <\input|Scheme] >
      ;; start from the answer https://stackoverflow.com/a/33338401\ 

      ;; to the Stack Overflow question

      ;; https://stackoverflow.com/questions/33338078/flattening-a-list-in-scheme:

      \;

      ;;(define (denestify lst)

      ;; \ (cond ((null? lst) '())

      ;; \ \ \ \ \ \ \ ((pair? (car lst))

      ;; \ \ \ \ \ \ \ \ (append (denestify (car lst))

      ;; \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (denestify (cdr lst))))

      ;; \ \ \ \ \ \ \ (else (cons (car lst) (denestify (cdr lst))))))

      \;

      ;; This function is not tail-recursive; see
      https://stackoverflow.com/a/33338608

      ;; for a tail-recursive function

      \ \ (define (denestify-conditional lst)

      \ \ \ \ (cond ((null? lst) '())

      \ \ \ \ \ \ \ \ \ \ ((pair? (car lst))

      \ \ \ \ \ \ \ \ \ \ \ ; If the car of (car lst) is 'with or another\ 

      \ \ \ \ \ \ \ \ \ \ \ ; of the symbols in denest-test, we cons it

      \ \ \ \ \ \ \ \ \ \ \ (if (denest-test (car (car lst)))\ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (cons (car lst)

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (denestify-conditional (cdr
      lst)))

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ;; otherwise we flatten it with
      recursion,

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ;; obtaining a flat list, and append it
      to

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ;; the flattened rest of the list, in
      this

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ;; way flattening the combination of the\ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ;; two lists

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (append (denestify-conditional (car lst))

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (denestify-conditional
      (cdr lst)))))

      \ \ \ \ \ \ \ \ \ \ ;; (car lst) is an atom

      \ \ \ \ \ \ \ \ \ \ (else (if (denest-test (car lst))\ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ; test presence of (car lst) in the
      list\ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ; of symbols that stop denestification

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ lst ;; we leave lst as it is

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ;; otherwise we cons (car lst) onto the

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ;; flattened version of (cdr lst)

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (cons (car lst)
      (denestify-conditional (cdr lst)))))))
    </input>

    <\input|Scheme] >
      \;
    </input>
  </session>

  <paragraph|Definition of basic graphical objects>

  Let us define a function for generating points, and use that to define some
  graphical objects:

  <\session|scheme|default>
    <\input|Scheme] >
      (define (pt x y)

      \ \ `(point ,(number-\<gtr\>string x) ,(number-\<gtr\>string y)))
    </input>

    <\textput>
      \;
    </textput>

    <\textput>
      We will work with a circle so we need \<pi\>!
    </textput>

    <\input|Scheme] >
      (define pi (acos -1))
    </input>

    <\textput>
      Define points for the triangle
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

    <\textput>
      Use points to build up a drawing, where each object is typed down as a
      list.
    </textput>

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
  </session>

  <paragraph|Combination of individual graphical objects into complex
  objects>

  Let us join graphical objects as lists to form complex graphical objects.
  We will use the conditional flattening inside the graphical list to express
  our complex objects in the way <TeXmacs> expects them.

  <\session|scheme|default>
    <\input|Scheme] >
      (define triangle `(with "color" "red" "line-width" "1pt" (cline ,pA ,pB
      ,pC)))
    </input>

    <\input|Scheme] >
      (define half-circle `(

      (with "color" "black" (arc ,pA ,pC ,pB))

      (with "color" "black" (line ,pA ,pB))))
    </input>

    <\input|Scheme] >
      (define letters `((with "color" "black" \ (text-at "A" ,tA))

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (with "color" "black" \ (text-at
      "B" ,tB))

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (with "color" "black" \ (text-at
      "C" ,tC))))
    </input>

    <\input|Scheme] >
      (define caption `((with "color" "blue" \ "font-shape" "upright"

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (text-at (TeXmacs) ,(pt
      -0.55 -0.75)))))
    </input>

    <\unfolded-io|Scheme] >
      (stree-\<gtr\>tree

      \ `(with "gr-geometry"

      \ \ \ \ \ \ (tuple "geometry" "400px" "300px" "center")

      \ \ \ \ "font-shape" "italic"

      \ \ \ \ ,(denestify-conditional `(graphics

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ,triangle

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ,letters

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ,half-circle

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ,caption))))

      \ 
    <|unfolded-io>
      <text|<with|gr-geometry|<tuple|geometry|400px|300px|center>|font-shape|italic|<graphics|<with|color|red|line-width|1pt|<cline|<point|-2|0>|<point|2|0>|<point|-1.0|1.73205080756888>>>|<with|color|black|<text-at|A|<point|-2.3|-0.5>>>|<with|color|black|<text-at|B|<point|2.1|-0.5>>>|<with|color|black|<text-at|C|<point|-1.2|1.93205080756888>>>|<with|color|black|<arc|<point|-2|0>|<point|-1.0|1.73205080756888>|<point|2|0>>>|<with|color|black|<line|<point|-2|0>|<point|2|0>>>|<with|color|blue|font-shape|upright|<text-at|<TeXmacs>|<point|-0.55|-0.75>>>>>>
    </unfolded-io>
  </session>

  <paragraph|A function for complex graphics>

  To write less ourselves, we can define a function that flattens graphics
  lists and wraps them with the <TeXmacs> syntax:

  <\session|scheme|default>
    <\input|Scheme] >
      (define (scheme-graphics x-size y-size alignment graphics-list)

      \ \ (stree-\<gtr\>tree

      \ \ \ `(with "gr-geometry" (tuple "geometry" ,x-size ,y-size alignment)

      \ \ \ \ \ \ "font-shape" "italic"

      \ \ \ \ \ \ ,(denestify-conditional `(graphics ,graphics-list)))))
    </input>

    <\textput>
      Let's use it:
    </textput>

    <\unfolded-io|Scheme] >
      (scheme-graphics "400px" "300px" "center" `(

      ,half-circle

      ,triangle

      ,letters

      ,caption))
    <|unfolded-io>
      <text|<with|gr-geometry|<tuple|geometry|400px|300px|alignment>|font-shape|italic|<graphics|<with|color|black|<arc|<point|-2|0>|<point|-1.0|1.73205080756888>|<point|2|0>>>|<with|color|black|<line|<point|-2|0>|<point|2|0>>>|<with|color|red|line-width|1pt|<cline|<point|-2|0>|<point|2|0>|<point|-1.0|1.73205080756888>>>|<with|color|black|<text-at|A|<point|-2.3|-0.5>>>|<with|color|black|<text-at|B|<point|2.1|-0.5>>>|<with|color|black|<text-at|C|<point|-1.2|1.93205080756888>>>|<with|color|blue|font-shape|upright|<text-at|<TeXmacs>|<point|-0.55|-0.75>>>>>>
    </unfolded-io>
  </session>

  <section|Manipulation of complex objects>

  We would like to manipulate complex objects as units. Let's see how to
  translate them; one can in a similar way rotate and stretch them (perhaps
  with respect to reference points which are calculated from the objects
  themselves). We will then see how to apply properties to all of the
  components of an object.

  <paragraph|Translate complex objects>

  Since all objects are made out of points (that is, lists that start with
  the symbol <scm|point>), we need to translate each point which the list is
  composed of.

  We do it by mapping a translation function
  recursively<marginal-note|normal|c|<small|<with|color|red|do I need to
  mention that my functions for translation and property setting are not
  tail-recursive?>>> onto the list that represents a complex object; in this
  recursive mapping we distinguish between expressions that represent points
  (that have to be translated) and expressions that represent something else
  (that have to be left as they are).

  The distinction is made when the recursion either gets to a point or gets
  to an atom: if it does get to an atom, then it is
  transformed<marginal-note|normal|c|<small|<with|color|red|I need a better
  expression here: to keep immutability evident in the sentence>>> into
  itself. Here is the algorithm applied to a list:

  <\itemize>
    <item>If the list starts with <scm|point>, we apply the function that
    translates the point

    <item>If the list does not start with <scm|point>, we map the translation
    function onto the list

    <item>If while mapping we meet an atom, we leave it as it is
  </itemize>

  <\session|scheme|default>
    <\textput>
      A function to translate points
    </textput>

    <\input|Scheme] >
      (define (translate-point point delta)

      \ \ (let ((coord (map string-\<gtr\>number (cdr point))))

      \ \ \ \ (pt (+ (car coord) (car delta))

      \ \ \ \ \ \ \ \ (+ (cadr coord) (cadr delta)))))
    </input>

    <\textput>
      The general translation function. It is called <scm|translate-element>
      rather than <scm|translate-object> because it applies to all elements,
      including atoms.
    </textput>

    <\input|Scheme] >
      (define (translate-element element delta)

      \ \ (cond ((list? element)

      \ \ \ \ \ \ \ \ \ (if (equal? (car element) 'point)

      \ \ \ \ \ \ \ \ \ \ \ \ \ (translate-point element delta)

      \ \ \ \ \ \ \ \ \ \ \ \ \ (map (lambda (x) (translate-element x delta))
      element)))

      \ \ \ \ \ \ \ \ (else

      \ \ \ \ \ \ \ \ \ \ element)))
    </input>

    <\textput>
      Let's apply this function to a polyline to see its effect on the
      <name|Scheme> expression:
    </textput>

    <\unfolded-io|Scheme] >
      (translate-element `((line ,(pt 1 2) ,(pt 2 3) ,(pt 3 4))

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (text-at TeXmacs ,(pt -1 -1))) '(1
      1))
    <|unfolded-io>
      ((line (point "2" "3") (point "3" "4") (point "4" "5")) (text-at
      TeXmacs (point "0" "0")))
    </unfolded-io>

    <\input|Scheme] >
      \;
    </input>
  </session>

  Let us now use our translation function on a complex object in a drawing:
  the triangle inscribed in the half-circle we first drew by listing all of
  the elementary objects and then by combining the complex <scm|triangle>,
  <scm|half-circle> and <scm|letter> objects (we are then going to add the
  <TeXmacs> caption!).

  This time, we define the whole drawing as a unit, calling it
  <scm|triangle-in-half-circle>; we will need to remember to unquote the
  symbol <scm|triangle-in-half-circle> when placing it inside lists defined
  through quasiquoting.

  <\session|scheme|default>
    <\input|Scheme] >
      (define triangle-in-half-circle

      \ \ `(

      ,half-circle

      ,triangle

      ,letters))
    </input>

    <\textput>
      Draw it by placing it in the list argument of the <scm|scheme-graphics>
      function:
    </textput>

    <\unfolded-io|Scheme] >
      (scheme-graphics "400px" "300px" "center"\ 

      `(,triangle-in-half-circle)))
    <|unfolded-io>
      <text|<with|gr-geometry|<tuple|geometry|400px|300px|alignment>|font-shape|italic|<graphics|<with|color|black|<arc|<point|-2|0>|<point|-1.0|1.73205080756888>|<point|2|0>>>|<with|color|black|<line|<point|-2|0>|<point|2|0>>>|<with|color|red|line-width|1pt|<cline|<point|-2|0>|<point|2|0>|<point|-1.0|1.73205080756888>>>|<with|color|black|<text-at|A|<point|-2.3|-0.5>>>|<with|color|black|<text-at|B|<point|2.1|-0.5>>>|<with|color|black|<text-at|C|<point|-1.2|1.93205080756888>>>>>>
    </unfolded-io>

    <\textput>
      Now add to the drawing a translated copy of
      <scm|triangle-in-half-circle> and the <TeXmacs> caption (translating
      that too):
    </textput>

    <\unfolded-io|Scheme] >
      (scheme-graphics "400px" "300px" "center" `(

      ,triangle-in-half-circle

      ,(translate-element triangle-in-half-circle '(1.0 -1.5))

      ,(translate-element caption '(1.0 -1.5))))
    <|unfolded-io>
      <text|<with|gr-geometry|<tuple|geometry|400px|300px|alignment>|font-shape|italic|<graphics|<with|color|black|<arc|<point|-2|0>|<point|-1.0|1.73205080756888>|<point|2|0>>>|<with|color|black|<line|<point|-2|0>|<point|2|0>>>|<with|color|red|line-width|1pt|<cline|<point|-2|0>|<point|2|0>|<point|-1.0|1.73205080756888>>>|<with|color|black|<text-at|A|<point|-2.3|-0.5>>>|<with|color|black|<text-at|B|<point|2.1|-0.5>>>|<with|color|black|<text-at|C|<point|-1.2|1.93205080756888>>>|<with|color|black|<arc|<point|-1.0|-1.5>|<point|0.0|0.23205080756888>|<point|3.0|-1.5>>>|<with|color|black|<line|<point|-1.0|-1.5>|<point|3.0|-1.5>>>|<with|color|red|line-width|1pt|<cline|<point|-1.0|-1.5>|<point|3.0|-1.5>|<point|0.0|0.23205080756888>>>|<with|color|black|<text-at|A|<point|-1.3|-2.0>>>|<with|color|black|<text-at|B|<point|3.1|-2.0>>>|<with|color|black|<text-at|C|<point|-0.2|0.43205080756888>>>|<with|color|blue|font-shape|upright|<text-at|<TeXmacs>|<point|0.45|-2.25>>>>>>
    </unfolded-io>
  </session>

  <paragraph|Manipulate object properties>

  We write a simple function which wraps each elementary object in a
  <scm|with>, placing it inside with respect to any other <scm|with>
  construct the object might be already placed in. This function, applied a
  few times, generates deeply nested lists that may be difficult to read; a
  more refined function would check if the object is already inside a
  <scm|with> construct and if it is, modify the <scm|with> list rather than
  adding another one. We prefer the simple function to the refined one to
  keep this post to the point (\Pmodular graphics\Q).

  The <scm|with> needs to be placed as innermost wrapping construct for each
  element so that the new property will prevail onto pre-existing properties
  (<scm|with>s are scoping constructs).

  The <scm|apply-property> function is built with the same logic as the
  <scm|translate-element> function. When applied to a list, it first checks
  if the list starts with one of the \Pgraphical object\Q symbols; if it
  does, <scm|apply-property> wraps it in a <scm|with> construct; if it does
  not, <scm|apply-property> maps itself onto the list elements. When applied
  to an atom, <scm|apply-property> returns the input.

  In this way the function seeks recursively inside the lists of all the
  graphical objects, and applies the desired property to each.

  <\session|scheme|default>
    <\input|Scheme] >
      (define (apply-property element name value)

      \ \ (cond\ 

      \ \ \ \ ((list? element)

      \ \ \ \ \ (if (object-test (car element))

      \ \ \ \ \ \ \ \ \ `(with ,name ,value ,element)

      \ \ \ \ \ \ \ \ \ (map (lambda (x) (apply-property x name value))
      element)))

      \ \ \ \ \ (else element))) \ \ \ \ \ \ \ \ 
    </input>

    <\textput>
      Let's apply dashing to the <scm|triangle> object (let us view the
      <name|Scheme> lists):
    </textput>

    <\unfolded-io|Scheme] >
      (apply-property triangle "dash-style" "11100")
    <|unfolded-io>
      (with "color" "red" "line-width" "1pt" (with "dash-style" "11100"
      (cline (point "-2" "0") (point "2" "0") (point "-1.0"
      "1.73205080756888"))))
    </unfolded-io>

    <\textput>
      We act on a more complex object in the same way as we do on a simpler
      object\Vwe now apply dashing to the translated copy of
      <scm|triangle-in-half-circle>:
    </textput>

    <\unfolded-io|Scheme] >
      (apply-property

      \ \ (translate-element triangle-in-half-circle '(1.0 -1.5))

      \ \ "dash-style" "11100")
    <|unfolded-io>
      (((with "color" "black" (with "dash-style" "11100" (arc (point "-1.0"
      "-1.5") (point "0.0" "0.23205080756888") (point "3.0" "-1.5")))) (with
      "color" "black" (with "dash-style" "11100" (line (point "-1.0" "-1.5")
      (point "3.0" "-1.5"))))) (with "color" "red" "line-width" "1pt" (with
      "dash-style" "11100" (cline (point "-1.0" "-1.5") (point "3.0" "-1.5")
      (point "0.0" "0.23205080756888")))) ((with "color" "black" (with
      "dash-style" "11100" (text-at "A" (point "-1.3" "-2.0")))) (with
      "color" "black" (with "dash-style" "11100" (text-at "B" (point "3.1"
      "-2.0")))) (with "color" "black" (with "dash-style" "11100" (text-at
      "C" (point "-0.2" "0.43205080756888"))))))
    </unfolded-io>

    <\textput>
      Placing our objects in the list argument of <scm|scheme-graphics>, we
      obtain the drawing in a modular way:
    </textput>

    <\unfolded-io|Scheme] >
      (scheme-graphics "400px" "300px" "center" `(

      ,triangle-in-half-circle

      ,(apply-property

      \ \ (translate-element triangle-in-half-circle '(1.0 -1.5))

      \ \ "dash-style" "11100")

      ,(translate-element caption '(1.0 -1.5))))
    <|unfolded-io>
      <text|<with|gr-geometry|<tuple|geometry|400px|300px|alignment>|font-shape|italic|<graphics|<with|color|black|<arc|<point|-2|0>|<point|-1.0|1.73205080756888>|<point|2|0>>>|<with|color|black|<line|<point|-2|0>|<point|2|0>>>|<with|color|red|line-width|1pt|<cline|<point|-2|0>|<point|2|0>|<point|-1.0|1.73205080756888>>>|<with|color|black|<text-at|A|<point|-2.3|-0.5>>>|<with|color|black|<text-at|B|<point|2.1|-0.5>>>|<with|color|black|<text-at|C|<point|-1.2|1.93205080756888>>>|<with|color|black|<with|dash-style|11100|<arc|<point|-1.0|-1.5>|<point|0.0|0.23205080756888>|<point|3.0|-1.5>>>>|<with|color|black|<with|dash-style|11100|<line|<point|-1.0|-1.5>|<point|3.0|-1.5>>>>|<with|color|red|line-width|1pt|<with|dash-style|11100|<cline|<point|-1.0|-1.5>|<point|3.0|-1.5>|<point|0.0|0.23205080756888>>>>|<with|color|black|<with|dash-style|11100|<text-at|A|<point|-1.3|-2.0>>>>|<with|color|black|<with|dash-style|11100|<text-at|B|<point|3.1|-2.0>>>>|<with|color|black|<with|dash-style|11100|<text-at|C|<point|-0.2|0.43205080756888>>>>|<with|color|blue|font-shape|upright|<text-at|<TeXmacs>|<point|0.45|-2.25>>>>>>
    </unfolded-io>

    <\textput>
      <scm|apply-property> and <scm|translate-element> can be applied in both
      orders. In the previous example we translated first the object, then we
      applied the dashing; here we apply the dashed style first, then we
      translate the object.
    </textput>

    <\unfolded-io|Scheme] >
      (scheme-graphics "400px" "300px" "center" `(

      ,triangle-in-half-circle

      ,(translate-element\ 

      \ \ (apply-property

      \ \ \ triangle-in-half-circle\ 

      \ \ "dash-style" "11100")

      \ \ '(1.0 -1.5))

      ,(translate-element caption '(1.0 -1.5))))
    <|unfolded-io>
      <text|<with|gr-geometry|<tuple|geometry|400px|300px|alignment>|font-shape|italic|<graphics|<with|color|black|<arc|<point|-2|0>|<point|-1.0|1.73205080756888>|<point|2|0>>>|<with|color|black|<line|<point|-2|0>|<point|2|0>>>|<with|color|red|line-width|1pt|<cline|<point|-2|0>|<point|2|0>|<point|-1.0|1.73205080756888>>>|<with|color|black|<text-at|A|<point|-2.3|-0.5>>>|<with|color|black|<text-at|B|<point|2.1|-0.5>>>|<with|color|black|<text-at|C|<point|-1.2|1.93205080756888>>>|<with|color|black|<with|dash-style|11100|<arc|<point|-1.0|-1.5>|<point|0.0|0.23205080756888>|<point|3.0|-1.5>>>>|<with|color|black|<with|dash-style|11100|<line|<point|-1.0|-1.5>|<point|3.0|-1.5>>>>|<with|color|red|line-width|1pt|<with|dash-style|11100|<cline|<point|-1.0|-1.5>|<point|3.0|-1.5>|<point|0.0|0.23205080756888>>>>|<with|color|black|<with|dash-style|11100|<text-at|A|<point|-1.3|-2.0>>>>|<with|color|black|<with|dash-style|11100|<text-at|B|<point|3.1|-2.0>>>>|<with|color|black|<with|dash-style|11100|<text-at|C|<point|-0.2|0.43205080756888>>>>|<with|color|blue|font-shape|upright|<text-at|<TeXmacs>|<point|0.45|-2.25>>>>>>
    </unfolded-io>

    <\textput>
      The last application of <scm|apply-property> prevails, as it is set in
      the innermost <scm|with> list; subobjects which have individually-set
      values of the property will all be set to the value fixed by the last
      application of <scm|apply-property>. Here we apply a short-dash style
      on an object which has long-dashing throughout:
    </textput>

    <\unfolded-io|Scheme] >
      (scheme-graphics "400px" "300px" "center" `(

      ,triangle-in-half-circle

      ,(translate-element\ 

      \ \ (apply-property

      \ \ \ (apply-property

      \ \ \ triangle-in-half-circle\ 

      \ \ "dash-style" "11100")

      \ \ "dash-style" "101010")

      \ \ '(1.0 -1.5))

      ,(translate-element caption '(1.0 -1.5))))
    <|unfolded-io>
      <text|<with|gr-geometry|<tuple|geometry|400px|300px|alignment>|font-shape|italic|<graphics|<with|color|black|<arc|<point|-2|0>|<point|-1.0|1.73205080756888>|<point|2|0>>>|<with|color|black|<line|<point|-2|0>|<point|2|0>>>|<with|color|red|line-width|1pt|<cline|<point|-2|0>|<point|2|0>|<point|-1.0|1.73205080756888>>>|<with|color|black|<text-at|A|<point|-2.3|-0.5>>>|<with|color|black|<text-at|B|<point|2.1|-0.5>>>|<with|color|black|<text-at|C|<point|-1.2|1.93205080756888>>>|<with|color|black|<with|dash-style|11100|<with|dash-style|101010|<arc|<point|-1.0|-1.5>|<point|0.0|0.23205080756888>|<point|3.0|-1.5>>>>>|<with|color|black|<with|dash-style|11100|<with|dash-style|101010|<line|<point|-1.0|-1.5>|<point|3.0|-1.5>>>>>|<with|color|red|line-width|1pt|<with|dash-style|11100|<with|dash-style|101010|<cline|<point|-1.0|-1.5>|<point|3.0|-1.5>|<point|0.0|0.23205080756888>>>>>|<with|color|black|<with|dash-style|11100|<with|dash-style|101010|<text-at|A|<point|-1.3|-2.0>>>>>|<with|color|black|<with|dash-style|11100|<with|dash-style|101010|<text-at|B|<point|3.1|-2.0>>>>>|<with|color|black|<with|dash-style|11100|<with|dash-style|101010|<text-at|C|<point|-0.2|0.43205080756888>>>>>|<with|color|blue|font-shape|upright|<text-at|<TeXmacs>|<point|0.45|-2.25>>>>>>
    </unfolded-io>
  </session>

  <section|<name|Scheme> expressions that show what we mean>

  We apply again the idea of modularity<marginal-note|normal|c|<small|<with|color|red|or
  is it abstraction in this case?>>> by assigning to a variable the object
  which we obtain after translation and application of dashing, and using the
  variable to build a drawing. Our code again shows that in <name|Scheme>
  building blocks combine together well.

  <\session|scheme|default>
    <\input|Scheme] >
      (define translated-triangle-in-half-circle-short-dashes

      \ \ (translate-element\ 

      \ \ (apply-property

      \ \ \ (apply-property

      \ \ \ triangle-in-half-circle\ 

      \ \ "dash-style" "11100")

      \ \ "dash-style" "101010")

      \ \ '(1.0 -1.5))) \ 
    </input>

    <\input|Scheme] >
      (define translated-caption (translate-element caption '(1.0 -1.5)))
    </input>

    <\textput>
      The drawing is made out of complex objects, but the final expression
      shows what we have in mind: our geometrical construction and a shifted
      replica drawn with short dashes.
    </textput>

    <\unfolded-io|Scheme] >
      (scheme-graphics "400px" "300px" "center" `(

      ,triangle-in-half-circle

      ,translated-triangle-in-half-circle-short-dashes

      ,translated-caption))
    <|unfolded-io>
      <text|<with|gr-geometry|<tuple|geometry|400px|300px|alignment>|font-shape|italic|<graphics|<with|color|black|<arc|<point|-2|0>|<point|-1.0|1.73205080756888>|<point|2|0>>>|<with|color|black|<line|<point|-2|0>|<point|2|0>>>|<with|color|red|line-width|1pt|<cline|<point|-2|0>|<point|2|0>|<point|-1.0|1.73205080756888>>>|<with|color|black|<text-at|A|<point|-2.3|-0.5>>>|<with|color|black|<text-at|B|<point|2.1|-0.5>>>|<with|color|black|<text-at|C|<point|-1.2|1.93205080756888>>>|<with|color|black|<with|dash-style|11100|<with|dash-style|101010|<arc|<point|-1.0|-1.5>|<point|0.0|0.23205080756888>|<point|3.0|-1.5>>>>>|<with|color|black|<with|dash-style|11100|<with|dash-style|101010|<line|<point|-1.0|-1.5>|<point|3.0|-1.5>>>>>|<with|color|red|line-width|1pt|<with|dash-style|11100|<with|dash-style|101010|<cline|<point|-1.0|-1.5>|<point|3.0|-1.5>|<point|0.0|0.23205080756888>>>>>|<with|color|black|<with|dash-style|11100|<with|dash-style|101010|<text-at|A|<point|-1.3|-2.0>>>>>|<with|color|black|<with|dash-style|11100|<with|dash-style|101010|<text-at|B|<point|3.1|-2.0>>>>>|<with|color|black|<with|dash-style|11100|<with|dash-style|101010|<text-at|C|<point|-0.2|0.43205080756888>>>>>|<with|color|blue|font-shape|upright|<text-at|<TeXmacs>|<point|0.45|-2.25>>>>>>
    </unfolded-io>
  </session>

  <with|color|red|<small|Examine <scm|with> lists (for input checking:
  <hlink|https://stackoverflow.com/a/13377695|https://stackoverflow.com/a/13377695>)>>

  Another possibility is to define styles as shortcuts to set several
  properties of a graphical object with a single operation. For examples,
  styles could be defined as lists of name-value pairs (this might allow
  easier error-checking), which can be inserted into <scm|with> constructs by
  a function which first flattens the pairs then appends the resulting list
  into a <scm|'(with ... object)> list at the position we indicated with the
  dots to apply all of the properties to <scm|object>. Never mind that the
  <name|Scheme> syntax to achieve what we want is slightly different from our
  description, it is close enough that I hope it is convincing.

  About persuasion. I hope that I convinced you that the initial effort of
  setting up <name|Scheme> functions pays off: one constructs a powerful
  graphical language in which arbitrarily complex graphics are treated
  uniformly.

  \;

  \;

  \;

  \;

  \;

  \;

  \;

  \;

  \;

  \;

  \;

  \;

  \;
</body>

<\initial>
  <\collection>
    <associate|page-medium|papyrus>
    <associate|page-screen-margin|false>
    <associate|preamble|false>
    <associate|prog-scripts|scheme>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|auto-1|<tuple|?|3>>
    <associate|auto-10|<tuple|3|14>>
    <associate|auto-2|<tuple|1|3>>
    <associate|auto-3|<tuple|1|3>>
    <associate|auto-4|<tuple|2|5>>
    <associate|auto-5|<tuple|3|7>>
    <associate|auto-6|<tuple|4|8>>
    <associate|auto-7|<tuple|2|9>>
    <associate|auto-8|<tuple|1|9>>
    <associate|auto-9|<tuple|2|11>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Modular
      graphics with <with|font-shape|<quote|small-caps>|Scheme>>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-1><vspace|0.5fn>

      1.<space|2spc>Composing complex objects
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2>

      <with|par-left|<quote|4tab>|Flattening nested lists of graphical
      objects <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3><vspace|0.15fn>>

      <with|par-left|<quote|4tab>|Definition of basic graphical objects
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4><vspace|0.15fn>>

      <with|par-left|<quote|4tab>|Combination of individual graphical objects
      into complex objects <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-5><vspace|0.15fn>>

      <with|par-left|<quote|4tab>|A function for complex graphics
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6><vspace|0.15fn>>

      2.<space|2spc>Manipulation of complex objects
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-7>

      <with|par-left|<quote|4tab>|Translate complex objects
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-8><vspace|0.15fn>>

      <with|par-left|<quote|4tab>|Manipulate object properties
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-9><vspace|0.15fn>>

      3.<space|2spc><with|font-shape|<quote|small-caps>|Scheme> expressions
      that show what we mean <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-10>
    </associate>
  </collection>
</auxiliary>