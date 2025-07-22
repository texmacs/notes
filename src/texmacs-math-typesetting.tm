<TeXmacs|2.1.4>

<style|<tuple|notes|old-dots|old-lengths|doc>>

<\body>
  <\hide-preamble>
    <assign|tm-example|<\macro|body>
      <\wide-tabular>
        <tformat|<cwith|1|1|2|2|cell-width|0.6par>|<cwith|1|1|2|2|cell-hmode|exact>|<table|<row|<\cell>
          <\equation*>
            <arg|body>
          </equation*>
        </cell>|<\cell>
          <inactive*|<arg|body>>

          <\tm-fragment>
            <quasi|<compound|inactive*|<unquote|<arg|body>>>>
          </tm-fragment>
        </cell>>>>
      </wide-tabular>
    </macro>>

    \;

    <assign|pseudo-code|<\macro|body>
      <\surround||<no-indent*>>
        <\framed-quoted>
          <\with|font-base-size|8|par-first|0fn|par-par-sep|0fn|item-hsep|<macro|1.5fn>>
            <\framed-code>
              <arg|body>
            </framed-code>
          </with>
        </framed-quoted>
      </surround>
    </macro>>

    <assign|render-code|<\macro|body>
      <\surround||<no-indent*>>
        <\padded*>
          <\indent>
            <\with|font-base-size|8|par-first|0fn|par-par-sep|0fn|item-hsep|<macro|1tab>|numbered-offset|<value|code-numbered-offset>>
              <arg|body>
            </with>
          </indent>
        </padded*>
      </surround>
    </macro>>

    <assign|tm-cpp-code|<\macro|path|body>
      <\with|font-base-size|8>
        <\pseudo-code>
          <\wide-tabular>
            <tformat|<cwith|1|1|1|1|cell-hyphen|n>|<cwith|1|1|1|1|cell-bsep|0.2em>|<cwith|1|1|1|1|cell-tsep|0.2em>|<cwith|1|1|1|1|cell-lsep|0.5em>|<cwith|1|1|1|1|cell-rsep|0.5em>|<cwith|1|1|1|1|cell-halign|r>|<cwith|1|1|1|1|cell-background|light
            grey>|<cwith|2|2|1|1|cell-background|#f0f0f0>|<cwith|2|2|1|1|cell-lsep|0.4em>|<cwith|2|2|1|1|cell-rsep|0.4em>|<cwith|2|2|1|1|cell-bsep|0.4em>|<cwith|2|2|1|1|cell-tsep|0.4em>|<table|<row|<cell|<with|color|dark
            grey|<with|font-base-size|7|<tp-ref|<arg|path>>>>>>|<row|<\cell>
              <cpp|<arg|body>>
            </cell>>>>
          </wide-tabular>

          \;
        </pseudo-code>
      </with>
    </macro>>

    \;

    <assign|tm-path|<macro|path|<verbatim|<arg|path>>>>
  </hide-preamble>

  <notes-header>

  <chapter*|Mathematical typesetting in <TeXmacs>>

  <\notes-abstract>
    This document describes how <TeXmacs> deals with the typesetting of
    mathematics, and in particular with the low level implementation of the
    typesetting primitives relative to mathematical documents. It should be
    useful if you are interested in understanding the <verbatim|C++> sources.
    We describe the state of facts as per <verbatim|svn> revision <tt|r14561>
    (December 2024, <tt|TeXmacs 2.14+>). Excerpts from the official
    documentation are included in this document for completeness.

    \;
  </notes-abstract>

  <section|Overview>

  In this chapter we describe the algorithms used by <TeXmacs> in order to
  typeset mathematical formulas. This is a difficult subject, because
  esthetics and effectiveness do not always go hand in hand. Until now, <TeX>
  is widely accepted for having achieved an optimal compromise in this
  respect. Nevertheless, we thought that several improvements could still be
  made, which have now been implemented in <TeXmacs>. We will shortly
  describe the motivations behind them.

  In order to obtain esthetic formulas, what criteria should we use? It is
  often stressed that good typesetting allows the reader to concentrate on
  what he reads, without being distracted by ugly typesetting details. Such
  distracting details arise when distinct, though similar parts of text are
  typeset in a non uniform way:

  <\description>
    <item*|Different base lines>The eye expects text of a similar nature to
    be typeset with respect to a same base line. For instance, in
    <math|x+y+z>, the bottoms of the <math|x> and <math|z> should be at the
    same height as the bottom of the <math|u>-part in the <math|y>. This
    should again be the case in <math|2<rsup|x>+2<rsup|y>+2<rsup|z>>.

    <item*|Unequal spacing>Different components of text with approximately
    the same function should be separated by equal amounts of space. For
    instance, in <math|a<rsup|2>+f<rsup|2>>, the typesetter should notice the
    hangover of the <math|f>. This should again be the case in
    <math|e<rsup|a>+e<rsup|f>+e<rsup|x>>. Similarly, the distance between the
    baselines of the <math|a> and the <math|i> in <math|a<rsub|i>> should not
    be disproportionally large with respect to the height of an <math|x>.
  </description>

  Additional difficulties may arise when considering automatically generated
  formulas, in which case line breaking has to be dealt with in a
  satisfactory way.

  Unfortunately, the different esthetic criteria may enter into conflict with
  each other. For instance, consider the formula
  <math|x<rsub|p>+x<rsub|p><rsup|2>>. On the one hand, the baselines of the
  scripts should be the same, but the other hand, the first subscript should
  not be \Pdisproportionally low\Q with respect to the <math|x>.
  Unfortunately, this dilemma can not been solved in a completely
  satisfactory way without the help of a human for the simple reason that the
  computer has no way to know whether the <math|x<rsub|p>> and
  <math|x<rsub|p><rsup|i>> are \Prelated\Q. Indeed, if the <math|x<rsub|p>>
  and <math|x<rsub|p><rsup|i>> are close (like in
  <math|x<rsub|p>+x<rsub|p><rsup|i>>), then it is natural to opt for a common
  base line. However, if they are further away from each other (like in
  <math|x<rsub|p>+<big|sum><rsub|i=0><rsup|\<infty\>>c<rsub|i>x<rsub|p><rsup|i>>),
  then we might want to opt for different base lines and locally optimize the
  rendering of the first <math|x<rsub|p>>.

  Consequently, <TeXmacs> should offer a reasonable compromise for the most
  frequent cases, while offering methods for the user to make finer
  adjustments in the remaining ones. We provide the constructs
  <menu|Format|Adjust|Move> and <menu|Format|Adjust|Resize> to move and
  resize boxes in order to perform such adjustments. For instance, if the
  brackets around the two sums

  <\equation*>
    \<phi\><around*|(|<big|sum><rsub|i>a<rsub|i>x<rsup|i>|)>=\<psi\><around*|(|<big|sum><rsub|<smash|j>>b<rsub|j>y<rsup|j>|)>
  </equation*>

  have different sizes, then one may resize the bottom of the subscript
  <math|j> of the second sum to <verbatim|0fn>. Alternatively, one may resize
  the bottoms of both the <math|i> and <math|j> subscripts to (say)
  <verbatim|-0.3fn>. For easier adjustments you may use
  <menu|Format|Adjust|Smash> and <menu|Format|Adjust|Inflate> to
  automatically adjust the size of the contents to the height of the
  character \Px\Q and the largest one in the font respectively.

  Notice that one should adjust by preference in a structural and not visual
  way. For instance, one should prefer <verbatim|-0.3fn> to <verbatim|-2mm>
  in the above example, because the second option disallows you to switch to
  another font size for your document. Similarly, you should try not change
  the semantics of the formula. For instance, in the above example, you might
  have added a \Pdummy subscript\Q to the <math|i> subscript of the sum.
  However, this would alter the meaning of the formula (whence make it non
  suitable as input to a computer algebra system) In the future, we plan to
  provide additional constructs in order to facilitate structural adjusting.
  For instance, in the case of a formula like

  <\equation*>
    1+x<rsub|1>+x<rsub|1><rsup|2>+\<cdots\>+x<rsub|2>+x<rsub|1>x<rsub|2>+x<rsub|1><rsup|2>x<rsub|2>+\<cdots\>x<rsub|2><rsup|2>+x<rsub|1>x<rsub|2><rsup|2>+x<rsub|1><rsup|2>x<rsub|2><rsup|2>+\<cdots\>,
  </equation*>

  one might think of a construct to enclose the entire formula into an area,
  where all scripts are forced to be double (using dummy superscripts
  wherever necessary).

  <section|Mathematical primitives>

  <\explain>
    <explain-macro|left|large-delimiter>

    <explain-macro|left|large-delimiter|size>

    <explain-macro|left|large-delimiter|bottom|top>

    <explain-macro|mid|large-delimiter|<math|\<cdots\>>>

    <explain-macro|right|large-delimiter|<math|\<cdots\>>><explain-synopsis|large
    delimiters>
  <|explain>
    These primitives are used for producing large delimiters, like in the
    formula

    <\equation*>
      <around*|\<langle\>|<frac|1|a<rsub|1>><mid|\|><frac|1|a<rsub|2>><mid|\|>\<cdots\><mid|\|><frac|1|a<rsub|n>>|\<rangle\>>.
    </equation*>

    Matching left and right delimiters are automatically sized so as contain
    the enclosed expression. Between matching left and right delimiters, the
    formula may contain an arbitrary number of middle delimiters, which are
    sized in a similar way. Contrary to <TeX>, the depth of a large delimiter
    is not necessarily equal to its height, so as to correctly render
    formulas like

    <\equation*>
      f<around*|(|<frac|1|x+<frac|1|y+<frac|1|z>>>|)>
    </equation*>

    The user may override the automatically determined size by specifying
    additional length parameters <src-arg|size> or <src-arg|bottom> and
    <src-arg|top>. For instance,

    <\tm-fragment>
      <inactive*|f<left|(|-8mm|4mm>x<mid|\||8mm>y<right|)|-4mm|8mm>>
    </tm-fragment>

    is rendered as

    <\equation*>
      f<left|(|-8mm|4mm>x<mid|\||8mm>y<right|)|-4mm|8mm>
    </equation*>

    The <src-arg|size> may also be a number <math|n>, in which case the
    <math|n>-th available size for the delimiter is taken. For instance,

    <\tm-fragment>
      <inactive*|g<left|(|0><left|(|1><left|(|2><left|(|3>z<right|)|3><right|)|2><right|)|1><right|)|0>>
    </tm-fragment>

    is rendered as

    <\equation*>
      g<left|(|0><left|(|1><left|(|2><left|(|3>z<right|)|3><right|)|2><right|)|1><right|)|0>
    </equation*>
  </explain>

  \;

  <\explain>
    <explain-macro|big|big-symbol><explain-synopsis|big symbols>
  <|explain>
    This primitive is used in order to produce big operators as in

    <\equation>
      <label|big-example><big|sum><rsub|i=0><rsup|\<infty\>>a<rsub|i>*z<rsup|i>
    </equation>

    The size of the operator depends on whether the formula is rendered in
    ``display style'' or not. Formulas in separate equations, like
    (<reference|big-example>), are said to be rendered in display style,
    contrary to formulas which occur in the main text, like
    <math|<big|sum><rsub|i=0><rsup|\<infty\>>a<rsub|i>*z<rsup|i>>. The user
    may use <menu|Format|Display style> to override the current settings.

    Notice that the formula (<reference|big-example>) is internally
    represented as

    <\tm-fragment>
      <inactive*|<big|sum><rsub|i=0><rsup|\<infty\>>a<rsub|i>*z<rsup|i><big|.>>
    </tm-fragment>

    The invisible big operator <inactive*|<big|.>> is used to indicate the
    end of the scope of <inactive*|<big|sum>>.
  </explain>

  <\explain>
    <explain-macro|frac|num|den><explain-synopsis|fractions>
  <|explain>
    The <markup|frac> primitive is used in order to render fractions like
    <math|<frac|x|y>>. In display style, the numerator <src-arg|num> and
    denominator <src-arg|den> are rendered in the normal size, but display
    style is turned of when typesetting <src-arg|num> and <src-arg|den>. When
    the display style is turned of, then the arguments are rendered in script
    size. For instance, the content

    <\tm-fragment>
      <inactive*|<frac|1|a<rsub|0>+<frac|1|a<rsub|1>+<frac|1|a<rsub|2>+\<ddots\>>>>>
    </tm-fragment>

    is rendered in display style as

    <\equation*>
      <frac|1|a<rsub|0>+<frac|1|a<rsub|1>+<frac|1|a<rsub|2>+\<ddots\>>>>
    </equation*>
  </explain>

  <\explain>
    <explain-macro|sqrt|content>

    <explain-macro|sqrt|content|n><explain-synopsis|roots>
  <|explain>
    The <markup|sqrt> primitive is used in order to render square roots like
    <math|<sqrt|x>> or <src-arg|n>-th roots like <math|<sqrt|x|3>>. The root
    symbol is automatically sized so as to encapsulate the <src-arg|content>:

    <\equation*>
      <sqrt|<frac|f<around|(|x|)>|y<rsup|2>+z<rsup|2>>|i+j>
    </equation*>
  </explain>

  <\explain>
    <explain-macro|lsub|script>

    <explain-macro|lsup|script>

    <explain-macro|rsub|script>

    <explain-macro|rsup|script><explain-synopsis|scripts>
  <|explain>
    These primitives are used in order to attach a <src-arg|script> to the
    preceding box in a horizontal concatenation (in the case of right
    scripts) or the next one (in the case of left scripts). When there is no
    such box, then the script is attached to an empty box. Moreover, when
    both a subscript and a superscript are specified on the same side, then
    they are merged together. For instance, the expression

    <\tm-fragment>
      <inactive*|<rsub|a><rsup|b>+<lsub|1><lsup|2>x<rsub|3><rsup|4>=y<rsub|1>+<lsub|c>>
    </tm-fragment>

    is rendered as

    <\equation*>
      <rsub|a><rsup|b>+<lsub|1><lsup|2>x<rsub|3><rsup|4>=y<rsub|1>+<lsub|c>
    </equation*>

    When a right script is attached to an operator (or symbol) which accepts
    limits, then it is rendered below or above instead of beside the
    operator:

    <\equation*>
      lim<rsub|n\<rightarrow\>\<infty\>>a<rsub|n>
    </equation*>

    Scripts are rendered in a smaller font in non-display style.
    Nevertheless, in order to keep formulas readable, the size is not reduced
    below script-script-size.
  </explain>

  <\explain>
    <explain-macro|lprime|prime-symbols>

    <explain-macro|rprime|prime-symbols><explain-synopsis|primes>
  <|explain>
    Left and right primes are similar to left and right superscripts, except
    that they behave in a different way when being edited. For instance, when
    your cursor is behind the prime symbol in <math|f<rprime|'>> and you
    press backspace, then the prime is removed. If you are behind
    <math|f<rsup|n>> and you press backspace several times, then you first
    enter the superscript, next remove <math|n> and finally remove the
    superscript. Notice also that <src-arg|prime-symbols> is necessarily a
    string of concatenated prime symbols. For instance,
    <math|f<rprime|'\<dag\>>> is represented by
    <inactive*|f<rprime|'\<dag\>>>.
  </explain>

  <\explain>
    <explain-macro|below|content|script>

    <explain-macro|above|content|script><explain-synopsis|scripts above and
    below>
  <|explain>
    The <markup|below> and <markup|above> tags are used to explicitly attach
    a <src-arg|script> below or above a given <src-arg|content>. Both can be
    mixed in order to produce content with both a script below and above:

    <\equation*>
      <above|<below|xor|i=1>|\<infty\>> x<rsub|i>
    </equation*>

    can be produced using

    <\tm-fragment>
      <inactive*|<above|<below|xor|i=1>|\<infty\>> x<rsub|i>>
    </tm-fragment>
  </explain>

  <\explain>
    <explain-macro|wide|content|wide-symbol>

    <explain-macro|wide*|content|wide-symbol><explain-synopsis|wide symbols>
  <|explain>
    These primitives can be used in order to produce wide accents above or
    below some mathematical <src-arg|content>. For instance
    <math|<wide|x+y|\<bar\>>> corresponds to the markup
    <inactive*|<wide|x+y|\<bar\>>>.
  </explain>

  <\explain>
    <explain-macro|neg|content><explain-synopsis|negations>
  <|explain>
    This primitive is mainly used for producing negated symbols or
    expressions, such as <math|<neg|\<rightarrowtail\>>> or <math|<neg|a>>.
  </explain>

  <\explain>
    <explain-macro|tree|root|child-1|<math|\<cdots\>>|child-n><explain-synopsis|trees>
  <|explain>
    This primitive is used to produce a tree with a given <src-arg|root> and
    children <src-arg|child-1> until <src-arg|child-n>. The primitive should
    be used recursively in order to produce trees. For instance,

    <\equation*>
      <tree|+|x|y|<tree|\<times\>|2|y|z>>
    </equation*>

    corresponds to the markup

    <\tm-fragment>
      <inactive*|<tree|+|x|y|<tree|\<times\>|2|y|z>>>
    </tm-fragment>

    In the future, we plan to provide further style parameters in order to
    control the rendering.
  </explain>

  <section|The font parameters>

  Several font parameters are crucial for the correct positioning of the
  different components. The following are often needed:

  <\description>
    <item*|<verbatim|quad>>The main font reference space <verbatim|1fn>,
    which can be taken as the distance between successive lines of text.

    <item*|<verbatim|y1> and <verbatim|y2>>The bottom and top level for the
    font (we have <verbatim|y2-y1=quad>).

    <item*|<verbatim|sep>>The reference minimal space between distinct
    components, like the minimal distance between a subscript and a
    superscript. In fact, <verbatim|sep=quad/10>.

    <item*|<verbatim|wline>>The width of several types of lines, like the
    fraction and square root bars, wide accents, etc.

    <item*|<verbatim|yfrac>>The height of the fraction bar, which is needed
    for the positioning of fractions and big delimiters. Usually,
    <verbatim|yfrac> is almost equal to <verbatim|yx/2> below.
  </description>

  The following parameters are mainly needed in order to deal with scripts:

  <\description>
    <item*|<verbatim|yx>>The height of the <math|x> character, which is
    needed for the positioning of scripts. All the remaining parameters are
    actually computed as a function of <verbatim|yx>.

    <item*|<verbatim|ysub lo base>>Logical base line for subscripts.

    <item*|<verbatim|ysub hi lim>>Subscripts may never physically exceed this
    top height.

    <item*|<verbatim|ysup lo base>>Logical base line for superscripts.

    <item*|<verbatim|ysup lo lim>>Superscripts may never physically exceed
    this bottom height.

    <item*|<verbatim|ysup hi lim>>Suggestion for a physical top line for
    superscripts.

    <item*|<verbatim|yshift>>Possible shift of the base lines when we are
    inside fractions or scripts.
  </description>

  The individual strings in a font also have several important positioning
  properties. First of all, they always admit left and right slopes.
  Furthermore, they admit left and right italic corrections, which are needed
  for the positioning of scripts or when passing from text in upright to text
  in italics (or vice versa).

  <section|Implementation of the mathematical primitives>

  The typesetting semantics of TeXmacs documents is implemented by

  <\cpp-code>
    void concater_rep::typeset (tree t, path ip);
  </cpp-code>

  in <verbatim|src/Typeset/Concat/concat_math.cpp> which dispatch according
  to the current tree label to more specialized routines, which we will
  describe below.

  Tree labels for mathematical typesettings are (in
  <verbatim|scr/Kernel/Types/tree_label.hpp>)

  <\cpp-code>
    enum tree_label {

    \ \ // [... other labels ...]

    \ \ 

    \ \ // mathematics

    \ \ AROUND, VAR_AROUND, BIG_AROUND,

    \ \ LEFT, MID, RIGHT, BIG, LONG_ARROW,

    \ \ LPRIME, RPRIME, BELOW, ABOVE,

    \ \ LSUB, LSUP, RSUB, RSUP,

    \ \ FRAC, SQRT, WIDE, VAR_WIDE, NEG, TREE,

    \ \ SYNTAX,

    \;

    \ \ // [... other labels ...]

    };
  </cpp-code>

  They provide labels for the primitives to typeset brackets
  (<markup|around>, <markup|var_around>, <markup|big_around>,
  <verbatim|left>, <verbatim|mid>, <verbatim|right>), sub/super-scripts
  (<verbatim|lsup>, <verbatim|lsub>, <verbatim|rsup>, <verbatim|rsub>),
  accents (<verbatim|lprime>, <verbatim|rprime>), above and below formulas
  (<verbatim|below>, <verbatim|above>) fractions (<verbatim|frac>), roots
  (<verbatim|sqrt>), wide under and over braces (<verbatim|wide>,
  <verbatim|var_wide>), negations (<verbatim|neg>), and trees
  (<verbatim|tree>) or syntax (<verbatim|syntax>) constructions.

  <subsection|Primed expressions>

  Primed expressions are encoded in TeXmacs as

  <\wide-tabular>
    <tformat|<cwith|1|1|2|2|cell-width|0.6par>|<cwith|1|1|2|2|cell-hmode|exact>|<table|<row|<\cell>
      <\equation*>
        a<rprime|'>,a<rprime|\<ddag\>>,<lprime|\<ddag\>>s
      </equation*>
    </cell>|<\cell>
      <\tm-fragment>
        <inactive*|<math|a<rprime|'>,a<rprime|\<ddag\>>,<lprime|\<ddag\>>s>>
      </tm-fragment>
    </cell>>>>
  </wide-tabular>

  and are typeset via the following code (the code for <verbatim|rprime> is
  analogous and is not shown):

  <\cpp-code>
    void

    concater_rep::typeset_lprime (tree t, path ip) {

    \ \ if ((N(t) == 1) && is_atomic (t[0])) {

    \ \ \ \ string s= t[0]-\<gtr\>label;

    \ \ \ \ bool flag= (env-\<gtr\>fn-\<gtr\>type == FONT_TYPE_UNICODE);

    \ \ \ \ if (flag)

    \ \ \ \ \ \ for (int i=0; i\<less\>N(s); i++)

    \ \ \ \ \ \ \ \ flag= flag && (s[i] == '\\'' \|\| s[i] == '`');

    \ \ \ \ if (env-\<gtr\>fn-\<gtr\>type == FONT_TYPE_TEX \|\|

    \ \ \ \ \ \ \ \ env-\<gtr\>fn-\<gtr\>math_type != MATH_TYPE_NORMAL)

    \ \ \ \ \ \ s= replace_primes (s);

    \ \ \ \ tree old_il;

    \ \ \ \ if (!flag) old_il= env-\<gtr\>local_begin_script ();

    \ \ \ \ path sip= descend (ip, 0);

    \ \ \ \ box b1, b2;

    \ \ \ \ b2= typeset_as_concat (env, s /*t[0]*/, sip);

    \ \ \ \ b2= symbol_box (sip, b2, N(t[0]-\<gtr\>label));

    \ \ \ \ if (flag \|\| env-\<gtr\>fn-\<gtr\>math_type !=
    MATH_TYPE_TEX_GYRE)

    \ \ \ \ \ \ b2= move_box (sip, b2,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ flag? 0: env-\<gtr\>as_length
    (string ("-0.05fn")),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ flag? env-\<gtr\>as_length
    ("-0.75ex"): 0,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ false, true);

    \ \ \ \ if (!flag) env-\<gtr\>local_end_script (old_il);

    \ \ \ \ print (LSUP_ITEM, OP_SKIP, script_box (ip, b1, b2,
    env-\<gtr\>fn));

    \ \ \ \ penalty_max (HYPH_INVALID);

    \ \ }

    \ \ else typeset_error (t, ip);

    }
  </cpp-code>

  Note that we output an <verbatim|LSUP_ITEM>, since later on, in a second
  pass, we need to reposition these boxes as we will do for \ sub,
  superscripts.

  The <cpp|replace_primes> function:\ 

  <\cpp-code>
    string

    replace_primes (string s) {

    \ \ string r;

    \ \ int i, n= N(s);

    \ \ for (i=0; i\<less\>n; i++)

    \ \ \ \ if (s[i] == '\\'') r \<less\>\<less\> "\<less\>prime\<gtr\>";

    \ \ \ \ else if (s[i] == '`') r \<less\>\<less\>
    "\<less\>backprime\<gtr\>";

    \ \ \ \ else r \<less\>\<less\> s[i];

    \ \ return r;

    }
  </cpp-code>

  <subsection|Fractions>

  Fractions can be inline <math|<frac|\<mathd\>x|\<mathd\>y>> or in display
  style and have different variants (standard <verbatim|frac>, display
  <verbatim|dfrac>, small inline <verbatim|tfrac>, continued <verbatim|cfrac>
  and slashed <verbatim|frac*>). For example\ 

  <\wide-tabular>
    <tformat|<cwith|1|1|2|2|cell-width|0.6par>|<cwith|1|1|2|2|cell-hmode|exact>|<table|<row|<\cell>
      <\equation*>
        <dfrac|\<mathd\>x|\<mathd\>y>,<space|2em><frac*|\<mathd\>x|\<mathd\>y>,<space|2em><tfrac|\<mathd\>x|\<mathd\>y>,
      </equation*>
    </cell>|<\cell>
      <\tm-fragment>
        \<less\>dfrac\|\\\<less\>mathd\\\<gtr\>x\|\\\<less\>mathd\\\<gtr\>y\<gtr\>,\<less\>space\|2em\<gtr\>

        \<less\>frac*\|\\\<less\>mathd\\\<gtr\>x\|\\\<less\>mathd\\\<gtr\>y\<gtr\>,

        <inactive*|<math|<dfrac|\<mathd\>x|\<mathd\>y>,<space|2em><frac*|\<mathd\>x|\<mathd\>y>,<space|2em><tfrac|\<mathd\>x|\<mathd\>y>,>>
      </tm-fragment>
    </cell>>>>
  </wide-tabular>

  <\wide-tabular>
    <tformat|<cwith|1|1|2|2|cell-width|0.6par>|<cwith|1|1|2|2|cell-hmode|exact>|<cwith|1|1|1|-1|cell-valign|c>|<table|<row|<\cell>
      <\equation*>
        <cfrac|1|1+<cfrac|1|1+<cfrac|1|1+x>>>
      </equation*>
    </cell>|<\cell>
      <\tm-fragment>
        \<less\>cfrac\|1\|1+\<less\>cfrac\|1\|1+\<less\>cfrac\|1\|1+x\<gtr\>\<gtr\>\<gtr\>
      </tm-fragment>
    </cell>>>>
  </wide-tabular>

  \;

  Apart from <verbatim|frac>, the others tags are implemented in
  <verbatim|std-maths.ts> as:

  <\tm-fragment>
    <\inactive*>
      <assign|tfrac|<macro|x|y|<with|mode|math|<with|math-display|false|<frac|<arg|x>|<arg|y>>>>>>

      \;

      <assign|dfrac|<macro|x|y|<with|mode|math|<with|math-display|true|<frac|<arg|x>|<arg|y>>>>>>

      \;

      <assign|cfrac|<macro|x|y|<with|mode|math|<dfrac|<arg|x>|<resize|<arg|y>|||<plus|1r|-1sep>|>>>>>

      \;

      <assign|frac*|<macro|x|y|<move|<lsup|<arg|x>><resize|/|<plus|1l|0.15em>|<plus|1b|0.5em>|<minus|1r|0.15em>|<minus|1t|0.5em>><rsub|<arg|y>>||0.05em>>>

      \;

      <drd-props|frac*|arity|2|syntax|<macro|x|y|<arg|x>/<arg|y>>>
    </inactive*>
  </tm-fragment>

  The <verbatim|frac> tag is primitive and typesetted by
  <verbatim|concater_rep::typeset_frac> :

  <\cpp-code>
    void

    concater_rep::typeset_frac (tree t, path ip) {

    \ \ if (N(t) != 2) { typeset_error (t, ip); return; }

    \ \ bool disp= env-\<gtr\>display_style;

    \ \ tree old;

    \ \ if (disp) old= env-\<gtr\>local_begin (MATH_DISPLAY, "false");

    \ \ else old= env-\<gtr\>local_begin_script ();

    \ \ tree old_vp= env-\<gtr\>local_begin (MATH_VPOS, "1");

    \ \ box num= typeset_as_concat (env, t[0], descend (ip, 0));

    \ \ env-\<gtr\>local_end (MATH_VPOS, "-1");

    \ \ box den= typeset_as_concat (env, t[1], descend (ip, 1));

    \ \ env-\<gtr\>local_end (MATH_VPOS, old_vp);

    \ \ font sfn= env-\<gtr\>fn;

    \ \ if (disp) env-\<gtr\>local_end (MATH_DISPLAY, old);

    \ \ else env-\<gtr\>local_end_script (old);

    \ \ if (num-\<gtr\>w() \<less\>= env-\<gtr\>frac_max && den-\<gtr\>w ()
    \<less\>= env-\<gtr\>frac_max)

    \ \ \ \ print (frac_box (ip, num, den, env-\<gtr\>fn, sfn,
    env-\<gtr\>pen));

    \ \ else typeset_wide_frac (t, ip);

    }
  </cpp-code>

  The <cpp|"math-vpos"> environment variable is set to <math|0,-1,1>
  depending on where we are in the typesetting of fractions. This is used in
  the finalization routines. <todo|Add more?>

  The function <cpp|frac_box> inserts an instance of <cpp|frac_box_rep>

  <\cpp-code>
    frac_box_rep::frac_box_rep (

    \ \ path ip, box b1, box b2, font fn2, font sfn2, pencil pen2):

    \ \ \ \ composite_box_rep (ip), fn (fn2), sfn (sfn2), pen (pen2)

    {

    \ \ // Italic correction does not lead to nicer results,

    \ \ // because right correction is not equilibrated w.r.t. left
    correction

    \;

    \ \ SI bar_y = fn-\<gtr\>yfrac;

    \ \ SI bar_w = fn-\<gtr\>wline;

    \ \ SI sep \ \ = fn-\<gtr\>sep;

    \ \ SI b1_y \ = min (b1-\<gtr\>y1, sfn-\<gtr\>y1);

    \ \ SI b2_y \ = max (b2-\<gtr\>y2, sfn-\<gtr\>y2);

    \ \ SI w \ \ \ \ = max (b1-\<gtr\>w (), b2-\<gtr\>w()) + 2*sep;

    \ \ SI d \ \ \ \ = sep \<gtr\>\<gtr\> 1;

    \;

    \ \ pencil bar_pen= pen-\<gtr\>set_width (bar_w);

    \ \ insert (b1, (w\<gtr\>\<gtr\>1) - (b1-\<gtr\>x2\<gtr\>\<gtr\>1),
    bar_y+ sep+ (bar_w\<gtr\>\<gtr\>1)- b1_y);

    \ \ insert (b2, (w\<gtr\>\<gtr\>1) - (b2-\<gtr\>x2\<gtr\>\<gtr\>1),
    bar_y- sep- (bar_w\<gtr\>\<gtr\>1)- b2_y);

    \ \ insert (line_box (decorate_middle (ip), d, 0, w-d, 0, bar_pen), 0,
    bar_y);

    \;

    \ \ italic_correct (b1);

    \ \ italic_correct (b2);

    \ \ position ();

    \ \ italic_restore (b1);

    \ \ italic_restore (b2);

    \ \ x1= min (0, x1);

    \ \ x2= max (w, x2);

    \ \ left_justify ();

    \ \ finalize ();

    }
  </cpp-code>

  The following heuristics are used:

  <\itemize>
    <item>The horizontal middles of the numerator and the denominator are
    taken to be the same.

    <item>The vertical spaces between the numerator <abbr|resp.> denominator
    and the fraction bar is at least <verbatim|sep>.

    <item>The depth (<abbr|resp.> height) of the numerator (<abbr|resp.>
    denominator) is descended (<abbr|resp.> increased) to <verbatim|y1>
    (<abbr|resp.> <verbatim|y2>) if necessary. This forces the base lines of
    not too large numerators <abbr|resp.> denominators to be the same in
    presence of multiple fractions.

    <item>The fraction bar has a overhang of <verbatim|sep/2> to both sides
    and the logical limits of the fraction are another <verbatim|sep/2>
    further. The logical left limit is zero.
  </itemize>

  The italic corrections are not taken into account during the positioning
  algorithms, because this may create the impression that the numerator and
  denominator are not correctly centered with respect to each other.
  Nevertheless, the italic corrections are taken into account in order to
  compute the logical bounding box of the fraction (whose has italic slopes
  vanish at both sides).

  In the case the fraction's numerator or denominator are very wide a
  fallback typesetting strategy is used, according to:

  <\cpp-code>
    void

    concater_rep::typeset_wide_frac (tree t, path ip) {

    \ \ bool numb= needs_brackets (t[0], "Product");

    \ \ bool denb= needs_brackets (t[1], "Power");

    \ \ pencil old_pen= env-\<gtr\>pen;

    \ \ marker (descend (ip, 0));

    \ \ typeset_large (tree (LEFT, "."), decorate_left (descend (ip, 0)),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LEFT_BRACKET_ITEM, OP_OPENING_BRACKET,
    "\<less\>left-");

    \ \ env-\<gtr\>pen= env-\<gtr\>flatten_pen;

    \ \ if (numb)

    \ \ \ \ typeset_large (tree (LEFT, "("), decorate_left (descend (ip, 0)),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LEFT_BRACKET_ITEM,
    OP_OPENING_BRACKET, "\<less\>left-");

    \ \ env-\<gtr\>pen= old_pen;

    \ \ typeset (t[0], descend (ip, 0));

    \ \ env-\<gtr\>pen= env-\<gtr\>flatten_pen;

    \ \ if (numb)

    \ \ \ \ typeset_large (tree (RIGHT, ")"), decorate_right (descend (ip,
    0)),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ RIGHT_BRACKET_ITEM,
    OP_CLOSING_BRACKET, "\<less\>right-");

    \ \ typeset_large (tree (MID, "/"), decorate_middle (ip),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ MIDDLE_BRACKET_ITEM, OP_MIDDLE_BRACKET,
    "\<less\>mid-");

    \ \ if (denb)

    \ \ \ \ typeset_large (tree (LEFT, "("), decorate_left (descend (ip, 1)),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LEFT_BRACKET_ITEM,
    OP_OPENING_BRACKET, "\<less\>left-");

    \ \ env-\<gtr\>pen= old_pen;

    \ \ typeset (t[1], descend (ip, 1));

    \ \ env-\<gtr\>pen= env-\<gtr\>flatten_pen;

    \ \ if (denb)

    \ \ \ \ typeset_large (tree (RIGHT, ")"), decorate_right (descend (ip,
    1)),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ RIGHT_BRACKET_ITEM,
    OP_CLOSING_BRACKET, "\<less\>right-");

    \ \ env-\<gtr\>pen= old_pen;

    \ \ typeset_large (tree (RIGHT, "."), decorate_right (descend (ip, 1)),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ RIGHT_BRACKET_ITEM, OP_CLOSING_BRACKET,
    "\<less\>right-");

    \ \ marker (descend (ip, 1));

    }
  </cpp-code>

  <subsection|Roots>

  The following heuristics are used:

  <\itemize>
    <item>The vertical space between the main argument and the upper bar is
    at least <verbatim|sep>.

    <item>The root itself is typeset like a large delimiter. The positioning
    of a potential script is very dependent on the usage of <TeX> fonts.
    <todo|make precise>

    <item>The upper bar has a overhang of <verbatim|sep/2> at the right and
    the logical right limit of the root is situated another <verbatim|sep/2>
    further to the right.
  </itemize>

  We take the logical right border plus the italic correction of the main
  argument in order to determine the right hand limit of the upper bar. The
  left italic correction is not needed.

  <\wide-tabular>
    <tformat|<cwith|1|1|2|2|cell-width|0.6par>|<cwith|1|1|2|2|cell-hmode|exact>|<table|<row|<\cell>
      <\equation*>
        <sqrt|1+<frac|3|4>+\<cdots\>+d>
      </equation*>
    </cell>|<\cell>
      <\tm-fragment>
        \<less\>sqrt\|1+\<less\>frac\|3\|4\<gtr\>+\\\<less\>cdots\\\<gtr\>+d\<gtr\>
      </tm-fragment>
    </cell>>>>
  </wide-tabular>

  Typesetting goes as follows:

  <\cpp-code>
    void

    concater_rep::typeset_sqrt (tree t, path ip) {

    \ \ if (N(t) != 1 && N(t) != 2) { typeset_error (t, ip); return; }

    \ \ box b= typeset_as_concat (env, t[0], descend (ip, 0));

    \ \ if (b-\<gtr\>w () \<gtr\> env-\<gtr\>frac_max) { typeset_wide_sqrt
    (t, ip); return; }

    \ \ box ind;

    \ \ if (N(t)==2) {

    \ \ \ \ bool disp= env-\<gtr\>display_style;

    \ \ \ \ tree old;

    \ \ \ \ if (disp) old= env-\<gtr\>local_begin (MATH_DISPLAY, "false");

    \ \ \ \ tree old_il= env-\<gtr\>local_begin_script ();

    \ \ \ \ ind= typeset_as_concat (env, t[1], descend (ip, 1));

    \ \ \ \ env-\<gtr\>local_end_script (old_il);

    \ \ \ \ if (disp) env-\<gtr\>local_end (MATH_DISPLAY, old);

    \ \ }

    \ \ SI sep= env-\<gtr\>fn-\<gtr\>sep;

    \ \ font lfn= env-\<gtr\>fn;

    \ \ bool stix= starts (lfn-\<gtr\>res_name, "stix-");

    \ \ if (stix) lfn= rubber_font (lfn);

    \ \ box sqrtb= delimiter_box (decorate_left (ip),
    "\<less\>large-sqrt\<gtr\>",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ lfn,
    env-\<gtr\>pen, b-\<gtr\>y1, b-\<gtr\>y2 + (3*sep \<gtr\>\<gtr\> 1));

    \ \ if (stix) sqrtb= shift_box (decorate_left (ip), sqrtb,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -env-\<gtr\>fn-\<gtr\>wline/2,
    -env-\<gtr\>fn-\<gtr\>wline/3,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ false, true);

    \ \ print (sqrt_box (ip, b, ind, sqrtb, env-\<gtr\>fn, env-\<gtr\>pen));

    }
  </cpp-code>

  \;

  <\cpp-code>
    sqrt_box_rep::sqrt_box_rep (

    \ \ path ip, box b1, box b2, box sqrtb, font fn2, pencil pen2):

    \ \ \ \ composite_box_rep (ip), fn (fn2), pen (pen2)

    {

    \ \ right_italic_correct (b1);

    \;

    \ \ SI sep \ = fn-\<gtr\>sep;

    \ \ SI wline= fn-\<gtr\>wline;

    \ \ SI dx \ \ = -fn-\<gtr\>wfn/36, dy= -fn-\<gtr\>wfn/36; // correction

    \ \ SI by \ \ = sqrtb-\<gtr\>y2+ dy;

    \ \ if (sqrtb-\<gtr\>x2 - sqrtb-\<gtr\>x4 \<gtr\> wline) dx -=
    (sqrtb-\<gtr\>x2 - sqrtb-\<gtr\>x4);

    \ \ 

    \ \ pencil rpen= pen-\<gtr\>set_width (wline);

    \ \ insert (b1, 0, 0);

    \ \ if (!is_nil (b2)) {

    \ \ \ \ SI X = - sqrtb-\<gtr\>w();

    \ \ \ \ SI M = X / 3;

    \ \ \ \ SI Y = sqrtb-\<gtr\>y1;

    \ \ \ \ SI bw= sqrtb-\<gtr\>w();

    \ \ \ \ SI bh= sqrtb-\<gtr\>h();

    \ \ \ \ if (fn-\<gtr\>math_type == MATH_TYPE_TEX_GYRE) {

    \ \ \ \ \ \ if (2*bh \<less\> 9*bw) Y += bh \<gtr\>\<gtr\> 1;

    \ \ \ \ \ \ else if (occurs ("ermes", fn-\<gtr\>res_name)) Y += (19*bw)
    \<gtr\>\<gtr\> 3;

    \ \ \ \ \ \ else if (occurs ("agella", fn-\<gtr\>res_name)) Y += (16*bw)
    \<gtr\>\<gtr\> 3;

    \ \ \ \ \ \ else Y += (15*bw) \<gtr\>\<gtr\> 3;

    \ \ \ \ }

    \ \ \ \ else {

    \ \ \ \ \ \ if (bh \<less\> 3*bw) Y += bh \<gtr\>\<gtr\> 1;

    \ \ \ \ \ \ else Y += (bw*3) \<gtr\>\<gtr\> 1;

    \ \ \ \ }

    \ \ \ \ insert (b2, min (X, M- b2-\<gtr\>x2), Y- b2-\<gtr\>y1+ sep);

    \ \ }

    \ \ insert (sqrtb, -sqrtb-\<gtr\>x2, 0);

    \ \ insert (line_box (decorate_middle (ip), dx, by, b1-\<gtr\>x2, by,
    rpen), 0, 0);

    \ \ 

    \ \ position ();

    \ \ left_justify ();

    \ \ y1 -= wline;

    \ \ y2 += wline;

    \ \ x2 += sep \<gtr\>\<gtr\> 1;

    \;

    \ \ right_italic_restore (b1);

    \ \ finalize ();

    }
  </cpp-code>

  Wide versions of the square root goes as follows:

  <\cpp-code>
    void

    concater_rep::typeset_wide_sqrt (tree t, path ip) {

    \ \ bool br= needs_brackets (t[0], "Postfixed");

    \ \ pencil old_pen= env-\<gtr\>pen;

    \ \ marker (descend (ip, 0));

    \ \ typeset_large (tree (LEFT, "."), decorate_left (descend (ip, 0)),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LEFT_BRACKET_ITEM, OP_OPENING_BRACKET,
    "\<less\>left-");

    \ \ env-\<gtr\>pen= env-\<gtr\>flatten_pen;

    \ \ if (br)

    \ \ \ \ typeset_large (tree (LEFT, "("), decorate_left (descend (ip, 0)),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ LEFT_BRACKET_ITEM,
    OP_OPENING_BRACKET, "\<less\>left-");

    \ \ env-\<gtr\>pen= old_pen;

    \ \ typeset (t[0], descend (ip, 0));

    \ \ env-\<gtr\>pen= env-\<gtr\>flatten_pen;

    \ \ if (br)

    \ \ \ \ typeset_large (tree (RIGHT, ")"), decorate_right (descend (ip,
    0)),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ RIGHT_BRACKET_ITEM,
    OP_CLOSING_BRACKET, "\<less\>right-");

    \ \ env-\<gtr\>pen= old_pen;

    \;

    \ \ bool disp= env-\<gtr\>display_style;

    \ \ tree old;

    \ \ if (disp) old= env-\<gtr\>local_begin (MATH_DISPLAY, "false");

    \ \ tree old_il= env-\<gtr\>local_begin_script ();

    \ \ env-\<gtr\>pen= env-\<gtr\>flatten_pen;

    \ \ box num= typeset_as_concat (env, "1", decorate_middle (ip));

    \ \ box den;

    \ \ if (N(t) \<gtr\>= 2) {

    \ \ \ \ env-\<gtr\>pen= old_pen;

    \ \ \ \ den= typeset_as_concat (env, t[1], descend (ip, 1));

    \ \ \ \ env-\<gtr\>pen= env-\<gtr\>flatten_pen;

    \ \ }

    \ \ else den= typeset_as_concat (env, "2", decorate_middle (ip));

    \ \ box fr= frac_box (decorate_middle (ip), num, den, env-\<gtr\>fn,
    env-\<gtr\>fn, env-\<gtr\>pen);

    \ \ env-\<gtr\>pen= old_pen;

    \ \ env-\<gtr\>local_end_script (old_il);

    \ \ if (disp) env-\<gtr\>local_end (MATH_DISPLAY, old);

    \ \ penalty_max (HYPH_INVALID);

    \ \ a \<less\>\<less\> line_item (RSUP_ITEM, OP_SKIP,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ script_box (ip, box (), fr,
    env-\<gtr\>fn), HYPH_INVALID);

    \;

    \ \ typeset_large (tree (RIGHT, "."), decorate_right (descend (ip, 1)),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ RIGHT_BRACKET_ITEM, OP_CLOSING_BRACKET,
    "\<less\>right-");

    \ \ marker (descend (ip, 1));

    }
  </cpp-code>

  <subsection|Negations>

  Negations are barred expressions:

  <\wide-tabular>
    <tformat|<cwith|1|1|2|2|cell-width|0.6par>|<cwith|1|1|2|2|cell-hmode|exact>|<table|<row|<\cell>
      <\equation*>
        <neg|abc>
      </equation*>
    </cell>|<\cell>
      <\tm-fragment>
        <inactive*|\<less\>neg\|abc\<gtr\>>
      </tm-fragment>
    </cell>>>>
  </wide-tabular>

  \;

  The following heuristics are used:

  <\itemize>
    <item>The negation bar passes through the logical center of the argument.

    <item>The italic corrections of the argument are only taken into account
    during the computation of the logical limits of the negation box (which
    has zero left and right slopes).
  </itemize>

  Typesetting of negation tags is very elementary

  <\cpp-code>
    void

    concater_rep::typeset_neg (tree t, path ip) {

    \ \ if (N(t) != 1) { typeset_error (t, ip); return; }

    \ \ box b= typeset_as_concat (env, t[0], descend (ip, 0));

    \ \ print_semantic (neg_box (ip, b, env-\<gtr\>fn, env-\<gtr\>pen),
    t[0]);

    }
  </cpp-code>

  and give rise to negation boxes:

  <\cpp-code>
    neg_box_rep::neg_box_rep (path ip, box b, font fn2, pencil pen2):

    \ \ composite_box_rep (ip), fn (fn2), pen (pen2)

    {

    \ \ SI wline= fn-\<gtr\>wline;

    \ \ SI delta= fn-\<gtr\>wfn/6;

    \ \ SI X \ \ \ = (b-\<gtr\>x1 + b-\<gtr\>x2) \<gtr\>\<gtr\> 1;

    \ \ SI Y \ \ \ = (b-\<gtr\>y1 + b-\<gtr\>y2) \<gtr\>\<gtr\> 1;

    \ \ SI DX, DY;

    \;

    \ \ pencil npen= pen-\<gtr\>set_width (wline);

    \ \ insert (b, 0, 0);

    \ \ if ((3*(b-\<gtr\>x2-b-\<gtr\>x1)) \<gtr\>
    (2*(b-\<gtr\>y2-b-\<gtr\>y1))) {

    \ \ \ \ DY= delta + ((b-\<gtr\>y2 - b-\<gtr\>y1)\<gtr\>\<gtr\>1);

    \ \ \ \ DX= DY\<gtr\>\<gtr\>1;

    \ \ }

    \ \ else {

    \ \ \ \ DX= delta + ((b-\<gtr\>x2 - b-\<gtr\>x1)\<gtr\>\<gtr\>1);

    \ \ \ \ DY= DX;

    \ \ }

    \ \ insert (line_box (decorate_middle (ip), X+DX, Y+DY, X-DX, Y-DY,
    npen), 0, 0);

    \ \ 

    \ \ italic_correct (b);

    \ \ position ();

    \ \ italic_restore (b);

    \ \ finalize ();

    }
  </cpp-code>

  <subsection|Wide boxes>

  Wide boxes are used for under and over-braces and wide accents:

  <\wide-tabular>
    <tformat|<cwith|1|1|2|2|cell-width|0.6par>|<cwith|1|1|2|2|cell-hmode|exact>|<table|<row|<\cell>
      <\equation*>
        <wide*|x+y|\<wide-underbrace\>><rsub|s><space|1em><wide|x+\<cdots\>+y|\<wide-overbrace\>><rsup|s>
      </equation*>
    </cell>|<\cell>
      <\tm-fragment>
        \<less\>wide*\|x+y\|\\\<less\>wide-underbrace\\\<gtr\>\<gtr\>\<less\>rsub\|s\<gtr\>

        \<less\>wide\|x+\\\<less\>cdots\\\<gtr\>+y\|\\\<less\>wide-overbrace\\\<gtr\>\<gtr\>\<less\>rsup\|s\<gtr\>
      </tm-fragment>
    </cell>>>>
  </wide-tabular>

  \;

  The following heuristics are used:

  <\itemize>
    <item>We use <TeX> fonts for small accents and an
    <with|font-shape|italic|ad hoc> algorithm for the wider ones.

    <item>The distance between the main argument and the accent is at least
    <verbatim|sep> (or a distance which depends on the <TeX> font for small
    accents).

    <item>The accent is positioned horizontally according to the right slope
    of the main argument.

    <item>The slopes for the accented box are inherited from those of the
    main argument and the italic corrections are adjusted accordingly.

    <item>All script height parameters of the accented box are inherited from
    the main argument. The only exception is <verbatim|ysup_hi_lim>, which
    may be increased by the height of the accent, or determined in the
    generic way, whichever leads to the least value. It is indeed better to
    keep superscripts positioned reasonably low, whenever possible.
  </itemize>

  <\cpp-code>
    void

    concater_rep::typeset_wide (tree t, path ip, bool above) {

    \ \ if (N(t) != 2) { typeset_error (t, ip); return; }

    \ \ box b= typeset_as_concat (env, t[0], descend (ip, 0));

    \ \ string s= env-\<gtr\>exec_string (t[1]);

    \ \ if (s == "^") s= "\<less\>hat\<gtr\>";

    \ \ if (s == "~") s= "\<less\>tilde\<gtr\>";

    \ \ bool request_wide= false;

    \ \ if (starts (s, "\<less\>wide-")) {

    \ \ \ \ s= "\<less\>" * s (6, N(s));

    \ \ \ \ request_wide= true;

    \ \ }

    \ \ if (ends (s, "brace\<gtr\>") \|\| ends (s, "brace*\<gtr\>"))

    \ \ \ \ b= move_box (decorate_middle (descend (ip, 0)), b, 0, 0, true);

    \ \ box wb= wide_box (ip, b, s, env-\<gtr\>fn, env-\<gtr\>pen,
    request_wide, above);

    \ \ print_semantic (wb, t[0]);

    \ \ if (ends (s, "brace\<gtr\>")) with_limits (LIMITS_ALWAYS);

    }
  </cpp-code>

  <cpp|wide_box> produces a <cpp|wide_box_rep> whose constructor perform
  further computations and handling of special cases:

  <\cpp-code>
    wide_box_rep::wide_box_rep (

    \ \ path ip, box ref2, string s2, font fn2, pencil pen2,

    \ \ bool request_wide2, bool above2):

    \ \ \ \ composite_box_rep (ip), ref (ref2), s (s2), fn (fn2), pen (pen2),

    \ \ \ \ request_wide (request_wide2), above (above2)

    {

    \ \ box hi;

    \ \ wide= compute_wide_accent (ip, ref, s, fn, pen, request_wide, above,
    hi, sep);

    \ \ SI X, Y, dx;

    \ \ SI hw= max (ref-\<gtr\>w(), hi-\<gtr\>w()) \<gtr\>\<gtr\> 1;

    \ \ SI m = (ref-\<gtr\>x1 + ref-\<gtr\>x2) \<gtr\>\<gtr\> 1;

    \ \ insert (ref, 0, 0);

    \ \ if (above) {

    \ \ \ \ Y= ref-\<gtr\>y2;

    \ \ \ \ X= m;

    \ \ \ \ if (ref-\<gtr\>right_slope () != 0)

    \ \ \ \ \ \ X += ref-\<gtr\>rsup_correction() + ((SI)
    (ref-\<gtr\>right_slope() * fn-\<gtr\>yx * 0.5));

    \ \ \ \ X += ref-\<gtr\>wide_correction (1);

    \ \ \ \ //X= ((SI) (ref-\<gtr\>right_slope () * (Y - fn-\<gtr\>yx))) + m;

    \ \ \ \ insert (hi, X- ((hi-\<gtr\>x1 + hi-\<gtr\>x2)\<gtr\>\<gtr\>1), Y+
    sep);

    \ \ }

    \ \ else {

    \ \ \ \ Y= ref-\<gtr\>y1 - hi-\<gtr\>y2;

    \ \ \ \ X= m - ((SI) (ref-\<gtr\>right_slope () * sep));

    \ \ \ \ X += ref-\<gtr\>wide_correction (-1);

    \ \ \ \ //X= ((SI) (ref-\<gtr\>right_slope () * (Y - sep))) + m;

    \ \ \ \ insert (hi, X- ((hi-\<gtr\>x1 + hi-\<gtr\>x2)\<gtr\>\<gtr\>1), Y-
    sep);

    \ \ }

    \ \ position ();

    \ \ dx= x1;

    \ \ left_justify ();

    \;

    \ \ dh= hi-\<gtr\>y2+ sep;

    \ \ dw= (SI) (dh * ref-\<gtr\>right_slope ());

    \ \ dd= fn-\<gtr\>sep;

    \ \ x1= m- hw- dx;

    \ \ x2= m+ hw- dx;

    \ \ x1= min (x1, ref-\<gtr\>x1);

    \ \ x2= max (x2, ref-\<gtr\>x2);

    \ \ if (!above) y1 += fn-\<gtr\>sep - sep;

    \ \ finalize ();

    }
  </cpp-code>

  The computation of the wide accent is more involved and divided in several
  cases.

  <\cpp-code>
    bool

    compute_wide_accent (path ip, box b, string s,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ font fn, pencil pen, bool
    request_wide, bool above,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ box& wideb, SI& sep) {

    \ \ bool unicode= (fn-\<gtr\>type == FONT_TYPE_UNICODE);

    \ \ bool stix= (fn-\<gtr\>math_type == MATH_TYPE_STIX);

    \ \ bool tex_gyre= (fn-\<gtr\>math_type == MATH_TYPE_TEX_GYRE);

    \ \ bool wide= (b-\<gtr\>w() \<gtr\> (fn-\<gtr\>wquad)) \|\|
    request_wide;

    \ \ if (ends (s, "dot\<gtr\>") \|\| (s == "\<less\>acute\<gtr\>") \|\|

    \ \ \ \ \ \ (s == "\<less\>grave\<gtr\>") \|\| (s ==
    "\<less\>abovering\<gtr\>")) wide= false;

    \ \ if (wide && !request_wide && b-\<gtr\>wide_correction (0) != 0) wide=
    false;

    \ \ bool very_wide= false;

    \ \ SI \ \ accw= fn-\<gtr\>wfn;

    \ \ if (wide) {

    \ \ \ \ if (tex_gyre) {

    \ \ \ \ \ \ if (s == "^" \|\| s == "\<less\>hat\<gtr\>" \|\|

    \ \ \ \ \ \ \ \ \ \ s == "~" \|\| s == "\<less\>tilde\<gtr\>" \|\|

    \ \ \ \ \ \ \ \ \ \ s == "\<less\>check\<gtr\>")

    \ \ \ \ \ \ \ \ very_wide= (b-\<gtr\>w() \<gtr\>= ((8*fn-\<gtr\>wfn)
    \<gtr\>\<gtr\> 2));

    \ \ \ \ \ \ else if (ends (s, "brace\<gtr\>") \|\| ends (s,
    "brace*\<gtr\>")) {

    \ \ \ \ \ \ \ \ if (starts (s, "\<less\>sq"))

    \ \ \ \ \ \ \ \ \ \ very_wide= (b-\<gtr\>w() \<gtr\>= ((11*fn-\<gtr\>wfn)
    \<gtr\>\<gtr\> 2));

    \ \ \ \ \ \ \ \ else very_wide= (b-\<gtr\>w() \<gtr\>=
    ((15*fn-\<gtr\>wfn) \<gtr\>\<gtr\> 2));

    \ \ \ \ \ \ }

    \ \ \ \ \ \ else very_wide= true;

    \ \ \ \ }

    \ \ \ \ else if (!unicode) {

    \ \ \ \ \ \ if (s == "^" \|\| s == "\<less\>hat\<gtr\>" \|\| s == "~"
    \|\| s == "\<less\>tilde\<gtr\>")

    \ \ \ \ \ \ \ \ very_wide= (b-\<gtr\>w() \<gtr\>= ((9*fn-\<gtr\>wfn)
    \<gtr\>\<gtr\> 2));

    \ \ \ \ \ \ else very_wide= true;

    \ \ \ \ }

    \ \ \ \ else if (stix) very_wide= true;

    \ \ \ \ /*

    \ \ \ \ else if (s == "^" \|\| s == "\<less\>hat\<gtr\>" \|\| s == "~"
    \|\| s == "\<less\>tilde\<gtr\>" \|\|

    \ \ \ \ \ \ \ \ \ \ \ \ \ s == "\<less\>bar\<gtr\>" \|\| s ==
    "\<less\>vect\<gtr\>" \|\| s == "\<less\>check\<gtr\>" \|\|

    \ \ \ \ \ \ \ \ \ \ \ \ \ s == "\<less\>breve\<gtr\>" \|\| s ==
    "\<less\>invbreve\<gtr\>") {

    \ \ \ \ \ \ box wb= text_box (decorate_middle (ip), 0, s, fn, pen);

    \ \ \ \ \ \ accw= wb-\<gtr\>x4 - wb-\<gtr\>x3;

    \ \ \ \ \ \ if (b-\<gtr\>w() \<gtr\>= 16*accw) very_wide= true;

    \ \ \ \ }

    \ \ \ \ */

    \ \ \ \ else very_wide= true;

    \ \ }

    \ \ if (wide && stix) {

    \ \ \ \ if (s == "^") s= "\<less\>hat\<gtr\>";

    \ \ \ \ if (s == "~") s= "\<less\>tilde\<gtr\>";

    \ \ \ \ if (s == "\<less\>hat\<gtr\>" \|\| s == "\<less\>tilde\<gtr\>"
    \|\| s == "\<less\>check\<gtr\>" \|\|

    \ \ \ \ \ \ \ \ ends (s, "brace\<gtr\>") \|\| ends (s, "brace*\<gtr\>"))
    {

    \ \ \ \ \ \ font rfn= rubber_font (fn);

    \ \ \ \ \ \ SI width= b-\<gtr\>x2- b-\<gtr\>x1 - fn-\<gtr\>wfn/4;

    \ \ \ \ \ \ wideb= wide_stix_box (decorate_middle (ip),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "\<less\>rubber-"
    * s (1, N(s)-1) * "\<gtr\>",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ rfn, pen, width);

    \ \ \ \ \ \ if (wideb-\<gtr\>w() \<gtr\>= width) {

    \ \ \ \ \ \ \ \ if (b-\<gtr\>right_slope () != 0)

    \ \ \ \ \ \ \ \ \ \ wideb= shift_box (decorate_middle (ip), wideb,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (SI) (-0.5 *
    b-\<gtr\>right_slope () * fn-\<gtr\>yx), 0);

    \ \ \ \ \ \ \ \ sep= above? -fn-\<gtr\>yx: fn-\<gtr\>sep;

    \ \ \ \ \ \ \ \ if (above) {

    \ \ \ \ \ \ \ \ \ \ if (s == "\<less\>overbrace\<gtr\>" \|\| s ==
    "\<less\>squnderbrace*\<gtr\>") sep= 2 * fn-\<gtr\>sep;

    \ \ \ \ \ \ \ \ \ \ if (s == "\<less\>poverbrace\<gtr\>") sep= 3 *
    fn-\<gtr\>sep;

    \ \ \ \ \ \ \ \ }

    \ \ \ \ \ \ \ \ return wide;

    \ \ \ \ \ \ }

    \ \ \ \ }

    \ \ }

    \ \ if (very_wide) {

    \ \ \ \ SI w= fn-\<gtr\>wline;

    \ \ \ \ if (stix) w= (SI) (1.189 * w);

    \ \ \ \ pencil wpen= pen-\<gtr\>set_width (w);

    \ \ \ \ if ((s == "^") \|\| (s == "\<less\>hat\<gtr\>"))

    \ \ \ \ \ \ wideb= wide_hat_box \ \ (decorate_middle (ip), b-\<gtr\>x1,
    b-\<gtr\>x2, wpen);

    \ \ \ \ else if ((s == "~") \|\| (s == "\<less\>tilde\<gtr\>"))

    \ \ \ \ \ \ wideb= wide_tilda_box (decorate_middle (ip), b-\<gtr\>x1,
    b-\<gtr\>x2, wpen);

    \ \ \ \ else if (s == "\<less\>bar\<gtr\>")

    \ \ \ \ \ \ wideb= wide_bar_box \ \ (decorate_middle (ip), b-\<gtr\>x1,
    b-\<gtr\>x2, wpen);

    \ \ \ \ else if (s == "\<less\>vect\<gtr\>")

    \ \ \ \ \ \ wideb= wide_vect_box \ (decorate_middle (ip), b-\<gtr\>x1,
    b-\<gtr\>x2, wpen);

    \ \ \ \ else if (s == "\<less\>check\<gtr\>")

    \ \ \ \ \ \ wideb= wide_check_box (decorate_middle (ip), b-\<gtr\>x1,
    b-\<gtr\>x2, wpen);

    \ \ \ \ else if (s == "\<less\>breve\<gtr\>" \|\| s ==
    "\<less\>punderbrace\<gtr\>" \|\| s == "\<less\>punderbrace*\<gtr\>")

    \ \ \ \ \ \ wideb= wide_breve_box (decorate_middle (ip), b-\<gtr\>x1,
    b-\<gtr\>x2, wpen);

    \ \ \ \ else if (s == "\<less\>invbreve\<gtr\>" \|\| s ==
    "\<less\>poverbrace\<gtr\>" \|\| s == "\<less\>poverbrace*\<gtr\>")

    \ \ \ \ \ \ wideb= wide_invbreve_box(decorate_middle (ip), b-\<gtr\>x1,
    b-\<gtr\>x2, wpen);

    \ \ \ \ else if (s == "\<less\>squnderbrace\<gtr\>" \|\| s ==
    "\<less\>squnderbrace*\<gtr\>")

    \ \ \ \ \ \ wideb= wide_squbr_box (decorate_middle (ip), b-\<gtr\>x1,
    b-\<gtr\>x2, wpen);

    \ \ \ \ else if (s == "\<less\>sqoverbrace\<gtr\>" \|\| s ==
    "\<less\>sqoverbrace*\<gtr\>")

    \ \ \ \ \ \ wideb= wide_sqobr_box (decorate_middle (ip), b-\<gtr\>x1,
    b-\<gtr\>x2, wpen);

    \ \ \ \ else wideb= wide_box (decorate_middle (ip),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "\<less\>rubber-" * s
    (1, N(s)-1) * "\<gtr\>",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ fn, pen, b-\<gtr\>x2-
    b-\<gtr\>x1);

    \ \ \ \ sep= fn-\<gtr\>sep;

    \ \ \ \ if (stix \|\| !unicode) sep= (SI) (1.5 * sep);

    \ \ }

    \ \ else if (wide && tex_gyre) {

    \ \ \ \ string ws= "\<less\>wide-" * s (1, N(s)-1) * "\<gtr\>";

    \ \ \ \ SI width= b-\<gtr\>x2- b-\<gtr\>x1 - fn-\<gtr\>wfn/4;

    \ \ \ \ wideb= wide_box (decorate_middle (ip), ws, fn, pen, width);

    \ \ \ \ if (b-\<gtr\>right_slope () != 0) {

    \ \ \ \ \ \ bool times= stix \|\| (tex_gyre && occurs ("ermes",
    fn-\<gtr\>res_name));

    \ \ \ \ \ \ double factor= ((times \|\| !above)? 0.2: 0.5);

    \ \ \ \ \ \ wideb= shift_box (decorate_middle (ip), wideb,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (SI) (-factor *
    b-\<gtr\>right_slope () * fn-\<gtr\>yx), 0);

    \ \ \ \ }

    \ \ \ \ sep= above? -fn-\<gtr\>yx: fn-\<gtr\>sep;

    \ \ }

    \ \ else if (wide && !unicode) {

    \ \ \ \ string ss= s (1, N(s)-1);

    \ \ \ \ if (ss == "^") ss= "hat";

    \ \ \ \ if (ss == "~") ss= "tilde";

    \ \ \ \ string ws= "\<less\>wide-" * ss * "\<gtr\>";

    \ \ \ \ SI width= b-\<gtr\>x2- b-\<gtr\>x1 - fn-\<gtr\>wfn/4;

    \ \ \ \ wideb= wide_box (decorate_middle (ip), ws, fn, pen, width);

    \ \ \ \ if (b-\<gtr\>right_slope () != 0) {

    \ \ \ \ \ \ double factor= (above? 0.5: 0.2);

    \ \ \ \ \ \ wideb= shift_box (decorate_middle (ip), wideb,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (SI) (-factor *
    b-\<gtr\>right_slope () * fn-\<gtr\>yx), 0);

    \ \ \ \ }

    \ \ \ \ sep= above? -fn-\<gtr\>yx: fn-\<gtr\>sep;

    \ \ }

    \ \ else if (wide) {

    \ \ \ \ SI pad= fn-\<gtr\>wfn - accw;

    \ \ \ \ pad= (SI) ((0.75 * accw * pad) / (b-\<gtr\>w() - pad));

    \ \ \ \ double sx= ((double) (b-\<gtr\>w() - pad)) / ((double) accw);

    \ \ \ \ sx= floor (4.0*sx) / 4.0;

    \ \ \ \ double sy= sqrt (sqrt (sx));

    \ \ \ \ font sfn= fn-\<gtr\>magnify (sx, sy);

    \ \ \ \ wideb= text_box (decorate_middle (ip), 0, s, sfn, pen);

    \ \ \ \ wideb= resize_box (decorate_middle (ip), wideb,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ max (wideb-\<gtr\>x1,
    wideb-\<gtr\>x3), wideb-\<gtr\>y1,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ min (wideb-\<gtr\>x2,
    wideb-\<gtr\>x4), wideb-\<gtr\>y2);

    \ \ \ \ if (unicode && b-\<gtr\>right_slope () != 0)

    \ \ \ \ \ \ wideb= shift_box (decorate_middle (ip), wideb,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (SI) (-0.5 *
    b-\<gtr\>right_slope () * fn-\<gtr\>yx), 0);

    \ \ \ \ sep= above? -fn-\<gtr\>yx: fn-\<gtr\>sep;

    \ \ \ \ if (above) sep -= 3 * (sy - 1.0) * fn-\<gtr\>sep;

    \ \ }

    \ \ else {

    \ \ \ \ wideb= text_box (decorate_middle (ip), 0, s, fn, pen);

    \ \ \ \ if (unicode && b-\<gtr\>right_slope () != 0) {

    \ \ \ \ \ \ bool times= stix \|\| (tex_gyre && occurs ("ermes",
    fn-\<gtr\>res_name));

    \ \ \ \ \ \ double factor= ((times \|\| !above)? 0.2: 0.5);

    \ \ \ \ \ \ wideb= shift_box (decorate_middle (ip), wideb,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (SI) (-factor *
    b-\<gtr\>right_slope () * fn-\<gtr\>yx), 0);

    \ \ \ \ }

    \ \ \ \ sep= above? -fn-\<gtr\>yx: fn-\<gtr\>sep;

    \ \ }

    \ \ if (above && unicode) {

    \ \ \ \ SI min_d= fn-\<gtr\>yx / 8;

    \ \ \ \ SI max_d= fn-\<gtr\>yx / 3;

    \ \ \ \ if (wideb-\<gtr\>y1 + sep \<less\> \ min_d) sep= min_d -
    wideb-\<gtr\>y1;

    \ \ \ \ if (wideb-\<gtr\>y1 + sep \<gtr\>= max_d) sep= max_d -
    wideb-\<gtr\>y1;

    \ \ }

    \ \ if (!unicode && !wide && !above)

    \ \ \ \ wideb= vresize_box (wideb-\<gtr\>ip, wideb, wideb-\<gtr\>y1 +
    fn-\<gtr\>yx, wideb-\<gtr\>y2);

    \ \ else if (unicode && s == "\<less\>vect\<gtr\>") {

    \ \ \ \ if (wide);

    \ \ \ \ else if (above) sep -= fn-\<gtr\>yx + (fn-\<gtr\>sep
    \<gtr\>\<gtr\> 1);

    \ \ \ \ else wideb= vresize_box (wideb-\<gtr\>ip, wideb, wideb-\<gtr\>y1
    + fn-\<gtr\>yx, wideb-\<gtr\>y2);

    \ \ }

    \ \ else if (stix \|\| tex_gyre) sep += fn-\<gtr\>sep \<gtr\>\<gtr\> 1;

    \ \ return wide;

    }
  </cpp-code>

  To complete the description we discuss <cpp|wide_box> and
  <cpp|wide_stix_box> which are variants of the same logic:

  <\cpp-code>
    box

    wide_box (path ip, string s, font fn, pencil pen, SI width) {

    \ \ string r= get_wide (s, fn, width);

    \ \ metric ex;

    \ \ fn-\<gtr\>get_extents (r, ex);

    \ \ box b= text_box (ip, 0, r, fn, pen);

    \ \ return macro_box (ip, b, fn);

    }

    \;

    box

    wide_stix_box (path ip, string s, font fn, pencil pen, SI width) {

    \ \ string r= get_wide_stix (s, fn, width);

    \ \ metric ex;

    \ \ fn-\<gtr\>get_extents (r, ex);

    \ \ box b= text_box (ip, 0, r, fn, pen);

    \ \ return macro_box (ip, b, fn);

    }
  </cpp-code>

  the concrete selection of the appropriate glyph which fits the horizontal
  size of wide construction is performed by <cpp|get_wide> (or
  <cpp|get_stix_wide>):

  <\cpp-code>
    static string

    get_wide (string s, font fn, SI width) {

    \ \ ASSERT (N(s) \<gtr\>= 2 && s[0] == '\<less\>' && s[N(s)-1] ==
    '\<gtr\>',

    \ \ \ \ \ \ \ \ \ \ "invalid rubber character");

    \ \ string radical= s (0, N(s)-1) * "-";

    \ \ string first \ = radical * "0\<gtr\>";

    \ \ metric ex;

    \ \ fn-\<gtr\>get_extents (first, ex);

    \ \ if ((ex-\<gtr\>x2- ex-\<gtr\>x1) \<gtr\>= width) return first;

    \;

    \ \ string second = radical * "1\<gtr\>";

    \ \ metric ey;

    \ \ fn-\<gtr\>get_extents (second, ey);

    \ \ SI w1= ex-\<gtr\>x2- ex-\<gtr\>x1;

    \ \ SI w2= ey-\<gtr\>x2- ey-\<gtr\>x1;

    \ \ if ((w2 \<less\>= w1) \|\| (w2 \<gtr\> width)) return first;

    \ \ SI \ d= w2- w1;

    \ \ int n= (width-w1) / (d+1);

    \;

    \ \ int credit= 20;

    \ \ while (true) {

    \ \ \ \ string test= radical * as_string (n+1) * "\<gtr\>";

    \ \ \ \ fn-\<gtr\>get_extents (test, ey);

    \ \ \ \ if (ey-\<gtr\>x2- ey-\<gtr\>x1 \<gtr\> width \|\| credit
    \<less\>= 0)

    \ \ \ \ \ \ return radical * as_string (n) * "\<gtr\>";

    \ \ \ \ n++;

    \ \ \ \ credit--;

    \ \ }

    }

    \;

    static string

    get_wide_stix (string s, font fn, SI width) {

    \ \ ASSERT (N(s) \<gtr\>= 2 && s[0] == '\<less\>' && s[N(s)-1] ==
    '\<gtr\>',

    \ \ \ \ \ \ \ \ \ \ "invalid rubber character");

    \ \ string radical= s (0, N(s)-1) * "-";

    \ \ metric ex;

    \ \ int n= 0;

    \ \ while (true) {

    \ \ \ \ string test= radical * as_string (n) * "\<gtr\>";

    \ \ \ \ fn-\<gtr\>get_extents (test, ex);

    \ \ \ \ if (ex-\<gtr\>x2- ex-\<gtr\>x1 \<gtr\> width \|\| n \<gtr\>= 6)

    \ \ \ \ \ \ return radical * as_string (n) * "\<gtr\>";

    \ \ \ \ n++;

    \ \ }

    }
  </cpp-code>

  <subsection|Subscripts and superscripts>

  The positioning of subscripts and superscripts is a complicated affair, due
  to the conflict between locally and globally optimal esthetics mentioned
  above. The base line for a subscript is determined as follows:

  <\enumerate>
    <item>Always pretend that the subscript has height at least
    <verbatim|y2-yshift> in the script font (actually we should use the
    height of an <math|M> instead).

    <item>Try to position the script at the base line given by the main
    argument.

    <item>If the top limit (given by the main argument) is physically
    exceeded by the subscript, then the base line is moved further down
    accordingly.
  </enumerate>

  The base line for a superscript is determined as follows:

  <\enumerate>
    <item>Try to physically position the superscript beneath the suggested
    top line. Usually, this will place the superscript to far down.

    <item>Move the superscript up to the logical base line if necessary. This
    will usually occur: most of the time, the logical base line is the just
    the height of an <math|x>-script below the suggested top line.

    <item>If the superscript physically descends below the physical under
    limit given by the main box, then we move the superscript further
    upwards.
  </enumerate>

  If both a subscript and a superscript were present, then we still have to
  adjust the base lines: if the top of the subscript and the bottom of the
  superscript are not physically separated by <verbatim|sep>, then we both
  move the subscript and the superscript by the same amount away from each
  other. Because of step 1 in the positioning of the subscript, the base
  lines of double scripts will usually be the same in formulas with several
  of them.

  The right slope and italic correction of a script box may be non trivial.
  In order to compute them, we first determine the script (or main argument),
  whose right limit (taking into account its italic correction) is furthest
  to the right (this may be the main box, in the case of a big integral with
  a tiny subscript). Then the right slope of the main box is inherited by the
  right slope of this script (or main argument). As to the italic correction,
  it is precisely the difference between the right offset of the script plus
  its italic correction minus the logical right coordinate of the entire box.
  The italic correction should be at least zero though. The left slope and
  italic correction are computed in a similar way.

  <todo|Explain the code below>

  \;

  <\cpp-code>
    void

    concater_rep::typeset_script (tree t, path ip, bool right) {

    \ \ if (N(t) != 1) { typeset_error (t, ip); return; }

    \ \ int type= RSUP_ITEM;

    \ \ box b1, b2;

    \ \ tree old_ds= env-\<gtr\>local_begin (MATH_DISPLAY, "false");

    \ \ tree old_mc= env-\<gtr\>local_begin (MATH_CONDENSED, "true");

    \ \ tree old_il= env-\<gtr\>local_begin_script ();

    \ \ if (is_func (t, SUB (right))) {

    \ \ \ \ tree old_vp= env-\<gtr\>local_begin (MATH_VPOS, "-1");

    \ \ \ \ b1= typeset_as_concat (env, t[0], descend (ip, 0));

    \ \ \ \ type= right? RSUB_ITEM: LSUB_ITEM;

    \ \ \ \ env-\<gtr\>local_end (MATH_VPOS, old_vp);

    \ \ }

    \ \ if (is_func (t, SUP (right))) {

    \ \ \ \ tree old_vp= env-\<gtr\>local_begin (MATH_VPOS, "1");

    \ \ \ \ b2= typeset_as_concat (env, t[0], descend (ip, 0));

    \ \ \ \ type= right? RSUP_ITEM: LSUP_ITEM;

    \ \ \ \ env-\<gtr\>local_end (MATH_VPOS, old_vp);

    \ \ }

    \ \ env-\<gtr\>local_end_script (old_il);

    \ \ env-\<gtr\>local_end (MATH_CONDENSED, old_mc);

    \ \ env-\<gtr\>local_end (MATH_DISPLAY, old_ds);

    \ \ if (right) penalty_max (HYPH_INVALID);

    \ \ a \<less\>\<less\> line_item (type, OP_SKIP,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ script_box (ip, b1, b2,
    env-\<gtr\>fn), HYPH_INVALID);

    \ \ // do not use print, because of italic space

    \ \ if (!right) penalty_max (HYPH_INVALID);

    }
  </cpp-code>

  \;

  <\cpp-code>
    dummy_script_box_rep::dummy_script_box_rep (path ip, box b1, box b2, font
    fn2):

    \ \ composite_box_rep (ip), fn (fn2)

    {

    \ \ SI sep \ = fn-\<gtr\>sep;

    \ \ SI lo_y = fn-\<gtr\>ysub_lo_base;

    \ \ SI hi_y = fn-\<gtr\>ysup_lo_base;

    \ \ SI miny2= (fn-\<gtr\>y2 - fn-\<gtr\>yshift) * script (fn-\<gtr\>size,
    1) / fn-\<gtr\>size;

    \;

    \ \ type= 0;

    \ \ if (!is_nil (b1)) type += 1;

    \ \ if (!is_nil (b2)) type += 2;

    \;

    \ \ if ((!is_nil (b1)) && (!is_nil (b2))) {

    \ \ \ \ SI y= max (b1-\<gtr\>y2, miny2);

    \ \ \ \ SI d= lo_y + y + sep - hi_y - b2-\<gtr\>y1;

    \ \ \ \ if (d \<gtr\> 0) {

    \ \ \ \ \ \ lo_y -= (d\<gtr\>\<gtr\>1);

    \ \ \ \ \ \ hi_y += (d\<gtr\>\<gtr\>1);

    \ \ \ \ }

    \ \ }

    \ \ if (!is_nil (b1)) {

    \ \ \ \ insert (b1, 0, lo_y);

    \ \ \ \ italic_correct (b1);

    \ \ }

    \ \ if (!is_nil (b2)) {

    \ \ \ \ insert (b2, 0, hi_y);

    \ \ \ \ italic_correct (b2);

    \ \ }

    \ \ position ();

    \ \ if (!is_nil (b1)) italic_restore (b1);

    \ \ if (!is_nil (b2)) italic_restore (b2);

    \ \ left_justify ();

    \ \ y1= min (y1, fn-\<gtr\>ysub_lo_base);

    \ \ y2= max (y2, fn-\<gtr\>ysup_lo_base + fn-\<gtr\>yx);

    \ \ finalize ();

    }
  </cpp-code>

  <subsection|Big operators>

  Big operators, like the big sum, products or integrals

  <\wide-tabular>
    <tformat|<cwith|1|1|2|2|cell-width|0.6par>|<cwith|1|1|2|2|cell-hmode|exact>|<table|<row|<\cell>
      <\equation*>
        <big|sum><rsub|n=1><rsup|N>a<rsub|n>,
      </equation*>
    </cell>|<\cell>
      <\tm-fragment>
        \<less\>big\|sum\<gtr\>\<less\>rsub\|n=1\<gtr\>\<less\>rsup\|N\<gtr\>a\<less\>rsub\|n\<gtr\>
      </tm-fragment>
    </cell>>>>
  </wide-tabular>

  <\wide-tabular>
    <tformat|<cwith|1|1|2|2|cell-width|0.6par>|<cwith|1|1|2|2|cell-hmode|exact>|<table|<row|<\cell>
      <\equation*>
        <big|prod><rsub|n=1><rsup|\<infty\>><around*|(|1-<frac|1|n>|)>
      </equation*>
    </cell>|<\cell>
      <\tm-fragment>
        \<less\>big\|prod\<gtr\>\<less\>rsub\|n=1\<gtr\>\<less\>rsup\|\\\<less\>infty\\\<gtr\>\<gtr\>

        \<less\>around*\|(\|1-\<less\>frac\|1\|n\<gtr\>\|)\<gtr\>
      </tm-fragment>
    </cell>>>>
  </wide-tabular>

  \;

  <\wide-tabular>
    <tformat|<cwith|1|1|2|2|cell-width|0.6par>|<cwith|1|1|2|2|cell-hmode|exact>|<table|<row|<\cell>
      <\equation*>
        <big|int><rsub|0><rsup|1>x<rsup|2>\<mathd\>x
      </equation*>
    </cell>|<\cell>
      <\tm-fragment>
        \<less\>big\|int\<gtr\>x\<less\>rsup\|2\<gtr\>\\\<less\>mathd\\\<gtr\>x
      </tm-fragment>
    </cell>>>>
  </wide-tabular>

  <\equation*>
    \;
  </equation*>

  It has two basic shapes, either in display style as above or inline as
  <math|<big|sum><rsub|n=1><rsup|N>a<rsub|n>>,
  <math|<big|prod><rsub|n=1><rsup|\<infty\>><around*|(|1-<frac|1|n>|)>>,
  <math|<big|int><rsub|0><rsup|1>x<rsup|2>\<mathd\>x>.

  They are typeset by:

  <\cpp-code>
    void

    concater_rep::typeset_bigop (tree t, path ip) {

    \ \ if ((N(t) == 1) && is_atomic (t[0])) {

    \ \ \ \ space spc= env-\<gtr\>fn-\<gtr\>spc;

    \ \ \ \ string l= t[0]-\<gtr\>label;

    \ \ \ \ string s= "\<less\>big-" * l * "\<gtr\>";

    \ \ \ \ bool flag= (!env-\<gtr\>math_condensed) && (l != ".");

    \ \ \ \ box b;

    \ \ \ \ if (env-\<gtr\>fn-\<gtr\>type == FONT_TYPE_UNICODE) {

    \ \ \ \ \ \ font mfn= rubber_font (env-\<gtr\>fn);

    \ \ \ \ \ \ b= big_operator_box (ip, s, mfn, env-\<gtr\>pen,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ env-\<gtr\>display_style?
    2: 1);

    \ \ \ \ }

    \ \ \ \ else b= big_operator_box (ip, s, env-\<gtr\>fn, env-\<gtr\>pen,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ env-\<gtr\>display_style?
    2: 1);

    \ \ \ \ print (STD_ITEM, OP_BIG, b);

    \ \ \ \ penalty_min (HYPH_PANIC);

    \ \ \ \ bool int_flag= false, it_flag= false, lim_flag= true;

    \ \ \ \ get_big_flags (l, int_flag, it_flag, lim_flag);

    \ \ \ \ if (lim_flag) with_limits (LIMITS_DISPLAY);

    \ \ \ \ if (flag) {

    \ \ \ \ \ \ if (int_flag) {

    \ \ \ \ \ \ \ \ if (env-\<gtr\>fn-\<gtr\>math_type == MATH_TYPE_STIX)

    \ \ \ \ \ \ \ \ \ \ print (env-\<gtr\>display_style? (spc / 2): (spc /
    4));

    \ \ \ \ \ \ \ \ else if (env-\<gtr\>fn-\<gtr\>math_type ==
    MATH_TYPE_TEX_GYRE)

    \ \ \ \ \ \ \ \ \ \ print (env-\<gtr\>display_style? (spc / 2): (spc /
    4));

    \ \ \ \ \ \ \ \ else if (it_flag)

    \ \ \ \ \ \ \ \ \ \ print (env-\<gtr\>display_style? 0: (spc / 4));

    \ \ \ \ \ \ \ \ else print (spc / 4);

    \ \ \ \ \ \ }

    \ \ \ \ \ \ else print (env-\<gtr\>display_style? spc: (spc / 2));

    \ \ \ \ }

    \ \ \ \ // FIXME: we should use parameters from operator-big class in
    std-math.syx

    \ \ \ \ // FIXME: in concat_post, we add some more space behind big
    operators

    \ \ \ \ // \ \ \ \ \ \ \ with scripts; this should be understood better
    and formalized

    \ \ }

    \ \ else typeset_error (t, ip);

    }
  </cpp-code>

  where we note the handling of limits and of the correct spacing after the
  symbol. The relevant glyph for <verbatim|\<less\>big\|sum\<gtr\>> is
  <verbatim|\<less\>big-sum-N\<gtr\>> where <verbatim|N=1,2> according to the
  appropriate size. Note that for Unicode fonts (<cpp|type ==
  FONT_TYPE_UNICODE>) we dispatch the selection of the glyph to a rubber
  obtained via <cpp|rubber_font>.

  The function <cpp|big_operator_box> takes care of the proper vertical
  placement of the glyph:

  <\cpp-code>
    box

    big_operator_box (path ip, string s, font fn, pencil pen, int n) {

    \ \ ASSERT (N(s) \<gtr\>= 2 && s[0] == '\<less\>' && s[N(s)-1] ==
    '\<gtr\>',

    \ \ \ \ \ \ \ \ \ \ "invalid rubber character");

    \ \ string r= s (0, N(s)-1) * "-" * as_string (n) * "\<gtr\>";

    \ \ metric ex;

    \ \ fn-\<gtr\>get_extents (r, ex);

    \ \ SI y= fn-\<gtr\>yfrac - ((ex-\<gtr\>y1 + ex-\<gtr\>y2) \<gtr\>\<gtr\>
    1);

    \ \ box mvb= move_box (ip, text_box (ip, 0, r, fn, pen), 0, y, false,
    true);

    \ \ return macro_box (ip, mvb, fn, BIG_OP_BOX);

    }
  </cpp-code>

  <subsection|Big delimiters>

  The automatic positioning and computation of sizes of big delimiters is
  again complicated because of potential conflicts between locally and
  globally optimal esthetics.

  First of all, <TeX> fonts come only with a discrete set of possible sizes
  for large delimiters. This is an advantage from the point of view that it
  favorites delimiters around slightly different expressions to have the same
  baselines. However, it has the disadvantage that delimiters are easily made
  \Pone size to large\Q. For this reason, we actually diminish the height and
  the depth of the delimited expression by the small amount <verbatim|sep>,
  before computing the sizes of the delimiters.

  Secondly, it is best when the vertical middles of big delimiters occur at
  the height of fraction bars. However, in a formula like

  <\equation*>
    f<around*|(|<frac|1|1+<frac|1|1+<frac|1|1+<frac|1|x>>>>|)>,
  </equation*>

  it may be worth it to descend the delimiters a bit. On the other hand,
  slight vertical shifts in the middles of the delimiters potentially have a
  bad effect on base lines, like in

  <\equation*>
    f<around*|(|<big|sum><rsub|i=1><rsup|b>X<rsub|i>|)>+g<around*|(|<big|sum><rsub|j=1><rsup|a>Y<rsub|j>|)>.
  </equation*>

  In <TeXmacs>, we use the following compromise: we start with the middle of
  the delimited expression as a first approximation to the middle of the
  delimiters. The real middle is obtained by shifting this middle towards the
  height of fraction bars by an amount which cannot exceed <verbatim|sep>.

  From a horizontal point of view, we finally have to notice that we adapted
  the metrics of the big delimiters in a way that potential scripts are
  positioned in a better way. For instance, according to the <TeX>
  <verbatim|tfm> file, in a formula like

  <\equation*>
    <around*|(|A+<around*|(|<big|sum><rsub|i=1><rsup|10>B<rsub|i>|)><rsup|2>|)>,
  </equation*>

  the square rather seems to be a left superscript of the second closing
  bracket than a right superscript of the first one. This is particularly
  annoying in the case of automatically generated formulas, where this
  situation occurs quite often.

  Markup looks like

  <\wide-tabular>
    <tformat|<cwith|1|1|2|2|cell-width|0.6par>|<cwith|1|1|2|2|cell-hmode|exact>|<table|<row|<\cell>
      <\equation*>
        <around*|[|<around*|{|<frac|1|2>+\<cdots\>+<frac|3|4>|}>+\<alpha\>|]>
      </equation*>
    </cell>|<\cell>
      <\tm-fragment>
        \<less\>around*\|[\|

        <space|1em>\<less\>around*\|{\|

        <space|3em>\<less\>frac\|1\|2\<gtr\>+\\\<less\>cdots\\\<gtr\>+\<less\>frac\|3\|4\<gtr\>

        <space|1em>\|}\<gtr\>+\\\<less\>alpha\\\<gtr\>

        \|]\<gtr\>
      </tm-fragment>
    </cell>>>>
  </wide-tabular>

  \;

  for automatic sizing of the brackets and like

  <\wide-tabular>
    <tformat|<cwith|1|1|2|2|cell-width|0.6par>|<cwith|1|1|2|2|cell-hmode|exact>|<table|<row|<\cell>
      <\equation*>
        <around*|<left|[|5>|<around*|<left|{|2>|1+\<cdots\>+3|<right|}|2>>+\<alpha\>|<right|]|5>>
      </equation*>
    </cell>|<\cell>
      <\tm-fragment>
        \<less\>around*\|\<less\>left\|[\|5\<gtr\>\|

        <space|1em>\<less\>around*\|\<less\>left\|{\|2\<gtr\>\|

        <space|3em>1+\\\<less\>cdots\\\<gtr\>+3

        <space|1em>\|\<less\>right\|}\|2\<gtr\>\<gtr\>+\\\<less\>alpha\\\<gtr\>

        \|\<less\>right\|]\|5\<gtr\>\<gtr\>
      </tm-fragment>
    </cell>>>>
  </wide-tabular>

  for manual sizing. The typesetting of big delimiters proceeds in various
  phases. A first phase fixes the basic structure and horizontal positioning
  of the three arguments of the <verbatim|around> tag. If requested via an
  appropriate environment variable, we use different colors to emphasize the
  matching brackets.

  <\cpp-code>
    void

    concater_rep::typeset_around (tree t, path ip, bool colored) {

    \ \ tree old_nl=

    \ \ \ \ env-\<gtr\>local_begin (MATH_NESTING_LEVEL, as_string
    (env-\<gtr\>nesting_level + 1));

    \ \ if (colored) {

    \ \ \ \ tree old_col= env-\<gtr\>local_begin (COLOR, bracket_color
    (env-\<gtr\>nesting_level));

    \ \ \ \ typeset_around (t, ip, false);

    \ \ \ \ env-\<gtr\>local_end (COLOR, old_col);

    \ \ }

    \ \ else {

    \ \ \ \ marker (descend (ip, 0));

    \ \ \ \ switch (L(t)) {

    \ \ \ \ case AROUND:

    \ \ \ \ \ \ if (N(t) == 3) {

    \ \ \ \ \ \ \ \ box br1= typeset_as_concat (env, t[0], descend (ip, 0));

    \ \ \ \ \ \ \ \ print (STD_ITEM, OP_OPENING_BRACKET, br1);

    \ \ \ \ \ \ \ \ typeset (t[1], descend (ip, 1));

    \ \ \ \ \ \ \ \ box br2= typeset_as_concat (env, t[2], descend (ip, 2));

    \ \ \ \ \ \ \ \ print (STD_ITEM, OP_CLOSING_BRACKET, br2);

    \ \ \ \ \ \ }

    \ \ \ \ \ \ else typeset_error (t, ip);

    \ \ \ \ \ \ break;

    \ \ \ \ case VAR_AROUND:

    \ \ \ \ \ \ if (N(t) == 3) {

    \ \ \ \ \ \ \ \ font old_fn= env-\<gtr\>fn;

    \ \ \ \ \ \ \ \ font new_fn= env-\<gtr\>fn;

    \ \ \ \ \ \ \ \ if (starts (new_fn-\<gtr\>res_name, "stix-"))

    \ \ \ \ \ \ \ \ \ \ //if (new_fn-\<gtr\>type == FONT_TYPE_UNICODE)

    \ \ \ \ \ \ \ \ \ \ new_fn= rubber_font (new_fn);

    \ \ \ \ \ \ \ \ env-\<gtr\>fn= new_fn;

    \ \ \ \ \ \ \ \ typeset (make_large (LEFT, t[0]),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ decorate_middle (descend (ip, 0)));

    \ \ \ \ \ \ \ \ env-\<gtr\>fn= old_fn;

    \ \ \ \ \ \ \ \ typeset (t[1], descend (ip, 1));

    \ \ \ \ \ \ \ \ env-\<gtr\>fn= new_fn;

    \ \ \ \ \ \ \ \ typeset (make_large (RIGHT, t[2]),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ decorate_middle (descend (ip, 2)));

    \ \ \ \ \ \ \ \ env-\<gtr\>fn= old_fn;

    \ \ \ \ \ \ }

    \ \ \ \ \ \ else typeset_error (t, ip);

    \ \ \ \ \ \ break;

    \ \ \ \ case BIG_AROUND:

    \ \ \ \ \ \ if (N(t) == 2) {

    \ \ \ \ \ \ \ \ typeset (make_large (BIG, t[0]),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ decorate_middle (descend (ip, 0)));

    \ \ \ \ \ \ \ \ typeset (t[1], descend (ip, 1));

    \ \ \ \ \ \ }

    \ \ \ \ \ \ else typeset_error (t, ip);

    \ \ \ \ \ \ break;

    \ \ \ \ default:

    \ \ \ \ \ \ break;

    \ \ \ \ }

    \ \ \ \ marker (descend (ip, 1));

    \ \ }

    \ \ env-\<gtr\>local_end (MATH_NESTING_LEVEL, old_nl);

    }
  </cpp-code>

  The expression <cpp|make_large (LEFT, t[0])> ensures that the first and
  third subtrees have a specific structure, of the form
  <verbatim|\<less\>left\|[\|5\<gtr\>> for a fixed size or
  <verbatim|\<less\>left\|[\<gtr\>> if there is automatic sizing.

  <\cpp-code>
    static tree

    make_large (tree_label l, tree t) {

    \ \ if (!is_atomic (t)) {

    \ \ \ \ if (is_func (t, l)) {

    \ \ \ \ \ \ if (N(t) == 2 && is_atomic (t[0]) && is_int (t[1])) {

    \ \ \ \ \ \ \ \ string s= t[0]-\<gtr\>label;

    \ \ \ \ \ \ \ \ if (N(s) \<gtr\>= 3 && s[0] == '\<less\>' && s[N(s)-1] ==
    '\<gtr\>') s= s (1, N(s)-1);

    \ \ \ \ \ \ \ \ return tree (l, s * "-" * t[1]-\<gtr\>label);

    \ \ \ \ \ \ }

    \ \ \ \ \ \ else return t;

    \ \ \ \ }

    \ \ \ \ else return tree (l, ".");

    \ \ }

    \ \ string s= t-\<gtr\>label;

    \ \ if (N(s) \<less\>= 1) return tree (l, s);

    \ \ if (s[0] != '\<less\>' \|\| s[N(s)-1] != '\<gtr\>' \|\| s ==
    "\<less\>nobracket\<gtr\>")

    \ \ \ \ return tree (l, ".");

    \ \ return tree (l, s (1, N(s)-1));

    }
  </cpp-code>

  The typesetting of <verbatim|LEFT>, <verbatim|RIGHT> and <verbatim|MID>
  markup is dispatched as follows in <cpp|concater_rep::typeset>:

  <\cpp-code>
    \ \ case LEFT:

    \ \ \ \ typeset_large (t, ip, LEFT_BRACKET_ITEM, OP_OPENING_BRACKET,
    "\<less\>left-");

    \ \ \ \ break;

    \ \ case MID:

    \ \ \ \ typeset_wide_middle (t, ip);

    \ \ \ \ break;

    \ \ case RIGHT:

    \ \ \ \ typeset_large (t, ip, RIGHT_BRACKET_ITEM, OP_CLOSING_BRACKET,
    "\<less\>right-");

    \ \ \ \ break;
  </cpp-code>

  and realised as follows:

  <\cpp-code>
    void

    concater_rep::typeset_large (tree t, path ip, int tp, int otp, string
    prefix) {

    \ \ font old_fn= env-\<gtr\>fn;

    \ \ if (starts (old_fn-\<gtr\>res_name, "stix-"))

    \ \ \ \ //if (old_fn-\<gtr\>type == FONT_TYPE_UNICODE)

    \ \ \ \ env-\<gtr\>fn= rubber_font (old_fn);

    \ \ 

    \ \ if (N(t) \<less\> 1 \|\| !is_atomic (t[0]))

    \ \ \ \ typeset_error (t, ip);

    \ \ else {

    \ \ \ \ string br= t[0]-\<gtr\>label;

    \ \ \ \ if (N(br) \<gtr\> 2 && br[0] == '\<less\>' && br[N(br)-1] ==
    '\<gtr\>')

    \ \ \ \ \ \ br= br (1, N(br) - 1);

    \ \ \ \ if (N(t) == 1) {

    \ \ \ \ \ \ string s= prefix * br * "\<gtr\>";

    \ \ \ \ \ \ box b= text_box (ip, 0, s, env-\<gtr\>fn, env-\<gtr\>pen);

    \ \ \ \ \ \ print (tp, otp, b);

    \ \ \ \ \ \ // temporarary: use parameters from group-open class in
    std-math.syx

    \ \ \ \ \ \ // bug: allow hyphenation after ) and before *

    \ \ \ \ }

    \ \ \ \ else if (N(t) == 2 && is_int (t[1])) {

    \ \ \ \ \ \ int nr= max (as_int (t[1]-\<gtr\>label), 0);

    \ \ \ \ \ \ string s= prefix * br * "-" * as_string (nr) * "\<gtr\>";

    \ \ \ \ \ \ box b= text_box (ip, 0, s, env-\<gtr\>fn, env-\<gtr\>pen);

    \ \ \ \ \ \ SI dy= env-\<gtr\>fn-\<gtr\>yfrac - ((b-\<gtr\>y1 +
    b-\<gtr\>y2) \<gtr\>\<gtr\> 1);

    \ \ \ \ \ \ box mvb= move_box (ip, b, 0, dy, false, true);

    \ \ \ \ \ \ print (STD_ITEM, otp, macro_box (ip, mvb, env-\<gtr\>fn));

    \ \ \ \ }

    \ \ \ \ else {

    \ \ \ \ \ \ SI y1, y2;

    \ \ \ \ \ \ if (N(t) == 2) {

    \ \ \ \ \ \ \ \ SI l= env-\<gtr\>as_length (t[1]) \<gtr\>\<gtr\> 1;

    \ \ \ \ \ \ \ \ y1= env-\<gtr\>fn-\<gtr\>yfrac - l;

    \ \ \ \ \ \ \ \ y2= env-\<gtr\>fn-\<gtr\>yfrac + l;

    \ \ \ \ \ \ }

    \ \ \ \ \ \ else {

    \ \ \ \ \ \ \ \ y1= env-\<gtr\>as_length (t[1]);

    \ \ \ \ \ \ \ \ y2= env-\<gtr\>as_length (t[2]);

    \ \ \ \ \ \ }

    \ \ \ \ \ \ string s= prefix * br * "\<gtr\>";

    \ \ \ \ \ \ box b= delimiter_box (ip, s, env-\<gtr\>fn, env-\<gtr\>pen,
    y1, y2);

    \ \ \ \ \ \ print (STD_ITEM, otp, b);

    \ \ \ \ }

    \ \ }

    \;

    \ \ env-\<gtr\>fn= old_fn;

    }
  </cpp-code>

  Note that the main branch for markup like <verbatim|\<less\>left\|[\<gtr\>>
  produces only a text box with an appropriate glyph. The vertical size of
  the glyph is still not correct at this point. Since it depends on the
  globality of the current expression and not known when typesetting the left
  bracket. It will be determined later on. See
  Section<nbsp><reference|sec:finalization>.

  <subsection|Long arrows>

  Long arrows refers to the following markup:

  <\wide-tabular>
    <tformat|<cwith|1|1|2|2|cell-width|0.6par>|<cwith|1|1|2|2|cell-hmode|exact>|<table|<row|<\cell>
      <\equation*>
        A<long-arrow|\<rubber-rightarrow\>||<text|a long arrow>>B
      </equation*>
    </cell>|<\cell>
      <\tm-fragment>
        <inactive*|A<long-arrow|\<rubber-rightarrow\>||<text|a long arrow>>B>
      </tm-fragment>
    </cell>>>>
  </wide-tabular>

  allowing for material above and below. The typesetting of long arrows do
  not require further mechanisms to those already put in place for wide
  boxes:

  <\cpp-code>
    void

    concater_rep::typeset_long_arrow (tree t, path ip) {

    \ \ if (N(t) != 2 && N(t) != 3) { typeset_error (t, ip); return; }

    \ \ tree old_ds= env-\<gtr\>local_begin (MATH_DISPLAY, "false");

    \ \ tree old_mc= env-\<gtr\>local_begin (MATH_CONDENSED, "true");

    \ \ tree old_il= env-\<gtr\>local_begin_script ();

    \ \ box sup_b, sub_b;

    \ \ if (N(t) \<gtr\>= 2) {

    \ \ \ \ tree old_vp= env-\<gtr\>local_begin (MATH_VPOS, "-1");

    \ \ \ \ sup_b= typeset_as_concat (env, t[1], descend (ip, 1));

    \ \ \ \ env-\<gtr\>local_end (MATH_VPOS, old_vp);

    \ \ }

    \ \ if (N(t) \<gtr\>= 3) {

    \ \ \ \ tree old_vp= env-\<gtr\>local_begin (MATH_VPOS, "1");

    \ \ \ \ sub_b= typeset_as_concat (env, t[2], descend (ip, 2));

    \ \ \ \ env-\<gtr\>local_end (MATH_VPOS, old_vp);

    \ \ }

    \ \ env-\<gtr\>local_end_script (old_il);

    \ \ env-\<gtr\>local_end (MATH_CONDENSED, old_mc);

    \ \ env-\<gtr\>local_end (MATH_DISPLAY, old_ds);

    \;

    \ \ string s= env-\<gtr\>exec_string (t[0]);

    \ \ SI w= sup_b-\<gtr\>w();

    \ \ if (N(t) == 3) w= max (w, sub_b-\<gtr\>w());

    \ \ w += env-\<gtr\>fn-\<gtr\>wquad;

    \ \ box arrow= wide_box (decorate (descend (ip, 0)), s, env-\<gtr\>fn,
    env-\<gtr\>pen, w);

    \;

    \ \ space spc= env-\<gtr\>fn-\<gtr\>spc;

    \ \ if (env-\<gtr\>math_condensed) spc= space
    (spc-\<gtr\>min\<gtr\>\<gtr\>3, spc-\<gtr\>def\<gtr\>\<gtr\>3,
    spc-\<gtr\>max\<gtr\>\<gtr\>2);

    \ \ else spc= space (spc-\<gtr\>min\<gtr\>\<gtr\>1,
    spc-\<gtr\>def\<gtr\>\<gtr\>1, spc-\<gtr\>max);

    \ \ print (spc);

    \ \ print (limit_box (ip, arrow, sub_b, sup_b, env-\<gtr\>fn, false));

    \ \ print (spc);

    }
  </cpp-code>

  It introduces <cpp|lim_box_rep> which takes care of the relative
  positioning of the various subboxes (<cpp|limit_box> returns a
  <cpp|lim_box_rep>):

  <\cpp-code>
    lim_box_rep::lim_box_rep (path ip, box r2, box lo, box hi, font fn2, bool
    gl):

    \ \ composite_box_rep (ip), ref (r2), fn (fn2), glued (gl)

    {

    \ \ SI sep_lo= fn-\<gtr\>sep + fn-\<gtr\>yshift;

    \ \ SI sep_hi= fn-\<gtr\>sep + (fn-\<gtr\>yshift \<gtr\>\<gtr\> 1);

    \ \ SI X, Y;

    \ \ insert (ref, 0, 0);

    \ \ type= 0;

    \ \ if (!is_nil (lo)) type += 1;

    \ \ if (!is_nil (hi)) type += 2;

    \ \ if (!is_nil (lo)) {

    \ \ \ \ SI top= max (lo-\<gtr\>y2, fn-\<gtr\>y2 * script (fn-\<gtr\>size,
    1) / fn-\<gtr\>size) + sep_lo;

    \ \ \ \ Y= ref-\<gtr\>y1;

    \ \ \ \ X= ((SI) (ref-\<gtr\>right_slope ()* (Y+top-lo-\<gtr\>y1))) +
    ((ref-\<gtr\>x1+ref-\<gtr\>x2)\<gtr\>\<gtr\>1);

    \ \ \ \ insert (lo, X- (lo-\<gtr\>x2 \<gtr\>\<gtr\> 1), Y-top);

    \ \ \ \ italic_correct (lo);

    \ \ }

    \ \ if (!is_nil (hi)) {

    \ \ \ \ SI bot= min (hi-\<gtr\>y1, fn-\<gtr\>y1 * script (fn-\<gtr\>size,
    1) / fn-\<gtr\>size) - sep_hi;

    \ \ \ \ Y= ref-\<gtr\>y2;

    \ \ \ \ X= ((SI) (ref-\<gtr\>right_slope ()*(Y+hi-\<gtr\>y2-bot))) +
    ((ref-\<gtr\>x1+ref-\<gtr\>x2)\<gtr\>\<gtr\>1);

    \ \ \ \ insert (hi, X- (hi-\<gtr\>x2 \<gtr\>\<gtr\> 1), Y-bot);

    \ \ \ \ italic_correct (hi);

    \ \ }

    \ \ italic_correct (ref);

    \ \ position ();

    \ \ italic_restore (ref);

    \ \ if (!is_nil (lo)) italic_restore (lo);

    \ \ if (!is_nil (hi)) italic_restore (hi);

    \ \ left_justify ();

    \ \ finalize ();

    }
  </cpp-code>

  <subsection|Above and below boxes>

  The <markup|below> and <markup|above> tags are used to explicitly attach a
  <src-arg|script> below or above a given <src-arg|content>. Both can be
  mixed in order to produce content with both a script below and above:

  <\wide-tabular>
    <tformat|<cwith|1|1|2|2|cell-width|0.6par>|<cwith|1|1|2|2|cell-hmode|exact>|<table|<row|<\cell>
      <\equation*>
        \ <above|<below|xor|i=1>|\<infty\>> x<rsub|i>
      </equation*>
    </cell>|<\cell>
      <\tm-fragment>
        <inactive*|<math| <above|<below|xor|i=1>|\<infty\>> x<rsub|i>>>
      </tm-fragment>
    </cell>>>>
  </wide-tabular>

  Like long arrows, above and below tags also rely on <cpp|lim_box_rep> for
  their graphical rendering:

  <\cpp-code>
    void

    concater_rep::typeset_below (tree t, path ip) {

    \ \ if (N(t) != 2) { typeset_error (t, ip); return; }

    \ \ box b1= typeset_as_concat (env, t[0], descend (ip, 0));

    \ \ tree old_ds= env-\<gtr\>local_begin (MATH_DISPLAY, "false");

    \ \ tree old_mc= env-\<gtr\>local_begin (MATH_CONDENSED, "true");

    \ \ tree old_il= env-\<gtr\>local_begin_script ();

    \ \ box b2= typeset_as_concat (env, t[1], descend (ip, 1));

    \ \ env-\<gtr\>local_end_script (old_il);

    \ \ env-\<gtr\>local_end (MATH_CONDENSED, old_mc);

    \ \ env-\<gtr\>local_end (MATH_DISPLAY, old_ds);

    \ \ print (limit_box (ip, b1, b2, box (), env-\<gtr\>fn, false));

    }
  </cpp-code>

  <\cpp-code>
    void

    concater_rep::typeset_above (tree t, path ip) {

    \ \ if (N(t) != 2) { typeset_error (t, ip); return; }

    \ \ box b1= typeset_as_concat (env, t[0], descend (ip, 0));

    \ \ tree old_ds= env-\<gtr\>local_begin (MATH_DISPLAY, "false");

    \ \ tree old_mc= env-\<gtr\>local_begin (MATH_CONDENSED, "true");

    \ \ tree old_il= env-\<gtr\>local_begin_script ();

    \ \ box b2= typeset_as_concat (env, t[1], descend (ip, 1));

    \ \ env-\<gtr\>local_end_script (old_il);

    \ \ env-\<gtr\>local_end (MATH_CONDENSED, old_mc);

    \ \ env-\<gtr\>local_end (MATH_DISPLAY, old_ds);

    \ \ // NOTE: start dirty hack to get scripts above ... right

    \ \ if ((t[0] == "\<less\>ldots\<gtr\>" && env-\<gtr\>read ("low-dots")
    != UNINIT) \|\|

    \ \ \ \ \ \ (t[0] == "\<less\>cdots\<gtr\>" && env-\<gtr\>read
    ("center-dots") != UNINIT)) {

    \ \ \ \ string s= (t[0] == "\<less\>ldots\<gtr\>"? ",":
    "\<less\>cdot\<gtr\>");

    \ \ \ \ box tb= typeset_as_concat (env, s, decorate_middle (descend (ip,
    0)));

    \ \ \ \ b1= resize_box (descend (ip, 0), b1, b1-\<gtr\>x1, b1-\<gtr\>y1,
    b1-\<gtr\>x2, tb-\<gtr\>y2);

    \ \ }

    \ \ // NOTE: end dirty hack to get scripts above ... right

    \ \ print (limit_box (ip, b1, box (), b2, env-\<gtr\>fn, false));

    }
  </cpp-code>

  <subsection|Finalization><label|sec:finalization>

  The computation of the correct size of extensible brackets and the proper
  placement of super/sub-scripts require a second pass through the
  <cpp|line_item> array that <cpp|concater> is currently typesetting. This
  triggered by <cpp|concater_rep::finish ()>:

  <\cpp-code>
    void

    concater_rep::finish () {

    \ \ kill_spaces ();

    \ \ pre_glue ();

    \ \ handle_brackets ();

    \ \ clean_and_correct ();

    }
  </cpp-code>

  <verbatim|kill_spaces> and <verbatim|pre_glue> simplify the
  <verbatim|line_items> array:

  <\cpp-code>
    /******************************************************************************

    * Kill invalid spaces

    ******************************************************************************/

    \;

    void

    concater_rep::kill_spaces () {

    \ \ int i;

    \ \ for (i=N(a)-1; (i\<gtr\>0) && (a[i]-\<gtr\>type == CONTROL_ITEM);
    i--)

    \ \ \ \ a[i-1]-\<gtr\>spc= space (0);

    \ \ for (i=0; (i\<less\>N(a)) && (a[i]-\<gtr\>type == CONTROL_ITEM); i++)

    \ \ \ \ a[i]-\<gtr\>spc= space (0);

    \;

    \ \ for (i=0; i\<less\>N(a); i++)

    \ \ \ \ if (a[i]-\<gtr\>type==CONTROL_ITEM) {

    \ \ \ \ \ \ if (is_formatting (a[i]-\<gtr\>t)) {

    \ \ \ \ \ \ \ \ tree_label lab= L(a[i]-\<gtr\>t);

    \ \ \ \ \ \ \ \ if ((lab==NEXT_LINE) \|\| (lab==LINE_BREAK) \|\|
    (lab==NEW_LINE))

    \ \ \ \ \ \ \ \ \ \ {

    \ \ \ \ \ \ \ \ \ \ \ \ if (i\<gtr\>0) a[i-1]-\<gtr\>spc= space (0);

    \ \ \ \ \ \ \ \ \ \ \ \ a[i]-\<gtr\>spc= space (0);

    \ \ \ \ \ \ \ \ \ \ }

    \ \ \ \ \ \ }

    \;

    \ \ \ \ \ \ if (is_tuple (a[i]-\<gtr\>t, "env_par") \|\|

    \ \ \ \ \ \ \ \ \ \ is_tuple (a[i]-\<gtr\>t, "env_page"))

    \ \ \ \ \ \ \ \ a[i]-\<gtr\>spc= space (0);

    \ \ \ \ }

    }
  </cpp-code>

  while <cpp|pre_glue> put together neightbor sub and super scripts on the
  same side labelling them with the line items type <cpp|GLUE_LSUBS_ITEM> or
  <cpp|GLUE_RSUBS_ITEM>:

  <\cpp-code>
    \;

    void

    concater_rep::pre_glue () {

    \ \ int i=0;

    \ \ while (true) {

    \ \ \ \ int j= succ(i);

    \ \ \ \ if (j \<gtr\>= N(a)) break;

    \ \ \ \ line_item item1= a[i];

    \ \ \ \ line_item item2= a[j];

    \ \ \ \ int t1= item1-\<gtr\>type;

    \ \ \ \ int t2= item2-\<gtr\>type;

    \ \ \ \ if (((t1 == RSUB_ITEM) && (t2 == RSUP_ITEM)) \|\|

    \ \ \ \ \ \ \ \ ((t1 == RSUP_ITEM) && (t2 == RSUB_ITEM)) \|\|

    \ \ \ \ \ \ \ \ ((t1 == LSUB_ITEM) && (t2 == LSUP_ITEM)) \|\|

    \ \ \ \ \ \ \ \ ((t1 == LSUP_ITEM) && (t2 == LSUB_ITEM)))

    \ \ \ \ \ \ {

    \ \ \ \ \ \ \ \ bool \ flag1 = (t1 == LSUB_ITEM) \|\| (t1 == RSUB_ITEM);

    \ \ \ \ \ \ \ \ bool \ flag2 = (t1 == LSUB_ITEM) \|\| (t1 == LSUP_ITEM);

    \ \ \ \ \ \ \ \ int \ \ type \ = flag2? GLUE_LSUBS_ITEM: GLUE_RSUBS_ITEM;

    \ \ \ \ \ \ \ \ box \ \ b1 \ \ \ = flag1? item1-\<gtr\>b[0]:
    item2-\<gtr\>b[0];

    \ \ \ \ \ \ \ \ box \ \ b2 \ \ \ = flag1? item2-\<gtr\>b[0]:
    item1-\<gtr\>b[0];

    \ \ \ \ \ \ \ \ box \ \ b \ \ \ \ = script_box (b1-\<gtr\>ip, b1, b2,
    env-\<gtr\>fn);

    \ \ \ \ \ \ \ \ int \ \ pen \ \ = item2-\<gtr\>penalty;

    \ \ \ \ \ \ \ \ space spc \ \ = max (item1-\<gtr\>spc, item2-\<gtr\>spc);

    \;

    \ \ \ \ \ \ \ \ a[i]= line_item (type, OP_SKIP, b, pen);

    \ \ \ \ \ \ \ \ a[i]-\<gtr\>spc = spc;

    \ \ \ \ \ \ \ \ for (int k=i+1; k\<less\>j; k++)

    \ \ \ \ \ \ \ \ \ \ if (a[k]-\<gtr\>type == MARKER_ITEM)

    \ \ \ \ \ \ \ \ \ \ \ \ a[k]= line_item (OBSOLETE_ITEM, OP_SKIP,
    a[k]-\<gtr\>b, a[k]-\<gtr\>penalty);

    \ \ \ \ \ \ \ \ a[j]= line_item (OBSOLETE_ITEM, OP_SKIP, item2-\<gtr\>b,
    pen);

    \ \ \ \ \ \ }

    \ \ \ \ i++;

    \ \ }

    }
  </cpp-code>

  \;

  The function <cpp|handle_brackets> fixes the size of the extensible
  brackets and middle marks and also the global placement of scripts :

  <\cpp-code>
    void

    concater_rep::handle_brackets () {

    \ \ int first=-1, start=0, i=0;

    \ \ while (i\<less\>N(a)) {

    \ \ \ \ if (a[i]-\<gtr\>type==LEFT_BRACKET_ITEM) {

    \ \ \ \ \ \ if (first==-1) first= i;

    \ \ \ \ \ \ start= i;

    \ \ \ \ }

    \ \ \ \ if (a[i]-\<gtr\>type==RIGHT_BRACKET_ITEM) {

    \ \ \ \ \ \ handle_scripts \ (succ (start), prec (i));

    \ \ \ \ \ \ handle_matching (start, i);

    \ \ \ \ \ \ if (first!=-1) i=first-1;

    \ \ \ \ \ \ start= 0;

    \ \ \ \ \ \ first= -1;

    \ \ \ \ }

    \ \ \ \ i++;

    \ \ }

    \ \ if (N(a)\<gtr\>0) {

    \ \ \ \ handle_scripts \ (0, N(a)-1);

    \ \ \ \ handle_matching (0, N(a)-1);

    \ \ }

    }
  </cpp-code>

  \;

  The placement of scripts is the job of <cpp|handle_scripts>:

  <\cpp-code>
    void

    concater_rep::handle_scripts (int start, int end) {

    \ \ int i;

    \ \ for (i=start; i\<less\>=end; ) {

    \ \ \ \ if ((a[i]-\<gtr\>type == OBSOLETE_ITEM) \|\|

    \ \ \ \ \ \ \ \ (a[i]-\<gtr\>type == LSUB_ITEM) \|\|

    \ \ \ \ \ \ \ \ (a[i]-\<gtr\>type == LSUP_ITEM) \|\|

    \ \ \ \ \ \ \ \ (a[i]-\<gtr\>type == GLUE_LSUBS_ITEM) \|\|

    \ \ \ \ \ \ \ \ (a[i]-\<gtr\>type == RSUB_ITEM) \|\|

    \ \ \ \ \ \ \ \ (a[i]-\<gtr\>type == RSUP_ITEM) \|\|

    \ \ \ \ \ \ \ \ (a[i]-\<gtr\>type == GLUE_RSUBS_ITEM) \|\|

    \ \ \ \ \ \ \ \ (a[i]-\<gtr\>type == CONTROL_ITEM && L(a[i]-\<gtr\>t) ==
    DATOMS)) {

    \ \ \ \ \ \ i++; continue; }

    \;

    \ \ \ \ path sip;

    \ \ \ \ int l= prec (i);

    \ \ \ \ box lb1, lb2;

    \ \ \ \ if (l \<less\> start) l= -1;

    \ \ \ \ else switch (a[l]-\<gtr\>type) {

    \ \ \ \ case LSUB_ITEM:

    \ \ \ \ \ \ lb1= a[l]-\<gtr\>b[0]; sip= lb1-\<gtr\>ip;

    \ \ \ \ \ \ break;

    \ \ \ \ case LSUP_ITEM:

    \ \ \ \ \ \ lb2= a[l]-\<gtr\>b[0]; sip= lb2-\<gtr\>ip;

    \ \ \ \ \ \ break;

    \ \ \ \ case GLUE_LSUBS_ITEM:

    \ \ \ \ \ \ lb1= a[l]-\<gtr\>b[0]; lb2= a[l]-\<gtr\>b[1];

    \ \ \ \ \ \ sip= lb2-\<gtr\>ip;

    \ \ \ \ \ \ break;

    \ \ \ \ default:

    \ \ \ \ \ \ l = -1;

    \ \ \ \ }

    \;

    \ \ \ \ int r= succ (i);

    \ \ \ \ box rb1, rb2;

    \ \ \ \ if (r \<gtr\> end) r= N(a);

    \ \ \ \ else switch (a[r]-\<gtr\>type) {

    \ \ \ \ case RSUB_ITEM:

    \ \ \ \ \ \ rb1= a[r]-\<gtr\>b[0]; sip= rb1-\<gtr\>ip;

    \ \ \ \ \ \ break;

    \ \ \ \ case RSUP_ITEM:

    \ \ \ \ \ \ rb2= a[r]-\<gtr\>b[0]; sip= rb2-\<gtr\>ip;

    \ \ \ \ \ \ break;

    \ \ \ \ case GLUE_RSUBS_ITEM:

    \ \ \ \ \ \ rb1= a[r]-\<gtr\>b[0]; rb2= a[r]-\<gtr\>b[1];

    \ \ \ \ \ \ sip= rb2-\<gtr\>ip;

    \ \ \ \ \ \ break;

    \ \ \ \ default:

    \ \ \ \ \ \ r = N(a);

    \ \ \ \ }

    \;

    \ \ \ \ box b;

    \ \ \ \ if (l==-1) {

    \ \ \ \ \ \ if (r==N(a)) { i++; continue; }

    \ \ \ \ \ \ else {

    \ \ \ \ \ \ \ \ font ref_fn= get_reference_font (a[i]-\<gtr\>b,
    env-\<gtr\>fn);

    \ \ \ \ \ \ \ \ box mb= glue_right_markers (a[i]-\<gtr\>b, i, r, false);

    \ \ \ \ \ \ \ \ if (a[i]-\<gtr\>limits)

    \ \ \ \ \ \ \ \ \ \ b= limit_box (sip, mb, rb1, rb2, ref_fn, true);

    \ \ \ \ \ \ \ \ else

    \ \ \ \ \ \ \ \ \ \ b= right_script_box (sip, mb, rb1, rb2, ref_fn,
    env-\<gtr\>vert_pos);

    \ \ \ \ \ \ \ \ glue (b, i, r);

    \ \ \ \ \ \ }

    \ \ \ \ }

    \ \ \ \ else {

    \ \ \ \ \ \ font ref_fn= get_reference_font (a[i]-\<gtr\>b,
    env-\<gtr\>fn);

    \ \ \ \ \ \ box mb= glue_left_markers (a[i]-\<gtr\>b, i, l);

    \ \ \ \ \ \ if (r==N(a)) {

    \ \ \ \ \ \ \ \ b= left_script_box (sip, mb, lb1, lb2, ref_fn,
    env-\<gtr\>vert_pos);

    \ \ \ \ \ \ \ \ glue (b, i, l);

    \ \ \ \ \ \ }

    \ \ \ \ \ \ else {

    \ \ \ \ \ \ \ \ mb= glue_right_markers (mb, i, r, true);

    \ \ \ \ \ \ \ \ b = side_box (sip, mb, lb1, lb2, rb1, rb2, ref_fn,
    env-\<gtr\>vert_pos);

    \ \ \ \ \ \ \ \ glue (b, i, l, r);

    \ \ \ \ \ \ }

    \ \ \ \ }

    \ \ }

    }
  </cpp-code>

  with the help of the following subsidiary routines: <todo|explain more>

  <\cpp-code>
    box

    concater_rep::glue_left_markers (box b, int ref, int arg) {

    \ \ int i= arg+1;

    \ \ while (i \<less\> ref && a[i]-\<gtr\>type == OBSOLETE_ITEM) i++;

    \ \ if (i \<gtr\>= ref) return b;

    \ \ array\<less\>box\<gtr\> bs;

    \ \ array\<less\>SI\<gtr\> \ spc;

    \ \ while (i \<less\> ref) {

    \ \ \ \ if (a[i]-\<gtr\>type == MARKER_ITEM) {

    \ \ \ \ \ \ bs \ \<less\>\<less\> a[i]-\<gtr\>b;

    \ \ \ \ \ \ spc \<less\>\<less\> 0;

    \ \ \ \ \ \ a[i]-\<gtr\>type= OBSOLETE_ITEM;

    \ \ \ \ }

    \ \ \ \ i++;

    \ \ }

    \ \ bs \ \<less\>\<less\> b;

    \ \ spc \<less\>\<less\> 0;

    \ \ return concat_box (b-\<gtr\>ip, bs, spc);

    }

    \;

    box

    concater_rep::glue_right_markers (box b, int ref, int arg, bool flag) {

    \ \ int i= ref+1;

    \ \ while (i \<less\> arg && a[i]-\<gtr\>type == OBSOLETE_ITEM) i++;

    \ \ if (i \<gtr\>= arg) return b;

    \ \ array\<less\>box\<gtr\> bs;

    \ \ array\<less\>SI\<gtr\> \ spc;

    \ \ if (flag) {

    \ \ \ \ for (int j=0; j\<less\>N(b); j++) {

    \ \ \ \ \ \ bs \ \<less\>\<less\> b[j];

    \ \ \ \ \ \ spc \<less\>\<less\> 0;

    \ \ \ \ }

    \ \ }

    \ \ else {

    \ \ \ \ bs \ \<less\>\<less\> b;

    \ \ \ \ spc \<less\>\<less\> 0;

    \ \ }

    \ \ while (i \<less\> arg) {

    \ \ \ \ if (a[i]-\<gtr\>type == MARKER_ITEM) {

    \ \ \ \ \ \ bs \ \<less\>\<less\> a[i]-\<gtr\>b;

    \ \ \ \ \ \ spc \<less\>\<less\> 0;

    \ \ \ \ \ \ a[i]-\<gtr\>type= OBSOLETE_ITEM;

    \ \ \ \ }

    \ \ \ \ i++;

    \ \ }

    \ \ return concat_box (b-\<gtr\>ip, bs, spc);

    }

    \;

    void

    concater_rep::glue (box b, int ref, int arg) {

    \ \ if (a[ref]-\<gtr\>op_type == OP_BIG && arg \<gtr\>= ref &&
    !a[ref]-\<gtr\>limits) {

    \ \ \ \ font ref_fn= get_reference_font (a[ref]-\<gtr\>b, env-\<gtr\>fn);

    \ \ \ \ if (ref_fn-\<gtr\>math_type != MATH_TYPE_NORMAL)

    \ \ \ \ \ \ if (a[ref]-\<gtr\>spc-\<gtr\>def \<gtr\> 0) {

    \ \ \ \ \ \ \ \ space spc= ref_fn-\<gtr\>spc;

    \ \ \ \ \ \ \ \ a[ref]-\<gtr\>spc += space (spc-\<gtr\>min/3,
    spc-\<gtr\>def/3, spc-\<gtr\>def/3);

    \ \ \ \ \ \ }

    \ \ }

    \ \ 

    \ \ space spc = max (a[ref]-\<gtr\>spc, a[arg]-\<gtr\>spc);

    \;

    \ \ a[arg] \ = line_item (OBSOLETE_ITEM, OP_SKIP, a[arg]-\<gtr\>b,
    a[arg]-\<gtr\>penalty);

    \ \ a[ref] \ = line_item (arg\<less\>ref? GLUE_LEFT_ITEM:
    GLUE_RIGHT_ITEM,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ a[ref]-\<gtr\>op_type, b,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ min (a[ref]-\<gtr\>penalty,
    a[arg]-\<gtr\>penalty));

    \ \ a[ref]-\<gtr\>spc = spc;

    }

    \;

    void

    concater_rep::glue (box b, int ref, int arg1, int arg2) {

    \ \ if (a[ref]-\<gtr\>op_type == OP_BIG && !a[ref]-\<gtr\>limits) {

    \ \ \ \ font ref_fn= get_reference_font (a[ref]-\<gtr\>b, env-\<gtr\>fn);

    \ \ \ \ if (ref_fn-\<gtr\>math_type != MATH_TYPE_NORMAL)

    \ \ \ \ \ \ if (a[ref]-\<gtr\>spc-\<gtr\>def \<gtr\> 0) {

    \ \ \ \ \ \ \ \ space spc= ref_fn-\<gtr\>spc;

    \ \ \ \ \ \ \ \ a[ref]-\<gtr\>spc += space (spc-\<gtr\>min/3,
    spc-\<gtr\>def/3, spc-\<gtr\>def/3);

    \ \ \ \ \ \ }

    \ \ }

    \;

    \ \ space spc = max (a[ref]-\<gtr\>spc, max (a[arg1]-\<gtr\>spc,
    a[arg2]-\<gtr\>spc));

    \ \ int \ \ pen = min (a[ref]-\<gtr\>penalty, min
    (a[arg1]-\<gtr\>penalty, a[arg2]-\<gtr\>penalty));

    \;

    \ \ space ref_spc= a[ref]-\<gtr\>spc;

    \ \ a[arg1]= line_item (OBSOLETE_ITEM, OP_SKIP, a[arg1]-\<gtr\>b,
    a[arg1]-\<gtr\>penalty);

    \ \ a[arg2]= line_item (OBSOLETE_ITEM, OP_SKIP, a[arg2]-\<gtr\>b,
    a[arg2]-\<gtr\>penalty);

    \ \ a[ref]= line_item (GLUE_BOTH_ITEM, a[ref]-\<gtr\>op_type, b, pen);

    \ \ a[ref]-\<gtr\>spc = spc;

    }
  </cpp-code>

  \;

  Finally, the sizing of the brackets is the job of <cpp|handle_matching>:

  <\cpp-code>
    void

    concater_rep::handle_matching (int start, int end) {

    \ \ //cout \<less\>\<less\> "matching " \<less\>\<less\> start
    \<less\>\<less\> " -- " \<less\>\<less\> end \<less\>\<less\> "\\n";

    \ \ //cout \<less\>\<less\> a \<less\>\<less\> "\\n\\n";

    \ \ int i;

    \ \ SI y1= \ MAX_SI;

    \ \ SI y2= -MAX_SI;

    \ \ bool uninit= true;

    \ \ a[start]-\<gtr\>penalty++;

    \ \ a[end]-\<gtr\>penalty++;

    \ \ for (i=start+1; i\<less\>end; i++) {

    \ \ \ \ if (a[i]-\<gtr\>type == OBSOLETE_ITEM) continue;

    \ \ \ \ // cout \<less\>\<less\> " \ " \<less\>\<less\> a[i]
    \<less\>\<less\> ": " \<less\>\<less\> (a[i]-\<gtr\>b-\<gtr\>y2-
    a[i]-\<gtr\>b-\<gtr\>y1) \<less\>\<less\> "\\n";

    \ \ \ \ // y1= min (y1, a[i]-\<gtr\>b-\<gtr\>sub_base());

    \ \ \ \ // y2= max (y2, a[i]-\<gtr\>b-\<gtr\>sup_base());

    \ \ \ \ SI lo, hi;

    \ \ \ \ a[i]-\<gtr\>b-\<gtr\>get_bracket_extents (lo, hi);

    \ \ \ \ y1= min (y1, lo);

    \ \ \ \ y2= max (y2, hi);

    \ \ \ \ a[i]-\<gtr\>penalty++;

    \ \ \ \ uninit= false;

    \ \ }

    \ \ if (uninit) {

    \ \ \ \ y1= min (a[start]-\<gtr\>b-\<gtr\>y1, a[end]-\<gtr\>b-\<gtr\>y2);

    \ \ \ \ y2= max (a[start]-\<gtr\>b-\<gtr\>y1, a[end]-\<gtr\>b-\<gtr\>y2);

    \ \ }

    \;

    \ \ for (i=start; i\<less\>=end; i++) {

    \ \ \ \ int tp= a[i]-\<gtr\>type;

    \ \ \ \ if (tp == LEFT_BRACKET_ITEM \|\|

    \ \ \ \ \ \ \ \ tp == MIDDLE_BRACKET_ITEM \|\|

    \ \ \ \ \ \ \ \ tp == RIGHT_BRACKET_ITEM)

    \ \ \ \ \ \ {

    \ \ \ \ \ \ \ \ string ls= a[i]-\<gtr\>b-\<gtr\>get_leaf_string ();

    \ \ \ \ \ \ \ \ pencil lp= a[i]-\<gtr\>b-\<gtr\>get_leaf_pencil ();

    \ \ \ \ \ \ \ \ font \ \ fn= a[i]-\<gtr\>b-\<gtr\>get_leaf_font ();

    \;

    \ \ \ \ \ \ \ \ // find the middle of the bracket, around where to center

    \ \ \ \ \ \ \ \ SI mid= (a[i]-\<gtr\>b-\<gtr\>y1 +
    a[i]-\<gtr\>b-\<gtr\>y2) \<gtr\>\<gtr\> 1;

    \ \ \ \ \ \ \ \ bool custom=

    \ \ \ \ \ \ \ \ \ \ N(ls) \<gtr\> 2 && is_digit (ls[N(ls)-2]) && !ends
    (ls, "-0\<gtr\>");

    \ \ \ \ \ \ \ \ if (custom) {

    \ \ \ \ \ \ \ \ \ \ int pos= N(ls)-1;

    \ \ \ \ \ \ \ \ \ \ while (pos \<gtr\> 0 && ls[pos] != '-') pos--;

    \ \ \ \ \ \ \ \ \ \ if (pos \<gtr\> 0 && ls[pos-1] == '-') pos--;

    \ \ \ \ \ \ \ \ \ \ string ss= ls (0, pos) * "\<gtr\>";

    \ \ \ \ \ \ \ \ \ \ box auxb= text_box (a[i]-\<gtr\>b-\<gtr\>ip, 0, ss,
    fn, lp);

    \ \ \ \ \ \ \ \ \ \ mid= (auxb-\<gtr\>y1 + auxb-\<gtr\>y2) \<gtr\>\<gtr\>
    1;

    \ \ \ \ \ \ \ \ }

    \;

    \ \ \ \ \ \ \ \ // make symmetric and prevent from too large delimiters
    if possible

    \ \ \ \ \ \ \ \ SI Y1 \ \ = y1 + (fn-\<gtr\>sep \<gtr\>\<gtr\> 1);

    \ \ \ \ \ \ \ \ SI Y2 \ \ = y2 - (fn-\<gtr\>sep \<gtr\>\<gtr\> 1);

    \ \ \ \ \ \ \ \ SI tol \ = fn-\<gtr\>sep \<less\>\<less\> 1;

    \ \ \ \ \ \ \ \ SI drift= ((Y1 + Y2) \<gtr\>\<gtr\> 1) - mid; //
    fn-\<gtr\>yfrac;

    \ \ \ \ \ \ \ \ if (drift \<less\> 0) Y2 += min (-drift, tol)
    \<less\>\<less\> 1;

    \ \ \ \ \ \ \ \ else Y1 -= min (drift, tol) \<less\>\<less\> 1;

    \;

    \ \ \ \ \ \ \ \ // further adjustments when the enclosed expression is
    not very high

    \ \ \ \ \ \ \ \ // and for empty brackets

    \ \ \ \ \ \ \ \ SI h= y2 - y1 - fn-\<gtr\>sep;

    \ \ \ \ \ \ \ \ SI d= 5 * fn-\<gtr\>yx - h;

    \ \ \ \ \ \ \ \ if (d \<gtr\> 0) { Y1 += d/12; Y2 -= d/12; }

    \ \ \ \ \ \ \ \ if (N(ls) \<gtr\>= 8 && (ls[6] == '.' \|\| ls[7] == '.'))

    \ \ \ \ \ \ \ \ \ \ if (starts (ls, "\<less\>left-.") \|\| starts (ls,
    "\<less\>right-.")) {

    \ \ \ \ \ \ \ \ \ \ \ \ Y1 += d/6; Y2 -= d/12; }

    \;

    \ \ \ \ \ \ \ \ // replace item by large or small delimiter

    \ \ \ \ \ \ \ \ if (Y1 \<less\> fn-\<gtr\>y1 \|\| Y2 \<gtr\> fn-\<gtr\>y2
    \|\| custom \|\| use_poor_rubber (fn))

    \ \ \ \ \ \ \ \ \ \ a[i]-\<gtr\>b= delimiter_box
    (a[i]-\<gtr\>b-\<gtr\>ip, ls, fn, lp, Y1, Y2, mid, y1, y2);

    \ \ \ \ \ \ \ \ else {

    \ \ \ \ \ \ \ \ \ \ string s= "\<less\>nobracket\<gtr\>";

    \ \ \ \ \ \ \ \ \ \ int j;

    \ \ \ \ \ \ \ \ \ \ for (j=0; j\<less\>N(ls); j++)

    \ \ \ \ \ \ \ \ \ \ \ \ if (ls[j] == '-') break;

    \ \ \ \ \ \ \ \ \ \ if (j\<less\>N(ls) && ls[N(ls)-1] == '\<gtr\>') s= ls
    (j+1, N(ls)-1);

    \ \ \ \ \ \ \ \ \ \ if (N(s) \<gtr\> 1 && s[0] != '\<less\>') s=
    "\<less\>" * s * "\<gtr\>";

    \ \ \ \ \ \ \ \ \ \ else if (N(s) == 0 \|\| s == ".") s=
    "\<less\>nobracket\<gtr\>";

    \ \ \ \ \ \ \ \ \ \ a[i]-\<gtr\>b= text_box (a[i]-\<gtr\>b-\<gtr\>ip, 0,
    s, fn, lp);

    \ \ \ \ \ \ \ \ \ \ tp= STD_ITEM;

    \ \ \ \ \ \ \ \ }

    \ \ \ \ \ \ \ \ a[i]-\<gtr\>type= STD_ITEM;

    \ \ \ \ \ \ }

    \ \ \ \ if (tp == LEFT_BRACKET_ITEM)

    \ \ \ \ \ \ for (int j= i-1; j\<gtr\>=0; j--) {

    \ \ \ \ \ \ \ \ if (a[j]-\<gtr\>type == MARKER_ITEM) {

    \ \ \ \ \ \ \ \ \ \ SI Y1= a[i]-\<gtr\>b-\<gtr\>y1;

    \ \ \ \ \ \ \ \ \ \ SI Y2= a[i]-\<gtr\>b-\<gtr\>y2;

    \ \ \ \ \ \ \ \ \ \ //a[j]-\<gtr\>b = marker_box
    (a[j]-\<gtr\>b-\<gtr\>find_lip (), 0, Y1, 0, Y2, a[j]-\<gtr\>b);

    \ \ \ \ \ \ \ \ \ \ a[j]-\<gtr\>b \ \ = marker_box
    (a[j]-\<gtr\>b-\<gtr\>find_lip (), 0, Y1, 0, Y2, a[i]-\<gtr\>b);

    \ \ \ \ \ \ \ \ \ \ a[j]-\<gtr\>type= STD_ITEM;

    \ \ \ \ \ \ \ \ }

    \ \ \ \ \ \ \ \ else if (a[j]-\<gtr\>type != CONTROL_ITEM) break;

    \ \ \ \ \ \ }

    \ \ \ \ if (tp == RIGHT_BRACKET_ITEM)

    \ \ \ \ \ \ for (int j= i+1; j\<less\>N(a); j++) {

    \ \ \ \ \ \ \ \ if (a[j]-\<gtr\>type == MARKER_ITEM) {

    \ \ \ \ \ \ \ \ \ \ SI Y1= a[i]-\<gtr\>b-\<gtr\>y1;

    \ \ \ \ \ \ \ \ \ \ SI Y2= a[i]-\<gtr\>b-\<gtr\>y2;

    \ \ \ \ \ \ \ \ \ \ //a[j]-\<gtr\>b = marker_box
    (a[j]-\<gtr\>b-\<gtr\>find_lip (), 0, Y1, 0, Y2, a[j]-\<gtr\>b);

    \ \ \ \ \ \ \ \ \ \ a[j]-\<gtr\>b \ \ = marker_box
    (a[j]-\<gtr\>b-\<gtr\>find_lip (), 0, Y1, 0, Y2, a[i]-\<gtr\>b);

    \ \ \ \ \ \ \ \ \ \ a[j]-\<gtr\>type= STD_ITEM;

    \ \ \ \ \ \ \ \ }

    \ \ \ \ \ \ \ \ else if (a[j]-\<gtr\>type != CONTROL_ITEM) break;

    \ \ \ \ \ \ }

    \ \ }

    }
  </cpp-code>

  Again, a key point of this procedure is the call to <cpp|delimiter_box> (in
  <verbatim|src/Typeset/Boxes/Basic/text_boxes.cpp>) in order to replace the
  \Ptemporary\Q vertical delimiter, with a correctly sized one (be it a left,
  right or middle delimiter).\ 

  <\cpp-code>
    box

    delimiter_box (path ip, string s, font fn, pencil pen,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ SI bot, SI top, SI mid, SI real_bot, SI
    real_top)

    {

    \ \ SI h= top - bot;

    \ \ string r= get_delimiter (s, fn, h);

    \ \ box b= text_box (ip, 0, r, fn, pen);

    \ \ SI x= -b-\<gtr\>x1;

    \ \ SI y= (top + bot - b-\<gtr\>y1 - b-\<gtr\>y2) \<gtr\>\<gtr\> 1;

    \ \ if (b-\<gtr\>y2 - b-\<gtr\>y1 \<less\> h) {

    \ \ \ \ y= (mid - b-\<gtr\>y1 - b-\<gtr\>y2) \<gtr\>\<gtr\> 1;

    \ \ \ \ y= min (top - b-\<gtr\>y2, y);

    \ \ \ \ y= max (bot - b-\<gtr\>y1, y);

    \ \ }

    \ \ //cout \<less\>\<less\> s \<less\>\<less\> ", " \<less\>\<less\>
    bot/PIXEL \<less\>\<less\> " -- " \<less\>\<less\> top/PIXEL

    \ \ // \ \ \ \ \<less\>\<less\> " -\<gtr\> " \<less\>\<less\> r
    \<less\>\<less\> "; " \<less\>\<less\> x/PIXEL \<less\>\<less\> ", "
    \<less\>\<less\> y/PIXEL \<less\>\<less\> "\\n";

    \ \ //cout \<less\>\<less\> " \ extents: " \<less\>\<less\>
    b-\<gtr\>x1/PIXEL \<less\>\<less\> ", " \<less\>\<less\>
    b-\<gtr\>y1/PIXEL

    \ \ // \ \ \ \ \<less\>\<less\> "; " \<less\>\<less\> b-\<gtr\>x2/PIXEL
    \<less\>\<less\> ", " \<less\>\<less\> b-\<gtr\>y2/PIXEL \<less\>\<less\>
    "\\n";

    \ \ box mvb= move_delimiter_box (ip, b, x, y, real_bot, real_top);

    \ \ if (ends (r, "-0\<gtr\>")) return mvb;

    \ \ SI dy= ((mvb-\<gtr\>y1 + mvb-\<gtr\>y2)\<gtr\>\<gtr\>1) -
    fn-\<gtr\>yfrac;

    \ \ return macro_delimiter_box (ip, mvb, fn, dy);

    }
  </cpp-code>

  The function <cpp|get_delimiter> queries the font for a sequence of glyphs
  in the form <verbatim|\<less\>left-[-N\<gtr\>> (for example) with
  <verbatim|N=0,1,2,3,4,<text-dots>> until we obtain the required height.

  <\cpp-code>
    /******************************************************************************

    * Computing right size for rubber characters

    ******************************************************************************/

    \;

    static int

    get_number (string s, int& pos) {

    \ \ int n= N(s);

    \ \ pos= n-1;

    \ \ while (pos \<gtr\> 0 && s[pos] != '-') pos--;

    \ \ if (pos \<gtr\> 0 && s[pos-1] == '-') pos--;

    \ \ return as_int (s (pos+1, n-1));

    }

    \;

    static string

    get_delimiter (string s, font fn, SI height) {

    \ \ int ns= N(s);

    \ \ ASSERT (ns \<gtr\>= 2 && s[0] == '\<less\>' && s[ns-1] == '\<gtr\>',

    \ \ \ \ \ \ \ \ \ \ "invalid rubber character");

    \ \ if (is_digit (s[ns-2])) {

    \ \ \ \ int pos;

    \ \ \ \ int plus= get_number (s, pos);

    \ \ \ \ if (pos \<gtr\> 0) {

    \ \ \ \ \ \ string s2= s (0, pos) * "\<gtr\>";

    \ \ \ \ \ \ string r2= get_delimiter (s2, fn, height);

    \ \ \ \ \ \ int pos2;

    \ \ \ \ \ \ int nr2= get_number (r2, pos2);

    \ \ \ \ \ \ if (pos2 \<gtr\> 0) {

    \ \ \ \ \ \ \ \ int nr= max (nr2 + plus, 0);

    \ \ \ \ \ \ \ \ return r2 (0, pos2) * "-" * as_string (nr) * "\<gtr\>";

    \ \ \ \ \ \ }

    \ \ \ \ }

    \ \ }

    \ \ height -= PIXEL;

    \ \ string radical= s (0, N(s)-1) * "-";

    \ \ string best= radical * "0\<gtr\>";

    \ \ SI best_h= 0;

    \ \ int n= 0;

    \ \ SI last= 0;

    \ \ int credit= 20;

    \ \ while (credit \<gtr\> 0) {

    \ \ \ \ metric ex;

    \ \ \ \ string test= radical * as_string (n) * "\<gtr\>";

    \ \ \ \ fn-\<gtr\>get_extents (test, ex);

    \ \ \ \ SI h= ex-\<gtr\>y2 - ex-\<gtr\>y1;

    \ \ \ \ if (h \<gtr\>= (height - (n==1? PIXEL: 0))) return test;

    \ \ \ \ if (h \<gtr\> best_h) { best_h= h; best= test; }

    \ \ \ \ int d= h - last;

    \ \ \ \ if (last \<gtr\> 0 && d \<gtr\> 0) {

    \ \ \ \ \ \ int plus= (height - h - 1) / d;

    \ \ \ \ \ \ if (plus \<less\>= 1 \|\| n \<less\>= 4) { n++; last= h; }

    \ \ \ \ \ \ else {

    \ \ \ \ \ \ \ \ int n2= n + plus;

    \ \ \ \ \ \ \ \ metric ex2;

    \ \ \ \ \ \ \ \ string test2= radical * as_string (n2) * "\<gtr\>";

    \ \ \ \ \ \ \ \ fn-\<gtr\>get_extents (test2, ex2);

    \ \ \ \ \ \ \ \ SI h2= ex2-\<gtr\>y2 - ex2-\<gtr\>y1;

    \ \ \ \ \ \ \ \ if (h2 \<gtr\>= height \|\| h2 \<less\> h) { n++; last=
    h; }

    \ \ \ \ \ \ \ \ else { n= n2; last= 0; }

    \ \ \ \ \ \ }

    \ \ \ \ }

    \ \ \ \ else if (last \<less\>= 0 \|\| n \<less\> 10) { n++; last= h; }

    \ \ \ \ else return best;

    \ \ \ \ credit--;

    \ \ }

    \ \ return best;

    }
  </cpp-code>

  <section|Final remarks>

  A list of possible improvements to the code reviewed in this document:

  <\itemize>
    <item>The mechanism to select appropriate glyphs do not depend on
    specific details of the typesetting process apart from the required size,
    so maybe can be moved into the font (and possibly allow for
    simplification in this generic part)

    <item>Ideally we want to try to remove dependence on specific fonts in
    this part of code, all the required measurements should be available in a
    generic way from the current font without further tweaking (or less of
    it).

    <item>Allow for OpenType <verbatim|MATH> table information (if available)
    to be used, e.g. in the placement of various math constructions.
  </itemize>

  \;

  \;
</body>

<\initial>
  <\collection>
    <associate|code-numbered-offset|0.5tab>
    <associate|font|typewriter=roman,TeX Gyre Termes>
    <associate|font-family|rm>
    <associate|math-font|math-termes>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|auto-1|<tuple|?|?>>
    <associate|auto-10|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|left>|?>>
    <associate|auto-11|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|mid>|?>>
    <associate|auto-12|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|right>|?>>
    <associate|auto-13|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|big>|?>>
    <associate|auto-14|<tuple|1|?>>
    <associate|auto-15|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|frac>|?>>
    <associate|auto-16|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|sqrt>|?>>
    <associate|auto-17|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|sqrt>|?>>
    <associate|auto-18|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|lsub>|?>>
    <associate|auto-19|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|lsup>|?>>
    <associate|auto-2|<tuple|1|?>>
    <associate|auto-20|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|rsub>|?>>
    <associate|auto-21|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|rsup>|?>>
    <associate|auto-22|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|lprime>|?>>
    <associate|auto-23|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|rprime>|?>>
    <associate|auto-24|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|below>|?>>
    <associate|auto-25|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|above>|?>>
    <associate|auto-26|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|wide>|?>>
    <associate|auto-27|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|wide*>|?>>
    <associate|auto-28|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|neg>|?>>
    <associate|auto-29|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|tree>|?>>
    <associate|auto-3|<tuple|Unequal spacing|?>>
    <associate|auto-30|<tuple|3|?>>
    <associate|auto-31|<tuple|4|?>>
    <associate|auto-32|<tuple|4.1|?>>
    <associate|auto-33|<tuple|4.2|?>>
    <associate|auto-34|<tuple|4.3|?>>
    <associate|auto-35|<tuple|4.4|?>>
    <associate|auto-36|<tuple|4.5|?>>
    <associate|auto-37|<tuple|4.6|?>>
    <associate|auto-38|<tuple|4.7|?>>
    <associate|auto-39|<tuple|4.8|?>>
    <associate|auto-4|<tuple|Unequal spacing|?>>
    <associate|auto-40|<tuple|4.9|?>>
    <associate|auto-41|<tuple|4.10|?>>
    <associate|auto-42|<tuple|4.11|?>>
    <associate|auto-43|<tuple|5|?>>
    <associate|auto-5|<tuple|Unequal spacing|?>>
    <associate|auto-6|<tuple|Unequal spacing|?>>
    <associate|auto-7|<tuple|2|?>>
    <associate|auto-8|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|left>|?>>
    <associate|auto-9|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|left>|?>>
    <associate|big-example|<tuple|1|?>>
    <associate|sec:finalization|<tuple|4.11|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|idx>
      <tuple|<tuple|<with|font-family|<quote|ss>|Format>|<with|font-family|<quote|ss>|Adjust>|<with|font-family|<quote|ss>|Move>>|<pageref|auto-2>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Format>|<with|font-family|<quote|ss>|Adjust>|<with|font-family|<quote|ss>|Resize>>|<pageref|auto-3>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Format>|<with|font-family|<quote|ss>|Adjust>|<with|font-family|<quote|ss>|Smash>>|<pageref|auto-4>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Format>|<with|font-family|<quote|ss>|Adjust>|<with|font-family|<quote|ss>|Inflate>>|<pageref|auto-5>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|left>>|<pageref|auto-7>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|left>>|<pageref|auto-8>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|left>>|<pageref|auto-9>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|mid>>|<pageref|auto-10>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|right>>|<pageref|auto-11>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|big>>|<pageref|auto-12>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Format>|<with|font-family|<quote|ss>|Display
      style>>|<pageref|auto-13>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|frac>>|<pageref|auto-14>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|sqrt>>|<pageref|auto-15>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|sqrt>>|<pageref|auto-16>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|lsub>>|<pageref|auto-17>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|lsup>>|<pageref|auto-18>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|rsub>>|<pageref|auto-19>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|rsup>>|<pageref|auto-20>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|lprime>>|<pageref|auto-21>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|rprime>>|<pageref|auto-22>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|below>>|<pageref|auto-23>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|above>>|<pageref|auto-24>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|wide>>|<pageref|auto-25>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|wide*>>|<pageref|auto-26>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|neg>>|<pageref|auto-27>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|tree>>|<pageref|auto-28>>
    </associate>
    <\associate|toc>
      1.<space|2spc>Overview <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1>

      2.<space|2spc>Mathematical primitives
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6>

      3.<space|2spc>The font parameters <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-29>

      4.<space|2spc>Implementation of the mathematical primitives
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-30>

      <with|par-left|<quote|1tab>|4.1.<space|2spc>Primed expressions
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-31>>

      <with|par-left|<quote|1tab>|4.2.<space|2spc>Fractions
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-32>>

      <with|par-left|<quote|1tab>|4.3.<space|2spc>Roots
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-33>>

      <with|par-left|<quote|1tab>|4.4.<space|2spc>Negations
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-34>>

      <with|par-left|<quote|1tab>|4.5.<space|2spc>Wide boxes
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-35>>

      <with|par-left|<quote|1tab>|4.6.<space|2spc>Subscripts and superscripts
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-36>>

      <with|par-left|<quote|1tab>|4.7.<space|2spc>Big operators
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-37>>

      <with|par-left|<quote|1tab>|4.8.<space|2spc>Big delimiters
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-38>>

      <with|par-left|<quote|1tab>|4.9.<space|2spc>Long arrows
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-39>>

      <with|par-left|<quote|1tab>|4.10.<space|2spc>Above and below boxes
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-40>>

      <with|par-left|<quote|1tab>|4.11.<space|2spc>Finalization
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-41>>

      5.<space|2spc>Final remarks <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-42>
    </associate>
  </collection>
</auxiliary>