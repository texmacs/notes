<TeXmacs|1.99.14>

<style|<tuple|notes|triangle-list|compact-list>>

<\body>
  <\hide-preamble>
    \;
  </hide-preamble>

  <notes-header>

  <chapter*|An overview of <TeXmacs> from altitude>

  <small|A rapid overview/executive summary of the <TeXmacs> system.>

  <section*|Main features>

  <\itemize>
    <item>Visual <with|font-series|bold|structured> editor: WYSWYG
    <with|font-series|bold|&> WYSWYM

    <item>Inspired by <TeX> and <name|Emacs>

    <item>High-quality typesetting algorithms (including microtypography)

    <item>Special features for mathematical typesetting and input

    <item>Support for interactive sessions: Scheme, Python, R, Octave,
    Maxima, Axiom, Mathemagix (and other CAS).

    <item>Multi-platform: Unix, MacOS, Windows (via <name|Qt>)

    <item>Own format (<name|XML><nbsp>like). Native output to <name|PDF> and
    <name|PS>. Export to <LaTeX>, <name|HTML>

    <item>Internal image editor, interfaces to <name|Svn> and <name|Git>,
    versioning tool, database tool, encryption of documents.

    <item>Website and documentation written in TeXmacs
  </itemize>

  <section*|Gallery>

  <\center>
    <image|../resources/overview/texmacs-1.png|500px|||>

    The legacy X11 backend
  </center>

  <\center>
    <image|../resources/overview/texmacs-ffnlogn.png|600px|||>

    The <name|Qt> backend, high quality typesetting
  </center>

  <\center>
    <image|../resources/overview/Screenshot 2019-05-11 at
    13.15.10.png|600px|||>

    Structured editing, high quality math typesetting
  </center>

  <\center>
    <image|../resources/overview/texmacs-beamer.png|600px|||>

    Presentation mode
  </center>

  <\center>
    <image|../resources/overview/Screenshot 2019-05-11 at
    12.48.10.png|500px|||>

    Graphics editor
  </center>

  <\center>
    <image|../resources/overview/Screenshot 2019-05-11 at
    13.08.48.png|650px|||>

    Microtypography, synthetic math fonts
  </center>

  <\center>
    <image|../resources/overview/Screenshot 2019-05-11 at
    13.16.53.png|600px|||>

    Interfaces to external packages (here Dra<TeX>)
  </center>

  <\center>
    <image|../resources/overview/texmacs-cas.png|600px|||>

    Interfaces to external packages (here <name|Mathemagix> and
    <name|Maxima>)
  </center>

  <\center>
    <image|../resources/overview/texmacs-chinese.png|600px|||>

    Support for oriental scripts
  </center>

  \;

  <section*|Development>

  <\itemize>
    <item>Started in 1998 by <name|Joris Van Der Hoeven>

    <\small>
      <\itemize-dot>
        <item>v0.2.3\<beta\> released 26 Oct 1999

        <item>v1.0 (2002)

        <item><name|Qt> backend in v1.0.7 (2008)

        <item>native <name|Pdf> support in v1.99.1 (2013)

        <item>currently version 1.99.9 (soon 2.1)
      </itemize-dot>
    </small>

    <item>Written in <name|C++> (~300.000 loc) and <name|Scheme> (~150.000
    loc) (from <hlink|[openhub]|https://www.openhub.net/p/texmacs/analyses/latest/languages_summary>).

    <item>Fully modular, external dependencies (mostly) isolated via tight
    interfaces.

    <item>Two UI backends: legacy <name|X11> with custom widget library,
    modern <name|Qt> backend (cross-platform support).

    <item><with|font-series|bold|GNU Guile as extension language>. C++ export
    basic manipulation routines and few internal datatypes.
  </itemize>

  <section*|TeXmacs' content model>

  All <TeXmacs> documents or document fragments can be thought of as
  <em|trees>.\ 

  \;

  For instance, the tree

  <\equation*>
    <tree|<text|<markup|with>>|mode|math|<tree|<text|<markup|concat>>|x+y+|<tree|<text|<markup|frac>>|1|2>|+|<tree|<text|<markup|sqrt>>|y+z>>>
  </equation*>

  typically represents the formula

  <\equation*>
    <label|tm-tree-ex>x+y+<frac|1|2>+<sqrt|y+z>
  </equation*>

  <section*|External representations>

  Serialization of TeXmacs documents without loss of informations

  \;

  <\itemize-dot>
    <item><TeXmacs> format

    <\quote-env>
      <framed-fragment|<verbatim|\<less\>with\|mode\|math\|x+y+\<less\>frac\|1\|2\<gtr\>+\<less\>sqrt\|y+z\<gtr\>\<gtr\>>>
    </quote-env>

    <item><name|XML> format

    <\quote-env>
      <framed-fragment|<\verbatim>
        \<less\>frac\<gtr\>\<less\>tm-arg\<gtr\>1\<less\>/tm-arg\<gtr\>\<less\>tm-arg\<gtr\>2\<less\>/tm-arg\<gtr\>\<less\>/frac\<gtr\>+\<less\>sqrt\<gtr\>y+z\<less\>/sqrt\<gtr\>
      </verbatim>>
    </quote-env>

    <item> <name|Scheme> format

    <\framed-fragment>
      <verbatim|(with "mode" "math" (concat "x+y+" (frac "1" "2") "+" (sqrt
      "y+z")))>
    </framed-fragment>
  </itemize-dot>

  <section*|Typesetting>

  Typesetting process converts TeXmacs trees into boxes:

  <with|gr-mode|<tuple|group-edit|move>|gr-frame|<tuple|scale|1cm|<tuple|0.5gw|0.5gh>>|gr-geometry|<tuple|geometry|1par|0.130433par|center>|gr-snap|<tuple|text
  border point|control point|grid point|grid curve point|curve-grid
  intersection|curve point|curve-curve intersection>|gr-arrow-end|\<gtr\>|gr-line-width|2ln|<graphics||<text-at|<with|ornament-vpadding|.5em|ornament-hpadding|.5em|<decorated|<verbatim|tree>>>|<point|-6.05515610530493|-0.144066675486175>>|<text-at|<with|ornament-vpadding|.5em|ornament-hpadding|.5em|<decorated|<verbatim|tree>>>|<point|-0.74740375711073|-0.17892578383384>>|<text-at|<with|ornament-vpadding|.5em|ornament-hpadding|.5em|<decorated|<verbatim|boxes>>>|<point|4.6472218547427|-0.153684349781717>>|<with|color|#aaf|arrow-end|\<gtr\>|line-width|2ln|<line|<point|-4.22002|0.0257971>|<point|-0.898548088371478|-0.00906204524407991>>>|<with|color|#aaf|arrow-end|\<gtr\>|line-width|2ln|<line|<point|1.08773|-0.00906205>|<point|4.49608083079772|0.0334534991400979>>>|<text-at|evaluation|<point|-4.0|-0.7>>|<text-at|typesetting|<point|1.5|-0.7>>>>

  The <hlink|typesetting primitives|../regular/regular.en.tm> are designed to
  be very fast and they are built-in into the editor:

  <\quote-env>
    <small|e.g. typesetting primitives for horizontal concatenations
    (<markup|concat>), page breaks (<markup|page-break>), mathematical
    fractions (<markup|frac>), hyperlinks (<markup|hlink>), and so on.>
  </quote-env>

  The rendering of many of the primitives may be customized through the
  <hlink|built-in environment variables|../environment/environment.en.tm>.

  <\quote-env>
    <small|e.g. the environment variable <src-var|color> specifies the
    current color of objects, <src-var|par-left> the current left margin of
    paragraphs, <abbr|etc.>>
  </quote-env>

  The <hlink|stylesheet language|../stylesheet/stylesheet.en.tm> allows the
  user to write new primitives (macros) on top of the built-in primitives.\ 

  <\quote-env>
    <small|Contains primitives for defining macros, conditional statements,
    computations, delayed execution, <abbr|etc.> and a special
    <markup|extern> tag to inject <scheme> expressions in order to write
    macros.>
  </quote-env>

  <section*|Macros>

  Evaluation of TeXmacs trees proceeds by reduction of the primitives,
  essentialy by evaluation of macro applications.

  \;

  <\tm-fragment>
    <inactive*|<assign|hello|<macro|name|Hello <arg|name>, how are you
    today?>>>
  </tm-fragment>

  \;

  Macros have editable input fields. Examples here below (activate the
  macros):

  <inactive|<assign|hello|<macro|name|Hello <with|color|red|<arg|name>>, how
  are you today?>>>

  <hello|dsdjskjds>

  <inactive|<assign|seq|<macro|val|<math|<around*|(|<arg|val><rsub|1>,\<ldots\>,<arg|val><rsub|n>|)>>>>>

  <\equation*>
    <seq|f>=<seq|g>
  </equation*>

  <section*|<name|Guile> as extension language>

  TeXmacs is extendable and customizable in various ways:

  <\itemize>
    <item><name|<with|font-series|bold|Guile>> embedded as extension and
    scripting language

    <item>A plugin system allows asyncronous communication with external
    programs\ 

    <item>Mechanism to dynamically load external code (via C interface)
  </itemize>

  \;

  <name|Guile> is easy to embed and provides a reasonably fast implementation
  of <name|Scheme>.

  \;

  Why <name|Scheme>?

  <\enumerate>
    <item>Allows to mix programs and data in a common framework.

    <item>Allows to customize the language itself, by adding new programming
    constructs.

    <item>Allows to write programs on a very abstract level.
  </enumerate>

  <section*| Menus>

  <\scm-code>
    (menu-bind file-menu

    \ \ ("New" (new-buffer))

    \ \ ("Load" (choose-file load-buffer "Load file" ""))

    \ \ ("Save" (save-buffer))

    \ \ ...)
  </scm-code>

  can be easily extended from user code:

  <\scm-code>
    (menu-bind insert-menu

    \ \ (former)

    \ \ \U\U\U

    \ \ (-\<gtr\> "Opening"

    \ \ \ \ \ \ ("Dear Sir" (insert "Dear Sir,"))

    \ \ \ \ \ \ ("Dear Madam" (insert "Dear Madam,")))

    \ \ (-\<gtr\> "Closing"

    \ \ \ \ \ \ ("Yours sincerely" (insert "Yours sincerely,"))

    \ \ \ \ \ \ ("Greetings" (insert "Greetings,"))))
  </scm-code>

  <section*|Some more GUI>

  Keybindings

  <\scm-code>
    (kbd-map

    \ \ ("D e f ." (make 'definition))

    \ \ ("L e m ." (make 'lemma))

    \ \ ("P r o p ." (make 'proposition))

    \ \ ("T h ." (make 'theorem)))
  </scm-code>

  The file <verbatim|my-init-buffer.scm> is executed every time a buffer is
  loaded, it allows some specific customizations. For example:

  <\scm-code>
    (if (not (buffer-has-name? (current-buffer)))

    \ \ \ \ (begin

    \ \ \ \ \ \ (init-style "article")

    \ \ \ \ \ \ (buffer-pretend-saved (current-buffer))))

    \;

    (if (not (buffer-has-name? (current-buffer)))

    \ \ \ \ (make-session "maxima" (url-\<gtr\>string (current-buffer))))
  </scm-code>

  <section*|Scheme invocation>

  <name|Scheme> commands can be invoked interactively (like in <name|Emacs>)
  using the <shortcut|(interactive footer-eval)> shortcut.\ 

  A <scheme> session is started using the <menu|Insert|Session|Scheme> menu
  item:

  <\session|scheme|default>
    <\folded-io|scheme] >
      (define (square x) (* x x))
    </folded-io|>

    <\folded-io|scheme] >
      (square 1111111)
    </folded-io|>

    <\folded-io|scheme] >
      (kbd-map ("h i ." (insert "Hi there!")))
    </folded-io|>

    <\folded-io|scheme] >
      ;; try typing ``hi.''
    </folded-io|>
  </session>

  <name|Scheme> commands can be invoked from the command line:

  <\shell-code>
    texmacs text.tm -x "(print)" -q
  </shell-code>

  Or scheme statement executed from inside TeXmacs macros:

  <\tm-fragment>
    <inactive*|<extern|(lambda (x) `(concat "Hallo " ,x))|Piet>>
  </tm-fragment>

  <section*|The <scm|tm-define> macro>

  <with|font-shape|italic|Contextual overloading>\ 

  Function definition can depend on several run-time conditions (e.g. editor
  mode). This allows to develop modular user interfaces.

  <\scm-code>
    (tm-define (hello) (insert "Hello"))

    (tm-define (hello) (:require (in-math?)) (insert-go-to "hello()" '(6)))
  </scm-code>

  <\scm-code>
    (tm-define (hello)

    \ \ (if (in-math?) (insert-go-to "hello()" '(6)) (former)))
  </scm-code>

  <\scm-code>
    (tm-define (my-replace what by)

    \ \ default-implementation)

    \;

    (tm-define (my-replace what by)

    \ \ (:require (== what by))

    \ \ (noop))
  </scm-code>

  <section*|Meta informations>

  <\scm-code>
    (tm-define (square x)

    \ \ (:synopsis "Compute the square of @x")

    \ \ (:argument x "A number")

    \ \ (:returns "The square of @x")

    \ \ (* x x))
  </scm-code>

  Used via e.g. <scm|(help square)>. Allows for interactive input of
  parameters: typing <shortcut|(interactive exec-interactive-command)>
  followed by <scm|square> and <shortcut|(kbd-return)> and you will be
  prompted for \PA number\Q on the footer (or in a dialog). Tab-completion.

  <\scm-code>
    (tm-property (choose-file fun text type)

    \ \ (:interactive #t))
  </scm-code>

  to indicate interactive commands in menu items like:

  <\scm-code>
    ("Load" (choose-file load-buffer "Load file" ""))
  </scm-code>

  Check-marks for menu items:

  <\scm-code>
    (tm-define (toggle-session-math-input)

    \ \ (:check-mark "v" session-math-input?)

    \ \ (session-use-math-input (not (session-math-input?))))
  </scm-code>

  \;

  <\scm-code>
    (tm-define mouse-unfold

    \ \ (:secure #t)

    \ \ (with-action t

    \ \ \ \ (tree-go-to t :start)

    \ \ \ \ (fold)))
  </scm-code>

  <\unfolded>
    This is a fold/unfold environment
  <|unfolded>
    It allows to toggle the display of its content by switching the tag from
    <markup|fold> to <markup|unfold> and back.
  </unfolded>

  <section*|<name|Scheme> representation TeXmacs content>

  <\itemize-dot>
    <item><with|font-series|bold|Passive trees> (<verbatim|stree>)

    <\equation*>
      <frac|a<rsup|2>|b+c>
    </equation*>

    is typically represented by

    <\scm-code>
      (frac (concat "a" (rsup "2")) "b+c")
    </scm-code>

    convenient to manipulate content directly using standard <scheme>
    routines on lists.

    <item><with|font-series|bold|Active trees> (<verbatim|tree>). <TeXmacs>
    internal C++ type <verbatim|tree> which is exported to <name|Scheme> via
    the glue. Keeps track of the <with|font-shape|italic|position> of the
    tree inside the global document tree and can be used to programmatically
    modify documents.

    <item><with|font-series|bold|Hybrid representation> (<verbatim|content>).
    an expression of the type <verbatim|content> is either a string, a tree
    or a list whose first element is a symbol and whose remaining elements
    are other expressions of type <verbatim|content>.

    <\session|scheme|default>
      <\input|scheme] >
        (tree-set! t '(document "First line." "Second line."))
      </input>

      <\input|scheme] >
        (tree-set t 1 "New second line.")
      </input>

      <\input|scheme] >
        (tree-set t 0 `(strong ,(tree-ref t 0)))
      </input>
    </session>
  </itemize-dot>

  <section*|A full example>

  \;

  <\scm-code>
    (tm-define (swap-numerator-denominator t)

    \ \ (:require (tree-is? t 'frac))

    \ \ (with p (tree-cursor-path t)

    \ \ \ \ (tree-set! t `(frac ,(tree-ref t 1) ,(tree-ref t 0)))

    \ \ \ \ (tree-go-to t (cons (- 1 (car p)) (cdr p)))

    \ \ \ \ (tree-focus t)))
  </scm-code>

  \;

  To be called as <scm|(swap-numerator-denominator (focus-tree))>, or just
  add it as a structured variant to <markup|frac>

  <\scm-code>
    (tm-define (variant-circulate t forward?)

    \ \ (:require (tree-is? t 'frac))

    \ \ (swap-numerator-denominator t))
  </scm-code>

  <section*|Regular expressions>

  \;

  \;

  <TeXmacs> implements the routines <scm|match?> and <scm|select> for
  matching regular expressions and selecting subexpressions along a \Ppath\Q.
  For instance: \ in the current buffer search all expressions of the form

  <\equation*>
    <frac|<with|color|brown|a>|1+<sqrt|<with|color|brown|b>>>
  </equation*>

  where <math|<with|color|brown|a>> and <math|<with|color|brown|b>> are
  general expressions:

  <\session|scheme|default>
    <\input|Scheme] >
      (select (buffer-tree) '(:* (:match (frac :%1 (concat "1+" (sqrt
      :%1))))))
    </input>
  </session>

  <section*|More scheme>

  <with|font-series|bold|User preferences>

  <\scm-code>
    (define-preferences

    \ \ ("Gnu's hair color" "brown" notify-gnu-hair-change)

    \ \ ("Snail's cruising speed" "1mm/sec" notify-Achilles))
  </scm-code>

  \;

  <with|font-series|bold|New data formats and converters>

  <\scm-code>
    (define-format blablah

    \ \ (:name "Blablah")

    \ \ (:suffix "bla"))

    \;

    (converter blablah-file latex-file

    \ \ (:require (url-exists-in-path? "bla2tex"))

    \ \ (:shell "bla2tex" from "\<gtr\>" to))
  </scm-code>

  When a format can be converted from or into <TeXmacs>, then it will
  automatically appear into the <menu|File|Export> and <menu|File|Import>
  menus. Similarly, when a format can be converted to <name|Postscript>, then
  it also becomes a valid format for images. <TeXmacs> also attempts to
  combine explicitly declared converters into new ones.

  <section*|Dialogues & Widgets>

  <with|font-series|bold|Dialogues>

  <\session|scheme|default>
    <\input|Scheme] >
      (user-ask "First number:"

      \ \ (lambda (a)

      \ \ \ \ (user-ask "Second number:"

      \ \ \ \ \ \ (lambda (b)

      \ \ \ \ \ \ \ \ (set-message (number-\<gtr\>string (*
      (string-\<gtr\>number a)

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (string-\<gtr\>number
      b)))

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "product")))))
    </input>
  </session>

  \;

  <with|font-series|bold|Widgets>

  <\session|scheme|default>
    <\input|Scheme] >
      (tm-widget (example3)

      \ \ (hlist\ 

      \ \ \ \ (bold (text "Hello"))

      \ \ \ \ \<gtr\>\<gtr\>\<gtr\>

      \ \ \ \ (inert (explicit-buttons ("world" (display "!\\n"))))))
    </input>

    <\input|Scheme] >
      (top-window example3 "Some text")
    </input>

    <\input|Scheme] >
      \;
    </input>
  </session>

  <section*|<scm|tree-view>>

  <with|font-base-size|8|<\session|scheme|default>
    <\input|Scheme] >
      (define t

      \ \ (stree-\<gtr\>tree

      \ \ \ '(root

      \ \ \ \ \ (library "Library" "$TEXMACS_PIXMAP_PATH/tm_german.xpm" 01

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ (collection "Cool stuff" 001)

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ (collection "Things to read" 002)

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ (collection "Current work" 003

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (collection
      "Forever current" 004)

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (collection "Read
      me" 005))))))
    </input>

    <\input|Scheme] >
      (define dd

      \ \ (stree-\<gtr\>tree

      \ \ \ '(list (library DisplayRole DecorationRole UserRole:1)

      \ \ \ \ \ \ \ \ \ \ (collection DisplayRole UserRole:1))))
    </input>

    <\input|Scheme] >
      (define (action clicked cmd-role . user-roles)

      \ \ (display* "clicked= " clicked ", cmd-role= " cmd-role

      \ \ \ \ \ \ \ \ \ \ \ \ ", user-roles= " user-roles "\\n")))
    </input>

    <\input|Scheme] >
      (tm-widget (widget-library)

      \ \ (resize ("150px" "400px" "9000px") ("300px" "600px" "9000px")

      \ \ \ \ (vertical

      \ \ \ \ \ \ (bold (text "Testing tree-view"))

      \ \ \ \ \ \ ===

      \ \ \ \ \ \ (tree-view action t dd))))
    </input>

    <\input|Scheme] >
      (top-window widget-library "Tree View")
    </input>

    <\input|Scheme] >
      \;
    </input>
  </session>>

  <section*|Forms>

  <with|font-base-size|8|<\session|scheme|default>
    <\input|Scheme] >
      (tm-widget (form3 cmd)

      \ \ (resize "500px" "500px"

      \ \ \ \ (padded

      \ \ \ \ \ \ (form "Test"

      \ \ \ \ \ \ \ \ (aligned

      \ \ \ \ \ \ \ \ \ \ (item (text "Input:")

      \ \ \ \ \ \ \ \ \ \ \ \ (form-input "fieldname1" "string" '("one")
      "1w"))

      \ \ \ \ \ \ \ \ \ \ (item === ===)

      \ \ \ \ \ \ \ \ \ \ (item (text "Enum:")

      \ \ \ \ \ \ \ \ \ \ \ \ (form-enum "fieldname2" '("one" "two" "three")
      "two" "2w"))

      \ \ \ \ \ \ \ \ \ \ (item === ===)

      \ \ \ \ \ \ \ \ \ \ (item (text "Choice:")

      \ \ \ \ \ \ \ \ \ \ \ \ (form-choice "fieldname3" '("one" "two"
      "three") "one"))

      \ \ \ \ \ \ \ \ \ \ (item === ===)

      \ \ \ \ \ \ \ \ \ \ (item (text "Choices:")

      \ \ \ \ \ \ \ \ \ \ \ \ (form-choices "fieldname4"\ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ '("one" "two"
      "three")\ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ '("one" "two"))))

      \ \ \ \ \ \ \ \ (bottom-buttons

      \ \ \ \ \ \ \ \ \ \ ("Cancel" (cmd "cancel")) \<gtr\>\<gtr\>

      \ \ \ \ \ \ \ \ \ \ ("Ok"

      \ \ \ \ \ \ \ \ \ \ \ (display* (form-fields) " -\<gtr\> "
      (form-values) "\\n")

      \ \ \ \ \ \ \ \ \ \ \ (cmd "ok")))))))
    </input>

    <\input|Scheme] >
      (dialogue-window form3 (lambda (x) (display* x "\\n")) "Test of form3")
    </input>

    <\input|Scheme] >
      \;
    </input>
  </session>>

  <section*|Bibliography styles>

  New styles can be defined via <name|Scheme> modules like
  <verbatim|example.scm> defined as follows:

  <\scm-code>
    (texmacs-module (bibtex example)

    \ \ (:use (bibtex bib-utils)))

    \;

    (bib-define-style "example" "plain")

    \;

    (tm-define (bib-format-date e)

    \ \ (:mode bib-example?)

    \ \ (bib-format-field e "year"))
  </scm-code>

  This example style behaves in a similar way as the <verbatim|plain> style,
  except that all dates are formatted according to our custom routine. Styles
  are stored in <verbatim|$TEXMACS_PATH/progs/bibtex> and referred to as e.g.
  <verbatim|tm-example> (for \ when used in a <TeXmacs> document.

  \;

  <section*|Graphics>

  Graphics objects are also part of the TeXmacs format and can be manipulated
  programmatically from Scheme.

  Actually, part of the graphics editor is written in Scheme.

  \;

  <\session|scheme|default>
    <\unfolded-io|Scheme] >
      (stree-\<gtr\>tree\ 

      \ \ '(with gr-geometry (tuple "geometry" "200px" "100px" "center")\ 

      \ \ \ \ \ \ \ \ \ color "blue"\ 

      \ \ \ \ \ \ \ \ (graphics (text-at "TeXmacs" (point "-2.5" "-1"))\ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (point 0 -1)\ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (line (point 0 0) (point 0 1)\ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (point 1 1) (point 1 0)
      (point 0 0)))))
    <|unfolded-io>
      <text|<with|gr-geometry|<tuple|geometry|200px|100px|center>|color|blue|<graphics|<text-at|TeXmacs|<point|-2.5|-1>>|<point|0|-1>|<line|<point|0|0>|<point|0|1>|<point|1|1>|<point|1|0>|<point|0|0>>>>>
    </unfolded-io>

    <\input|Scheme] >
      \;
    </input>
  </session>

  <section*|The future of TeXmacs>

  Many improvements ahead

  \;

  <\itemize>
    <item>Version 2.1 to be released soon

    <item>Update the backend to <name|Qt><nbsp>5 (currently
    <name|Qt><nbsp>4.8) [almost there]

    <item>Adapt the scheme code to run on <name|Guile<nbsp>3>. (currently
    <name|Guile><nbsp>1.8) [WIP]

    <item>New website, documentations, videos [WIP]

    <item><name|Jupyter> plugins (protocol to interface to many computational
    kernels, e.g. <name|Python>, <name|Julia>, <name|R>, <name|Haskell>,
    <name|Guile>, <text-dots>)

    <item>Improvements to the styling of presentations and posters [WIP]

    <item>More documentation, more tutorial, grow community [Stackexchange
    proposal]

    <item>Collaboration tools

    <item>Bibliography management with <name|Zotero>
  </itemize>

  <section*|Hacking TeXmacs>

  <with|font-shape|italic|Many opportunities for contributions> for all
  tastes

  <\itemize>
    <item>From the outside

    <\small>
      <\itemize>
        <item>Write and review documentations, tutorials, videos, improve
        community, advertise

        <item>Develop plugins to your preferred system or to add your
        preferred feature, e.g.: literate programming tools with beautyful
        output

        <item>Write new document styles, templates, presentation styles,
        poster styles

        <item>Font tuning
      </itemize>
    </small>

    <item>Hack the <name|C++> code

    <\small>
      <\itemize>
        <item>Understand the code and write developer documentation

        <item>Improve the <name|Qt> backend, fix bugs, add features, improve
        stability, better image handling and PDF export of TeXmacs features

        <item>Write new backends (<name|Cocoa>), port to tablets or to the
        browser
      </itemize>
    </small>

    <item>Hack <scheme>

    <\small>
      <\itemize>
        <item>Help porting to <name|Guile 3>, improve speed

        <item>fix bugs, review code, add new cool features
      </itemize>
    </small>
  </itemize>

  \;
</body>

<\initial>
  <\collection>
    <associate|page-medium|papyrus>
    <associate|preamble|false>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|auto-1|<tuple|?|?>>
    <associate|auto-10|<tuple|3|?>>
    <associate|auto-11|<tuple|3|?>>
    <associate|auto-12|<tuple|3|?>>
    <associate|auto-13|<tuple|3|?>>
    <associate|auto-14|<tuple|3|?>>
    <associate|auto-15|<tuple|3|?>>
    <associate|auto-16|<tuple|3|?>>
    <associate|auto-17|<tuple|<with|mode|<quote|math>|\<bullet\>>|?>>
    <associate|auto-18|<tuple|<with|mode|<quote|math>|\<bullet\>>|?>>
    <associate|auto-19|<tuple|<with|mode|<quote|math>|\<bullet\>>|?>>
    <associate|auto-2|<tuple|?|?>>
    <associate|auto-20|<tuple|<with|mode|<quote|math>|\<bullet\>>|?>>
    <associate|auto-21|<tuple|<with|mode|<quote|math>|\<bullet\>>|?>>
    <associate|auto-22|<tuple|<with|mode|<quote|math>|\<bullet\>>|?>>
    <associate|auto-23|<tuple|<with|mode|<quote|math>|\<bullet\>>|?>>
    <associate|auto-24|<tuple|<with|mode|<quote|math>|\<bullet\>>|?>>
    <associate|auto-25|<tuple|<with|mode|<quote|math>|\<bullet\>>|?>>
    <associate|auto-26|<tuple|<with|mode|<quote|math>|\<bullet\>>|?>>
    <associate|auto-27|<tuple|<with|mode|<quote|math>|\<bullet\>>|?>>
    <associate|auto-28|<tuple|<with|mode|<quote|math>|<with|font-series|<quote|bold>|math-font-series|<quote|bold>|<with|math-condensed|<quote|true>|<syntax|\<blacktriangleright\>|x>>>>|?>>
    <associate|auto-3|<tuple|<with|mode|<quote|math>|<with|font-series|<quote|bold>|math-font-series|<quote|bold>|<with|math-condensed|<quote|true>|<syntax|\<blacktriangleright\>|x>>>>|?>>
    <associate|auto-4|<tuple|<with|mode|<quote|math>|<with|font-series|<quote|bold>|math-font-series|<quote|bold>|<with|math-condensed|<quote|true>|<syntax|\<blacktriangleright\>|x>>>>|?>>
    <associate|auto-5|<tuple|<with|mode|<quote|math>|<with|font-series|<quote|bold>|math-font-series|<quote|bold>|<with|math-condensed|<quote|true>|<syntax|\<blacktriangleright\>|x>>>>|?>>
    <associate|auto-6|<tuple|<with|mode|<quote|math>|<with|font-series|<quote|bold>|math-font-series|<quote|bold>|<with|math-condensed|<quote|true>|<syntax|\<blacktriangleright\>|x>>>>|?>>
    <associate|auto-7|<tuple|<with|mode|<quote|math>|\<bullet\>>|?>>
    <associate|auto-8|<tuple|<with|mode|<quote|math>|\<bullet\>>|?>>
    <associate|auto-9|<tuple|<with|mode|<quote|math>|\<bullet\>>|?>>
    <associate|tm-tree-ex|<tuple|<with|mode|<quote|math>|<with|font-series|<quote|bold>|math-font-series|<quote|bold>|<with|math-condensed|<quote|true>|<syntax|\<blacktriangleright\>|x>>>>|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|An
      overview of T<rsub|<space|-0.4spc><move|<resize|<with|math-level|<quote|0>|E>||||0.5fn>|0fn|-0.1fn>><space|-0.4spc>X<rsub|<space|-0.4spc><move|<resize|M<space|-0.2spc>A<space|-0.4spc>CS||||0.5fn>|0fn|-0.1fn>>>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-1><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>