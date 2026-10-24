<TeXmacs|2.1.4>

<style|notes>

<\body>
  <\hide-preamble>
    <assign|tm-src|<macro|path|<hlink|<verbatim|<arg|path>>|<merge|https://github.com/texmacs/texmacs/blob/svn_mirror/|<arg|path>>>>>
  </hide-preamble>

  <notes-header>

  <chapter*|Behind the markup: internal macros of <TeXmacs>>

  <notes-abstract|A guided tour of the internal macros and primitives that
  <TeXmacs> uses behind the scenes: the <markup|render-*> hooks of the
  standard styles, footnotes, labels and the binding mechanism, loci and
  links, and the processing of title data. Each topic starts from how
  <TeXmacs> works and ends with examples you can try.>

  [Version 1.0 of 24.10.2026. Based on the forum wiki thread
  <hlink|Undocumented internal macros in TeXmacs|http://forum.texmacs.cn/t/undocumented-internal-macros-in-texmacs-wiki/224>
  and its contributors.]

  This article grew out of a wiki thread on the <TeXmacs> forum, started in
  2020 by <hlink|re4zuaFe|http://forum.texmacs.cn/u/re4zuaFe> and extended
  over the years by <hlink|jeroen|http://forum.texmacs.cn/u/jeroen>,
  <hlink|jingkaimori|http://forum.texmacs.cn/u/jingkaimori> and
  <hlink|sharkc|http://forum.texmacs.cn/u/sharkc>, with suggestions by
  <hlink|pireddag|http://forum.texmacs.cn/u/pireddag> and
  <hlink|mgubi|http://forum.texmacs.cn/u/mgubi>. The thread collected tags
  that appear in documents and style files but are not (or only barely)
  described in the manual. Here we reorganize that material, check it against
  the source code and put it into the wider context of how <TeXmacs> typesets
  a document, so that the individual tags stop looking like magic.

  All statements below refer to <TeXmacs> 2.1.4 and to the development
  version (SVN trunk, revision 15370, October 2026); the relevant files are
  identical in the two versions. Links to the sources point to the
  <hlink|GitHub mirror|https://github.com/texmacs/texmacs> of the official
  repository. All the examples were tested with <TeXmacs> 2.1.4.

  Examples of <TeXmacs> markup are shown as source code: tag names are
  between angle brackets, and names in italics are macro arguments (like
  <src-arg|body>) or environment variables (like <src-var|font-size>). The
  easiest way to enter them is in source mode (<menu|Document|Source|Edit
  source tree>).

  <section|How <TeXmacs> turns markup into pages><label|sec-model>

  To understand internal macros we first need a picture of what a <TeXmacs>
  document is and of what happens when it is displayed.

  <paragraph|Documents are trees.>A <TeXmacs> document is a labelled tree.
  When you write a sentence with a footnote, the editor stores something like

  <\tm-fragment>
    <inactive*|Some text<footnote|A note.> and more text.>
  </tm-fragment>

  which, seen from Scheme (for instance with <scm|(tm-\<gtr\>stree
  (buffer-tree))> in a Scheme session), is the tree

  <\scm-code>
    (document

    \ \ (concat "Some text" (footnote "A note.") " and more text."))
  </scm-code>

  Every node has a label (<verbatim|concat>, <verbatim|footnote>, ...) and
  children. You can always see this structure in source mode
  (<menu|Document|Source|Edit source tree>).

  <paragraph|Primitives and macros.>Some labels are <em|primitives>: they are
  known to the C++ typesetter, which knows how to turn them into boxes. They
  are listed in <tm-src|src/Kernel/Types/tree_label.hpp>, and their arity and
  properties are declared in <tm-src|src/Data/Drd/drd_std.cpp>. Examples are
  <markup|concat>, <markup|with>, <markup|macro>, <markup|locus> or
  <markup|set-binding>. All other labels are <em|macros>, defined in style
  files and packages (the <verbatim|.ts> files under
  <verbatim|TeXmacs/packages>) with the <markup|assign> primitive:

  <\tm-fragment>
    <inactive*|<assign|footnote-sep|<macro|. >>>
  </tm-fragment>

  When the typesetter meets a tag which is not a primitive, it looks up its
  name in the <em|environment>, finds a <markup|macro> and typesets the body
  of the macro with the arguments substituted. So <markup|footnote> is not
  built into <TeXmacs>: it is an ordinary macro of the <verbatim|env-float>
  package, and you can read its definition.

  <paragraph|The environment.>The environment is a map from names to values
  which contains both typesetting variables (like <src-var|font-size> or
  <src-var|par-left>) and macros. <markup|assign> changes a value from that
  point onwards, while <markup|with> changes it locally:

  <\tm-fragment>
    <inactive*|<with|font-shape|italic|footnote-sep|<macro|: >|<arg|body>>>
  </tm-fragment>

  Since macros live in the same environment as variables, a style package, a
  document preamble or even a <markup|with> can <em|redefine> a macro of the
  standard styles. This is the basic customization mechanism of <TeXmacs>,
  and it is the reason why internal macros are worth knowing: they are the
  places where the standard styles let you plug in your own behaviour.

  <paragraph|Some primitives are macros in disguise.>A few tags that are
  documented as primitives, like <markup|label>, <markup|reference>,
  <markup|pageref>, <markup|hlink> and <markup|action>, are in fact macros:
  they have tree labels in <verbatim|tree_label.hpp>, but the typesetter
  expands them from the environment, where their default definitions are
  hard-coded in C++, in <tm-src|src/Typeset/Env/env_default.cpp>. They are
  typeset like any other macro and can therefore be redefined from a document
  or a style file. We will see their definitions in Sections
  <reference|sec-bindings> and <reference|sec-links>; they are written in
  terms of the truly primitive tags discussed in this article.

  <paragraph|How to look under the hood yourself.>The tools for exploring
  macros are all available from the editor:

  <\itemize>
    <item>Put the cursor inside a tag and open the <menu|Preferences for tag>
    button of the focus toolbar (or <menu|Focus|Preferences>): for macros
    which can be edited, <menu|Edit macro> opens the definition of the
    current macro in a macro editor, and <menu|Edit source> opens the
    preamble or the style package in which it is defined. The <menu|Describe
    tag> button opens the documentation of the tag, when there is one.

    <item>The source mode (<menu|Document|Source|Edit source tree>) shows the
    tree structure of the document.

    <item><menu|Tools|Developer tool> adds a <menu|Developer> menu; an
    <menu|Insert|Session|Scheme> session lets you inspect the document and
    call the functions mentioned below.

    <item>The style packages themselves are in the <verbatim|packages>
    directory of your <TeXmacs> installation; searching them for
    <verbatim|assign\|name> is often the fastest way to find a definition.
  </itemize>

  <section|The <markup|render-*> hooks><label|sec-hooks>

  The standard styles follow a consistent pattern: a user-level macro takes
  care of the logic (numbering, labels, table of contents entries, ...) and
  then delegates the visual layout to a separate macro, whose name usually
  starts with <verbatim|render->. These <em|rendering hooks> are internal:
  you normally do not insert them in a document (an exception is
  <markup|render-code>, which the <menu|Pseudo code> menu entry inserts), but
  redefining them changes the look of every instance of the corresponding
  environment, without touching the numbering or the references.

  The most useful ones are:

  <\big-table|<tabular|<tformat|<cwith|1|1|1|-1|cell-bborder|1ln>|<table|<row|<cell|<strong|Hook>>|<cell|<strong|Used
  by>>|<cell|<strong|Defined in>>>|<row|<cell|<markup|render-footnote>,
  <markup|render-footnote*>>|<cell|<markup|footnote>>|<cell|<verbatim|env-float.ts>>>|<row|<cell|<markup|render-big-figure>,
  <markup|render-small-figure>, <markup|render-caption>>|<cell|<markup|big-figure>,
  <markup|small-figure>, <markup|big-table>,
  ...>|<cell|<verbatim|env-float.ts>>>|<row|<cell|<markup|render-theorem>>|<cell|<markup|theorem>,
  <markup|lemma>, <markup|proposition>, ...>|<cell|<verbatim|env-enunciation.ts>>>|<row|<cell|<markup|render-enunciation>>|<cell|<markup|render-theorem>,
  <markup|render-remark>, ...>|<cell|<verbatim|env-enunciation.ts>>>|<row|<cell|<markup|render-remark>,
  <markup|render-proof>, <markup|render-exercise>>|<cell|<markup|remark>,
  <markup|proof>, <markup|exercise>, ...>|<cell|<verbatim|env-enunciation.ts>>>|<row|<cell|<markup|render-item>,
  <markup|render-list>>|<cell|<markup|item>, <markup|itemize>,
  <markup|enumerate>, ...>|<cell|<verbatim|std-list.ts>>>|<row|<cell|<markup|render-abstract>>|<cell|<markup|abstract>>|<cell|<verbatim|title-base.ts>>>|<row|<cell|<markup|render-code>>|<cell|<markup|cpp-code>,
  <markup|scm-code>, ...>|<cell|<verbatim|env-program.ts>>>|<row|<cell|<markup|render-table-of-contents>,
  <markup|render-index>>|<cell|<markup|table-of-contents>,
  <markup|the-index>, ...>|<cell|<verbatim|section-base.ts>>>>>>>
    Some rendering hooks of the standard styles.
  </big-table>

  Not every hook follows the naming scheme. Short pieces of text have their
  own small macros, for instance <markup|theorem-name> and
  <markup|theorem-sep> (the style of the name of a theorem and the separator
  after it), <markup|enunciation-name> and <markup|enunciation-sep> (the same
  for all theorem-like environments), <markup|proof-text> (the word
  \PProof\Q), <markup|abstract-text> (the word \PAbstract\Q),
  <markup|figure-name> and <markup|figure-sep>, <markup|footnote-sep>, and
  <markup|item-vsep> and <markup|item-hsep> (the spacing of lists). The
  titles of documents use <markup|doc-author> and <markup|doc-authors>
  (Section <reference|sec-title>).

  The figure and theorem hooks, <markup|render-list>, the section hooks
  <markup|render-table-of-contents> and <markup|render-index>, and
  <markup|footnote-sep> are documented in the section of the manual on
  customizing the standard styles; the footnote, code, abstract and item
  hooks (<markup|render-item>, <markup|item-vsep>, <markup|item-hsep>) are
  not.

  <paragraph|Example: theorems with a dash.>Put the following in the preamble
  of a document (<menu|Document|Part|Create preamble>, or <menu|Show
  preamble> if it already exists), or in a style package of your own:

  <\tm-fragment>
    <inactive*|<assign|theorem-sep|<macro| -- >>>

    <inactive*|<assign|render-theorem|<macro|which|body|<render-enunciation|<with|color|dark
    blue|<theorem-name|<arg|which><theorem-sep>>>|<arg|body>>>>>

    <inactive*|<assign|proof-text|<macro|Demonstration>>>
  </tm-fragment>

  Theorems now read \P<with|color|dark blue|<strong|Theorem 1 -->> Every even
  number ...\Q, and since <markup|lemma>, <markup|proposition> and the other
  theorem-like environments are all created with <markup|new-theorem>, which
  uses <markup|render-theorem>, they all change at once. Proofs start with
  \P<em|Demonstration.>\Q. Note that our version of <markup|render-theorem>
  no longer sets the body in italics: the original definition wraps
  <src-arg|body> in <inactive*|<with|font-shape|italic|...>>, and it is a
  good habit to look at the original (with <menu|Edit macro>) before
  replacing it.

  <paragraph|Example: compact lists, renamed abstract.>Smaller hooks are just
  as easy:

  <\tm-fragment>
    <inactive*|<assign|item-vsep|<macro|0fn>>>

    <inactive*|<assign|abstract-text|<macro|Summary>>>

    <inactive*|<assign|enunciation-name|<macro|name|<em|<arg|name>>>>>
  </tm-fragment>

  removes the vertical space between list items and around lists, renames the
  abstract and sets the names of remarks, examples, theorems... in italics.

  <section|Footnotes from the inside><label|sec-footnotes>

  The first two entries of the forum thread were <markup|render-footnote*>
  and <markup|render-footnote>. Footnotes are a good example of the whole
  machinery at work: a counter, a hook, a floating object, a label, a binding
  and a reference. Here are the definitions from
  <tm-src|TeXmacs/packages/environment/env-float.ts>, slightly simplified (we
  removed some purely presentational <markup|with> and <markup|style-with>
  tags):

  <\tm-fragment>
    <inactive*|<assign|footnote|<macro|body|<next-footnote><render-footnote|<the-footnote>|<arg|body>><space|0spc><label|<merge|footnr-|<the-footnote>>><rsup|<reference|<merge|footnote-|<the-footnote>>>>>>>

    <inactive*|<assign|render-footnote|<macro|nr|body|<render-footnote*|<arg|nr>|<arg|nr>|<arg|body>>>>>

    <inactive*|<assign|render-footnote*|<macro|sym|nr|body|<float|footnote||<smaller|<surround|<locus|<id|<hard-id|<arg|body>>>|<link|hyperlink|<id|<hard-id|<arg|body>>>|<url|<merge|#footnr-|<arg|nr>>>>|<arg|sym>><footnote-sep>|<set-binding|<merge|footnote-|<arg|nr>>|<value|the-label>|body><right-flush>|<arg|body>>>>>>>
  </tm-fragment>

  Let us read them from the top.

  <\enumerate>
    <item><markup|footnote> first calls <markup|next-footnote>, which
    increments the footnote counter. Like every counter created with
    <markup|new-counter>, it also stores the new number in the environment
    variable <src-var|the-label> (see Section <reference|sec-bindings>).

    <item>It then calls the hook <markup|render-footnote> with the displayed
    number <markup|the-footnote> and the text of the note.

    <item>Back in the main text it places a <markup|label> called
    <verbatim|footnr-1> (for the first footnote) and, as a superscript, a
    <markup|reference> to <verbatim|footnote-1>. The number you see in the
    text is therefore a reference, which is why it is clickable.

    <item><markup|render-footnote> simply calls <markup|render-footnote*>
    with the number used twice, once as the symbol to display (<src-arg|sym>)
    and once as the number used in the names of the labels (<src-arg|nr>).

    <item><markup|render-footnote*> creates a <markup|float> of type
    <verbatim|footnote>, which the page breaker moves to the bottom of the
    page. Inside, the symbol is wrapped into a <markup|locus> with a
    <verbatim|hyperlink> to <verbatim|#footnr-1>: clicking the number in the
    footnote takes you back to the text. Then comes <markup|footnote-sep> (by
    default a period and a space) and finally a <markup|set-binding> which
    defines <verbatim|footnote-1> as the current value of
    <src-var|the-label>.
  </enumerate>

  This is more precise than the description in the forum thread (<hlink|post
  1|http://forum.texmacs.cn/t/undocumented-internal-macros-in-texmacs-wiki/224/1>):
  <verbatim|footnote-N> is not created by a <markup|label> but by a
  <markup|set-binding>, and the label <verbatim|footnr-N> is placed by
  <markup|footnote>, not by <markup|render-footnote*>. The third argument of
  <markup|set-binding>, here the macro argument name <verbatim|body>, tells
  the typesetter where the binding should point: references and page
  references to <verbatim|footnote-1> lead to the beginning of the text of
  the footnote.

  The split between <markup|render-footnote> and <markup|render-footnote*>
  presumably exists so that you can display a symbol different from the
  number, for instance an asterisk or a dagger, while keeping numbered
  labels.

  <paragraph|Example: footnotes with bracketed numbers.>

  <\tm-fragment>
    <inactive*|<assign|footnote-sep|<macro|: >>>

    <inactive*|<assign|render-footnote|<macro|nr|body|<render-footnote*|<with|font-series|bold|[<arg|nr>]>|<arg|nr>|<arg|body>>>>>
  </tm-fragment>

  With these definitions the footnotes read \P<strong|[1]>: Customized
  footnote body.\Q Since the labels still exist, you can refer to a note and
  to the place where it was called:

  <\tm-fragment>
    <inactive*|See note <reference|footnote-1> on page <pageref|footnote-1>;
    it is called on page <pageref|footnr-1>.>
  </tm-fragment>

  <paragraph|A remark about HTML.>The HTML exporter keeps only the body of a
  <markup|locus> and ignores <markup|set-binding>. In the exported page the
  footnote mark points to <verbatim|#footnote-1>, but the footnote itself
  gets no such anchor and there is no link back. The scripts which generate
  this website add the missing anchor after the export.

  <section|Labels, references and bindings><label|sec-bindings>

  Footnotes have shown that references are based on a more general mechanism:
  <em|bindings>. A binding associates a key with a value (and with the page
  on which it was defined). It is created by the primitive
  <markup|set-binding>, listed in the forum thread, and read by
  <markup|get-binding>:

  <\description>
    <item*|<inactive*|<set-binding|key|value>>>Binds <src-arg|key> to
    <src-arg|value>. It produces no visible output. An optional third
    argument names a macro argument whose position is used as the target of
    the binding.

    <item*|<inactive*|<set-binding|value>>>With a single argument, binds
    every key collected in the variable <src-var|the-tags> (by enclosing
    <markup|tag> macros) to <src-arg|value>, clears <src-var|the-tags>, and
    sets <src-var|the-label> to <src-arg|value>.

    <item*|<inactive*|<get-binding|key>>>Returns the value bound to
    <src-arg|key>; <inactive*|<get-binding|key|1>> returns the page number
    instead.

    <item*|<inactive*|<has-binding|key>>>Returns <verbatim|true> or
    <verbatim|false>.
  </description>

  Now we can read the default definitions of <markup|label> and
  <markup|reference> in <tm-src|src/Typeset/Env/env_default.cpp>. In
  <TeXmacs> notation they are, up to some details,

  <\tm-fragment>
    <inactive*|<assign|label|<macro|Id|<locus|<id|<hard-id|<arg|Id>>>|<link|anchor|<id|<merge|#|<arg|Id>>>>|<set-binding|<arg|Id>|<value|the-label>>>>>>

    <inactive*|<assign|reference|<macro|Id|<locus|<id|<hard-id|<arg|Id>>>|<link|hyperlink|<id|<hard-id|<arg|Id>>>|<url|<merge|#|<arg|Id>>>>|<get-binding|<arg|Id>>>>>>
  </tm-fragment>

  A <markup|label> binds its name to the current value of
  <src-var|the-label>, and a <markup|reference> displays the value bound to
  the name inside a link to it. Where does <src-var|the-label> come from?
  From the counters. The <markup|new-counter> macro of
  <tm-src|TeXmacs/packages/standard/std-counter.ts> defines, for a counter
  <verbatim|X>, a macro <markup|next-X> which increments the counter and then
  executes <inactive*|<set-binding|<the-X>>>, the one-argument form which
  sets <src-var|the-label>. This is why a label placed after a numbered
  section, equation or footnote picks up the right number.

  <paragraph|Example: playing with bindings.>Try the following in a document.
  The easiest way to enter it is in source mode; in normal mode, typing
  <verbatim|\\set-binding> and <verbatim|Return> inserts the one-argument
  form, still inactive; a second argument is added with <menu|Focus|Insert
  argument after>, and <verbatim|Return> activates the tag.

  <\tm-fragment>
    <inactive*|<set-binding|my-key|Hello>Value: <reference|my-key>,
    <get-binding|my-key>. Defined: <has-binding|my-key>,
    <has-binding|other>.>

    <inactive*|<set-binding|Alpha><label|lab-b>See <reference|lab-b>.>

    <inactive*|<tag|tag-d|<set-binding|Delta>>See <reference|tag-d>.>
  </tm-fragment>

  The output is \PValue: Hello, Hello. Defined: true, false.\Q, then \PSee
  Alpha.\Q and \PSee Delta.\Q The second line shows that a label can be given
  any text as its value, not only a number. The third uses <markup|tag>,
  which attaches a label to the next one-argument <markup|set-binding> inside
  its body.

  <paragraph|Bindings need several passes.>A reference can come before the
  corresponding label, so its value is not known during the first
  typesetting. <TeXmacs> stores the bindings of a document (you can see them
  in the <verbatim|\<less\>references\|...\<gtr\>> section at the end of a
  saved <verbatim|.tm> file) and uses the values of the previous pass.
  <menu|Document|Update|All> regenerates the auxiliary data and typesets the
  document again (once by default; the number of passes can be changed in the
  preferences); repeat it if some references are still wrong. Undefined
  references are displayed as \P?\Q. From Scheme, you can inspect the current
  bindings with <scm|(list-references)> and <scm|(get-reference "my-key")>,
  which returns the value together with the page number.

  <paragraph|Redefining references.>Since <markup|reference> is a macro, a
  document can redefine it. The following puts every reference between
  brackets (including the footnote marks, which are references too):

  <\tm-fragment>
    <inactive*|<assign|reference|<macro|Id|<locus|<id|<hard-id|<arg|Id>>>|<link|hyperlink|<id|<hard-id|<arg|Id>>>|<url|<merge|#|<arg|Id>>>>|[<get-binding|<arg|Id>>]>>>>
  </tm-fragment>

  The <verbatim|preview-ref> package (in <tm-src|TeXmacs/packages/utilities/preview-ref.ts>)
  uses exactly this technique to show a preview of the target when the mouse
  hovers over a reference.

  <section|Loci, links and the linking tool><label|sec-links>

  Most of the remaining tags of the forum thread (<markup|locus>,
  <markup|id>, <markup|url>, <markup|link>, <markup|observer>,
  <markup|script> and <markup|hard-id>) belong to the <em|linking
  primitives>, a general system for attaching identities to parts of
  documents and for connecting them with typed links. Hyperlinks, references,
  footnote back-links, actions and \Pmirrors\Q are all built on top of it.
  This part of <TeXmacs> is almost entirely undocumented, so it deserves a
  closer look.

  <subsection|The tags>

  <\description>
    <item*|<inactive*|<locus|item-1|...|item-n|body>>>A locus is a piece of
    the document, <src-arg|body>, which can be the source or the target of
    links. The arguments before the body are <markup|id>, <markup|link> or
    <markup|observer> tags. When the locus is typeset, its identifiers are
    registered in a global <em|link repository> and the body is displayed in
    the <src-var|locus-color> (or <src-var|visited-color> once it has been
    followed). Clicking on a locus follows its links.

    <item*|<inactive*|<id|identifier>>>Gives an identifier to the surrounding
    locus. Several loci may share the same identifier (for instance after a
    copy and paste); they then behave as a single entity.

    <item*|<inactive*|<link|type|vertex-1|...|vertex-n>>>A link of a given
    type (<verbatim|hyperlink>, <verbatim|action>, <verbatim|anchor>,
    <verbatim|mouse-over>, or any name you like) between several
    <em|vertices>. A vertex is an <markup|id> (another locus), an
    <markup|url> or a <markup|script>.

    <item*|<inactive*|<url|location>>>A vertex pointing to a document, a web
    page or an anchor (<verbatim|#name>) inside a document.

    <item*|<inactive*|<script|function|arg-1|...>>>A vertex which runs a
    Scheme function when the link is followed. Following such links is
    subject to the security settings of <TeXmacs>. (Do not confuse this tag
    with the <verbatim|scripts> package (in
    <verbatim|packages/compute/scripts.ts>) or with mathematical sub- and
    superscripts.)

    <item*|<inactive*|<observer|identifier|callback>>>Attaches a Scheme
    function to the locus, which is called when the content of the locus
    changes. The callback is only registered if it is declared secure (with
    <scm|(:secure #t)> in its <scm|tm-define>) or if the document is in a
    secure location (a directory listed in <verbatim|$TEXMACS_SECURE_PATH>).

    <item*|<inactive*|<hard-id|content>>>Returns an identifier for
    <src-arg|content>, valid during the current editing session. The argument
    is optional.
  </description>

  As noted in the forum thread for <markup|id>, <markup|url> and
  <markup|link> (and as we checked, also for <markup|script> and
  <markup|observer>), these tags have no effect outside a <markup|locus>: on
  their own they are just displayed as inactive markup.

  About <markup|hard-id> the thread (<hlink|post
  1|http://forum.texmacs.cn/t/undocumented-internal-macros-in-texmacs-wiki/224/1>)
  says that it generates a hash from the given text. This is not quite right.
  Its implementation (<verbatim|exec_hard_id> in
  <tm-src|src/Typeset/Env/env_exec.cpp>) returns a string built from the
  memory addresses of the typesetting environment and of its argument, like
  <verbatim|%134FBF300-127B80>; a hash of the content is added only for
  arguments which do not come from the document. Two
  <inactive*|<hard-id|abc>> in the same document therefore yield
  <em|different> values, and the values change from one session to the next.
  On the other hand, the same argument tree always gives the same value,
  which is why <markup|hlink> below can write
  <inactive*|<hard-id|<arg|body>>> twice and obtain matching identifiers. The
  values are never saved: <markup|hard-id> is meant to give an anonymous
  identity to an object that only needs to be found again during the current
  session, typically the locus of a hyperlink.

  <subsection|Everyday links are loci>

  The definition of <markup|hlink> in <tm-src|src/Typeset/Env/env_default.cpp>
  is

  <\tm-fragment>
    <inactive*|<assign|hlink|<macro|body|destination|<locus|<id|<hard-id|<arg|body>>>|<link|hyperlink|<id|<hard-id|<arg|body>>>|<url|<arg|destination>>>|<arg|body>>>>>
  </tm-fragment>

  This is the first structure described by
  <hlink|jingkaimori|http://forum.texmacs.cn/u/jingkaimori> (<hlink|post
  7|http://forum.texmacs.cn/t/undocumented-internal-macros-in-texmacs-wiki/224/7>):
  a locus with an anonymous identity and one link of type
  <verbatim|hyperlink> from that identity to the destination URL. Similarly,
  <markup|action> creates a link of type <verbatim|action> to a
  <markup|script>, and we have already seen that <markup|label>,
  <markup|reference> and footnotes use loci too.

  You can write such a locus by hand. In the following two lines, the first
  locus has a link to an external page, the second has a link to a third
  locus somewhere else in the document:

  <\tm-fragment>
    <inactive*|<locus|<id|+web1>|<link|hyperlink|<id|+web1>|<url|https://www.texmacs.org>>|TeXmacs
    site>>

    <inactive*|<locus|<id|+srcA>|<link|hyperlink|<id|+srcA>|<id|+dstB>>|go to
    target> ... <locus|<id|+dstB>|the target>>
  </tm-fragment>

  Clicking on \Pgo to target\Q moves the cursor to \Pthe target\Q. The
  converse does not happen, because <TeXmacs> by default does not follow
  links backwards (see <menu|Link|Navigation options>). Hand-made loci work
  in the editor. In PDF output, loci whose link points to an <markup|url>
  (including <verbatim|#label>) become clickable, while links between two
  loci only work in the editor; the HTML exporter keeps only the body of a
  locus. For web pages, use <markup|hlink>.

  <subsection|The linking tool>

  Loci can also be created interactively. Enable <menu|Tools|Linking tool>; a
  <menu|Link> menu appears. The procedure found by
  <hlink|jeroen|http://forum.texmacs.cn/u/jeroen> (<hlink|post
  8|http://forum.texmacs.cn/t/undocumented-internal-macros-in-texmacs-wiki/224/8>)
  is:

  <\enumerate>
    <item>Insert a locus with <menu|Link|New locus> and type some text in it.

    <item>With the cursor inside it, choose <menu|Link|Source>.

    <item>Insert a second locus elsewhere and choose <menu|Link|Target|Locus>
    inside it. (<menu|Link|Target|Url> and <menu|Link|Target|Script> set
    other kinds of targets.)

    <item>Create the link with <menu|Link|Create link|hyperlink>, or choose
    <menu|Other> to give the link a type of your own.
  </enumerate>

  The <menu|Link|Link mode> submenu decides where the link is stored. In the
  default <menu|Bidirectional> mode, the same <markup|link> is inserted in
  both loci, so that the link is known whichever of the two loci is loaded;
  <menu|Simple> stores it only in the source, and <menu|External> only in the
  locus which contains the cursor when the link is created (possibly in a
  third document), so that links between files can be kept separately. Other
  entries of the menu are <menu|Delete link>, <menu|Locus rendering>,
  <menu|Active link types> (which link types are followed on a click) and
  <menu|Extract>, whose entries <menu|Loci> and <menu|Constellation> list the
  loci of the document and the documents known to the link repository.

  Two warnings. First, a user reported several crashes while experimenting
  with the linking tool, so save your work before trying it. Second, while
  writing this article we found that <menu|Link|Delete link> in bidirectional
  mode removes the link only from the current locus and not from its partner:
  inside <tm-src|TeXmacs/progs/link/link-edit.scm> a local definition of
  <verbatim|link-vertices> shadows the global one used to find the other end
  of the link. The same shadowing breaks <verbatim|link-source> and
  <verbatim|link-target>, so that in <menu|Simple> mode the <menu|Delete
  link> entry fails altogether (and possibly the whole <menu|Link> menu,
  which uses the same function to decide whether to show it). Moreover, the
  test which selects the links of the current locus in that mode compares an
  identifier with a vertex <inactive*|<id|...>>, so it would fail even with
  the shadowing fixed.

  <subsection|Loci from Scheme>

  <hlink|jeroen|http://forum.texmacs.cn/u/jeroen> also explored the Scheme
  interface to loci (<hlink|post 6|http://forum.texmacs.cn/t/undocumented-internal-macros-in-texmacs-wiki/224/6>).
  The functions are defined in <tm-src|TeXmacs/progs/link/locus-edit.scm>,
  <tm-src|TeXmacs/progs/link/link-edit.scm> and
  <tm-src|TeXmacs/progs/link/link-navigate.scm>, and in the C++ glue. They
  are available globally. The functions which only read or change loci by
  identifier can be tried in a Scheme session (in the same window as the
  document, or with the document as the current buffer). With the two loci
  <verbatim|+srcA> and <verbatim|+dstB> of the example above in the current
  document:

  <\scm-code>
    (id-\<gtr\>trees "+dstB") \ \ \ \ \ \ \ \ \ ; =\<gtr\> the bodies of the
    loci with id +dstB

    (id-\<gtr\>loci "+dstB") \ \ \ \ \ \ \ \ \ \ ; =\<gtr\> the locus trees
    themselves

    (locus-id (car (id-\<gtr\>loci "+srcA"))) \ \ \ \ \ \ ; =\<gtr\> "+srcA"

    (current-link-types) \ \ \ \ \ \ \ \ ; =\<gtr\> ("hyperlink") : link
    types in use

    (map tm-\<gtr\>stree (vertex-\<gtr\>links '(id "+srcA")))

    ;; =\<gtr\> ((link "hyperlink" (attr "secure" "false") (id "+srcA") (id
    "+dstB")))

    (locus-set "+dstB" '(strong "replaced")) \ ; change every +dstB locus
  </scm-code>

  A few things to keep in mind:

  <\itemize>
    <item>Loci are registered when they are typeset, so these functions only
    see loci which have been displayed at least once.

    <item><scm|id-\<gtr\>loci> returns the locus trees, and
    <scm|id-\<gtr\>trees> their bodies (the contents).

    <item>Identifiers are not unique: if you copy a locus, both copies keep
    the same identifier, and <scm|locus-set> changes all of them. Use
    <scm|(create-unique-id)> to obtain fresh identifiers like
    <verbatim|+1XmE6jQ4UQg>, which is what <menu|Link|New locus> does.

    <item><scm|(locus-link-types #t)> and <scm|(locus-link-follow)> work on
    the locus at the cursor, like the menu entries.
  </itemize>

  The menu actions themselves can be scripted, but since they act at the
  cursor, they must run with the cursor in the document, not in a Scheme
  session: put them in a function and bind it to a key (see the companion
  article <hlink|Customizing <TeXmacs> with Scheme|scheme-snippets.tm>). The
  following creates two loci at the cursor and a hyperlink between them,
  exactly as the steps of the previous subsection:

  <\scm-code>
    (make-locus) \ \ \ \ \ \ \ \ \ ; like Link -\<gtr\> New locus

    (insert "first")

    (link-set-locus 0) \ \ \ ; like Link -\<gtr\> Source

    ;; ... move the cursor elsewhere ...

    (make-locus)

    (insert "second")

    (link-set-locus 1) \ \ \ ; like Link -\<gtr\> Target -\<gtr\> Locus

    (make-link "hyperlink")
  </scm-code>

  <subsection|Observers and mirrors>

  The second structure described by <hlink|jingkaimori|http://forum.texmacs.cn/u/jingkaimori>
  (<hlink|post 7|http://forum.texmacs.cn/t/undocumented-internal-macros-in-texmacs-wiki/224/7>)
  uses an <markup|observer>. It is what the <markup|mirror> tag of the
  <verbatim|relate> package expands to (see
  <tm-src|TeXmacs/packages/utilities/relate.ts>):

  <\tm-fragment>
    <inactive*|<locus|<id|channel>|<observer|unique-id|mirror-notify>|<surround|<hidden|<extern|mirror-initialize|...>>||body>>>
  </tm-fragment>

  Note that the identifier of the locus (a \Pchannel\Q) and the identifier of
  the observer (unique to each instance) are different. All loci sharing the
  same channel identifier are kept synchronized: whenever the body of one of
  them changes, the Scheme callback <verbatim|mirror-notify> (in
  <tm-src|TeXmacs/progs/part/part-shared.scm>) copies the new content into
  the others. To try it, add the <verbatim|relate> package to a document with
  <menu|Document|Style|Add package>; a <menu|Relate> menu with a
  <menu|Mirror> entry appears. Insert a mirror (you are asked for the name of
  a channel), insert a second mirror with the same channel name, or copy and
  paste the first one, and edit one of the copies.

  <section|Title data: <markup|doc-author> and
  <markup|doc-authors>><label|sec-title>

  The last entry of the thread concerns <markup|doc-authors>, a macro which
  is easily confused with <markup|doc-author>. As
  <hlink|sharkc|http://forum.texmacs.cn/u/sharkc> explained (<hlink|post
  10|http://forum.texmacs.cn/t/undocumented-internal-macros-in-texmacs-wiki/224/10>),
  it is not meant to be typed by the user. The title block of a document is a
  <markup|doc-data> tag, whose children are the title, the authors, the date
  and so on:

  <\tm-fragment>
    <inactive*|<doc-data|<doc-title|Two authors>|<doc-author|<author-data|<author-name|Ada
    Lovelace>|<author-email|ada@example.org>>>|<doc-author|<author-data|<author-name|Alan
    Turing>|<author-affiliation|Bletchley Park>>>>>
  </tm-fragment>

  This is what you get by inserting a title and then adding a second author
  from the focus toolbar while the cursor is in the title. The macro
  <markup|doc-data>, defined in <tm-src|TeXmacs/packages/header/title-base.ts>,
  does not typeset its arguments directly. It is an <markup|xmacro> which
  passes them, with <markup|extern>, to the Scheme function
  <verbatim|doc-data> of <tm-src|TeXmacs/progs/database/title-markup.scm>.
  That function applies the options of the title (abbreviated authors,
  clustering by affiliation, ...) and reorganizes the data; in particular it
  groups two or more <markup|doc-author> children into a single
  <markup|doc-authors>:

  <\scm-code>
    (tm-define (doc-data-main t)

    \ \ `(document

    \ \ \ \ \ ,@(select t '(doc-title))

    \ \ \ \ \ ,@(select t '(doc-subtitle))

    \ \ \ \ \ ,@(with authors (select t '(doc-author))

    \ \ \ \ \ \ \ \ \ (if (\<less\>= (length authors) 1) authors

    \ \ \ \ \ \ \ \ \ \ \ \ \ (list `(doc-authors ,@authors))))

    \ \ \ \ \ ,@(select t '(doc-date))

    \ \ \ \ \ ,@(select t '(doc-misc))

    \ \ \ \ \ ,@(select t '(doc-inactive))))
  </scm-code>

  The resulting tree is then typeset. <markup|doc-authors> is therefore a
  <em|rendering hook> in the sense of Section <reference|sec-hooks>: its role
  is to arrange several authors side by side, and a style can redefine it to
  change that layout. To give a document several authors, simply add several
  <markup|doc-author> entries; writing <markup|doc-authors> yourself inside
  <markup|doc-data> makes the authors disappear, because the Scheme code only
  looks for <markup|doc-author> children. (The manual calls these hooks
  <verbatim|render-doc-authors> and <verbatim|render-doc-author> in its
  section on customizing titles; the first does not exist, and the second
  only in the <verbatim|book> and <verbatim|seminar> title styles. The macros
  used by the standard styles are <markup|doc-authors> and
  <markup|doc-author>.)

  The same pattern, a macro which delegates the structure to Scheme with
  <markup|extern> and lets the result be typeset by ordinary macros, is used
  elsewhere in <TeXmacs>. It explains why some tags cannot be inserted
  manually with the expected effect: they are the <em|output> of a Scheme
  transformation, not its input.

  <section|Summary>

  <\itemize>
    <item>Tags are either C++ primitives or macros stored in the environment;
    macros, including some that look like primitives, can be redefined by
    documents and style packages.

    <item>The standard styles separate logic from presentation: the
    <markup|render-*> hooks and the small <markup|*-name>, <markup|*-sep> and
    <markup|*-text> macros are the intended places for customization.

    <item>Labels, references, counters and footnotes all rest on bindings,
    created by <markup|set-binding> and read by <markup|get-binding>.

    <item>Loci, identified by <markup|id> and connected by typed
    <markup|link>s, implement hyperlinks, references, actions and mirrors;
    the linking tool and a Scheme API let you build your own.

    <item>Some macros, like <markup|doc-authors>, are produced by Scheme code
    and should not be inserted by hand.
  </itemize>

  The forum thread remains open for further discoveries; corrections and
  additions to this article are welcome as pull requests to the
  <hlink|repository of this website|https://github.com/texmacs/notes>.
</body>

<initial|<\collection>
</collection>>

<\references>
  <\collection>
    <associate|auto-1|<tuple|?|?>>
    <associate|auto-10|<tuple|<with|mode|<quote|math>|\<bullet\>>|?>>
    <associate|auto-11|<tuple|<with|mode|<quote|math>|\<bullet\>>|?>>
    <associate|auto-12|<tuple|<with|mode|<quote|math>|\<bullet\>>|?>>
    <associate|auto-13|<tuple|<with|mode|<quote|math>|\<bullet\>>|?>>
    <associate|auto-14|<tuple|<with|mode|<quote|math>|\<bullet\>>|?>>
    <associate|auto-15|<tuple|<with|mode|<quote|math>|\<bullet\>>|?>>
    <associate|auto-16|<tuple|<with|mode|<quote|math>|\<bullet\>>|?>>
    <associate|auto-17|<tuple|<with|mode|<quote|math>|\<bullet\>>|?>>
    <associate|auto-18|<tuple|<with|mode|<quote|math>|\<bullet\>>|?>>
    <associate|auto-19|<tuple|2|?>>
    <associate|auto-2|<tuple|?|?>>
    <associate|auto-20|<tuple|2|?>>
    <associate|auto-21|<tuple|1|?>>
    <associate|auto-22|<tuple|1|?>>
    <associate|auto-23|<tuple|1|?>>
    <associate|auto-24|<tuple|1|?>>
    <associate|auto-25|<tuple|1|?>>
    <associate|auto-26|<tuple|2|?>>
    <associate|auto-27|<tuple|3|?>>
    <associate|auto-28|<tuple|1|?>>
    <associate|auto-29|<tuple|2|?>>
    <associate|auto-3|<tuple|1|?>>
    <associate|auto-30|<tuple|4|?>>
    <associate|auto-31|<tuple|1|?>>
    <associate|auto-32|<tuple|1|?>>
    <associate|auto-33|<tuple|2|?>>
    <associate|auto-34|<tuple|2|?>>
    <associate|auto-35|<tuple|3|?>>
    <associate|auto-36|<tuple|5|?>>
    <associate|auto-37|<tuple|5.1|?>>
    <associate|auto-38|<tuple|5.2|?>>
    <associate|auto-39|<tuple|5.2|?>>
    <associate|auto-4|<tuple|1|?>>
    <associate|auto-40|<tuple|5.3|?>>
    <associate|auto-41|<tuple|5.3|?>>
    <associate|auto-42|<tuple|5.3|?>>
    <associate|auto-43|<tuple|1|?>>
    <associate|auto-44|<tuple|2|?>>
    <associate|auto-45|<tuple|3|?>>
    <associate|auto-46|<tuple|3|?>>
    <associate|auto-47|<tuple|3|?>>
    <associate|auto-48|<tuple|4|?>>
    <associate|auto-49|<tuple|4|?>>
    <associate|auto-5|<tuple|1|?>>
    <associate|auto-50|<tuple|4|?>>
    <associate|auto-51|<tuple|4|?>>
    <associate|auto-52|<tuple|4|?>>
    <associate|auto-53|<tuple|4|?>>
    <associate|auto-54|<tuple|4|?>>
    <associate|auto-55|<tuple|4|?>>
    <associate|auto-56|<tuple|4|?>>
    <associate|auto-57|<tuple|4|?>>
    <associate|auto-58|<tuple|4|?>>
    <associate|auto-59|<tuple|4|?>>
    <associate|auto-6|<tuple|2|?>>
    <associate|auto-60|<tuple|4|?>>
    <associate|auto-61|<tuple|4|?>>
    <associate|auto-62|<tuple|4|?>>
    <associate|auto-63|<tuple|4|?>>
    <associate|auto-64|<tuple|5.4|?>>
    <associate|auto-65|<tuple|<with|mode|<quote|math>|\<bullet\>>|?>>
    <associate|auto-66|<tuple|5.5|?>>
    <associate|auto-67|<tuple|5.5|?>>
    <associate|auto-68|<tuple|5.5|?>>
    <associate|auto-69|<tuple|5.5|?>>
    <associate|auto-7|<tuple|3|?>>
    <associate|auto-70|<tuple|6|?>>
    <associate|auto-71|<tuple|7|?>>
    <associate|auto-8|<tuple|4|?>>
    <associate|auto-9|<tuple|5|?>>
    <associate|sec-bindings|<tuple|4|?>>
    <associate|sec-footnotes|<tuple|3|?>>
    <associate|sec-hooks|<tuple|2|?>>
    <associate|sec-links|<tuple|5|?>>
    <associate|sec-model|<tuple|1|?>>
    <associate|sec-title|<tuple|6|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|idx>
      <tuple|<tuple|<with|font-family|<quote|ss>|Document>|<with|font-family|<quote|ss>|Source>|<with|font-family|<quote|ss>|Edit
      source tree>>|<pageref|auto-2>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Document>|<with|font-family|<quote|ss>|Source>|<with|font-family|<quote|ss>|Edit
      source tree>>|<pageref|auto-5>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Preferences for
      tag>>|<pageref|auto-10>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Focus>|<with|font-family|<quote|ss>|Preferences>>|<pageref|auto-11>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Edit
      macro>>|<pageref|auto-12>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Edit
      source>>|<pageref|auto-13>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Describe
      tag>>|<pageref|auto-14>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Document>|<with|font-family|<quote|ss>|Source>|<with|font-family|<quote|ss>|Edit
      source tree>>|<pageref|auto-15>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Tools>|<with|font-family|<quote|ss>|Developer
      tool>>|<pageref|auto-16>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Developer>>|<pageref|auto-17>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Insert>|<with|font-family|<quote|ss>|Session>|<with|font-family|<quote|ss>|Scheme>>|<pageref|auto-18>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Pseudo
      code>>|<pageref|auto-20>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Document>|<with|font-family|<quote|ss>|Part>|<with|font-family|<quote|ss>|Create
      preamble>>|<pageref|auto-23>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Show
      preamble>>|<pageref|auto-24>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Edit
      macro>>|<pageref|auto-25>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Focus>|<with|font-family|<quote|ss>|Insert
      argument after>>|<pageref|auto-32>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Document>|<with|font-family|<quote|ss>|Update>|<with|font-family|<quote|ss>|All>>|<pageref|auto-34>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Link>|<with|font-family|<quote|ss>|Navigation
      options>>|<pageref|auto-39>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Tools>|<with|font-family|<quote|ss>|Linking
      tool>>|<pageref|auto-41>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Link>>|<pageref|auto-42>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Link>|<with|font-family|<quote|ss>|New
      locus>>|<pageref|auto-43>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Link>|<with|font-family|<quote|ss>|Source>>|<pageref|auto-44>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Link>|<with|font-family|<quote|ss>|Target>|<with|font-family|<quote|ss>|Locus>>|<pageref|auto-45>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Link>|<with|font-family|<quote|ss>|Target>|<with|font-family|<quote|ss>|Url>>|<pageref|auto-46>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Link>|<with|font-family|<quote|ss>|Target>|<with|font-family|<quote|ss>|Script>>|<pageref|auto-47>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Link>|<with|font-family|<quote|ss>|Create
      link>|<with|font-family|<quote|ss>|hyperlink>>|<pageref|auto-48>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Other>>|<pageref|auto-49>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Link>|<with|font-family|<quote|ss>|Link
      mode>>|<pageref|auto-50>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Bidirectional>>|<pageref|auto-51>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Simple>>|<pageref|auto-52>>

      <tuple|<tuple|<with|font-family|<quote|ss>|External>>|<pageref|auto-53>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Delete
      link>>|<pageref|auto-54>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Locus
      rendering>>|<pageref|auto-55>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Active link
      types>>|<pageref|auto-56>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Extract>>|<pageref|auto-57>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Loci>>|<pageref|auto-58>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Constellation>>|<pageref|auto-59>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Link>|<with|font-family|<quote|ss>|Delete
      link>>|<pageref|auto-60>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Simple>>|<pageref|auto-61>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Delete
      link>>|<pageref|auto-62>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Link>>|<pageref|auto-63>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Link>|<with|font-family|<quote|ss>|New
      locus>>|<pageref|auto-65>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Document>|<with|font-family|<quote|ss>|Style>|<with|font-family|<quote|ss>|Add
      package>>|<pageref|auto-67>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Relate>>|<pageref|auto-68>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Mirror>>|<pageref|auto-69>>
    </associate>
    <\associate|table>
      <tuple|normal|<\surround|<hidden-binding|<tuple>|1>|>
        Some rendering hooks of the standard styles.
      </surround>|<pageref|auto-21>>
    </associate>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Behind
      the markup: internal macros of T<rsub|<space|-0.4spc><move|<resize|<with|math-level|<quote|0>|E>||||0.5fn>|0fn|-0.1fn>><space|-0.4spc>X<rsub|<space|-0.4spc><move|<resize|M<space|-0.2spc>A<space|-0.4spc>CS||||0.5fn>|0fn|-0.1fn>>>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-1><vspace|0.5fn>

      1.<space|2spc>How T<rsub|<space|-0.4spc><move|<resize|<with|math-level|<quote|0>|E>||||0.5fn>|0fn|-0.1fn>><space|-0.4spc>X<rsub|<space|-0.4spc><move|<resize|M<space|-0.2spc>A<space|-0.4spc>CS||||0.5fn>|0fn|-0.1fn>>
      turns markup into pages <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3>

      <with|par-left|<quote|3tab>|Documents are trees.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4>>

      <with|par-left|<quote|3tab>|Primitives and macros.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6>>

      <with|par-left|<quote|3tab>|The environment.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-7>>

      <with|par-left|<quote|3tab>|Some primitives are macros in disguise.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-8>>

      <with|par-left|<quote|3tab>|How to look under the hood yourself.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-9>>

      2.<space|2spc>The <with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|render-*>
      hooks <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-19>

      <with|par-left|<quote|3tab>|Example: theorems with a dash.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-22>>

      <with|par-left|<quote|3tab>|Example: compact lists, renamed abstract.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-26>>

      3.<space|2spc>Footnotes from the inside
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-27>

      <with|par-left|<quote|3tab>|Example: footnotes with bracketed numbers.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-28>>

      <with|par-left|<quote|3tab>|A remark about HTML.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-29>>

      4.<space|2spc>Labels, references and bindings
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-30>

      <with|par-left|<quote|3tab>|Example: playing with bindings.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-31>>

      <with|par-left|<quote|3tab>|Bindings need several passes.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-33>>

      <with|par-left|<quote|3tab>|Redefining references.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-35>>

      5.<space|2spc>Loci, links and the linking tool
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-36>

      <with|par-left|<quote|1tab>|5.1.<space|2spc>The tags
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-37>>

      <with|par-left|<quote|1tab>|5.2.<space|2spc>Everyday links are loci
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-38>>

      <with|par-left|<quote|1tab>|5.3.<space|2spc>The linking tool
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-40>>

      <with|par-left|<quote|1tab>|5.4.<space|2spc>Loci from Scheme
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-64>>

      <with|par-left|<quote|1tab>|5.5.<space|2spc>Observers and mirrors
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-66>>

      6.<space|2spc>Title data: <with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|doc-author>
      and <with|mode|<quote|src>|color|<quote|blue>|font-family|<quote|ss>|doc-authors>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-70>

      7.<space|2spc>Summary <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-71>
    </associate>
  </collection>
</auxiliary>