<TeXmacs|2.1.4>

<style|<tuple|notes|old-dots|old-lengths|doc>>

<\body>
  <\hide-preamble>
    <assign|wip|<\macro|body>
      <with|color|dark red|<\wide-tabular>
        <tformat|<cwith|1|1|1|1|cell-background|pastel
        red>|<cwith|1|1|1|1|cell-tborder|0ln>|<cwith|1|1|1|1|cell-bborder|0ln>|<cwith|1|1|1|1|cell-lborder|5ln>|<cwith|1|1|1|1|cell-rborder|0ln>|<cwith|1|1|1|1|cell-lsep|1em>|<cwith|1|1|1|1|cell-rsep|1em>|<cwith|1|1|1|1|cell-bsep|0.5em>|<cwith|1|1|1|1|cell-tsep|0.5em>|<table|<row|<\cell>
          <arg|body>
        </cell>>>>
      </wide-tabular>>
    </macro>>

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
            <tformat|<cwith|1|1|1|1|cell-hyphen|n>|<cwith|1|1|1|1|cell-bsep|0.3em>|<cwith|1|1|1|1|cell-tsep|0.3em>|<cwith|1|1|1|1|cell-lsep|0.5em>|<cwith|1|1|1|1|cell-rsep|0.5em>|<cwith|1|1|1|1|cell-halign|r>|<cwith|1|1|1|1|cell-background|light
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

  <chapter*|From trees to boxes>

  <\notes-abstract>
    This document describes <TeXmacs> typesetter. We describe the state of
    facts as per <verbatim|svn> revision <tt|r14561> (December 2024,
    <tt|TeXmacs 2.14+>). Excerpts from the official documentation are
    included for completeness.

    \;
  </notes-abstract>

  <\wip>
    Still WIP.

    <\itemize>
      <item>Revise the overview;

      <item>Complete analysis of the bridge, and go to the concater, the
      stacker, etc<text-dots> and basic boxes mechanisms;

      <item>Review evaluation of trees?\ 
    </itemize>
  </wip>

  <section|Overview>

  <subsection|<TeXmacs> trees><label|sec-tm-tree>

  All <TeXmacs> documents or document fragments can be thought of as
  <em|trees>. For instance, the tree

  <\equation*>
    <tree|<text|<markup|with>>|mode|math|<tree|<text|<markup|concat>>|x+y+|<tree|<text|<markup|frac>>|1|2>|+|<tree|<text|<markup|sqrt>>|y+z>>>
  </equation*>

  typically represents the formula

  <\equation>
    <label|tm-tree-ex>x+y+<frac|1|2>+<sqrt|y+z>
  </equation>

  <paragraph*|Internal nodes of <TeXmacs> trees>

  Each of the internal nodes of a <TeXmacs> tree is a string symbol and each
  of the leafs is an ordinary string. A string symbol is different from a
  usual string only from the efficiency point of view: <TeXmacs> represents
  each symbol by a unique number, so that it is extremely fast to test
  weather two symbols are equal.

  <paragraph*|Leafs of <TeXmacs> trees>

  Currently, all strings are represented using the <em|universal <TeXmacs>
  encoding>. This encoding coincides with the Cork font encoding for all
  characters except \P<verbatim|\<less\>>\Q and \P<verbatim|\<gtr\>>\Q.
  Character sequences starting with \P<verbatim|\<less\>>\Q and ending with
  \P<verbatim|\<gtr\>>\Q are interpreted as special extension characters. For
  example, <verbatim|\<less\>alpha\<gtr\>> stands for the letter
  <math|\<alpha\>>. The semantics of characters in the universal <TeXmacs>
  encoding does not depend on the context (currently, cyrillic characters are
  an exception, but this should change soon). In other words, the universal
  <TeXmacs> encoding may be seen as an analogue of Unicode. In the future, we
  might actually switch to Unicode.

  The string leafs either contain ordinary text or special data. <TeXmacs>
  supports the following atomic data types:

  <\description>
    <item*|Boolean numbers>Either <verbatim|true> or <verbatim|false>.

    <item*|Integers>Sequences of digits which may be preceded by a minus
    sign.

    <item*|Floating point numbers>Specified using the usual scientific
    notation.

    <item*|Lengths>Floating point numbers followed by a <hlink|length
    unit|lengths.en.tm>, like <verbatim|29.7cm> or <verbatim|2fn>.
  </description>

  <subsection|<TeXmacs> documents><label|sec-tm-docs>

  Whereas <TeXmacs> document fragments can be general <TeXmacs> trees,
  <TeXmacs> documents are trees of a special form which we will describe now.
  The root of a <TeXmacs> document is necessarily a <markup|document> tag.
  The children of this tag are necessarily of one of the following forms:

  <\explain|<explain-macro|TeXmacs|version><explain-synopsis|<TeXmacs>
  version>>
    This mandatory tag specifies the version of <TeXmacs> which was used to
    save the document.
  </explain>

  <\explain|<explain-macro|project|ref><explain-synopsis|part of a project>>
    An optional project to which the document belongs.
  </explain>

  <\explain>
    <explain-macro|style|version>

    <explain-macro|style|<with|font-shape|right|<explain-macro|tuple|style|pack-1|<math|\<cdots\>>|pack-n>>><explain-synopsis|style
    and packages>
  <|explain>
    An optional style and additional packages for the document.
  </explain>

  <\explain|<explain-macro|body|content><explain-synopsis|body of the
  document>>
    This mandatory tag specifies the body of your document.
  </explain>

  <\explain|<label|initial-env><explain-macro|initial|table><explain-synopsis|initial
  environment>>
    Optional specification of the initial environment for the document, with
    information about the page size, margins, <abbr|etc.>. The
    <src-arg|table> is of the form <explain-macro|collection|binding-1|<math|\<cdots\>>|binding-n>.
    Each <src-arg|binding-<no-break>i> is of the form
    <explain-macro|associate|var-i|val-i> and associates the initial value
    <src-arg|val-i> to the environment variable <src-arg|var-i>. The initial
    values of environment variables which do not occur in the table are
    determined by the style file and packages.
  </explain>

  <\explain|<explain-macro|references|table><explain-synopsis|references>>
    An optional list of all valid references to labels in the document. Even
    though this information can be automatically recovered by the typesetter,
    this recovery requires several passes. In order to make the behaviour of
    the editor more natural when loading files, references are therefore
    stored along with the document.

    The <src-arg|table> is of a similar form as above. In this case a tuple
    is associated to each label. This tuple is either of the form
    <explain-macro|tuple|content|page-nr> or
    <explain-macro|tuple|content|page-nr|file>. The <src-arg|content>
    corresponds to the displayed text when referring to the label,
    <src-arg|page-nr> to the corresponding page number, and the optional
    <src-arg|file> to the file where the label was defined (this is only used
    when the file is part of a project).
  </explain>

  <\explain|<explain-macro|auxiliary|table><explain-synopsis|auxiliary data
  attached to the file>>
    This optional tag specifies all auxiliary data attached to the document.
    Usually, such auxiliary data can be recomputed automatically from the
    document, but such recomputations may be expensive and even require tools
    which are not necessarily installed on your system. The <src-arg|table>,
    which is specified in a similar way as above, associates auxiliary
    content to a key. Standard keys include <verbatim|bib>, <verbatim|toc>,
    <verbatim|idx>, <verbatim|gly>, <abbr|etc.>
  </explain>

  <\example>
    An article with the simple text \Phello world!\Q is represented as

    <\equation*>
      <tree|<text|<markup|document>>|<tree|<text|<markup|TeXmacs>>|<text|<TeXmacs-version>>>|<tree|<text|<markup|style>>|article>|<tree|<text|<markup|body>>|<tree|<text|<markup|document>>|hello
      world!>>>
    </equation*>
  </example>

  <subsection|Default serialization><label|sec-tm-tm>

  Documents are generally written to disk using the standard <TeXmacs> syntax
  (which corresponds to the <verbatim|.tm> and <verbatim|.ts> file
  extensions). This syntax is designed to be unobtrusive and easy to read, so
  the content of a document can be easily understood from a plain text
  editor. For instance, the formula (<reference|tm-tree-ex>) is represented
  by

  <\quote-env>
    <framed-fragment|<verbatim|\<less\>with\|mode\|math\|x+y+\<less\>frac\|1\|2\<gtr\>+\<less\>sqrt\|y+z\<gtr\>\<gtr\>>>
  </quote-env>

  On the other hand, <TeXmacs> syntax makes style files difficult to read and
  is not designed to be hand-edited: whitespace has complex semantics and
  some internal structures are not obviously presented. Do not edit documents
  (and especially style files) in the <TeXmacs> syntax unless you know what
  you are doing.

  <paragraph*|Main serialization principle>

  The <TeXmacs> format uses the special characters <verbatim|\<less\>>,
  <verbatim|\|>, <verbatim|\<gtr\>>, <verbatim|\\> and <verbatim|/> in order
  to serialize trees. By default, a tree like

  <\equation>
    <label|gen-tree-tm><tree|f|x<rsub|1>|\<cdots\>|x<rsub|n>>
  </equation>

  is serialized as

  <\tm-fragment>
    <verbatim|\<less\>f\|x<rsub|1>\|...\|x<rsub|n>\<gtr\>>
  </tm-fragment>

  If one of the arguments <math|x<rsub|1>,\<ldots\>,x<rsub|n>> is a
  multi-paragraph tree (which means in this context that it contains a
  <markup|document> tag or a <markup|collection> tag), then an alternative
  long form is used for the serialization. If <verbatim|f> takes only
  multi-paragraph arguments, then the tree would be serialized as

  <\tm-fragment>
    <\verbatim>
      \<less\>\\f\<gtr\>

      \ \ x<rsub|1>

      \<less\>\|f\<gtr\>

      \ \ ...

      \<less\>\|f\<gtr\>

      \ \ x<rsub|n>

      \<less\>/f\<gtr\>
    </verbatim>
  </tm-fragment>

  In general, arguments which are not multi-paragraph are serialized using
  the short form. For instance, if <verbatim|n=5> and <verbatim|x<rsub|3>>
  and <verbatim|x<rsub|5>> are multi-paragraph, but not <verbatim|x<rsub|1>,>
  <verbatim|x<rsub|2>> and <verbatim|x<rsub|4>>, then
  (<reference|gen-tree-tm>) is serialized as

  <\tm-fragment>
    <\verbatim>
      \<less\>\\f\|x<rsub|1>\|x<rsub|2>\<gtr\>

      \ \ x<rsub|3>

      \<less\>\|f\|x<rsub|4>\<gtr\>

      \ \ x<rsub|5>

      \<less\>/f\<gtr\>
    </verbatim>
  </tm-fragment>

  The escape sequences <verbatim|\\\<less\>less\\\<gtr\>>, <verbatim|\\\|>,
  <verbatim|\\\<less\>gtr\\\<gtr\>> and <verbatim|\\\\> may be used to
  represent the characters <verbatim|\<less\>>, <verbatim|\|>,
  <verbatim|\<gtr\>> and <verbatim|\\>. For instance,
  <math|\<alpha\>+\<beta\>> is serialized as
  <verbatim|\\\<less\>alpha\\\<gtr\>+\\\<less\>beta\\\<gtr\>>.

  <paragraph*|Formatting and whitespace>

  The <markup|document> and <markup|concat> primitives are serialized in a
  special way. The <markup|concat> primitive is serialized as usual
  concatenation. For instance, the text \Pan <em|important> note\Q is
  serialized as

  <\tm-fragment>
    <\verbatim>
      an \<less\>em\|important\<gtr\> note
    </verbatim>
  </tm-fragment>

  The <markup|document> tag is serialized by separating successive paragraphs
  by double newline characters. For instance, the quotation

  <\quote-env>
    <\dutch>
      Ik ben de blauwbilgorgel.

      Als ik niet wok of worgel,
    </dutch>
  </quote-env>

  is serialized as

  <\tm-fragment>
    <\verbatim>
      \<less\>\\quote-env\<gtr\>

      \ \ Ik ben de blauwbilgorgel.

      \;

      \ \ Als ik niet wok of worgel,

      \<less\>/quote-env\<gtr\>
    </verbatim>
  </tm-fragment>

  Notice that whitespace at the beginning and end of paragraphs is ignored.
  Inside paragraphs, any amount of whitespace is considered as a single
  space. Similarly, more than two newline characters are equivalent to two
  newline characters. For instance, the quotation might have been stored on
  disk as

  <\tm-fragment>
    <\verbatim>
      \<less\>\\quote-env\<gtr\>

      \ \ Ik ben de \ \ \ \ \ \ \ \ \ \ blauwbilgorgel.

      \;

      \;

      \ \ Als ik niet wok of \ \ \ \ \ \ \ \ \ worgel,

      \<less\>/quote-env\<gtr\>
    </verbatim>
  </tm-fragment>

  The space character may be explicitly represented through the escape
  sequence \P<verbatim|\\ >\Q. Empty paragraphs are represented using the
  escape sequence \P<verbatim|\\;>\Q.

  <paragraph*|Raw data>

  The <markup|raw-data> primitive is used inside <TeXmacs> for the
  representation of binary data, like image files included into the document.
  Such binary data is serialized as

  <\tm-fragment>
    <\verbatim>
      \<less\>#<em|binary-data>\<gtr\>
    </verbatim>
  </tm-fragment>

  where the <verbatim|<em|binary-data>> is a string of hexadecimal numbers
  which represents a string of bytes.

  <subsection|The typesetting process><label|sec-typesetting>

  In order to understand the <TeXmacs> document format well, it is useful to
  have a basic understanding about how documents are typeset by the editor.
  The typesetter mainly rewrites logical <TeXmacs> trees into physical
  <em|boxes>, which can be displayed on the screen or on paper (notice that
  boxes actually contain more information than is necessary for their
  rendering, such as information about how to position the cursor inside the
  box or how to make selections).

  The global typesetting process can be subdivided into two major parts
  (which are currently done at the same stage, but this may change in the
  future): evaluation of the <TeXmacs> tree using the stylesheet language,
  and the actual typesetting.

  The typesetting primitives are designed to be very fast and they are
  built-in into the editor. For instance, one has typesetting primitives for
  horizontal concatenations (<markup|concat>), page breaks
  (<markup|page-break>), mathematical fractions (<markup|frac>), hyperlinks
  (<markup|hlink>), and so on. The precise rendering of many of the
  typesetting primitives may be customized through the built-in environment
  variables. For instance, the environment variable <src-var|color> specifies
  the current color of objects, <src-var|par-left> the current left margin of
  paragraphs, <abbr|etc.>

  The stylesheet language allows the user to write new primitives (macros) on
  top of the built-in primitives. It contains primitives for defining macros,
  conditional statements, computations, delayed execution, <abbr|etc.> The
  stylesheet language also provides a special <markup|extern> tag which
  offers you the full power of the <scheme> extension language in order to
  write macros.

  It should be noticed that user-defined macros have two aspects. On the one
  hand they usually perform simple rewritings. For instance, the macro

  <\tm-fragment>
    <inactive*|<assign|seq|<macro|var|from|to|<active*|<math|<inactive*|<arg|var>><rsub|<inactive*|<arg|from>>>,\<ldots\>,<inactive*|<arg|var>><rsub|<inactive*|<arg|to>>>>>>>>
  </tm-fragment>

  is a shortcut in order to produce sequences like
  <math|a<rsub|1>,\<ldots\>,a<rsub|n>>. When macros perform simple rewritings
  like in this example, the children <src-arg|var>, <src-arg|from> and
  <src-arg|to> of the <markup|seq> tag remain <em|accessible> from within the
  editor. In other words, you can position the cursor inside them and modify
  them. User defined macros also have a synthetic or computational aspect.
  For instance, the dots of a <markup|seq> tag as above cannot be edited by
  the user. Similarly, the macro

  <\tm-fragment>
    <inactive*|<assign|square|<macro|x|<times|<arg|x>|<arg|x>>>>>
  </tm-fragment>

  serves an exclusively computational purpose. As a general rule, synthetic
  macros are sometimes easier to write, but the more accessibility is
  preserved, the more natural it becomes for the user to edit the markup.

  It should be noticed that <TeXmacs> also produces some auxiliary data as a
  byproduct of the typesetting product. For instance, the correct values of
  references and page numbers, as well as tables of contents, indexes,
  <abbr|etc.> are determined during the typesetting stage and memorized at a
  special place. Even though auxiliary data may be determined automatically
  from the document, it may be expensive to do so (one typically has to
  retypeset the document). When the auxiliary data are computed by an
  external plug-in, then it may even be impossible to perform the
  recomputations on certain systems. For these reasons, auxiliary data are
  carefully memorized and stored on disk when you save your work.

  <subsection|Data relation descriptions><label|sec-tm-drd>

  <paragraph*|The rationale behind <abbr|D.R.D.>s>

  One major advantage of <TeXmacs> is that the editor uses general trees as
  its data format. Like for <no-break>XML, this choice has the advantages of
  being simple to understand and making documents easy to manipulate by
  generic tools. However, when using the editor for a particular purpose, the
  data format usually needs to be restricted to a subset of the set of all
  possible trees.

  In XML, one uses Data Type Definitions (<abbr|D.T.D.>s) in order to
  formally specify a subset of the generic XML format. Such a <abbr|D.T.D.>
  specifies when a given document is valid for a particular purpose. For
  instance, one has <abbr|D.T.D.>s for documents on the web (<name|XHTML>),
  for mathematics <no-break>(<name|MathML>), for two-dimensional graphics
  (<name|SVG>) and so on. Moreover, up to a certain extent, XML provides
  mechanisms for combining such <abbr|D.T.D.>s. Finally, a precise
  description of a <abbr|D.T.D.> usually also provides some kind of reference
  manual for documents of a certain type.

  In <TeXmacs>, we have started to go one step further than <abbr|D.T.D.>s:
  besides being able to decide whether a given document is valid or not, it
  is also very useful to formally describe certain properties of the
  document. For instance, in an interactive editor, the numerator of a
  fraction may typically be edited by the user (we say that it is
  <em|accessible>), whereas the URL of a hyperlink is only editable on
  request. Similarly, certain primitives like <markup|itemize> correspond to
  block content, whereas other primitives like <markup|sqrt> correspond to
  inline content. Finally, certain groups of primitives, like
  <markup|chapter>, <markup|section>, <markup|subsection>, <abbr|etc.> behave
  similarly under certain operations, like conversions.

  A Data Relation Description (<abbr|D.R.D.>) consists of a Data Type
  Definition, together with additional logical properties of tags or document
  fragments. These logical properties are stated using so called <em|Horn
  clauses>, which are also used in logical programming languages such as
  Prolog. Contrary to logical programming languages, it should nevertheless
  be relatively straightforward to determine the properties of tags or
  document fragments, so that certain database techniques can be used for
  efficient implementations. At the moment, we only started to implement this
  technology (and we are still using lots of C++ hacks instead of what has
  been said above), so a more complete formal description of <abbr|D.R.D.>s
  will only be given at a later stage.

  One major advantage of the use of <abbr|D.R.D.>s is that it is not
  necessary to establish rigid hierarchies of object classes like in object
  oriented programming. This is particularly useful in our context, since
  properties like accessibility, inline-ness, <abbr|etc.> are quite
  independent one from another. In fact, where <abbr|D.T.D.>s may be good
  enough for the description of passive documents, more fine-grained
  properties are often useful when manipulating documents in a more
  interactive way.

  <paragraph*|Current <abbr|D.R.D.> properties and applications>

  Currently, the <abbr|D.R.D.> of a document contains the following
  information:

  <\itemize>
    <item>The possible arities of a tag.

    <item>The accessibility of a tag and its children.
  </itemize>

  In the near future, the following properties will be added:

  <\itemize>
    <item>Inline-ness of a tag and its children.

    <item>Tabular-ness of a tag and its children.

    <item>Purpose of a tag and its children.
  </itemize>

  The above information is used (among others) for the following
  applications:

  <\itemize>
    <item>Natural default behaviour when creating/deleting tags or children
    (automatic insertion of missing arguments and removal of tags with too
    little children).

    <item>Only traverse accessible nodes during searches, spell-checking,
    <abbr|etc.>

    <item>Automatic insertion of <markup|document> or <markup|table> tags
    when creating block or tabular environments.

    <item>Syntactic highlighting in source mode as a function of the purpose
    of tags and arguments.
  </itemize>

  <paragraph*|Determination of the <abbr|D.R.D.> of a document>

  <TeXmacs> associate a unique <abbr|D.R.D.> to each document. This
  <abbr|D.R.D.> is determined in two stages. First of all, <TeXmacs> tries to
  heuristically determine <abbr|D.R.D.> properties of user-defined tags, or
  tags which are defined in style files. For instance, when the user defines
  a tag like

  <\tm-fragment>
    <inactive*|<assign|hi|<macro|name|Hello <arg|name>!>>>
  </tm-fragment>

  <TeXmacs> automatically notices that <markup|hi> is a macro with one
  element, so it considers <math|1> to be the only possible arity of the
  <markup|hi> tag. Notice that the heuristic determination of the
  <abbr|D.R.D.> is done interactively: when defining a macro inside your
  document, its properties will automatically be put into the <abbr|D.R.D.>
  (assuming that you give <TeXmacs> a small amount of free time of the order
  of a second; this minor delay is used to avoid compromising the reactivity
  of the editor).

  Sometimes the heuristically defined properties are inadequate. For this
  case, <TeXmacs> provides the <markup|drd-props> tag in order to manually
  override the default properties.

  <subsection|<TeXmacs> lengths><label|sec-lengths>

  A simple <TeXmacs> length is a number followed by a length unit, like
  <verbatim|1cm> or <verbatim|1.5mm>. <TeXmacs> supports three main types of
  units:

  <\description>
    <item*|Absolute units>The length of an absolute unit like <verbatim|cm>
    or <verbatim|pt> on print is fixed.

    <item*|Context dependent units>Context-dependent length units depend on
    the current font or other environment variables. For instance,
    <verbatim|1ex> corresponds to the height of the \Px\Q character in the
    current font and <verbatim|1par> correspond to the current paragraph
    width.

    <item*|User defined units>Any nullary macro, whose name contains only
    lower case roman letters followed by <verbatim|-length>, and which
    returns a length, can be used as a unit itself. For instance, the
    following macro defines the <verbatim|dm> length:

    <\tm-fragment>
      <inactive*|<assign|dm-length|<macro|10cm>>>
    </tm-fragment>
  </description>

  Furthermore, length units can be <em|stretchable>. A stretchable length is
  represented by a triple of rigid lengths: a minimal length, a default
  length and a maximal length. When justifying lines or pages, stretchable
  lengths are automatically sized so as to produce nicely looking layout.

  In the case of page breaking, the <src-var|page-flexibility> environment
  provides additional control over the stretchability of white space. When
  setting the <src-var|page-flexibility> to <math|1>, stretchable spaces
  behave as usual. When setting the <src-var|page-flexibility> to <math|0>,
  stretchable spaces become rigid. For other values, the behaviour is linear.

  <paragraph*|Absolute length units>

  <\description>
    <item*|<code*|cm>>One centimeter.

    <item*|<code*|mm>>One millimeter.

    <item*|<code*|in>>One inch.

    <item*|<code*|pt>>The standard typographic point corresponds to
    <math|1/72.27> of an inch.

    <item*|<verbatim|bp>>A big point corresponds to <math|1/72> of an inch.

    <item*|<verbatim|dd>>The Didôt point equals 1/72 of a French inch,
    <abbr|i.e.> <verbatim|0.376mm>.

    <item*|<verbatim|pc>>One \Ppica\Q equals 12 points.

    <item*|<verbatim|cc>>One \Pcicero\Q equals 12 Didôt points.
  </description>

  <paragraph*|Rigid font-dependent length units>

  <\description>
    <item*|<verbatim|fs>>The font size. When using a <verbatim|12pt> font,
    <verbatim|1fs> corresponds to <verbatim|12pt>.

    <item*|<verbatim|fbs>>The base font size. Typically, when selecting
    <verbatim|10> as the font size for your document and when typing large
    text, the base font size is <verbatim|10pt> and the font size
    <verbatim|12pt>.

    <item*|<code*|ln>>The width of a nicely looking fraction bar for the
    current font.

    <item*|<code*|sep>>A typical separation between text and graphics for the
    current font, so as to keep the text readable. For instance, the
    numerator in a fraction is shifted up by <verbatim|1sep>.

    <item*|<verbatim|yfrac>>The height of the fraction bar for the current
    font (approximately <verbatim|0.5ex>).

    <item*|<verbatim|ex>>The height of the \Px\Q character in the current
    font.

    <item*|<verbatim|emunit>>The width of the \PM\Q character in the current
    font.
  </description>

  <paragraph*|Stretchable font-dependent length units>

  <\description>
    <item*|<code*|fn>>This is a stretchable variant of <verbatim|1quad>. The
    default length of <verbatim|1fn> is <verbatim|1quad>. When stretched,
    <verbatim|1fn> may be reduced to <verbatim|0.5fn> and extended to
    <verbatim|1.5fn>.

    <item*|<verbatim|fns>>This length defaults to zero, but it may be
    stretched up till <verbatim|1fn>.

    <item*|<verbatim|bls>>The \Pbase line skip\Q is the sum of
    <verbatim|1quad> and <src-var|par-sep>. It corresponds to the distance
    between successive lines of normal text.

    Typically, the baselines of successive lines are separated by a distance
    of <verbatim|1fn> (in <TeXmacs> and <LaTeX> a slightly larger space is
    used though so as to allow for subscripts and superscripts and avoid a
    too densely looking text. When stretched, <verbatim|1fn> may be reduced
    to <verbatim|0.5fn> and extended to <verbatim|1.5fn>.

    <item*|<code*|spc>>The (stretchable) width of space character in the
    current font.

    <item*|<verbatim|xspc>>The additional (stretchable) width of a space
    character after a period.
  </description>

  <paragraph*|Box lengths><label|box-lengths>

  Box length units can only be used within some special markup elements, such
  as <markup|move>, <markup|shift>, <markup|resize>, <markup|clipped> and
  <markup|image>. The principal body of this content (<abbr|e.g.> the content
  being \Pmoved\Q in the case of <markup|move>) is typeset as a box. The
  following lengths units then correspond to the size and the extents of the
  box.

  <\description>
    <item*|<code*|w>>The width of the box.

    <item*|<verbatim|h>>The height of the box.

    <item*|<code*|l>>The logical left <math|x>-coordinate of the box.

    <item*|<code*|r>>The logical right <math|x>-coordinate of the box.

    <item*|<code*|b>>The logical bottom <math|y>-coordinate of the box.

    <item*|<code*|t>>The logical top <math|y>-coordinate of the box.
  </description>

  For instance, the code

  <\tm-fragment>
    <inactive*|<move|Hello there||<plus|-0.5b|-0.5t>>>
  </tm-fragment>

  can be used to center <move|Hello there||<plus|-0.5b|-0.5t>> at the
  base-line.

  <paragraph*|Other length units>

  <\description>
    <item*|<code*|par>>The width of the paragraph. That is the length the
    text can span. It is affected by paper size, margins, number of columns,
    column separation, cell width (if in a table), <abbr|etc.>

    <item*|<verbatim|pag>>The height of the main text in a page. In a similar
    way as <verbatim|par>, this length unit is affected by page size,
    margins, <abbr|etc.>

    <item*|<code*|px>>One screen pixel, the meaning of this unit is affected
    by the shrinking factor.

    <item*|<code*|tmpt>>The smallest length unit for internal length
    calculations by <TeXmacs>. <verbatim|1px> divided by the shrinking factor
    corresponds to <verbatim|256tmpt>.
  </description>

  <paragraph*|Different ways to specify lengths>

  There are three types of lengths in <TeXmacs>:

  <\description>
    <item*|Simple lengths>A string consisting of a number followed by a
    length unit.

    <item*|Abstract lengths>An abstract length is a macro which evaluates to
    a length. Such lengths have the advantage that they may depend on the
    context.

    <item*|Normalized lengths>All lengths are ultimately converted into a
    normalized length, which is a tag of the form <explain-macro|tmlen|l>
    (for rigid lengths) or <explain-macro|tmlen|min|def|max> (for stretchable
    lengths). The user may also use this tag in order to specify stretchable
    lengths. For instance, <inactive*|<tmlen|<minus|1quad|1pt>|1quad|1.5quad>>
    evaluates to a length which is <verbatim|1quad> by default, at least
    <verbatim|1quad-1pt> and at most <verbatim|1.5quad>.
  </description>

  <subsection|Intern representation of texts>

  <TeXmacs> represents all texts by trees (for a fixed text, the
  corresponding tree is called the <em|edit tree>). The nodes of such a tree
  are labeled by standard <em|operators> which are listed in
  <verbatim|Basic/Data/tree.hpp> and <verbatim|Basic/Data/tree.cpp>. The
  labels of the leaves of the tree are strings, which are either invisible
  (such as lengths or macro definitions), or visible (the real text).

  The meaning of the text and the way it is typeset essentially depend on the
  current environment. The environment mainly consists of a relative hash
  table of type <verbatim|rel_hashmap\<less\>string,tree\<gtr\>>, i.e. a
  mapping from the environment variables to their tree values. The current
  language and the current font are examples of system environment variables;
  new variables can be defined by the user.

  <subsection|Text>

  All text strings in <TeXmacs> consist of sequences of either specific or
  universal symbols. A specific symbol is a character, different from
  <verbatim|'\\0'>, <verbatim|'\<less\>'> and <verbatim|'\<gtr\>'>. Its
  meaning may depend on the particular font which is being used. A universal
  symbol is a string starting with <verbatim|'\<less\>'>, followed by an
  arbitrary sequence of characters different from <verbatim|'\\0'>,
  <verbatim|'\<less\>'> and <verbatim|'\<gtr\>'>, and ending with
  <verbatim|'\<gtr\>'>. The meaning of universal characters does not depend
  on the particular font which is used, but different fonts may render them
  in a different way.

  <subsection|The language>

  The language of the text is capable performing a further semantic analysis
  of a text phrase. At least, it is capable of splitting a phrase up into
  <em|words> (which are smaller phrases) and inform the typesetter about the
  desired spaces between words and hyphenation information. In the future,
  additional semantics may be added into languages. For instance, spell
  checkers might be implemented for natural languages and parsers for
  mathematical formulas or programming languages.

  <section|Boxes>

  The <TeXmacs> typesetter essentially translates a document represented by a
  tree into a graphical box, which can either be displayed on a graphics
  device (e.g. the screen or a PDF file). Contrary to a system like <LaTeX>,
  the graphical box actually contains much more information than is necessary
  for a graphical rendering. Roughly speaking, this information can be
  subdivided into the following categories:

  <\itemize>
    <item>Logical and physical bounding boxes.

    <item>A method for graphical rendering.

    <item>Miscellaneous typesetting information.

    <item>Keeping track of the source subtree which led to the box.

    <item>Computing the positions of cursors and selections.

    <item>Event handlers for dynamic content.
  </itemize>

  The logical bounding box is used by the typesetter to position the box with
  respect to other boxes. A certain amount of other information, such as the
  slant of the box, is also stored for the typesetter. The physical bounding
  box encloses the graphical representation of the box. This knowledge is
  needed when partially redrawing a box in an efficient way.

  In order to position the cursor or when making a selection, it is necessary
  to have a correspondence between logical positions in the source tree and
  physical positions in the typeset boxes. More precisely, boxes and their
  subboxes are logically organized as a tree. Boxes provide routines to
  translate between paths in the box tree and the source tree and to find the
  path which is associated to a graphical point.

  Notice also that, besides a horizontal and vertical position, the physical
  cursor also contains an infinitesimal horizontal position. Roughly
  speaking, this infinitesimal coordinate is used to give certain boxes (such
  as color changes) an extra infinitesimal width.

  \;

  The abstract <cpp|box_rep> class is defined in
  <tm-path|src/Typeset/boxes.hpp>:

  <\cpp-code>
    class box_rep: public abstract_struct {

    private:

    \ \ SI x0, y0; \ \ \ // offset w.r.t. parent box

    \;

    public:

    \ \ SI x1, y1; \ \ \ // under left corner (logical)

    \ \ SI x2, y2; \ \ \ // upper right corner (logical)

    \ \ SI x3, y3; \ \ \ // under left corner (ink)

    \ \ SI x4, y4; \ \ \ // upper right corner (ink)

    \;

    \ \ path ip; \ \ \ \ \ // corresponding inverse path in source tree

    \ \ 

    \ \ // [methods not shown]

    }
  </cpp-code>

  Coordinates are expressed in the standard internal graphic unit <cpp|SI>
  which is essentially a fixed float with <cpp|PIXEL> being the unit size and
  set to <cpp|256> (in <tm-path|src/Graphics/rendered.hpp>). Cartesian
  coordinates are relative to a standard frame oriented as in elementary
  geometry, i.e. the x-axis from left to right and the y-axis from bottom to
  top.\ 

  <center|<with|gr-mode|<tuple|edit|text-at>|gr-frame|<tuple|scale|1.00002cm|<tuple|0.5gw|0.629973gh>>|gr-geometry|<tuple|geometry|0.600003par|0.333336par|center>|gr-grid|<tuple|empty>|gr-grid-old|<tuple|cartesian|<point|0|0>|1>|gr-edit-grid-aspect|<tuple|<tuple|axes|none>|<tuple|1|none>|<tuple|10|none>>|gr-edit-grid|<tuple|empty>|gr-edit-grid-old|<tuple|cartesian|<point|0|0>|1>|gr-color|darker
  grey|gr-transformation|<tuple|<tuple|1.0|0.0|0.0|0.0>|<tuple|0.0|0.283662185463224|0.95892427466314|0.0>|<tuple|0.0|-0.95892427466314|0.283662185463224|0.0>|<tuple|0.0|0.0|0.0|1.0>>|gr-dash-style|10|<graphics||<with|color|darker
  grey|dash-style|10|<line|<point|1|-1.6>|<point|1.0|-2.5>>>|<with|color|darker
  grey|dash-style|10|<line|<point|-1|-1.6>|<point|-3.0|-1.6>>>|<with|color|darker
  grey|dash-style|10|<line|<point|-1|-1.6>|<point|-1.0|-2.5625>>>|<with|color|darker
  grey|dash-style|10|<line|<point|-3|-2>|<point|-2.0|-2.0>>>|<with|color|darker
  grey|dash-style|10|<line|<point|-1|0.4>|<point|-3.0|0.4>>>|<with|color|darker
  grey|dash-style|10|<line|<point|2|-2>|<point|2.0|-2.5>>>|<with|color|#aaf|dash-style|10|line-width|2ln|<line|<point|-2|1>|<point|2.0|1.0>|<point|2.0|-2.0>|<point|-2.0|-2.0>|<point|-2.0|1.0>>>|<with|color|#aaf|dash-style|11100|line-width|2ln|<line|<point|-1|0.4>|<point|1.0|0.4>|<point|1.0|-1.6>|<point|-1.0|-1.6>|<point|-1.0|0.4>>>|<with|color|darker
  grey|dash-style|10|<line|<point|-2|-2>|<point|-2.0|-2.6>>>|<point|-2|-2>|<point|-2|1>|<point|2|1>|<point|2|-2>|<point|-1|-1.6>|<point|-1|0.4>|<point|1|0.4>|<point|1|-1.6>|<with|color|darker
  grey|dash-style|10|<line|<point|-3|1>|<point|-2.0|1.0>>>|<with|arrow-end|\<gtr\>|<line|<point|-4.0|-2.6>|<point|4.0|-2.5>>>|<with|arrow-end|\<gtr\>|<line|<point|-3|-2.6>|<point|-3.0|1.7>>>|<with|color|darker
  grey|<math-at|x1|<point|-2.0|-3.0>>>|<with|color|darker
  grey|<math-at|y1|<point|-3.5|-2.0>>>|<with|color|darker
  grey|<math-at|x3|<point|-1.0|-3.0>>>|<with|color|darker
  grey|<math-at|x4|<point|1.0|-3.0>>>|<with|color|darker
  grey|<math-at|x2|<point|2.0|-3.0>>>|<with|color|darker
  grey|<math-at|y3|<point|-3.5|-1.6>>>|<with|color|darker
  grey|<math-at|y4|<point|-3.5|0.4>>>|<with|color|darker
  grey|<math-at|y2|<point|-3.5|1.0>>>|<with|color|darker grey|<text-at|ink
  box|<point|-0.3|0.0>>>|<with|color|darker grey|<text-at|logical
  box|<point|0.2|0.6>>>>>>

  The field <cpp|ip> represents an <with|font-shape|italic|inverse path>
  needed to relate the box to the piece of document from which it originates.

  <subsection|The correspondence between a box and its source>

  In order to implement the correspondence between paths in the source tree
  and the box tree, one has to face several simultaneous difficulties:

  <\enumerate>
    <item>Due to line breaking, footnotes and macro expansions, the
    correspondence may be non straightforward.

    <item>The correspondence has to be reasonably time and space efficient.

    <item>Some boxes, such header and footers, or certain results of macro
    expansions, may not be \Paccessible\Q. Although one should be able to
    find a reasonable cursor position when clicking on them, the contents of
    this box can not be edited directly.

    <item>The correspondence has to be reasonably complete (see the next
    section).
  </enumerate>

  The first difficulty forces us to store a path in the source tree along
  with any box (in the <cpp|box_rep::ip> field). In order to save storage,
  this path is stored in a reversed manner, so that common heads can be
  shared. This common head sharing is also necessary to quickly change the
  source locations when modifying the source tree, for instance by inserting
  a new paragraph.

  In order to cope with the third difficulty, the inverse path may start with
  a negative number, which indicates that the box can not directly be edited
  (we also say that the box is a <with|font-shape|italic|decoration>). From
  <tm-path|src/Typeset/boxes.hpp>:

  <\cpp-code>
    #define DECORATION \ \ \ \ \ \ \ (-1)

    #define DECORATION_LEFT \ \ \ (-2)

    #define DECORATION_MIDDLE \ (-3)

    #define DECORATION_RIGHT \ \ (-4)

    #define DETACHED \ \ \ \ \ \ \ \ \ (-5)
  </cpp-code>

  In this case, the tail of the inverse path corresponds to a location in the
  source tree, where the cursor should be positioned when clicking on the
  box. The negative number influences the way in which this is done.

  <subsection|The three kinds of paths>

  More precisely, we have to deal with three kinds of paths:

  <\description>
    <item*|Tree paths>These paths correspond to paths in the source tree.
    Actually, the path minus its last item points to a subtree of the source
    tree. The last item gives a position in this subtree: if the subtree is a
    leaf, i.e. a string, it is a position in this string. Otherwise a zero
    indicates a position before the subtree and a one a position after the
    subtree.

    <item*|Inverse paths>These are just reverted tree paths (with shared
    tails), with an optional negative head. A negative head indicates that
    the tree path is not accessible, i.e. the corresponding subtree does not
    correspond to editable content. If the negative value is <math|-2>,
    <math|-3> or <hgroup|<math|-4>>, then a zero or one has to be put behind
    the tree path, depending on the value and the cursor position.

    <item*|Box paths>These paths correspond to logical paths in the box tree.
    Again, the path minus its last item points to a subbox of the main box,
    and the last item gives a position in this subtree: if the subbox
    corresponds to a text box it is a position in this text. Otherwise a zero
    indicates a position before the subbox and a one a position after it. In
    the case of side boxes, a two and a three may also indicate the position
    after the left script <abbr|resp.> before the right script.
  </description>

  In order to implement the conversion between the three kinds of paths,
  every box comes with a reference inverse path <verbatim|ip> in the source
  tree. Composite boxes also come with a left and a right inverse path
  <verbatim|lip> <abbr|resp.> <verbatim|rip>, which correspond to the
  left-most and right-most accessible paths in its subboxes (if there are
  such subboxes).

  The routine:

  <\cpp-code>
    \ \ \ \ virtual path box_rep::find_tree_path (path bp);
  </cpp-code>

  transforms a box path into a tree path. This routine (which only uses
  <verbatim|ip>) is fast and has a linear time complexity as a function of
  the lengths of the paths.\ 

  The routine:\ 

  <\cpp-code>
    \ \ \ \ virtual path box_rep::find_box_path (path p);
  </cpp-code>

  does the inverse conversion. Unfortunately, in the worst case, it may be
  necessary to search for the matching tree path in all subboxes.
  Nevertheless, in the best case, a dichotomic algorithm (which uses
  <verbatim|lip> and <verbatim|rip>), finds the right branch how to descend
  in a logarithmic time. This algorithm also has a quadratic time complexity
  as a function of the lengths of the paths, because we frequently need to
  revert paths.

  <subsection|The cursor and selections>

  In order to fulfill the requirement of being a \Pstructured editor\Q,
  <TeXmacs> needs to provide a (reasonably) complete correspondence between
  logical tree paths and physical cursor positions. This yields an additional
  difficulty in the case of \Penvironment changes\Q, such as a change in font
  or color. Indeed, when you are on the border of such a change, it is not
  clear <with|font-shape|italic|a priori> which environment you are in.

  In <TeXmacs>, the cursor position therefore contains an <math|x> and a
  <math|y> coordinate, as well as an additional infinitesimal
  <math|x>-coordinate, called <math|\<delta\>>. A change in environment is
  then represented by a box with an infinitesimal width. Although the
  <math|\<delta\>>-position of the cursor is always zero when you select
  using the mouse, it may be non zero when moving around using the cursor
  keys. The linear time routine:

  <\cpp-code>
    \ \ \ \ virtual path box_rep::find_box_path (SI x, SI y, SI delta);
  </cpp-code>

  as a function of the length of the path searches the box path which
  corresponds to a cursor position. Inversely, the routine:\ 

  <\cpp-code>
    \ \ \ \ virtual cursor box_rep::find_cursor (box bp);
  </cpp-code>

  yields a graphical representation for the cursor at a certain box path. The
  cursor is given by its <math|x>, <math|y> and <math|\<delta\>> coordinates
  and a line segment relative to this origin, given by its extremities
  <math|<around|(|x<rsub|1>,y<rsub|1>|)>> and
  <math|<around|(|x<rsub|2>,y<rsub|2>|)>>. From
  <tm-path|src/Typeset/boxes.hpp>:

  <\cpp-code>
    struct cursor_rep: concrete_struct {

    \ \ SI ox, oy; \ \ \ // main cursor position

    \ \ SI delta; \ \ \ \ // infinitesimal shift to the right

    \ \ SI y1; \ \ \ \ \ \ \ // under base line

    \ \ SI y2; \ \ \ \ \ \ \ // upper base line

    \ \ double slope; // slope of cursor

    \ \ bool valid; \ \ // the cursor is valid

    };
  </cpp-code>

  The default implementation of the <cpp|find_cursor> method is:

  <\cpp-code>
    cursor

    box_rep::find_cursor (path bp) {

    \ \ bool flag= bp == path (0);

    \ \ double slope= flag? left_slope (): right_slope ();

    \ \ cursor cu (flag? x1: x2, 0);

    \ \ cu-\<gtr\>y1= y1; cu-\<gtr\>y2= y2;

    \ \ cu-\<gtr\>slope= slope;

    \ \ return cu;

    }
  </cpp-code>

  In a similar way, the routine:\ 

  <\cpp-code>
    \ \ \ \ virtual selection box_rep::find_selection (box lbp, box rbp);
  </cpp-code>

  computes the selection between two given box paths. This selection
  comprises two delimiting tree paths and a graphical representation in the
  form of a list of rectangles.

  <\cpp-code>
    struct selection_rep: concrete_struct {

    \ \ rectangles rs;

    \ \ path start;

    \ \ path end;

    \ \ bool valid;

    };
  </cpp-code>

  The default implementation of <cpp|find_selection> reads:

  <\cpp-code>
    selection

    box_rep::find_selection (path lbp, path rbp) {

    \ \ if (lbp == rbp)

    \ \ \ \ return selection (rectangles (),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ find_tree_path (lbp),
    find_tree_path (rbp));

    \ \ else

    \ \ \ \ return selection (rectangle (x1, y1, x2, y2),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ find_tree_path (path (0)),
    find_tree_path (path (1)));

    }
  </cpp-code>

  <section|The low levels>

  A typical stack trace with a breakpoint in the low-level typesetting
  routines (in this case <cpp|sqrt_box>) looks like:

  <\verbatim-code>
    #0 0x000000010317b254 in sqrt_box(list\<less\>int\<gtr\>, box, box, box,
    font, pencil)\ 

    #1 0x0000000103270ee4 in concater_rep::typeset_sqrt(tree,
    list\<less\>int\<gtr\>)\ 

    #2 0x00000001032a73b4 in concater_rep::typeset(tree,
    list\<less\>int\<gtr\>)\ 

    #3 0x00000001032a9330 in typeset_concat(edit_env, tree,
    list\<less\>int\<gtr\>)\ 

    #4 0x000000010337c5c4 in typeset_concat_or_table(edit_env, tree,
    list\<less\>int\<gtr\>)\ 

    #5 0x000000010337d6ec in typeset_stack(edit_env, tree,
    list\<less\>int\<gtr\>, array\<less\>line_item\<gtr\>,
    array\<less\>line_item\<gtr\>, stack_border&)\ 

    #6 0x0000000103215ac4 in typesetter_rep::insert_paragraph(tree,
    list\<less\>int\<gtr\>)\ 

    #7 0x00000001031ccd78 in bridge_rep::my_typeset(int)\ 

    #8 0x00000001031cd6d4 in bridge_rep::typeset(int)\ 

    #9 0x00000001031e9f98 in bridge_document_rep::my_typeset(int)\ 

    #10 0x00000001031cd6d4 in bridge_rep::typeset(int)\ 

    #11 0x00000001031d317c in bridge_argument_rep::my_typeset(int)\ 

    #12 0x00000001031cd6d4 in bridge_rep::typeset(int)\ 

    #13 0x0000000103212430 in bridge_surround_rep::my_typeset(int)\ 

    #14 0x00000001031cd6d4 in bridge_rep::typeset(int)\ 

    #15 0x00000001031e9f98 in bridge_document_rep::my_typeset(int)\ 

    #16 0x00000001031cd6d4 in bridge_rep::typeset(int)\ 

    #17 0x0000000103214cf8 in bridge_with_rep::my_typeset(int)\ 

    #18 0x00000001031cd6d4 in bridge_rep::typeset(int)\ 

    #19 0x00000001031e2298 in bridge_compound_rep::my_typeset(int)\ 

    #20 0x00000001031cd6d4 in bridge_rep::typeset(int)\ 

    #21 0x00000001031e9f98 in bridge_document_rep::my_typeset(int)\ 

    #22 0x00000001031cd6d4 in bridge_rep::typeset(int)

    #23 0x0000000103217e80 in typesetter_rep::typeset()\ 

    #24 0x0000000103218370 in typesetter_rep::typeset(int&, int&, int&, int&)\ 

    #25 0x000000010321a9e8 in typeset(typesetter_rep*, int&, int&, int&,
    int&)\ 

    #26 0x0000000102db9954 in edit_typeset_rep::typeset_sub(int&, int&, int&,
    int&)\ 

    #27 0x0000000102db9df8 in edit_typeset_rep::typeset(int&, int&, int&,
    int&)\ 

    #28 0x0000000102df6694 in edit_interface_rep::apply_changes()\ 

    #29 0x000000010311c1e0 in tm_server_rep::interpose_handler()\ 

    #30 0x0000000103023540 in qt_gui_rep::update()\ 
  </verbatim-code>

  This gives a good idea how we go from the main entry points relative to the
  <cpp|typesetter> class, to the low lever routines which produce the actual
  boxes. In the intermediate steps of the computation an important role is
  played by the <cpp|bridge> object.

  <\cpp-code>
    class typesetter_rep {

    public:

    \ \ edit_env& \ \ \ env;

    \ \ bridge \ \ \ \ \ \ br;

    \ \ rectangles \ \ change_log;

    \ \ array\<less\>brush\<gtr\> old_bgs;

    \;

    \ \ array\<less\>page_item\<gtr\> l; \ \ \ \ \ // current lines

    \ \ stack_border \ \ \ \ sb; \ \ \ \ // border properties

    \ \ array\<less\>line_item\<gtr\> a; \ \ \ \ \ // left surroundings

    \ \ array\<less\>line_item\<gtr\> b; \ \ \ \ \ // right surroundings

    \;

    \ \ SI x1, y1, x2, y2;

    \ \ hashmap\<less\>string,tree\<gtr\> old_patch;

    \ \ bool paper;

    \;

    public:

    \ \ typesetter_rep (edit_env& env, tree et, path ip);

    \;

    \ \ void insert_stack \ \ \ \ (array\<less\>page_item\<gtr\> l,
    stack_border sb);

    \ \ void insert_parunit \ \ (tree t, path ip);

    \ \ void insert_paragraph (tree t, path ip);

    \ \ void insert_surround \ (array\<less\>line_item\<gtr\> a,
    array\<less\>line_item\<gtr\> b);

    \ \ void insert_marker \ \ \ (tree st, path ip);

    \;

    \ \ void local_start \ \ (array\<less\>page_item\<gtr\>& l, stack_border&
    sb);

    \ \ void local_end \ \ \ \ (array\<less\>page_item\<gtr\>& l,
    stack_border& sb);

    \;

    \ \ void determine_page_references (box b);

    \ \ box \ typeset ();

    \ \ box \ typeset (SI& x1, SI& y1, SI& x2, SI& y2);

    };
  </cpp-code>

  \;

  In the normal operation of the GUI the typesetting starts at
  <cpp|typesetter_rep::typeset(int&, int&, int&, int&)>:\ 

  <\cpp-code>
    box

    typesetter_rep::typeset (SI& x1b, SI& y1b, SI& x2b, SI& y2b) {

    \ \ x1= x1b; y1= y1b; x2=x2b; y2= y2b;

    \ \ box b= typeset ();

    \ \ // cout \<less\>\<less\> "-------------------------------------------------------------\\n";

    \ \ b-\<gtr\>position_at (0, 0, change_log);

    \ \ change_log= requires_update (change_log);

    \ \ rectangle r (0, 0, 0, 0);

    \ \ if (!is_nil (change_log)) r= least_upper_bound (change_log);

    \ \ array\<less\>brush\<gtr\> new_bgs;

    \ \ array\<less\>rectangle\<gtr\> rs;

    \ \ b-\<gtr\>collect_page_colors (new_bgs, rs);

    \ \ for (int i=0; i\<less\>min(N(old_bgs), N(new_bgs)); i++)

    \ \ \ \ if (new_bgs[i] != old_bgs[i])

    \ \ \ \ \ \ r= least_upper_bound (r, rs[i]);

    \ \ old_bgs= new_bgs;

    \ \ x1b= r-\<gtr\>x1; y1b= r-\<gtr\>y1; x2b= r-\<gtr\>x2; y2b=
    r-\<gtr\>y2;

    \ \ change_log= rectangles ();

    \ \ return b;

    }
  </cpp-code>

  which does some administrative work setting the view boundaries requested
  by the editor and, when the typesetting is done, performing some accesory
  computations to determine the new changed region due to changes in the
  background color of the pages and propagating it up via the reference
  arguments. The production of the boxes is the job of
  <cpp|typesetter_rep::typeset()>:\ 

  <\cpp-code>
    box

    typesetter_rep::typeset () {

    \ \ old_patch= hashmap\<less\>string,tree\<gtr\> (UNINIT);

    \ \ l \ \ \ \ \ \ \ = array\<less\>page_item\<gtr\> ();

    \ \ sb \ \ \ \ \ \ = stack_border ();

    \ \ a \ \ \ \ \ \ \ = array\<less\>line_item\<gtr\> ();

    \ \ b \ \ \ \ \ \ \ = array\<less\>line_item\<gtr\> ();

    \ \ paper \ \ \ = (env-\<gtr\>get_string (PAGE_MEDIUM) == "paper");

    \;

    \ \ // Test whether we are doing a complete typesetting

    \ \ env-\<gtr\>complete= br-\<gtr\>my_typeset_will_be_complete ();

    \ \ tree st= br-\<gtr\>st;

    \ \ int i= 0, n= N(st);

    \ \ if (is_compound (st[0], "show-preamble")) { i++; env-\<gtr\>complete=
    false; }

    \ \ if (is_compound (st[0], "hide-preamble")) i++;

    \ \ for (; i\<less\>n && env-\<gtr\>complete; i++) {

    \ \ \ \ if (is_compound (st[i], "hide-part")) env-\<gtr\>complete= false;

    \ \ \ \ if (!is_compound (st[i], "show-part")) break;

    \ \ }

    \;

    \ \ // Typeset

    \ \ if (env-\<gtr\>complete) {

    \ \ \ \ env-\<gtr\>local_aux= hashmap\<less\>string,tree\<gtr\> (UNINIT);

    \ \ \ \ env-\<gtr\>missing \ = hashmap\<less\>string,tree\<gtr\>
    (UNINIT);

    \ \ \ \ env-\<gtr\>redefined= array\<less\>tree\<gtr\> ();

    \ \ \ \ env-\<gtr\>touched \ = hashmap\<less\>string,bool\<gtr\> (false);

    \ \ }

    \ \ br-\<gtr\>typeset (PROCESSED+ WANTED_PARAGRAPH);

    \ \ pager ppp= tm_new\<less\>pager_rep\<gtr\> (br-\<gtr\>ip, env, l);

    \ \ box rb= ppp-\<gtr\>make_pages ();

    \ \ if (env-\<gtr\>complete && paper) determine_page_references (rb);

    \ \ tm_delete (ppp);

    \ \ // env-\<gtr\>complete= false; \ // moved to
    edit_typeset_rep::typeset

    \ \ return rb;

    }
  </cpp-code>

  Here we setup the typesetting environment and then ask the bridge <cpp|br>
  to start processing the document. The boxes so obtained require still to be
  laid out as a sequence of pages via a <cpp|pager> which will be illustrated
  later on.

  <subsection|The bridge>

  The bridge structure is receptive to changes \ in the document (via the
  observer pattern) and perform the necessary preparations for the
  typesetting and the typesetting itself of the subtree which it manages:\ 

  <\cpp-code>
    class bridge_rep: public abstract_struct {

    public:

    \ \ typesetter \ \ \ \ \ \ \ \ \ \ ttt; \ \ \ \ \ // the underlying
    typesetter

    \ \ edit_env& \ \ \ \ \ \ \ \ \ \ \ env; \ \ \ \ \ // the environment

    \ \ tree \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ st; \ \ \ \ \ \ // the present
    subtree

    \ \ path \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ip; \ \ \ \ \ \ // source
    location of the paragraph

    \ \ int \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ status; \ \ // status among
    above values

    \ \ hashmap\<less\>string,tree\<gtr\> changes; \ // changes in the
    environment

    \;

    \ \ array\<less\>page_item\<gtr\> \ \ \ \ l; \ \ \ \ \ \ \ // the
    typesetted lines of st

    \ \ stack_border \ \ \ \ \ \ \ \ sb; \ \ \ \ \ \ // border properties of
    l

    \ \ link_repository \ \ \ \ \ link_env; // loci and links declared inside
    bridge

    \;

    public:

    \ \ bridge_rep (typesetter ttt, tree st, path ip);

    \ \ inline virtual ~bridge_rep () {}

    \;

    \ \ virtual void notify_assign (path p, tree u) = 0;

    \ \ virtual void notify_insert (path p, tree u);

    \ \ virtual void notify_remove (path p, int nr);

    \ \ virtual void notify_split \ (path p);

    \ \ virtual void notify_join \ \ (path p);

    \ \ virtual bool notify_macro \ (int type, string var, int l, path p,
    tree u) = 0;

    \ \ virtual void notify_change () = 0;

    \;

    \ \ virtual void my_clean_links ();

    \ \ virtual void my_exec_until (path p);

    \ \ virtual bool my_typeset_will_be_complete ();

    \ \ virtual void my_typeset (int desired_status);

    \ \ virtual void exec_until (path p, bool skip_flag= false);

    \ \ void typeset (int desired_status);

    };
  </cpp-code>

  It is recursively created by parsing the document tree via
  <cpp|make_bridge> :

  <\cpp-code>
    bridge

    make_bridge (typesetter ttt, tree st, path ip) {

    \ \ // cout \<less\>\<less\> "Make bridge " \<less\>\<less\> st
    \<less\>\<less\> ", " \<less\>\<less\> ip \<less\>\<less\> LF;

    \ \ // cout \<less\>\<less\> "Preamble mode= " \<less\>\<less\>
    ttt-\<gtr\>env-\<gtr\>preamble \<less\>\<less\> LF;

    \ \ if (ttt-\<gtr\>env-\<gtr\>preamble)

    \ \ \ \ return make_inactive_bridge (ttt, st, ip);

    \ \ switch (L(st)) {

    \ \ case ERROR:

    \ \ \ \ return bridge_auto (ttt, st, ip, error_m, true);

    \ \ case DOCUMENT:

    \ \ \ \ return bridge_document (ttt, st, ip);

    \ \ case SURROUND:

    \ \ \ \ return bridge_surround (ttt, st, ip);

    \ \ case HIDDEN:

    \ \ \ \ return bridge_hidden (ttt, st, ip);

    \ \ case DATOMS:

    \ \ \ \ return bridge_formatting (ttt, st, ip, ATOM_DECORATIONS);

    \ \ case DLINES:

    \ \ \ \ return bridge_formatting (ttt, st, ip, LINE_DECORATIONS);

    \ \ case DPAGES:

    \ \ \ \ return bridge_formatting (ttt, st, ip, PAGE_DECORATIONS);

    \ \ case TFORMAT:

    \ \ \ \ return bridge_formatting (ttt, st, ip, CELL_FORMAT);

    \ \ case WITH:

    \ \ \ \ return bridge_with (ttt, st, ip);

    \ \ case COMPOUND:

    \ \ \ \ return bridge_compound (ttt, st, ip);

    \ \ case ARG:

    \ \ \ \ return bridge_argument (ttt, st, ip);

    \ \ case MAP_ARGS:

    \ \ \ \ // FIXME: we might want to merge bridge_rewrite and bridge_eval

    \ \ \ \ // 'map_args' should really be implemented using bridge_rewrite,

    \ \ \ \ // but bridge_eval leads to better locality of updates for
    'screens'

    \ \ \ \ return bridge_eval (ttt, st, ip);

    \ \ case MARK:

    \ \ case VAR_MARK:

    \ \ \ \ return bridge_mark (ttt, st, ip);

    \ \ case EXPAND_AS:

    \ \ \ \ return bridge_expand_as (ttt, st, ip);

    \ \ case EVAL:

    \ \ case QUASI:

    \ \ \ \ return bridge_eval (ttt, st, ip);

    \ \ case EXTERN:

    \ \ case VAR_INCLUDE:

    \ \ case WITH_PACKAGE:

    \ \ \ \ return bridge_rewrite (ttt, st, ip);

    \ \ case INCLUDE:

    \ \ \ \ return bridge_compound (ttt, st, ip);

    \ \ case STYLE_ONLY:

    \ \ case VAR_STYLE_ONLY:

    \ \ case ACTIVE:

    \ \ case VAR_ACTIVE:

    \ \ \ \ return bridge_compound (ttt, st, ip);

    \ \ case INACTIVE:

    \ \ \ \ return bridge_auto (ttt, st, ip, inactive_m, true);

    \ \ case VAR_INACTIVE:

    \ \ \ \ return bridge_auto (ttt, st, ip, var_inactive_m, true);

    \ \ case REWRITE_INACTIVE:

    \ \ \ \ return bridge_rewrite (ttt, st, ip);

    \ \ case LOCUS:

    \ \ \ \ return bridge_locus (ttt, st, ip);

    \ \ case HLINK:

    \ \ case ACTION:

    \ \ \ \ return bridge_compound (ttt, st, ip);

    \ \ case ANIM_STATIC:

    \ \ case ANIM_DYNAMIC:

    \ \ \ \ return bridge_eval (ttt, st, ip);

    \ \ case CANVAS:

    \ \ \ \ return bridge_canvas (ttt, st, ip);

    \ \ case ORNAMENT:

    \ \ \ \ return bridge_ornament (ttt, st, ip);

    \ \ case ART_BOX:

    \ \ \ \ return bridge_art_box (ttt, st, ip);

    \ \ default:

    \ \ \ \ if (L(st) \<less\> START_EXTENSIONS) return bridge_default (ttt,
    st, ip);

    \ \ \ \ else return bridge_compound (ttt, st, ip);

    \ \ }

    }
  </cpp-code>

  Default typesetting of the bridge is

  <\cpp-code>
    void

    bridge_rep::my_typeset (int desired_status) {

    \ \ if ((desired_status & WANTED_MASK) == WANTED_PARAGRAPH)

    \ \ \ \ ttt-\<gtr\>insert_paragraph (st, ip);

    \ \ if ((desired_status & WANTED_MASK) == WANTED_PARUNIT)

    \ \ \ \ ttt-\<gtr\>insert_parunit (st, ip);

    }
  </cpp-code>

  In the current implementation the result of the alternatives here produce
  the same effect, i.e.: the tree is typesetted in paragraph mode via
  <cpp|typeset_stack>

  <\cpp-code>
    array\<less\>page_item\<gtr\>

    typeset_stack (edit_env env, tree t, path ip,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ array\<less\>line_item\<gtr\> a,
    array\<less\>line_item\<gtr\> b, stack_border& sb)

    {

    \ \ // cout \<less\>\<less\> "Typeset stack " \<less\>\<less\> t
    \<less\>\<less\> "\\n";

    \ \ lazy_paragraph par (env, ip);

    \ \ par-\<gtr\>a= a;

    \ \ par-\<gtr\>a \<less\>\<less\> typeset_concat_or_table (env, t, ip);

    \ \ par-\<gtr\>a \<less\>\<less\> b;

    \ \ par-\<gtr\>format_paragraph ();

    \ \ sb= par-\<gtr\>sss-\<gtr\>sb;

    \ \ return par-\<gtr\>sss-\<gtr\>l;

    }
  </cpp-code>

  and the generated <cpp|page_item>s are appended to the
  <cpp|typesetter_rep::l> field. Note that the <cpp|a> and <cpp|b> arguments
  are taken, in this case from the typesetter's, <cpp|a> and <cpp|b> fields.

  Let's see how a more specific bridge works. Consider for example
  <cpp|bridge_document_rep>. Its initialization goes as follows:

  <\cpp-code>
    bridge_document_rep::bridge_document_rep (typesetter ttt, tree st, path
    ip):

    \ \ bridge_rep (ttt, st, ip)

    {

    \ \ initialize ();

    }

    \;

    void

    bridge_document_rep::initialize () {

    \ \ int i, n= N(st);

    \ \ brs= array\<less\>bridge\<gtr\> (n);

    \ \ for (i=0; i\<less\>n; i++)

    \ \ \ \ brs[i]= make_bridge (ttt, st[i], descend (ip, i));

    \ \ initialize_acc ();

    }
  </cpp-code>

  Indeed, recursively it creates bridges for its children. Typesetting, on
  the other hand, is also left to the sub-bridges, but around this, the
  document bridge takes cares of managing the semantics of typesetter's
  <cpp|a> and <cpp|b> fields appropriately:

  <\cpp-code>
    void

    bridge_document_rep::my_typeset (int desired_status) {

    \ \ //cout \<less\>\<less\> INDENT;

    \ \ if (is_nil (acc)) {

    \ \ \ \ int i, n= N(st);

    \ \ \ \ array\<less\>line_item\<gtr\> a= ttt-\<gtr\>a;

    \ \ \ \ array\<less\>line_item\<gtr\> b= ttt-\<gtr\>b;

    \ \ \ \ for (i=0; i\<less\>n; i++) {

    \ \ \ \ \ \ //cout \<less\>\<less\> "Typesetting " \<less\>\<less\> st[i]
    \<less\>\<less\> LF;

    \ \ \ \ \ \ int wanted= (i==n-1? desired_status & WANTED_MASK:
    WANTED_PARAGRAPH);

    \ \ \ \ \ \ ttt-\<gtr\>a= (i==0 \ ? a: array\<less\>line_item\<gtr\> ());

    \ \ \ \ \ \ ttt-\<gtr\>b= (i==n-1? b: array\<less\>line_item\<gtr\> ());

    \ \ \ \ \ \ brs[i]-\<gtr\>typeset (PROCESSED+ wanted);

    \ \ \ \ }

    \ \ }

    \ \ else acc-\<gtr\>my_typeset (desired_status);

    \ \ //cout \<less\>\<less\> UNINDENT;

    }
  </cpp-code>

  The typesetter's <cpp|a> and <cpp|b> fields are populated by the
  <markup|surround> primitive, typesetted by the corresponding bridge:

  <\cpp-code>
    void

    bridge_surround_rep::my_typeset (int desired_status) {

    \ \ if (corrupted \|\| (N(ttt-\<gtr\>old_patch) != 0)) {

    \ \ \ \ hashmap\<less\>string,tree\<gtr\> prev_back (UNINIT);

    \ \ \ \ env-\<gtr\>local_start (prev_back);

    \ \ \ \ /*

    \ \ \ \ cout \<less\>\<less\> st[0] \<less\>\<less\> "\\n";

    \ \ \ \ cout \<less\>\<less\> st[1] \<less\>\<less\> "\\n";

    \ \ \ \ cout \<less\>\<less\> "-------------------------------------------------------------\\n";

    \ \ \ \ */

    \ \ \ \ a= typeset_concat (env, st[0], descend (ip, 0));

    \ \ \ \ b= typeset_concat (env, st[1], descend (ip, 1));

    \ \ \ \ env-\<gtr\>local_update (ttt-\<gtr\>old_patch, changes_before);

    \ \ \ \ env-\<gtr\>local_end (prev_back);

    \ \ \ \ corrupted= false;

    \ \ }

    \ \ else env-\<gtr\>monitored_patch_env (changes_before);

    \;

    \ \ ttt-\<gtr\>insert_marker (st, ip);

    \ \ ttt-\<gtr\>insert_surround (a, b);

    \ \ body-\<gtr\>typeset (desired_status);

    }
  </cpp-code>

  <cpp|insert_surround> takes care of adding the surround material to the
  current typesetter status in the correct order:

  <\cpp-code>
    void

    typesetter_rep::insert_surround \ (array\<less\>line_item\<gtr\> a2,
    array\<less\>line_item\<gtr\> b2) {

    \ \ a \<less\>\<less\> a2;

    \ \ array\<less\>line_item\<gtr\> temp_b= b;

    \ \ b= copy (b2);

    \ \ b \<less\>\<less\> temp_b;

    }
  </cpp-code>

  \;

  <\wip>
    To investigate further: as far as I can see the <cpp|a,b> fields are
    resetted only in <cpp|typesetter_rep::typeset> and only \Paugmented\Q
    after that, which would seem to lead to a multiple typesetting of those
    elements.
  </wip>

  \;

  Going back to the bridge typesetting mechanisms, here's
  <cpp|bridge_eval_rep::my_typeset>:

  <\cpp-code>
    void

    bridge_eval_rep::my_typeset (int desired_status) {

    \ \ if (is_func (st, EVAL, 1))

    \ \ \ \ initialize (env-\<gtr\>exec (st[0]));

    \ \ else if (is_func (st, QUASI, 1))

    \ \ \ \ initialize (env-\<gtr\>exec (tree (QUASIQUOTE, st[0])));

    \ \ else if (is_func (st, ANIM_STATIC) \|\| is_func (st, ANIM_DYNAMIC))

    \ \ \ \ initialize (env-\<gtr\>exec (st));

    \ \ else if (is_func (st, MAP_ARGS))

    \ \ \ \ initialize (env-\<gtr\>rewrite (st));

    \ \ else initialize (tree (ERROR, "bad eval bridge"));

    \ \ ttt-\<gtr\>insert_marker (st, ip);

    \ \ body-\<gtr\>typeset (desired_status);

    }
  </cpp-code>

  that execute various subtrees in the current environment and then re-create
  an appropriate bridge for them via <cpp|initialize>:

  <\cpp-code>
    void

    bridge_eval_rep::initialize (tree body_t) {

    \ \ if (is_nil (body)) body= make_bridge (ttt, attach_right (body_t,
    ip));

    \ \ else replace_bridge (body, path (), bt, attach_right (body_t, ip));

    \ \ bt= copy (body_t);

    }
  </cpp-code>

  Indeed the eval bridge does not initialize its subtree in the constructor.
  Execution of trees will be discussed elsewhere.

  Another interesting bridge is <cpp|bridge_formatting_rep>, that typesets
  as:

  <\cpp-code>
    void

    bridge_formatting_rep::my_typeset (int desired_status) {

    \ \ tree new_format= env-\<gtr\>read (v) * st (0, last);

    \ \ tree old_format= env-\<gtr\>local_begin (v, new_format);

    \ \ if (v != CELL_FORMAT) ttt-\<gtr\>insert_marker (st, ip);

    \ \ if (is_func (st, DATOMS)) {

    \ \ \ \ array\<less\>line_item\<gtr\> a, b;

    \ \ \ \ box ab= empty_box (decorate (ip), 0, 0, 0,
    env-\<gtr\>fn-\<gtr\>yx);

    \ \ \ \ box bb= empty_box (decorate (ip), 0, 0, 0,
    env-\<gtr\>fn-\<gtr\>yx);

    \ \ \ \ a \<less\>\<less\> line_item (CONTROL_ITEM, OP_SKIP, ab,
    HYPH_INVALID, st (0, N(st)-1));

    \ \ \ \ b \<less\>\<less\> line_item (CONTROL_ITEM, OP_SKIP, bb,
    HYPH_INVALID, tree (L(st)));

    \ \ \ \ if (v != CELL_FORMAT) ttt-\<gtr\>insert_marker (st, ip);

    \ \ \ \ ttt-\<gtr\>insert_surround (a, b);

    \ \ }

    \ \ body-\<gtr\>typeset (desired_status);

    \ \ env-\<gtr\>local_end (v, old_format);

    }
  </cpp-code>

  It locally modifies the environment (e.g. <cpp|"atoms-decorations"> for the
  <markup|datoms> primitive).

  <\wip>
    I still need to understand what is the purpose of <cpp|CONTROL_ITEM>s.
  </wip>

  \;

  The auto bridge implements another part of interesting functionality, the
  rendering of (inactivated) markup. The <cpp|bridge_auto_rep> it is created
  by <cpp|make_bridge> in the following cases:

  <\cpp-code>
    \ \ case ERROR:

    \ \ \ \ return bridge_auto (ttt, st, ip, error_m, true);

    \ \ case INACTIVE:

    \ \ \ \ return bridge_auto (ttt, st, ip, inactive_m, true);

    \ \ case VAR_INACTIVE:

    \ \ \ \ return bridge_auto (ttt, st, ip, var_inactive_m, true);
  </cpp-code>

  and my <cpp|make_inactive_bridge> (used to typeset the preamble):

  <\cpp-code>
    bridge

    make_inactive_bridge (typesetter ttt, tree st, path ip) {

    \ \ if (is_document (st))

    \ \ \ \ return bridge_document (ttt, st, ip);

    \ \ else return bridge_auto (ttt, st, ip, inactive_auto, false);

    }
  </cpp-code>

  and it requires a <TeXmacs> macro in creation, in the cases above they are:

  <\cpp-code>
    static tree inactive_auto

    \ \ (MACRO, "x", tree (REWRITE_INACTIVE, tree (ARG, "x"), "recurse*"));

    static tree error_m

    \ \ (MACRO, "x", tree (REWRITE_INACTIVE, tree (ARG, "x", "0"),
    "error*"));

    static tree inactive_m

    \ \ (MACRO, "x", tree (REWRITE_INACTIVE, tree (ARG, "x", "0"), "once*"));

    static tree var_inactive_m

    \ \ (MACRO, "x", tree (REWRITE_INACTIVE, tree (ARG, "x", "0"),
    "recurse*"));
  </cpp-code>

  and an auto bridge typesets as follows:

  <\cpp-code>
    void

    bridge_auto_rep::my_typeset (int desired_status) {

    \ \ env-\<gtr\>macro_arg= list\<less\>hashmap\<less\>string,tree\<gtr\>
    \<gtr\> (

    \ \ \ \ hashmap\<less\>string,tree\<gtr\> (UNINIT),
    env-\<gtr\>macro_arg);

    \ \ env-\<gtr\>macro_src= list\<less\>hashmap\<less\>string,path\<gtr\>
    \<gtr\> (

    \ \ \ \ hashmap\<less\>string,path\<gtr\> (path (DECORATION)),
    env-\<gtr\>macro_src);

    \ \ string var= f[0]-\<gtr\>label;

    \ \ env-\<gtr\>macro_arg-\<gtr\>item (var)= st;

    \ \ env-\<gtr\>macro_src-\<gtr\>item (var)= ip;

    \ \ tree oldv= env-\<gtr\>read (PREAMBLE);

    \ \ env-\<gtr\>write_update (PREAMBLE, "false");

    \ \ initialize ();

    \ \ if (border) ttt-\<gtr\>insert_marker (st, ip);

    \ \ body-\<gtr\>typeset (desired_status);

    \ \ env-\<gtr\>write_update (PREAMBLE, oldv);

    \ \ env-\<gtr\>macro_arg= env-\<gtr\>macro_arg-\<gtr\>next;

    \ \ env-\<gtr\>macro_src= env-\<gtr\>macro_src-\<gtr\>next;

    }
  </cpp-code>

  and finally (via the macros) create an inner rewrite bridge:

  <\cpp-code>
    \ \ case REWRITE_INACTIVE:

    \ \ \ \ return bridge_rewrite (ttt, st, ip);
  </cpp-code>

  which typesets as follows:

  <\cpp-code>
    void

    bridge_rewrite_rep::my_typeset (int desired_status) {

    \ \ initialize (env-\<gtr\>rewrite (st));

    \ \ ttt-\<gtr\>insert_marker (st, ip);

    \ \ if (is_func (st, VAR_INCLUDE)) {

    \ \ \ \ url save_name= env-\<gtr\>cur_file_name;

    \ \ \ \ url file_name= url_unix (env-\<gtr\>exec_string (st[0]));

    \ \ \ \ env-\<gtr\>cur_file_name= relative (env-\<gtr\>base_file_name,
    file_name);

    \ \ \ \ env-\<gtr\>secure= is_secure (env-\<gtr\>cur_file_name);

    \ \ \ \ body-\<gtr\>typeset (desired_status);

    \ \ \ \ env-\<gtr\>cur_file_name= save_name;

    \ \ \ \ env-\<gtr\>secure= is_secure (env-\<gtr\>cur_file_name);

    \ \ }

    \ \ else body-\<gtr\>typeset (desired_status);

    }
  </cpp-code>

  by calling\ 

  <\cpp-code>
    tree edit_env_rep::rewrite (tree t);
  </cpp-code>

  which on its turns calls \ 

  <\cpp-code>
    tree edit_env_rep::rewrite_inactive (tree t, tree var);
  </cpp-code>

  to rewrite the tree so to typeset it in an inactive way.

  <\wip>
    Why this level of indirection, from auto bridge to rewrite bridge?
  </wip>

  <subsection|The concater>

  <\wip>
    TODO
  </wip>

  At the lower level the horizontal concatenation of boxes is implemented via
  the <cpp|concater> object. From <verbatim|src/Typeset/Concat/concater.cpp>:

  <\cpp-code>
    array\<less\>line_item\<gtr\>

    typeset_concat (edit_env env, tree t, path ip) {

    \ \ concater ccc= tm_new\<less\>concater_rep\<gtr\> (env);

    \ \ ccc-\<gtr\>typeset (t, ip);

    \ \ ccc-\<gtr\>finish ();

    \ \ array\<less\>line_item\<gtr\> a= ccc-\<gtr\>a;

    \ \ tm_delete (ccc);

    \ \ return a;

    }
  </cpp-code>

  Its main output is an array of <cpp|line_item> structs. From
  <verbatim|src/Typeset/Format/line_item.hpp>:

  <\cpp-code>
    class line_item_rep: public concrete_struct {

    public:

    \ \ int \ \ \ \ \ \ \ type; \ \ \ \ \ // type of the line item

    \ \ int \ \ \ \ \ \ \ op_type; \ \ // operator type for mathematical
    symbols

    \ \ box \ \ \ \ \ \ \ b; \ \ \ \ \ \ \ \ // the box

    \ \ space \ \ \ \ \ spc; \ \ \ \ \ \ // separation space

    \ \ int \ \ \ \ \ \ \ penalty; \ \ // penalty for a linebreak after this
    line_item

    \ \ bool \ \ \ \ \ \ limits; \ \ \ // line items has limits

    \ \ language \ \ lan; \ \ \ \ \ \ // language for hyphenating strings

    \ \ tree \ \ \ \ \ \ t; \ \ \ \ \ \ \ \ // for control items

    \;

    \ \ line_item_rep (int type, int ot_type, box b, int penalty);

    \ \ line_item_rep (int type, int ot_type, box b, int penalty, language
    lan);

    \ \ line_item_rep (int type, int ot_type, box b, int penalty, tree t);

    \ \ ~line_item_rep ();

    };
  </cpp-code>

  the possible types of line items are

  <\cpp-code>
    #define OBSOLETE_ITEM \ \ \ \ \ \ \ \ \ 0

    #define STD_ITEM \ \ \ \ \ \ \ \ \ \ \ \ \ \ 1

    #define MARKER_ITEM \ \ \ \ \ \ \ \ \ \ \ 2

    #define STRING_ITEM \ \ \ \ \ \ \ \ \ \ \ 3

    #define LEFT_BRACKET_ITEM \ \ \ \ \ 4

    #define MIDDLE_BRACKET_ITEM \ \ \ 5

    #define RIGHT_BRACKET_ITEM \ \ \ \ 6

    #define CONTROL_ITEM \ \ \ \ \ \ \ \ \ \ 7

    #define FLOAT_ITEM \ \ \ \ \ \ \ \ \ \ \ \ 8

    #define NOTE_LINE_ITEM \ \ \ \ \ \ \ \ 9

    #define NOTE_PAGE_ITEM \ \ \ \ \ \ \ 10

    \;

    #define LSUB_ITEM \ \ \ \ \ \ \ \ \ \ \ \ 11

    #define LSUP_ITEM \ \ \ \ \ \ \ \ \ \ \ \ 12

    #define RSUB_ITEM \ \ \ \ \ \ \ \ \ \ \ \ 13

    #define RSUP_ITEM \ \ \ \ \ \ \ \ \ \ \ \ 14

    #define GLUE_LSUBS_ITEM \ \ \ \ \ \ 15

    #define GLUE_RSUBS_ITEM \ \ \ \ \ \ 16

    #define GLUE_LEFT_ITEM \ \ \ \ \ \ \ 17

    #define GLUE_RIGHT_ITEM \ \ \ \ \ \ 18

    #define GLUE_BOTH_ITEM \ \ \ \ \ \ \ 19
  </cpp-code>

  <subsection|The stacker>

  <\wip>
    TODO
  </wip>

  From <verbatim|src/Typeset/Format/page_item.hpp>:

  <\cpp-code>
    class page_item_rep: public concrete_struct {

    public:

    \ \ int \ \ \ \ \ \ \ \ \ type; \ \ \ // type of the page item

    \;

    \ \ box \ \ \ \ \ \ \ \ \ b; \ \ \ \ \ \ // the box

    \ \ space \ \ \ \ \ \ \ spc; \ \ \ \ // separation space

    \ \ int \ \ \ \ \ \ \ \ \ penalty; // penalty for a linebreak after this
    page_item

    \;

    \ \ array\<less\>lazy\<gtr\> \ fl; \ \ \ \ \ // floating objects attached
    to this item

    \ \ int \ \ \ \ \ \ \ \ \ nr_cols; // number of columns

    \ \ tree \ \ \ \ \ \ \ \ t; \ \ \ \ \ \ // for page control items

    \;

    \ \ page_item_rep (box b, array\<less\>lazy\<gtr\> fl, int nr_cols);

    \ \ page_item_rep (tree t, int nr_cols);

    \ \ page_item_rep (int type, box b, space spc, int pen,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ array\<less\>lazy\<gtr\> fl, int
    nr_cols, tree t);

    };
  </cpp-code>

  the possible types of line items are

  <\cpp-code>
    #define PAGE_LINE_ITEM \ \ \ \ \ 0

    #define PAGE_HIDDEN_ITEM \ \ \ 1

    #define PAGE_CONTROL_ITEM \ \ 2

    #define PAGE_NOTE_ITEM \ \ \ \ \ 3
  </cpp-code>

  \;

  <\cpp-code>
    class stack_border_rep: public concrete_struct {

    public:

    \ \ SI \ \ \ height; \ // default distance between successive base lines

    \ \ SI \ \ \ sep; \ \ \ \ // (~~PAR_SEP) sep-ver_sep is maximal amount of
    shoving

    \ \ SI \ \ \ hor_sep; // min. hor. ink sep. when lines are shoved into
    each other

    \ \ SI \ \ \ ver_sep; // minimal separation of ink

    \ \ SI \ \ \ bot; \ \ \ \ // logical bottom of lines

    \ \ SI \ \ \ top; \ \ \ \ // logical top of lines

    \;

    \ \ SI \ \ \ height_before;

    \ \ SI \ \ \ sep_before;

    \ \ SI \ \ \ hor_sep_before;

    \ \ SI \ \ \ ver_sep_before;

    \;

    \ \ space vspc_before, vspc_after;

    \ \ bool \ nobr_before, nobr_after;

    \;

    \ \ inline stack_border_rep ():

    \ \ \ \ height (0), sep (0), hor_sep (0), ver_sep (0), bot (0), top (0),

    \ \ \ \ height_before (0), sep_before (0), hor_sep_before (0),
    ver_sep_before (0),

    \ \ \ \ vspc_before (0), vspc_after (0),

    \ \ \ \ nobr_before (false), nobr_after (false) {}

    };
  </cpp-code>

  \;

  \;

  <\cpp-code>
    box

    typeset_as_stack (edit_env env, tree t, path ip) {

    \ \ // cout \<less\>\<less\> "Typeset as stack " \<less\>\<less\> t
    \<less\>\<less\> "\\n";

    \ \ int i, n= N(t);

    \ \ stacker sss= tm_new\<less\>stacker_rep\<gtr\> ();

    \ \ SI sep \ \ \ \ \ \ = env-\<gtr\>get_length (PAR_SEP);

    \ \ SI hor_sep \ \ = env-\<gtr\>get_length (PAR_HOR_SEP);

    \ \ SI ver_sep \ \ = env-\<gtr\>get_length (PAR_VER_SEP);

    \ \ SI height \ \ \ = env-\<gtr\>as_length (string ("1fn"))+ sep;

    \ \ SI bot \ \ \ \ \ \ = 0;

    \ \ SI top \ \ \ \ \ \ = env-\<gtr\>fn-\<gtr\>yx;

    \ \ array\<less\>SI\<gtr\> swell;

    \ \ sss-\<gtr\>set_env_vars (height, sep, hor_sep, ver_sep, bot, top,
    swell);

    \ \ for (i=0; i\<less\>n; i++)

    \ \ \ \ sss-\<gtr\>print (typeset_as_concat (env, t[i], descend (ip,
    i)));

    \;

    \ \ n= N(sss-\<gtr\>l);

    \ \ array\<less\>box\<gtr\> lines_bx (n);

    \ \ array\<less\>SI\<gtr\> \ lines_ht (n);

    \ \ for (i=0; i\<less\>n; i++) {

    \ \ \ \ page_item item= copy (sss-\<gtr\>l[i]);

    \ \ \ \ lines_bx[i]= item-\<gtr\>b;

    \ \ \ \ lines_ht[i]= item-\<gtr\>spc-\<gtr\>def;

    \ \ }

    \;

    \ \ tm_delete (sss);

    \ \ box b= stack_box (ip, lines_bx, lines_ht);

    \ \ SI dy= n==0? 0: b[0]-\<gtr\>y2;

    \ \ return move_box (ip, stack_box (ip, lines_bx, lines_ht), 0, dy);

    }
  </cpp-code>
</body>

<\initial>
  <\collection>
    <associate|code-numbered-offset|0.5tab>
    <associate|font|typewriter=roman,TeX Gyre Termes>
    <associate|font-base-size|11>
    <associate|font-family|rm>
    <associate|math-font|math-termes>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|auto-1|<tuple|?|1>>
    <associate|auto-10|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|style>|2>>
    <associate|auto-11|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|tuple>|2>>
    <associate|auto-12|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|body>|2>>
    <associate|auto-13|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|initial>|2>>
    <associate|auto-14|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|collection>|2>>
    <associate|auto-15|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|associate>|2>>
    <associate|auto-16|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|references>|2>>
    <associate|auto-17|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|tuple>|2>>
    <associate|auto-18|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|tuple>|2>>
    <associate|auto-19|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|auxiliary>|3>>
    <associate|auto-2|<tuple|1|1>>
    <associate|auto-20|<tuple|1.3|3>>
    <associate|auto-21|<tuple|1.3|3>>
    <associate|auto-22|<tuple|2|4>>
    <associate|auto-23|<tuple|2|4>>
    <associate|auto-24|<tuple|1.4|5>>
    <associate|auto-25|<tuple|1.5|5>>
    <associate|auto-26|<tuple|1.5|6>>
    <associate|auto-27|<tuple|1.5|6>>
    <associate|auto-28|<tuple|<with|mode|<quote|math>|\<bullet\>>|7>>
    <associate|auto-29|<tuple|1.6|7>>
    <associate|auto-3|<tuple|1.1|1>>
    <associate|auto-30|<tuple|User defined units|7>>
    <associate|auto-31|<tuple|<with|language|<quote|verbatim>|<with|font|<quote|roman>|font-family|<quote|tt>|magnification|<quote|1.06>|cc>>|8>>
    <associate|auto-32|<tuple|<with|language|<quote|verbatim>|<with|font|<quote|roman>|font-family|<quote|tt>|magnification|<quote|1.06>|emunit>>|8>>
    <associate|auto-33|<tuple|<with|language|<quote|verbatim>|<with|font|<quote|roman>|font-family|<quote|tt>|magnification|<quote|1.06>|xspc>>|9>>
    <associate|auto-34|<tuple|<with|font-family|<quote|tt>|t>|9>>
    <associate|auto-35|<tuple|<with|font-family|<quote|tt>|tmpt>|9>>
    <associate|auto-36|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|tmlen>|9>>
    <associate|auto-37|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|tmlen>|9>>
    <associate|auto-38|<tuple|1.7|9>>
    <associate|auto-39|<tuple|1.8|10>>
    <associate|auto-4|<tuple|1|1>>
    <associate|auto-40|<tuple|1.9|10>>
    <associate|auto-41|<tuple|2|11>>
    <associate|auto-42|<tuple|2.1|12>>
    <associate|auto-43|<tuple|2.2|12>>
    <associate|auto-44|<tuple|2.3|13>>
    <associate|auto-45|<tuple|3|16>>
    <associate|auto-46|<tuple|3.1|20>>
    <associate|auto-47|<tuple|3.2|21>>
    <associate|auto-48|<tuple|3.3|?>>
    <associate|auto-5|<tuple|1|2>>
    <associate|auto-6|<tuple|1.2|2>>
    <associate|auto-7|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|TeXmacs>|2>>
    <associate|auto-8|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|project>|2>>
    <associate|auto-9|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|style>|2>>
    <associate|box-lengths|<tuple|<with|language|<quote|verbatim>|<with|font|<quote|roman>|font-family|<quote|tt>|magnification|<quote|1.06>|xspc>>|8>>
    <associate|gen-tree-tm|<tuple|2|3>>
    <associate|initial-env|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|body>|2>>
    <associate|sec-lengths|<tuple|1.6|7>>
    <associate|sec-tm-docs|<tuple|1.2|2>>
    <associate|sec-tm-drd|<tuple|1.5|5>>
    <associate|sec-tm-tm|<tuple|1.3|3>>
    <associate|sec-tm-tree|<tuple|1.1|1>>
    <associate|sec-typesetting|<tuple|1.4|4>>
    <associate|tm-tree-ex|<tuple|1|1>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|idx>
      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|TeXmacs>>|<pageref|auto-6>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|project>>|<pageref|auto-7>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|style>>|<pageref|auto-8>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|style>>|<pageref|auto-9>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|tuple>>|<pageref|auto-10>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|body>>|<pageref|auto-11>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|initial>>|<pageref|auto-12>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|collection>>|<pageref|auto-13>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|associate>>|<pageref|auto-14>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|references>>|<pageref|auto-15>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|tuple>>|<pageref|auto-16>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|tuple>>|<pageref|auto-17>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|auxiliary>>|<pageref|auto-18>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|tmlen>>|<pageref|auto-35>>

      <tuple|<tuple|<with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|tmlen>>|<pageref|auto-36>>
    </associate>
    <\associate|toc>
      1.<space|2spc>Overview <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1>

      <with|par-left|<quote|1tab>|1.1.<space|2spc>T<rsub|<space|-0.4spc><move|<resize|<with|math-level|<quote|0>|E>||||0.5fn>|0fn|-0.1fn>><space|-0.4spc>X<rsub|<space|-0.4spc><move|<resize|M<space|-0.2spc>A<space|-0.4spc>CS||||0.5fn>|0fn|-0.1fn>>
      trees <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2>>

      <with|par-left|<quote|3tab>|Internal nodes of
      T<rsub|<space|-0.4spc><move|<resize|<with|math-level|<quote|0>|E>||||0.5fn>|0fn|-0.1fn>><space|-0.4spc>X<rsub|<space|-0.4spc><move|<resize|M<space|-0.2spc>A<space|-0.4spc>CS||||0.5fn>|0fn|-0.1fn>>
      trees <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3>>

      <with|par-left|<quote|3tab>|Leafs of
      T<rsub|<space|-0.4spc><move|<resize|<with|math-level|<quote|0>|E>||||0.5fn>|0fn|-0.1fn>><space|-0.4spc>X<rsub|<space|-0.4spc><move|<resize|M<space|-0.2spc>A<space|-0.4spc>CS||||0.5fn>|0fn|-0.1fn>>
      trees <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4>>

      <with|par-left|<quote|1tab>|1.2.<space|2spc>T<rsub|<space|-0.4spc><move|<resize|<with|math-level|<quote|0>|E>||||0.5fn>|0fn|-0.1fn>><space|-0.4spc>X<rsub|<space|-0.4spc><move|<resize|M<space|-0.2spc>A<space|-0.4spc>CS||||0.5fn>|0fn|-0.1fn>>
      documents <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-5>>

      <with|par-left|<quote|1tab>|1.3.<space|2spc>Default serialization
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-19>>

      <with|par-left|<quote|3tab>|Main serialization principle
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-20>>

      <with|par-left|<quote|3tab>|Formatting and whitespace
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-21>>

      <with|par-left|<quote|3tab>|Raw data
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-22>>

      <with|par-left|<quote|1tab>|1.4.<space|2spc>The typesetting process
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-23>>

      <with|par-left|<quote|1tab>|1.5.<space|2spc>Data relation descriptions
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-24>>

      <with|par-left|<quote|3tab>|The rationale behind <rigid|D.R.D.>s
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-25>>

      <with|par-left|<quote|3tab>|Current <rigid|D.R.D.> properties and
      applications <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-26>>

      <with|par-left|<quote|3tab>|Determination of the <rigid|D.R.D.> of a
      document <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-27>>

      <with|par-left|<quote|1tab>|1.6.<space|2spc>T<rsub|<space|-0.4spc><move|<resize|<with|math-level|<quote|0>|E>||||0.5fn>|0fn|-0.1fn>><space|-0.4spc>X<rsub|<space|-0.4spc><move|<resize|M<space|-0.2spc>A<space|-0.4spc>CS||||0.5fn>|0fn|-0.1fn>>
      lengths <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-28>>

      <with|par-left|<quote|3tab>|Absolute length units
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-29>>

      <with|par-left|<quote|3tab>|Rigid font-dependent length units
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-30>>

      <with|par-left|<quote|3tab>|Stretchable font-dependent length units
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-31>>

      <with|par-left|<quote|3tab>|Box lengths
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-32>>

      <with|par-left|<quote|3tab>|Other length units
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-33>>

      <with|par-left|<quote|3tab>|Different ways to specify lengths
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-34>>

      <with|par-left|<quote|1tab>|1.7.<space|2spc>Intern representation of
      texts <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-37>>

      <with|par-left|<quote|1tab>|1.8.<space|2spc>Text
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-38>>

      <with|par-left|<quote|1tab>|1.9.<space|2spc>The language
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-39>>

      2.<space|2spc>Boxes <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-40>

      <with|par-left|<quote|1tab>|2.1.<space|2spc>The correspondence between
      a box and its source <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-41>>

      <with|par-left|<quote|1tab>|2.2.<space|2spc>The three kinds of paths
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-42>>

      <with|par-left|<quote|1tab>|2.3.<space|2spc>The cursor and selections
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-43>>

      3.<space|2spc>The low levels <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-44>

      <with|par-left|<quote|1tab>|3.1.<space|2spc>The bridge
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-45>>

      <with|par-left|<quote|1tab>|3.2.<space|2spc>The concater
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-46>>

      <with|par-left|<quote|1tab>|3.3.<space|2spc>The stacker
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-47>>
    </associate>
  </collection>
</auxiliary>