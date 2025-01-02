<TeXmacs|2.1.4>

<style|<tuple|notes|doc>>

<\body>
  <\hide-preamble>
    \;
  </hide-preamble>

  <notes-header>

  <chapter*|Font mechanics>

  <notes-abstract|We describe the various mechanisms and features of TeXmacs
  font handling, from the user interface at the level of documents to the
  inner workings of the various fonts types at the level of the
  <verbatim|C++> source code. TeXmacs implements sophisticate algorithms to
  allow to use a wide variety of fonts despite of the facts that they do to
  have all the necessary glyphs, especially for the typesetting of technical
  documents.>

  [Version 1.0 of 3.1.2025. By <hlink|@mgubi|https://github.com/mgubi>]

  This document aims to describe the way <TeXmacs> deals with fonts. We
  describe the state of affairs as per <verbatim|svn> revision <tt|r14561>
  (December 2024, <tt|TeXmacs 2.14+>). Parts of the general overview of fonts
  in TeXmacs are extracted, for reference, from the official documentation
  and from the paper \PMathematical font art\Q by Joris van der Hoeven.

  <section|Fonts in TeXmacs>

  Philosophically speaking, we think that a font should be characterized by
  the following two essential properties:

  <\enumerate>
    <item>A font associates graphical meanings to
    <with|font-shape|italic|words>. The words can always be represented by
    strings.

    <item>The way this association takes place is coherent as a function of
    the word.
  </enumerate>

  By a word, we either mean a word in a natural language, or a sequence of
  mathematical, technical or artistic symbols. This way of viewing fonts has
  several advantages:

  <\enumerate>
    <item>A font may take care of kerning and ligatures.

    <item>A font may consist of several \Pphysical fonts\Q, which are somehow
    merged together.

    <item>A font might in principle automatically build very complicated
    glyphs like hieroglyphs or large delimiters from words in a well chosen
    encoding.

    <item>A font is an irreducible and persistent entity, not a bunch of
    commands whose actions may depend on some environment.
  </enumerate>

  Notice finally that the \Pgraphical meaning\Q of a word might be more than
  just a bitmap: it might also contain some information about a logical
  bounding box, appropriate places for scripts, etc. Similarly, the
  \Pcoherence of the association\Q should be interpreted in its broadest
  sense: the font might contain additional information for the global
  typesetting of the words on a page, like the recommended distance between
  lines, the height of a fraction bar, etc.

  Fonts are usually made up from glyphs like \Px\Q, \Pffi\Q,
  \P<math|\<alpha\>>\Q, \P<math|<op|<big|sum>>>\Q, <abbr|etc.> When rendering
  a string, the string is decomposed into glyphs so as to take into account
  ligatures (like fi, fl, ff, ffi, ffl). Next, the individual glyphs are
  positioned while taking into account kerning information (in \Pxo\Q the
  \Po\Q character is slightly shifted to the left so as to take profit out of
  the hole in the \Px\Q). In the case of mathematical fonts, <TeXmacs> also
  provides a coherent rendering for resizable characters, like the large
  brackets in

  <\equation*>
    <around*|(|<around*|(|<around*|(||)><rsup|<rsup|\<nosymbol\>>>|)><rsup|<rsup|<rsup|\<nosymbol\>>>>|)>.
  </equation*>

  <section|String encodings>

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

  Universal symbols can also be used to represent mathematical symbols of
  variable sizes like large brackets. The point here is that the shapes of
  such symbols depend on certain size parameters, which can not conveniently
  be thought of as font parameters. This problem is solved by letting the
  extra parameters be part of the symbol. For instance,
  <verbatim|"\<less\>left-(-1\<gtr\>"> would be usual bracket and
  <verbatim|"\<less\>left-(-2\<gtr\>"> a slightly larger one.

  <section|Specifying the current font>

  Font properties may be controlled globally for the whole document in
  <menu|Document|Font> and locally for document fragments in
  <menu|Format|Font>.

  A <em|font family> is a family of fonts with different characteristics
  (like font weight, slant, <abbr|etc.>), but with a globally consistent
  rendering. One also says that the fonts in a font family \Pmix well
  together\Q. For instance, the standard roman font and its
  <with|font-series|bold|bold> and <with|font-shape|italic|italic> variants
  mix well together, but the computer modern roman font and the
  <with|font|avant-garde|Avant Garde> font do not.

  <\remark>
    In versions of <TeXmacs> prior to 1.99.1, the fonts for the mathematical
    and programming modes could be controlled independently using the
    environment variables <src-var|math-font>, <src-var|math-font-family>,
    <src-var|math-font-series>, <src-var|math-font-shape>,
    <src-var|prog-font>, <src-var|prog-font-family>,
    <src-var|prog-font-series>, <src-var|prog-font-shape>. In more recent
    versions of <TeXmacs>, the environment variables <src-var|font>,
    <src-var|font-family>, <src-var|font-series> and <src-var|font-shape>
    directly control the font for all modes.
  </remark>

  <\explain>
    <var-val|font|roman><explain-synopsis|font name>
  <|explain>
    These variables control the main name of the font, also called the
    <em|font family>. For instance:

    <\tm-fragment>
      <with|font|roman|Computer modern roman>, <with|font|Linux
      Libertine|Linux Libertine>, <with|font|chancery|Chancery>,
      <with|font|palatino|Palatino>
    </tm-fragment>

    Similarly, <TeXmacs> supports various mathematical fonts: <todo|Does not
    render correclty>

    <\tm-fragment>
      Roman: <math|a<rsup|2>+b<rsup|2>=c<rsup|2>>

      Adobe: <math|<with|math-font|adobe|a<rsup|2>+b<rsup|2>=c<rsup|2>>>

      New roman: <math|<with|math-font|ENR|a<rsup|2>+b<rsup|2>=c<rsup|2>>>

      Concrete: <math|<with|math-font|concrete|a<rsup|2>+b<rsup|2>=c<rsup|2>>>
    </tm-fragment>

    Most fonts only implement a subset of all Unicode glyphs. Sometimes, the
    user might wish to combine several fonts to cover a larger subset. For
    instance, when specifying <verbatim|roman,IPAMincho> or
    <verbatim|cjk=IPAMincho,roman> as the <src-var|font> name, ordinary text
    and mathematics will be typeset using the default <verbatim|roman> font,
    whereas Chinese text will use the <verbatim|IPAMincho> font. Similarly,
    when specifying <verbatim|math=Stix,roman> as the <src-var|font> name,
    ordinary text will be typeset using the default <verbatim|roman> font,
    but mathematical formulas using the <verbatim|Stix> font.
  </explain>

  <\explain>
    <var-val|font-family|rm><explain-synopsis|font variant>
  <|explain>
    This variable selects a variant of the major font, like a sans serif
    font, a typewriter font, and so on. As explained above, variants of a
    given font are designed to mix well together. Physically speaking, many
    fonts do not come with all possible variants (sans serif, typewriter,
    <abbr|etc.>), in which case <TeXmacs> tries to fall back on a suitable
    alternative font.

    Typical variants for text fonts are <verbatim|rm> (roman), <verbatim|tt>
    (typewriter) and <verbatim|ss> (sans serif):

    <\tm-fragment>
      roman, <with|font-family|tt|typewriter> and <with|font-family|ss|sans
      serif>

      Sans serif formula: <with|font-family|ss|<math|sin
      <around*|(|x+y|)>=sin x*cos y+cos x*sin y>>
    </tm-fragment>
  </explain>

  <\explain>
    <var-val|font-series|medium><explain-synopsis|font weight>
  <|explain>
    The font series determines the weight of the font. Most fonts only
    provide <verbatim|regular> and <verbatim|bold> font weights. Some fonts
    also provide <verbatim|light> as a possible value.

    <\tm-fragment>
      <with|font-series|light|light>, medium, <with|font-series|bold|bold>
    </tm-fragment>
  </explain>

  <\explain>
    <var-val|font-shape|right><explain-synopsis|font shape>
  <|explain>
    The font shape determines other characters of a font, like its slant,
    whether we use small capitals, whether it is condensed, and so on. For
    instance,

    <\tm-fragment>
      <with|font-shape|right|upright>, <with|font-shape|slanted|slanted>,
      <with|font-shape|italic|italic>, <with|font-shape|left-slanted|left
      slanted>, <with|font-shape|small-caps|Small Capitals>,
      <with|font-shape|proportional|<with|font-family|tt|proportional
      typewriter>>, <with|font-shape|condensed|<with|font-series|bold|bold
      condensed>>, <with|font-shape|flat|<with|font-family|ss|flat sans
      serif>>, <with|font-shape|long|long>
    </tm-fragment>
  </explain>

  <\explain>
    <label|font-base-size><var-val|font-base-size|10><explain-synopsis|font
    base size>
  <|explain>
    The base font size is specified in <hlink|<verbatim|pt>
    units|../basics/lengths.en.tm> and is usually invariant throughout the
    document. Usually, the base font size is <verbatim|9pt>, <verbatim|10pt>,
    <verbatim|11pt> or <verbatim|12pt>. Other font sizes are usually obtained
    by changing the <hlink|<src-var|magnification>|env-general.en.tm#magnification>
    or the relative <hlink|font-size|#font-size>.

    <\tm-fragment>
      <with|font-base-size|9|9pt>, <with|font-base-size|10|10pt>,
      <with|font-base-size|11|11pt>, <with|font-base-size|12|12pt>
    </tm-fragment>
  </explain>

  <\explain>
    <label|font-size><var-val|font-size|1><explain-synopsis|font size>
  <|explain>
    The real font size is obtained by multiplying the
    <src-var|font-base-size> by the <src-var|font-size> multiplier. The
    following standard font sizes are available from <menu|Format|Size>:

    <big-table|<descriptive-table|<tformat|<cwith|4|5|1|4|cell-bsep|0.25fn>|<cwith|4|5|1|4|cell-tsep|0.25fn>|<table|<row|<cell|size>|<cell|multiplier>|<cell|size>|<cell|multiplier>>|<row|<cell|<with|font-size|0.59|Tiny>>|<cell|0.59>|<cell|<with|font-size|0.71|Very
    small>>|<cell|0.71>>|<row|<cell|<with|font-size|0.84|Small>>|<cell|0.84>|<cell|<with|font-size|1|Normal>>|<cell|1>>|<row|<cell|<with|font-size|1.19|Large>>|<cell|1.19>|<cell|<with|font-size|1.41|Very
    large>>|<cell|1.41>>|<row|<cell|<with|font-size|1.68|Huge>>|<cell|1.68>|<cell|<with|font-size|2|Really
    huge>>|<cell|2>>>>>|Standard font sizes.>

    From a mathematical point of view, the multipliers are in a geometric
    progression with factor <no-break><math|<sqrt|2|4>>. Notice that the font
    size is also affected by the <hlink|index
    level|env-math.en.tm#math-level>.
  </explain>

  <\explain>
    <var-val|dpi|600><explain-synopsis|fonts rendering quality>
  <|explain>
    The rendering quality of raster fonts (also called Type 3 fonts), such as
    the fonts generated by the <name|Metafont> program is controlled through
    its discretization precision in dots per inch. Nowadays, most laser
    printers offer a printing quality of at least <verbatim|600dpi>, which is
    also the default <src-var|dpi> setting for <TeXmacs>. For really high
    quality printing, professionals usually use a precision of
    <verbatim|1200dpi>. The <src-var|dpi> is usually set once and for all for
    the whole document.
  </explain>

  <section|Font substition and emulation>

  For more details see the paper, J. van der Hoeven, \ \PMathematical font
  art\Q available at <slink|https://www.texmacs.org/joris/fontart/fontart-abs.html>.

  The typesetting of technical documents require a large set of glyphs which
  are typically not available in standard fonts. TeXmacs' general strategy
  for turning existing fonts into full fledged mathematical font families is
  to remedy each of the font's insufficiencies. The most common problems are
  the following:

  <\itemize>
    <item>Lack of the most important font declinations as needed in
    scientific documents: <strong|Bold>, <em|Italic>, <name|Small Capitals>,
    <samp|Sans Serif>, <verbatim|Typewriter>.

    <item>Lack of specific glyphs: non English languages, mathematical
    symbols, and in particular big operators, extensible brackets and wide
    accents.

    <item>Inconsistencies: sloppy design of some glyphs that are important
    for mathematics (such as <math|->, <math|\<less\>>, <abbr|etc.>), leading
    to inconsistencies.
  </itemize>

  The main countermeasures are <em|font substitution> and <em|font
  emulation>. The first technique consists of borrowing missing glyphs from
  other fonts. This can either be done on the level of an entire font
  (<abbr|e.g.> for obtaining bold or italic declinations) or for individual
  characters (<abbr|e.g.> a missing<nbsp><math|\<propto\>> symbol, or lacking
  Greek characters). Font emulation consists of combining and altering the
  glyphs of symbols in a font in order to generate new ones. This can again
  be done for entire fonts or individual glyphs.

  A prerequisite for automatic font substitutions is a detailed analysis of
  the main characteristics of all supported fonts. The results of this
  analysis are stored in a database. Using this database, we may then compute
  the<nbsp>distance between two fonts. In the case when a symbol
  <math|\<sigma\>> is missing in a<nbsp>font<nbsp><math|F<rsub|1>>, it then
  suffices to find the closest font <math|F<rsub|2>> that supports this
  symbol<nbsp><math|\<sigma\>>. Notice that the best substitution font may
  depend on the fonts which are installed on your system.

  In our database we both use discrete font characteristics (<abbr|e.g.> sans
  serif, small capitals, handwritten, ancient, gothic, <abbr|etc.>) and
  continuous ones (<abbr|e.g.> italic slant, height of an \Px\Q symbol,
  <abbr|etc.>). Most characteristics are determined automatically by
  analyzing the name of the font (for some of the discrete characteristics)
  or individual glyphs (for the continuous ones). Some \Pfont categories\Q
  (such as handwritten, gothic, <abbr|etc.>) can be specified manually.

  One of the most important font characteristics is the height of the \Px\Q
  symbol (with respect to the design size). When the font <math|F<rsub|1>>
  borrows a symbol from the font <math|F<rsub|2>> we first scale it by the
  quotient of these x-heights inside <math|F<rsub|1>>
  and<nbsp><math|F<rsub|2>>.

  Other common font characteristics are also taken into account into our
  database, such as the italic slant, the width of the \PM\Q symbol, the
  ascent and descent (above and above the<nbsp>\Px\Q symbol), etc. In
  addition, we carefully analyze the glyphs themselves in order to determine
  the horizontal and vertical stroke widths for the \Po\Q and \PO\Q symbols,
  the average aspect-ratios of uppercase and lowercase letters, and the
  average area of glyphs that is filled (how much ink will be used).

  Font emulation works at the level of glyphs bitmaps, in order to produce
  <strong|Bold>, <em|Italic> and <name|Small Capitals> and \Pblackboard
  bold\Q variations of a given font.

  Missing glyphs can be generated automatically from existing ones using a
  combination of the following main techniques, listed by increasing
  complexity:

  <\itemize>
    <item>Superposition of several glyphs: <math|+> and <math|-> can be
    combined into <math|\<pm\>>, and<nbsp><math|\<ll\>> be obtained by
    juxtaposing two <math|\<less\>> symbols.

    <item>Clipping rectangular areas: cutting <math|\<mapsto\>> and
    <math|\<twoheadrightarrow\>> in their midsts and combining them yields
    <math|\<twoheadmapsto\>>.

    <item>Linear transformations: combining a crushed O and an I, we may
    produce the Greek capital \<Phi*\>. Turning around <math|\<rightarrow\>>,
    we obtain <math|\<uparrow\>>.

    <item>Simple graphical constructs such as circles and lines. This can for
    instance be used for producing the missing half circle of
    <math|\<subset\>>.

    <item>Special <em|ad hoc> transformations that directly operate on the
    pixels of a<nbsp>glyph (or on their outlines if possible). For instance,
    we designed a<nbsp>special \Pcurlyfication\Q method that turns
    <math|\<less\>> into <math|\<prec*\>> and
    <move|<large|<math|<with|font|Papyrus|\<less\>>>>||-0.2ex> into
    <move|<large|<math|<with|font|Papyrus|\<prec*\>>>>||-0.2ex>. Similarly,
    we implemented a \Pflood fill\Q algorithm for transforming
    <math|\<vartriangleleft\>> into <math|\<blacktriangleleft\>>.

    <item>Emulation of uppercase Greek letters is obtained by gluing together
    pieces of certain glyphs to produce others. Lowecase Greek letters are
    not amenable to this approach.
  </itemize>

  One specific problem with mathematical fonts is the need for rubber
  characters. There are essentially four types of them: big operators
  (<math|<op|<big|sum>>>, <math|<op|<big|prod>>>, <math|<op|<big|otimes>>>),
  large delimiters <math|<around|(|<around|<left|(|1>|<around|<left|(|2>||<right|)|2>>|<right|)|1>>|)>>
  <math|<around|{|<around|<left|{|1>|<around|<left|{|2>||<right|}|2>>|<right|}|1>>|}>>,
  wide accents (<math|<wide||^>,<wide|<space|1.1em>|^>>,
  <math|<wide|<space|1.8em>|^>>), and long arrows
  (<math|<long-arrow|\<rubber-rightarrow\>|<space|2.7em>>>,
  <math|<long-arrow|\<rubber-leftrightharpoons\>|<space|2.8em>>>).

  We produce these rubber characters using essentially the same techniques as
  in the previous section. Especially horizontal and vertical scaling are
  very useful, as well as cutting symbols into several parts and reassembling
  them appropriately.

  <\big-figure>
    <math|<tabular*|<tformat|<cwith|2|2|1|-1|font|American
    Typewriter>|<cwith|3|3|1|-1|font|Didot>|<cwith|4|4|1|-1|font|Essays1743>|<cwith|5|5|1|-1|font|Optima>|<cwith|6|6|1|-1|font|Chalkboard>|<cwith|7|7|1|-1|font|Chalkduster>|<cwith|8|8|1|-1|font|Papyrus>|<table|<row|<cell|\<rubber-Leftarrow-20\>>|<cell|\<rubber-leftrightharpoons-20\>>|<cell|\<rubber-mapsto-20\>>>|<row|<cell|\<rubber-Leftarrow-20\>>|<cell|\<rubber-leftrightharpoons-20\>>|<cell|\<rubber-mapsto-20\>>>|<row|<cell|\<rubber-Leftarrow-20\>>|<cell|\<rubber-leftrightharpoons*-20\>>|<cell|\<rubber-mapsto*-20\>>>|<row|<cell|\<rubber-Leftarrow-20\>>|<cell|\<rubber-leftrightharpoons-20\>>|<cell|\<rubber-mapsto-20\>>>|<row|<cell|\<rubber-Leftarrow-20\>>|<cell|\<rubber-leftrightharpoons-20\>>|<cell|\<rubber-mapsto-20\>>>|<row|<cell|\<rubber-Leftarrow-20\>>|<cell|\<rubber-leftrightharpoons*-20\>>|<cell|\<rubber-mapsto*-20\>>>|<row|<cell|\<rubber-Leftarrow-20\>>|<cell|\<rubber-leftrightharpoons*-20\>>|<cell|\<rubber-mapsto*-20\>>>|<row|<cell|\<rubber-Leftarrow-20\>>|<cell|\<rubber-leftrightharpoons-20\>>|<cell|\<rubber-mapsto-20\>>>>>>><space|2em><tabular*|<tformat|<cwith|1|1|2|2|cell-halign|r>|<cwith|2|2|2|2|cell-halign|r>|<cwith|3|3|2|2|cell-halign|r>|<cwith|4|4|2|2|cell-halign|r>|<cwith|5|5|2|2|cell-halign|r>|<cwith|6|6|2|2|cell-halign|r>|<cwith|2|2|1|-1|font|American
    Typewriter>|<cwith|3|3|1|-1|font|Didot>|<cwith|4|4|1|-1|font|Chalkboard>|<cwith|5|5|1|-1|font|Chalkduster>|<cwith|6|6|1|-1|font|Papyrus>|<table|<row|<cell|<math|<op|<big|sum>>>>|<cell|<math|<with|math-display|true|<op|<big|sum>>>>>|<cell|<math|<with|math-display|true|<op|<big|prod>>>>>|<cell|<math|<op|<big|prod>>>>>|<row|<cell|<math|<op|<big|sum>>>>|<cell|<math|<with|math-display|true|<op|<big|sum>>>>>|<cell|<math|<with|math-display|true|<op|<big|prod>>>>>|<cell|<math|<op|<big|prod>>>>>|<row|<cell|<math|<op|<big|sum>>>>|<cell|<math|<with|math-display|true|<op|<big|sum>>>>>|<cell|<math|<with|math-display|true|<op|<big|prod>>>>>|<cell|<math|<op|<big|prod>>>>>|<row|<cell|<math|<op|<big|sum>>>>|<cell|<math|<with|math-display|true|<op|<big|sum>>>>>|<cell|<math|<with|math-display|true|<op|<big|prod>>>>>|<cell|<math|<op|<big|prod>>>>>|<row|<cell|<math|<op|<big|sum>>>>|<cell|<math|<with|math-display|true|<op|<big|sum>>>>>|<cell|<math|<with|math-display|true|<op|<big|prod>>>>>|<cell|<math|<op|<big|prod>>>>>|<row|<cell|<math|<op|<big|sum>>>>|<cell|<math|<with|math-display|true|<op|<big|sum>>>>>|<cell|<math|<with|math-display|true|<op|<big|prod>>>>>|<cell|<math|<op|<big|prod>>>>>>>><space|1em><math|<with|font|Chalkduster|<around*|\<lfloor\>|<tabular*|<tformat|<cwith|2|2|1|-1|font|American
    Typewriter>|<cwith|3|3|1|-1|font|Didot>|<cwith|4|4|1|-1|font|Essays1743>|<cwith|1|1|1|-1|font|Chalkboard>|<cwith|1|-1|1|-1|cell-lsep|0.25spc>|<cwith|1|-1|1|-1|cell-rsep|0.25spc>|<cwith|5|5|1|2|cell-lsep|0.25spc>|<cwith|5|5|1|2|cell-rsep|0.25spc>|<cwith|5|5|1|2|font|TriangleETcircle
    Shadowed>|<table|<row|<cell|<around|<left|(|3>|<around|<left|(|2>|<around|<left|(|1>|<around|(||)>|<right|)|1>>|<right|)|2>>|<right|)|3>>>|<cell|<around|<left|{|3>|<around|<left|{|2>|<around|<left|{|1>|<around|{||}>|<right|}|1>>|<right|}|2>>|<right|}|3>>>>|<row|<cell|<around|<left|(|3>|<around|<left|(|2>|<around|<left|(|1>|<around|(||)>|<right|)|1>>|<right|)|2>>|<right|)|3>>>|<cell|<around|<left|{|3>|<around|<left|{|2>|<around|<left|{|1>|<around|{||}>|<right|}|1>>|<right|}|2>>|<right|}|3>>>>|<row|<cell|<around|<left|(|3>|<around|<left|(|2>|<around|<left|(|1>|<around|(||)>|<right|)|1>>|<right|)|2>>|<right|)|3>>>|<cell|<around|<left|{|3>|<around|<left|{|2>|<around|<left|{|1>|<around|{||}>|<right|}|1>>|<right|}|2>>|<right|}|3>>>>|<row|<cell|<around|<left|(|3>|<around|<left|(|2>|<around|<left|(|1>|<around|(||)>|<right|)|1>>|<right|)|2>>|<right|)|3>>>|<cell|<around|<left|{|4>|<around|<left|{|3>|<around|<left|{|2>|<around|<left|{|1>||<right|}|1>>|<right|}|2>>|<right|}|3>>|<right|}|4>>>>|<row|<cell|<around|<left|(|3>|<around|<left|(|2>|<around|<left|(|1>|<around|(||)>|<right|)|1>>|<right|)|2>>|<right|)|3>>>|<cell|<around|<left|{|3>|<around|<left|{|2>|<around|<left|{|1>|<around|{||}>|<right|}|1>>|<right|}|2>>|<right|}|3>>>>>>>|\<rceil\>>>>

    \;
  </big-figure|Assorted rubber symbols from various fonts.>

  <section|The abstract font class>

  The main abstract <verbatim|font> class is defined in <verbatim|font.hpp>:\ 

  <\cpp-code>
    struct font_rep: rep\<less\>font\<gtr\> {<next-line> \ display \ dis;
    \ \ \ \ \ \ \ \ \ \ \ \ \ // underlying display<next-line> \ encoding
    enc; \ \ \ \ \ \ \ \ \ \ \ \ \ // underlying encoding of the
    font<next-line> \ SI \ \ \ \ \ \ design_size; \ \ \ \ \ // design size in
    points/256<next-line> \ SI \ \ \ \ \ \ display_size; \ \ \ \ // display
    size in points/PIXEL<next-line> \ double \ \ slope;
    \ \ \ \ \ \ \ \ \ \ \ // italic slope<next-line> \ space \ \ \ spc;
    \ \ \ \ \ \ \ \ \ \ \ \ \ // usual space between words<next-line> \ space
    \ \ \ extra; \ \ \ \ \ \ \ \ \ \ \ // extra space at end of
    words<next-line><next-line> \ SI \ \ \ \ \ \ y1;
    \ \ \ \ \ \ \ \ \ \ \ \ \ \ // bottom y position<next-line> \ SI
    \ \ \ \ \ \ y2; \ \ \ \ \ \ \ \ \ \ \ \ \ \ // top y position<next-line>
    \ SI \ \ \ \ \ \ yfrac; \ \ \ \ \ \ \ \ \ \ \ // vertical position
    fraction bar<next-line> \ SI \ \ \ \ \ \ ysub; \ \ \ \ \ \ \ \ \ \ \ \ //
    base line for subscripts<next-line> \ SI \ \ \ \ \ \ ysup;
    \ \ \ \ \ \ \ \ \ \ \ \ // base line for
    superscripts<next-line><next-line> \ SI \ \ \ \ \ \ wpt;
    \ \ \ \ \ \ \ \ \ \ \ \ \ // width of one point in font<next-line> \ SI
    \ \ \ \ \ \ wquad; \ \ \ \ \ \ \ \ \ \ \ // wpt * design size in
    points<next-line> \ SI \ \ \ \ \ \ wunit; \ \ \ \ \ \ \ \ \ \ \ // unit
    width for extendable fonts<next-line> \ SI \ \ \ \ \ \ wfrac;
    \ \ \ \ \ \ \ \ \ \ \ // width fraction bar<next-line> \ SI
    \ \ \ \ \ \ wsqrt; \ \ \ \ \ \ \ \ \ \ \ // width horzontal line in
    square root<next-line> \ SI \ \ \ \ \ \ wneg; \ \ \ \ \ \ \ \ \ \ \ \ //
    width of negation line<next-line><next-line> \ font_rep (display dis,
    string name);<next-line> \ font_rep (display dis, string name, font
    fn);<next-line> \ void copy_math_pars (font fn);<next-line><next-line>
    \ virtual void \ \ get_extents (string s, text_extents& ex) =
    0;<next-line> \ virtual void \ \ draw (ps_device dev, string s, SI x, SI
    y) = 0;<next-line><next-line> \ virtual SI \ \ \ \ get_sub_base (string
    s);<next-line> \ virtual SI \ \ \ \ get_sup_base (string s);<next-line>
    \ virtual double get_left_slope \ (string s);<next-line> \ virtual double
    get_right_slope (string s);<next-line> \ virtual SI
    \ \ \ \ get_left_correction \ (string s);<next-line> \ virtual SI
    \ \ \ \ get_right_correction (string s);<next-line> \ virtual SI
    \ \ \ \ get_lsub_correction (string s, double level);<next-line>
    \ virtual SI \ \ \ \ get_lsup_correction (string s, double
    level);<next-line> \ virtual SI \ \ \ \ get_rsub_correction (string s,
    double level);<next-line> \ virtual SI \ \ \ \ get_rsup_correction
    (string s, double level);<next-line> \ 

    };
  </cpp-code>

  <\verbatim>
    \ \ \ \ 
  </verbatim>

  The main abstract routines are <verbatim|get_extents> and <verbatim|draw>.
  The first routine determines the logical and physical bounding boxes of a
  graphical representation of a word, the second one draws the string on the
  the screen.

  The additional data are used for global typesetting using the font. The
  other virtual routines are used for determining additional properties of
  typeset strings.

  <section|Font selection>

  Font selection is initiated in <cpp|edit_env_rep::update_font> where the
  variables controlling the current font, family, series, shape, size and
  magnification are extracted from the current environment via calls to
  <cpp|edit_env_rep::get_string>.\ 

  <\cpp-code>
    void

    edit_env_rep::update_font () {

    \ \ fn_size= (int) (((double) get_int (FONT_BASE_SIZE)) *

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ get_double (FONT_SIZE) + 0.5);

    \ \ switch (mode) {

    \ \ case 0:

    \ \ case 1:

    \ \ \ \ fn= smart_font (get_string (FONT), get_string (FONT_FAMILY),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ get_string (FONT_SERIES),
    get_string (FONT_SHAPE),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ get_script_size (fn_size,
    index_level), (int) (magn*dpi));

    \ \ \ \ break;

    \ \ case 2:

    \ \ \ \ fn= smart_font (get_string (MATH_FONT), get_string
    (MATH_FONT_FAMILY),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ get_string (MATH_FONT_SERIES),
    get_string (MATH_FONT_SHAPE),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ get_string (FONT), get_string
    (FONT_FAMILY),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ get_string (FONT_SERIES),
    "mathitalic",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ get_script_size (fn_size,
    index_level), (int) (magn*dpi));

    \ \ \ \ break;

    \ \ case 3:

    \ \ \ \ fn= smart_font (get_string (PROG_FONT), get_string
    (PROG_FONT_FAMILY),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ get_string (PROG_FONT_SERIES),
    get_string (PROG_FONT_SHAPE),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ get_string (FONT), get_string
    (FONT_FAMILY) * "-tt",

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ get_string (FONT_SERIES),
    get_string (FONT_SHAPE),

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ get_script_size (fn_size,
    index_level), (int) (magn*dpi));

    \ \ \ \ break;

    \ \ }

    \ \ string eff= get_string (FONT_EFFECTS);

    \ \ if (N(eff) != 0) fn= apply_effects (fn, eff);

    }
  </cpp-code>

  Selection proceed according to the current mode <cpp|0>, <cpp|1>, <cpp|2>
  or <cpp|3>. See <cpp|edit_env_rep::update_mode> for the conversion between
  the environment variable <cpp|"mode"> and the variables
  <cpp|edit_env_rep::mode> and <cpp|edit_env_rep::modeop>. Different versions
  of the function <cpp|smart_font()> are called: either

  <\cpp-code>
    font smart_font (string family, string variant, string series, string
    shape,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ int sz, int dpi);
  </cpp-code>

  or (for <cpp|"math"> and <cpp|"prog"> modes)

  <\cpp-code>
    font smart_font (string family, string variant, string series, string
    shape,\ 

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ string tfam, string tvar, string tser,
    string tsh,\ 

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ int sz, int dpi);
    \ \ \ \ \ \ \ \ \ \ \ 
  </cpp-code>

  The second version make some adjustment and call the first version. The
  function reads

  <\cpp-code>
    font

    smart_font (string family, string variant, string series, string shape,

    \ \ \ \ \ \ \ \ \ \ \ \ string tfam, string tvar, string tser, string
    tsh,

    \ \ \ \ \ \ \ \ \ \ \ \ int sz, int dpi) {

    \ \ if (!new_fonts) return find_font (family, variant, series, shape, sz,
    dpi);

    \ \ if (tfam == "roman") tfam= family;

    \ \ if (variant != "mr") {

    \ \ \ \ if (variant == "ms") tvar= "ss";

    \ \ \ \ if (variant == "mt") tvar= "tt";

    \ \ }

    \ \ if (shape == "right") tsh= "mathupright";

    \ \ return smart_font (tfam, tvar, tser, tsh, sz, dpi);

    }
  </cpp-code>

  as we see, in the new font mechanism (selected via the <cpp|new_fonts>
  global boolean), we ignore the mode-dependent font selection variables, in
  favour of the main font variables, but we make local adjustement to carry
  over corretly the variant and shape selection.

  <section|Smart fonts>

  A smart font collects and coordinate various physical fonts in order to
  represent the full spectrum of TeXmacs basic entities (TeXmacs universal
  encoding) and handles also various customizations and effects. The
  structure has various fields:

  <\cpp-code>
    struct smart_font_rep: font_rep {

    \ \ string mfam;

    \ \ string family;

    \ \ string variant;

    \ \ string series;

    \ \ string shape;

    \ \ string rshape;

    \ \ int \ \ \ sz;

    \ \ int \ \ \ hdpi;

    \ \ int \ \ \ dpi;

    \ \ int \ \ \ math_kind;

    \ \ int \ \ \ italic_nr;

    \;

    \ \ array\<less\>font\<gtr\> fn;

    \ \ smart_map \ \ sm;

    \ \ 

    \ \ smart_font_rep (string name, font base_fn, font err_fn,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ string family, string variant,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ string series, string shape, int sz, int
    hdpi, int vdpi);

    \;

    \ \ // [...] methods are not shown here

    }
  </cpp-code>

  The value of the <cpp|family> field can be quite complex for smart fonts. A
  typical font can be instantiated in a TeXmacs document with an assignment
  to the <src-arg|font> environment variable as such:

  <\tm-fragment>
    <inactive*|<assign|font|mathlarge=TeX Gyre Pagella,cal=TeX Gyre
    Termes,bold-cal=TeX Gyre Termes,frak=TeX Gyre Pagella,Fira>>
  </tm-fragment>

  It is a string with comma separated fields and a final value which
  determines the main family <cpp|mfam> while the others determine special
  subfonts for certain groups of entities.

  A key field which controls the behaviour of the smart font is
  <cpp|math_kind>. The possible values are <cpp|0,1,2,3> and it is set in the
  constructor of the structure according to the value of the <cpp|shape>
  parameter. The value <cpp|0> is the default. If <cpp|shape> is one of
  <cpp|"mathitalic">, <cpp|"mathupright">, <cpp|"mathshape"> then
  <cpp|math_kind> is, respectively, set to <cpp|1,2,3>. This is used to
  determine the shape of alphabetic and Greek characters according to
  different conventions <todo|to be completed>.

  To understand how smart fonts work we can look at one of the entrypoints of
  the font mechanics, the <cpp|draw_fixed> method, which renders an entity on
  a graphical device.

  <\cpp-code>
    void

    smart_font_rep::draw_fixed (renderer ren, string s, SI x, SI y) {

    \ \ int i=0, n= N(s);

    \ \ while (i \<less\> n) {

    \ \ \ \ int nr;

    \ \ \ \ string r= s;

    \ \ \ \ metric ey;

    \ \ \ \ advance (s, i, r, nr);

    \ \ \ \ if (nr \<gtr\>= 0) {

    \ \ \ \ \ \ fn[nr]-\<gtr\>draw_fixed (ren, r, x, y);

    \ \ \ \ \ \ if (i \<less\> n) {

    \ \ \ \ \ \ \ \ fn[nr]-\<gtr\>get_extents (r, ey);

    \ \ \ \ \ \ \ \ x += ey-\<gtr\>x2;

    \ \ \ \ \ \ }

    \ \ \ \ }

    \ \ }

    }
  </cpp-code>

  In this case it off-loads the real work to a particular
  <with|font-shape|italic|subfont> <cpp|fn[nr]> which is determined by a call
  to the dispatching function <cpp|smart_font_rep::advance> whose result is
  to obtain a subfont number <cpp|nr> and, possibly a different
  representation of the entity in the string <cpp|r>. A value <cpp|-1> for
  <cpp|nr> is considered an invalid font and ignored.

  The <cpp|advance> method, scans the input string at the given position and
  looks up the entities using either caching mechanism provided by
  <cpp|smart_map>:

  <\cpp-code>
    struct smart_map_rep: rep\<less\>smart_map\<gtr\> {

    \ \ int chv[256];

    \ \ hashmap\<less\>string,int\<gtr\> cht;

    \ \ hashmap\<less\>tree,int\<gtr\> fn_nr;

    \ \ array\<less\>tree\<gtr\> fn_spec;

    \ \ array\<less\>int\<gtr\> fn_rewr;

    \;

    public:

    \ \ smart_map_rep (string name, tree fn);

    \ \ int add_font (tree fn, int rewr);

    \ \ int add_char (tree fn, string c);

    };
  </cpp-code>

  where <cpp|chv> give a subfont number for single byte characters while
  <cpp|cht> provide subfont lookup for other entities. If this lookup returns
  the invalid subfont <cpp|-1> then we proceed to determine the appropriate
  subfont via the <cpp|resolve> method. Once we got a subfont we may
  initialize it if needed, and the proceed to some rewriting, controlled by
  the value of smartmap's <cpp|fn_rewr[nr]> field, according to the values

  <\cpp-code>
    #define REWRITE_NONE \ \ \ \ \ \ \ \ \ \ \ 0

    #define REWRITE_MATH \ \ \ \ \ \ \ \ \ \ \ 1

    #define REWRITE_CYRILLIC \ \ \ \ \ \ \ 2

    #define REWRITE_LETTERS \ \ \ \ \ \ \ \ 3

    #define REWRITE_SPECIAL \ \ \ \ \ \ \ \ 4

    #define REWRITE_EMULATE \ \ \ \ \ \ \ \ 5

    #define REWRITE_POOR_BBB \ \ \ \ \ \ \ 6

    #define REWRITE_ITALIC_GREEK \ \ \ 7

    #define REWRITE_UPRIGHT_GREEK \ \ 8

    #define REWRITE_UPRIGHT \ \ \ \ \ \ \ \ 9

    #define REWRITE_ITALIC \ \ \ \ \ \ \ \ 10

    #define REWRITE_IGNORE \ \ \ \ \ \ \ \ 11
  </cpp-code>

  For example, in case <cpp|fn_rewr[nr] == REWRITE_MATH> we perform a
  rewriting according to the function

  <\cpp-code>
    static string

    rewrite_math (string s) {

    \ \ string r;

    \ \ int i= 0, n= N(s);

    \ \ while (i \<less\> n) {

    \ \ \ \ int start= i;

    \ \ \ \ tm_char_forwards (s, i);

    \ \ \ \ if (s[start] == '\<less\>' && start+1 \<less\> n && s[start+1] ==
    '#' && s[i-1] == '\<gtr\>')

    \ \ \ \ \ \ r \<less\>\<less\> utf8_to_cork (strict_cork_to_utf8 (s
    (start, i)));

    \ \ \ \ else r \<less\>\<less\> s (start, i);

    \ \ }

    \ \ return r;

    }
  </cpp-code>

  Each entity is transformed back and forth from Cork to UTF8, which has as
  effect to transform some entities in unicode points which are represented
  in TeXmacs' encoding as <verbatim|\<less\>#xxxx\<gtr\>>.\ 

  Let's make a brief digression on how this is implemented before continuing.
  <cpp|utf8_to_cork> is implemented in <verbatim|converter.cpp> and uses a
  <cpp|converter> object instatiated via\ 

  <\cpp-code>
    converter conv= load_converter ("UTF-8", "Cork");
  </cpp-code>

  and similarly for <cpp|strict_cork_to_utf8>. The relevant code which
  construct the conversion tables is in <cpp|converter_rep::load> and reads:

  <\cpp-code>
    \ \ else if (from=="UTF-8" && to=="Cork") {

    \ \ \ \ hashtree\<less\>char,string\<gtr\> dic;

    \ \ \ \ hashtree_from_dictionary (dic,"corktounicode", UTF8, BIT2BIT,
    true);

    \ \ \ \ hashtree_from_dictionary (dic,"unicode-cork-oneway", UTF8,
    BIT2BIT, false);

    \ \ \ \ hashtree_from_dictionary (dic,"tmuniversaltounicode", UTF8,
    BIT2BIT, true);

    \ \ \ \ hashtree_from_dictionary (dic,"unicode-symbol-oneway", UTF8,
    BIT2BIT, true);

    \ \ \ \ ht = dic;

    \ \ }

    \ \ if (from=="Strict-Cork" && to=="UTF-8" ) {

    \ \ \ \ hashtree\<less\>char,string\<gtr\> dic;

    \ \ \ \ hashtree_from_dictionary (dic,"corktounicode", BIT2BIT, UTF8,
    false);

    \ \ \ \ hashtree_from_dictionary (dic,"cork-unicode-oneway", BIT2BIT,
    UTF8, false);

    \ \ \ \ hashtree_from_dictionary (dic,"tmuniversaltounicode", BIT2BIT,
    UTF8, false);

    \ \ \ \ hashtree_from_dictionary (dic,"symbol-unicode-oneway", BIT2BIT,
    UTF8, false);

    \ \ \ \ hashtree_from_dictionary (dic,"symbol-unicode-math", BIT2BIT,
    UTF8, false);

    \ \ \ \ ht = dic;

    \ \ }
  </cpp-code>

  the boolean value determine if we construct the direct (<cpp|false>) or
  inverse (<cpp|true>) mapping. The various tables are encoded in Scheme
  expressions in various files in <verbatim|$TEXMACS_PATH/langs/encoding>. \ 

  <subsection|Entity resolution>

  We go back now to entity resolution in <cpp|smart_font>. The next step is
  how <cpp|resolve> works. The function is overloaded. The basic form is

  <\cpp-code>
    int smart_font_rep::resolve (string c)
  </cpp-code>

  which performs some basic dispatching for entities.

  \ If <cpp|math_kind != 0> we perform the following resolutions:

  <\itemize>
    <item>Entities <verbatim|\<less\>up-XXX\<gtr\>> are associated to a
    <cpp|REWRITE_UPRIGHT> rewrite rule, provided the <cpp|fn[SUBFONT_MAIN]>
    font supports the basic character, or entity.

    <item>Entities \ <verbatim|\<less\>up-XXX\<gtr\>> for greek letters are
    associated to a <cpp|REWRITE_UPRIGHT_GREEK> rewrite rule, provided the
    <cpp|fn[SUBFONT_MAIN]> font supports it.

    <item>Same for italic greek letters.

    <item>Several specific entities are associated to the <cpp|"italic-math">
    subfont (e.g. <verbatim|\<less\>imath\<gtr\>>,
    <verbatim|\<less\>jmath\<gtr\>>, <verbatim|\<less\>ell\<gtr\>>).

    <item>Special entities (as determined by <cpp|is_special>, provided some
    side conditions are not met) are associated to the <cpp|"special">
    subfont which is the <cpp|shape="right"> variant of the smart font. They
    corresponds to various mathematical entities including those in the form
    <verbatim|\<less\>big-XXXX-N\<gtr\>> which represent large glyphs or
    operators.

    <item>Other entities are associated to the <cpp|"emu-bracket"> subfont,
    if appropriate. See <cpp|find_in_emu_bracket>.\ 
  </itemize>

  If these cases do not apply we continue. If the shape is
  <verbatim|mathupright> and we are looking at the standard <verbatim|roman>
  family, we lookup the non-alphabetic characters in the standard
  <verbatim|mathitalic> font with a specific subfont with label
  <cpp|"italic-roman">:

  <\cpp-code>
    \ \ if (mfam == "roman" && shape == "mathupright" &&

    \ \ \ \ \ \ (variant == "rm" \|\| variant == "ss" \|\| variant == "tt")
    &&

    \ \ \ \ \ \ N(c) == 1 && (c[0] \<less\> 'A' \|\| c[0] \<gtr\> 'Z') &&
    (c[0] \<less\> 'a' \|\| c[0] \<gtr\> 'z'))

    \ \ \ \ return sm-\<gtr\>add_char (tuple ("italic-roman"), c);
  </cpp-code>

  At this point we need to take into account the structure of the font
  <cpp|family> string. Keep in mind that it might looks like this:

  <\cpp-code>
    "mathlarge=TeX Gyre Pagella,cal=TeX Gyre Termes,bold-cal=TeX Gyre
    Termes,"

    "frak=TeX Gyre Pagella,Fira"
  </cpp-code>

  This particular syntax is called a <with|font-shape|italic|font sequence>.
  We split the various subfields with something like:

  <\cpp-code>
    \ \ array\<less\>string\<gtr\> a= trimmed_tokenize (family, ",");
  </cpp-code>

  We call each element a <with|font-shape|italic|subfont selector>. The
  <with|font-shape|italic|main font (family)> \ is the first comma separated
  field which is not a substring containing an <cpp|"="> character, can be
  extracted via the <verbatim|main_family> function and call it the
  <with|font-shape|italic|main selector>. The other selectors are assumed to
  be pairs of the form <cpp|"XXX=YYY">, where the l.h.s. determines a
  particular subrange of entities and the r.h.s. the font to be used for
  their rendering. \ \ 

  For each selector in the <cpp|a> array, we perform a resolution with

  <\cpp-code>
    int smart_font_rep::resolve (string c, string fam, int attempt)
  </cpp-code>

  here the <cpp|attempt> variable indicate the number of attemps we already
  perfomed. This function implements the semantics of the font sequence
  string, allowing to choose different fonts for subranges of glyphs, or
  variants (like bold, italic, etc...).\ 

  For selectors <cpp|fam> of the form <cpp|"selector field=selector font"> it
  checks that the <with|font-shape|italic|selector field> matches either the
  glyph <cpp|c> or the indicated selector font's characteristics. Selector
  fields can be of the following types:

  <\itemize>
    <item>a particular feature, as returned by the <cpp|logical_font>
    function applied to the font's characteristics (<verbatim|family>,
    <verbatim|variant>, <verbatim|series> and <verbatim|rshape>);

    <item>an unicode range: one of <verbatim|latin>, <verbatim|greek>,
    <verbatim|cyrillic>, <verbatim|cjk>, <verbatim|hiragana>,
    <verbatim|hangul>, <verbatim|mathsymbols>, <verbatim|mathextra>,
    <verbatim|mathletters>, <verbatim|mathlarge>, <verbatim|mathbigops>,
    <verbatim|mathrubber> (see <cpp|in_unicode_range> for details);

    <item>a mathematical alphabeth range, i.e. one of <verbatim|bold-math>,
    <verbatim|italic-math>, <verbatim|bold-italic-math>, <verbatim|cal>,
    <verbatim|bold-cal>, <verbatim|frak>, <verbatim|bold-frak>,
    <verbatim|bbb>, <verbatim|ss>, <verbatim|bold-ss>, <verbatim|italic-ss>,
    <verbatim|bold-italic-ss>, <verbatim|tt> (see the
    <cpp|substitute_math_letter> function);

    <item>a particular entity (e.g. <verbatim|\<less\>alpha\<gtr\>> or
    <verbatim|\<less\>ell\<gtr\>>);

    <item>a letter range: <verbatim|digit>, <verbatim|latin>,
    <verbatim|latin-bold>, <verbatim|greek>, <verbatim|basic-letters>,
    <verbatim|uppercase-latin>, <verbatim|uppercase-latin-bold>,
    <verbatim|lowercase-latin>, <verbatim|lowercase-latin-bold>,
    <verbatim|greek-bold>, <verbatim|uppercase-greek>,
    <verbatim|uppercase-greek-bold>, <verbatim|lowecase-greek>,
    <verbatim|lowecase-greek-bold>, (see the <cpp|in_collection> function);

    <item>the <cpp|"!"> character followed by a letter range, to exclude a
    particular range;

    <item>a selector in the form <cpp|"XXXX:YYYY"> where <verbatim|XXXX> and
    <verbatim|YYYY> are TeXmacs entities, to match an unicode range.
  </itemize>

  In case it does, and we are at the first attempt, it proceed to allocate
  the glyph to the given font following several heuristics. \ In particular,
  if the font is the main font (this happens for the last font sequence
  element) we check if <cpp|fn[SUBFONT_MAIN]> can render the entity,
  otherwise if the font is not the main font, we need to first look up the
  font and check if we can render the entity. If all this does not work we
  have to do otherwise and look elsewhere for the glyph before failing. In
  particular we have special cases for TeX and similar fonts which have a
  complex resolution of entities for mathematical typesetting and we need to
  instantiate an appropriate <cpp|math_font> to handle them. This case is
  determined by the function <cpp|is_math_family>. Cyrillic and Greek letters
  have also special handling in case the font is <verbatim|roman>. We
  implement here also the fallback for blackboard bold entities
  <verbatim|\<less\>bbb-X\<gtr\>> with synthetic subfonts with \ label
  <cpp|"poor-bbb">. If the entity is an italic letter
  <verbatim|\<less\>it-X\<gtr\>>, we dispatch it to the <cpp|"it"> subfont
  with a <cpp|REWRITE_ITALIC> semantics. Finally, for the main selector, we
  check the <with|font-shape|italic|emulated fonts> as returned by the
  <cpp|emu_font_names> function, in case we find an appropriate match we
  instantiate a glyph in an <cpp|"emulate"> subfont.

  If this first attempt fails the function returns the invalid subfont
  selector <cpp|-1>. We check now if the entity is rubber. Rubbers are
  entities like <verbatim|\<less\>large-sqrt-2\<gtr\>> or
  <verbatim|\<less\>left-lparen-4\<gtr\>> which are extensible either
  horizontally or vertically. Whether an entity is rubber or not is
  determined by

  <\cpp-code>
    static bool

    is_rubber (string c) {

    \ \ return (starts (c, "\<less\>large-") \|\|

    \ \ \ \ \ \ \ \ \ \ starts (c, "\<less\>left-") \|\|

    \ \ \ \ \ \ \ \ \ \ starts (c, "\<less\>right-") \|\|

    \ \ \ \ \ \ \ \ \ \ starts (c, "\<less\>mid-")) && ends (c, "\<gtr\>");

    }
  </cpp-code>

  Note that some rubber entities can be matched in the earlier attemps, e.g.
  by <verbatim|mathlarge>, <verbatim|mathbigops> or <verbatim|mathrubber>
  selectors, and supported by a physical font, e.g. by an
  <verbatim|unicode_font>s below in Section<nbsp><reference|sec:unicode-font>.
  Generally however fonts only support the base size of a rubber glyph, e.g.
  in <verbatim|$TEXMACS_PATH/langs/encoding/symbol-unicode-oneway.scm> we
  have (among other translations)

  <\verbatim-code>
    ("\<less\>large-less-0\<gtr\>" \ \ \ \ \ "\<less\>")

    ("\<less\>large-gtr-0\<gtr\>" \ \ \ \ \ \ "\<gtr\>")

    ("\<less\>large-(\<gtr\>" \ \ \ \ \ \ \ \ \ \ "(")

    ("\<less\>large-)\<gtr\>" \ \ \ \ \ \ \ \ \ \ ")")

    ("\<less\>large-(-0\<gtr\>" \ \ \ \ \ \ \ \ "(")

    ("\<less\>large-)-0\<gtr\>" \ \ \ \ \ \ \ \ ")")

    ("\<less\>large-[\<gtr\>" \ \ \ \ \ \ \ \ \ \ "[")

    ("\<less\>large-]\<gtr\>" \ \ \ \ \ \ \ \ \ \ "]")

    ("\<less\>large-[-0\<gtr\>" \ \ \ \ \ \ \ \ "[")

    ("\<less\>large-]-0\<gtr\>" \ \ \ \ \ \ \ \ "]")

    ("\<less\>large-lceil\<gtr\>" \ \ \ \ \ \ "#2308")

    ("\<less\>large-rceil\<gtr\>" \ \ \ \ \ \ "#2309")

    ("\<less\>large-lfloor\<gtr\>" \ \ \ \ \ "#230A")

    ("\<less\>large-rfloor\<gtr\>" \ \ \ \ \ "#230B")

    ("\<less\>large-lceil-0\<gtr\>" \ \ \ \ "#2308")

    ("\<less\>large-rceil-0\<gtr\>" \ \ \ \ "#2309")

    ("\<less\>large-lfloor-0\<gtr\>" \ \ \ "#230A")

    ("\<less\>large-rfloor-0\<gtr\>" \ \ \ "#230B")
  </verbatim-code>

  For the other sizes we need larger or strecthed variants of those glyphs.
  This is the job of the rubber fonts, therefore for rubber entities which
  arrive at this point we try to instantiate a substitute in the
  <cpp|"rubber"> subfont which tries to render the glyph via the best method,
  and ultimately synthetize it via some virtual font, see
  Section<nbsp><reference|sec:rubber>.

  If the entity is not rubber, the resolution process then restart by
  scanning again all the selectors with an higher <cpp|attempt> number. At
  this point, since <cpp|attempt\<gtr\>1> the resolution however proceed
  differently. If the entity belongs to some mathematical alphabeth as
  detected via <cpp|substitute_math_letter>, then we stop further attempts
  and we dispatch the glyph to one of the subfonts for variants of
  alphabetical glyphs associated with one of the keys:\ 

  <cpp|"bold-math">, <cpp|"italic-math">, <cpp|"bold-italic-math">,
  <cpp|"cal">, <cpp|"bold-cal">, <cpp|"frak">, <cpp|"bold-frak">,
  <cpp|"bbb">, <cpp|"ss">, <cpp|"bold-ss">, <cpp|"italic-ss">,
  <cpp|"bold-italic-ss">, <cpp|"tt">.

  If the entity is not a mathematical letter, we need attempt to find a
  suitable replacement font via the use TeXmacs mechanism for searching fonts
  with similar characteristics. This is implemented via the function

  <\cpp-code>
    font closest_font (string family, string variant, string series, string
    shape,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ int sz, int dpi, int attempt)
  </cpp-code>

  to find an appropriate substitute. We indicate the required entity by
  augmenting the variant field with the unicode range of the required glyph,
  as returned by the <cpp|get_unicode_range> function:

  <\cpp-code>
    string

    get_unicode_range (int code) {

    \ \ if (code \<less\>= 0x7f) return "ascii";

    \ \ else if (code \<gtr\>= 0x80 && code \<less\>= 0x37f) return "latin";

    \ \ else if (code \<gtr\>= 0x380 && code \<less\>= 0x3ff) return "greek";

    \ \ else if (code \<gtr\>= 0x400 && code \<less\>= 0x4ff) return
    "cyrillic";

    \ \ else if (code \<gtr\>= 0x3000 && code \<less\>= 0x303f) return "cjk";

    \ \ else if (code \<gtr\>= 0x4e00 && code \<less\>= 0x9fcc) return "cjk";

    \ \ else if (code \<gtr\>= 0xff00 && code \<less\>= 0xffef) return "cjk";

    \ \ else if (code \<gtr\>= 0x3040 && code \<less\>= 0x309F) return
    "hiragana";

    \ \ else if (code \<gtr\>= 0xac00 && code \<less\>= 0xd7af) return
    "hangul";

    \ \ else if (code \<gtr\>= 0x2000 && code \<less\>= 0x23ff) return
    "mathsymbols";

    \ \ else if (code \<gtr\>= 0x2900 && code \<less\>= 0x2e7f) return
    "mathextra";

    \ \ else if (code \<gtr\>= 0x1d400 && code \<less\>= 0x1d7ff) return
    "mathletters";

    \ \ else return "";

    }
  </cpp-code>

  In case we manage to find a suitable font we instantiate it as a subfont
  with a key of the form

  <\cpp-code>
    tree key= tuple (fam, augmented_variant, series, rshape, as_string
    (attempt-1));
  </cpp-code>

  After a number of attemps determined by <cpp|FONT_ATTEMPTS> we give up. At
  this point we try <with|font-shape|italic|virtual fonts> via
  <cpp|find_in_virtual> and if successful instantiate the virtual font with
  key <cpp|"virtual">.

  Other special cases are dispatched to the \ <cpp|"other"> subfont. Finally
  we assign the glyph to the \ <cpp|"error"> subfont and show it as a red
  string. This concludes the description of the resolution mechanics.\ 

  The semanthics of the subfont keys is determined at the moment we
  instantiated the subfonts in <cpp|initialize_font>, as follows. The
  <cpp|fn_spec[nr]> field of <cpp|smart_map> is a tree which specify the kind
  of font

  <\cpp-code>
    void

    smart_font_rep::initialize_font (int nr) {

    \ \ if (N(fn) \<less\>= nr) fn-\<gtr\>resize (nr+1);

    \ \ if (!is_nil (fn[nr])) return;

    \ \ array\<less\>string\<gtr\> a= tuple_as_array (sm-\<gtr\>fn_spec[nr]);

    \ \ if (a[0] == "math")

    \ \ \ \ fn[nr]= adjust_subfont (get_math_font (a[1], a[2], a[3], a[4]));

    \ \ else if (a[0] == "cyrillic")

    \ \ \ \ fn[nr]= adjust_subfont (get_cyrillic_font (a[1], a[2], a[3],
    a[4]));

    \ \ else if (a[0] == "greek")

    \ \ \ \ fn[nr]= adjust_subfont (get_greek_font (a[1], a[2], a[3], a[4]));

    \ \ else if (a[0] == "subfont")

    \ \ \ \ fn[nr]= smart_font_bis (a[1], variant, series, shape, sz, hdpi,
    dpi);

    \ \ else if (a[0] == "special")

    \ \ \ \ fn[nr]= smart_font_bis (family, variant, series, "right", sz,
    hdpi, dpi);

    \ \ else if (a[0] == "emu-bracket")

    \ \ \ \ fn[nr]= virtual_font (this, "emu-bracket", sz, hdpi, dpi, false);

    \ \ else if (a[0] == "other") {

    \ \ \ \ int nvdpi= adjusted_dpi ("roman", variant, series, "mathitalic",
    1);

    \ \ \ \ int nhdpi= (hdpi * nvdpi + (dpi\<gtr\>\<gtr\>1)) / dpi;

    \ \ \ \ fn[nr]= smart_font_bis ("roman", variant, series, "mathitalic",
    sz,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ nhdpi, nvdpi);

    \ \ }

    \ \ else if (a[0] == "bold-math")

    \ \ \ \ fn[nr]= smart_font_bis (family, variant, "bold", "right", sz,
    hdpi, dpi);

    \ \ else if (a[0] == "fast-italic")

    \ \ \ \ fn[nr]= smart_font_bis (family, variant, series, "italic", sz,
    hdpi, dpi);

    \ \ else if (a[0] == "italic-math")

    \ \ \ \ fn[nr]= smart_font_bis (family, variant, series, "italic", sz,
    hdpi, dpi);

    \ \ else if (a[0] == "italic-roman")

    \ \ \ \ fn[nr]= smart_font_bis (family, variant, series, "mathitalic",
    sz,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ hdpi, dpi);

    \ \ else if (a[0] == "bold-italic-math")

    \ \ \ \ fn[nr]= smart_font_bis (family, variant, "bold", "italic", sz,
    hdpi, dpi);

    \ \ else if (a[0] == "italic-greek")

    \ \ \ \ fn[nr]= fn[SUBFONT_MAIN];

    \ \ else if (a[0] == "upright-greek")

    \ \ \ \ fn[nr]= fn[SUBFONT_MAIN];

    \ \ else if (a[0] == "up")

    \ \ \ \ fn[nr]= fn[SUBFONT_MAIN];

    \ \ else if (a[0] == "it")

    \ \ \ \ fn[nr]= smart_font_bis (family, variant, series, "italic", sz,
    hdpi, dpi);

    \ \ else if (a[0] == "tt")

    \ \ \ \ fn[nr]= smart_font_bis (family, "tt", series, "right", sz, hdpi,
    dpi);

    \ \ else if (a[0] == "ss")

    \ \ \ \ fn[nr]= smart_font_bis (family, "ss", series, "right", sz, hdpi,
    dpi);

    \ \ else if (a[0] == "bold-ss")

    \ \ \ \ fn[nr]= smart_font_bis (family, "ss", "bold", "right", sz, hdpi,
    dpi);

    \ \ else if (a[0] == "italic-ss")

    \ \ \ \ fn[nr]= smart_font_bis (family, "ss", series, "italic", sz, hdpi,
    dpi);

    \ \ else if (a[0] == "bold-italic-ss")

    \ \ \ \ fn[nr]= smart_font_bis (family, "ss", "bold", "italic", sz, hdpi,
    dpi);

    \ \ else if (a[0] == "cal" && N(a) == 1)

    \ \ \ \ fn[nr]= smart_font_bis (family, "calligraphic", series, "italic",
    sz,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ hdpi, dpi);

    \ \ else if (a[0] == "bold-cal")

    \ \ \ \ fn[nr]= smart_font_bis (family, "calligraphic", "bold", "italic",
    sz,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ hdpi, dpi);

    \ \ else if (a[0] == "frak")

    \ \ \ \ fn[nr]= smart_font_bis (family, "gothic", series, "right", sz,
    hdpi, dpi);

    \ \ else if (a[0] == "bold-frak")

    \ \ \ \ fn[nr]= smart_font_bis (family, "gothic", "bold", "right", sz,
    hdpi, dpi);

    \ \ else if (a[0] == "bbb" && N(a) == 1)

    \ \ \ \ fn[nr]= smart_font_bis (family, "outline", series, "right", sz,
    hdpi, dpi);

    \ \ else if (a[0] == "virtual")

    \ \ \ \ fn[nr]= virtual_font (this, a[1], sz, hdpi, dpi, false);

    \ \ else if (a[0] == "emulate") {

    \ \ \ \ font vfn= fn[SUBFONT_MAIN];

    \ \ \ \ if (a[1] != "emu-fundamental")

    \ \ \ \ \ \ vfn= virtual_font (vfn, "emu-fundamental", sz, hdpi, dpi,
    true);

    \ \ \ \ fn[nr]= virtual_font (vfn, a[1], sz, hdpi, dpi, true);

    \ \ }

    \ \ else if (a[0] == "poor-bold" && N(a) == 1) {

    \ \ \ \ font sfn= smart_font_bis (family, variant, "medium", shape, sz,
    hdpi, dpi);

    \ \ \ \ double emb= 5.0/3.0;

    \ \ \ \ double fat= ((emb - 1.0) * sfn-\<gtr\>wline) / sfn-\<gtr\>wfn;

    \ \ \ \ fn[nr]= poor_bold_font (sfn, fat, fat); }

    \ \ else if (a[0] == "poor-bbb" && N(a) == 3) {

    \ \ \ \ double pw= as_double (a[1]);

    \ \ \ \ double ph= as_double (a[2]);

    \ \ \ \ font sfn= smart_font_bis (family, variant, series, "right", sz,
    hdpi, dpi);

    \ \ \ \ fn[nr]= poor_bbb_font (sfn, pw, ph, 1.5*pw); }

    \ \ else if (a[0] == "rubber" && N(a) == 2 && is_int (a[1])) {

    \ \ \ \ initialize_font (as_int (a[1]));

    \ \ \ \ fn[nr]= adjust_subfont (rubber_font (fn[as_int (a[1])]));

    \ \ \ \ //fn[nr]= adjust_subfont (rubber_unicode_font (fn[as_int
    (a[1])]));

    \ \ }

    \ \ else if (a[0] == "ignore")

    \ \ \ \ fn[nr]= fn[SUBFONT_MAIN];

    \ \ else {

    \ \ \ \ int \ ndpi= adjusted_dpi (a[0], a[1], a[2], a[3], as_int (a[4]));

    \ \ \ \ font cfn = closest_font (a[0], a[1], a[2], a[3], sz, ndpi, as_int
    (a[4]));

    \ \ \ \ fn[nr]= adjust_subfont (cfn);

    \ \ }

    \ \ //cout \<less\>\<less\> "Font " \<less\>\<less\> nr \<less\>\<less\>
    ", " \<less\>\<less\> a \<less\>\<less\> " -\<gtr\> " \<less\>\<less\>
    fn[nr]-\<gtr\>res_name \<less\>\<less\> "\\n";

    \ \ if (fn[nr]-\<gtr\>res_name == res_name) {

    \ \ \ \ failed_error \<less\>\<less\> "Font " \<less\>\<less\> nr
    \<less\>\<less\> ", " \<less\>\<less\> a

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \<less\>\<less\> " -\<gtr\> "
    \<less\>\<less\> fn[nr]-\<gtr\>res_name \<less\>\<less\> "\\n";

    \ \ \ \ FAILED ("substitution font loop detected");

    \ \ }

    }
  </cpp-code>

  \;

  <section|Other fonts><label|sec:other>

  <subsection|Rubber fonts><label|sec:rubber>

  Rubber fonts take care of large variants of delimiters like brackets and
  square roots, described by entities like
  <verbatim|\<less\>large-lceil-X\<gtr\>> where <verbatim|X=0,1,2,3,..> is
  some small integer. The interface is the function

  <\cpp-code>
    font rubber_font (font base);
  </cpp-code>

  which returns a font appropriate to render the rubber for a base font
  <verbatim|base>. It caches the result of a call to\ 

  <\cpp-code>
    static font

    make_rubber_font (font fn) {

    \ \ string name= locase_all (fn-\<gtr\>res_name);

    \ \ if (starts (name, "stix-") \|\|

    \ \ \ \ \ \ starts (name, "stix,") \|\|

    \ \ \ \ \ \ occurs (",stix,", name) \|\|

    \ \ \ \ \ \ occurs ("math=stix", name) \|\|

    \ \ \ \ \ \ occurs ("mathrubber=stix", name))

    \ \ \ \ return rubber_stix_font (fn);

    \ \ else if (occurs ("mathlarge=", name) \|\|

    \ \ \ \ \ \ \ \ \ \ \ occurs ("mathrubber=", name))

    \ \ \ \ return fn;

    \ \ else if (has_poor_rubber && fn-\<gtr\>type == FONT_TYPE_UNICODE)

    \ \ \ \ return poor_rubber_font (fn);

    \ \ else if (fn-\<gtr\>type == FONT_TYPE_UNICODE)

    \ \ \ \ return rubber_unicode_font (fn);

    \ \ else

    \ \ \ \ return fn;

    }
  </cpp-code>

  There is some special handling for STIX fonts which we ignore for the
  moment, moreover if the family name contain a specific selector for
  <verbatim|mathlarge> or <verbatim|mathrubber>, then we instantiate the same
  font, inhibiting any emulation of rubber before the proper handling of the
  selector (as we have seen in <cpp|smart_font_rep::resolve>). In case the
  base font is an unicode font, the global bool flag <cpp|has_poor_rubber>
  (which by default is <cpp|true>) controls whether we try to synthetize
  rubber or we use the font's provided one. If everything else is not
  appropriate we return the base font.\ 

  A <verbatim|poor_rubber> font has the duty of rendering TeXmacs entities
  which come in various sizes according to some hard-coded heuristics.\ 

  <\cpp-code>
    struct poor_rubber_font_rep: font_rep {

    \ \ font base;

    \ \ bool big_flag;

    \ \ array\<less\>bool\<gtr\> initialized;

    \ \ array\<less\>font\<gtr\> larger;

    \ \ translator virt;

    \;

    \ \ poor_rubber_font_rep (string name, font base);

    \ \ font \ \ get_font (int nr);

    \ \ int \ \ \ search_font (string s, string& r);

    \;

    \ // + virtual methods from the base class

    };
  </cpp-code>

  It relies on magnified versions of the fonts stored in the <cpp|larger>
  field and on virtual fonts to synthetise even larger versions of some of
  the glyphs via the <cpp|"emu-large"> virtual font (see
  Section<nbsp><reference|sec:virtual-font>).\ 

  <\cpp-code>
    #define MAGNIFIED_NUMBER 4

    #define HUGE_ADJUST 1

    \;

    poor_rubber_font_rep::poor_rubber_font_rep (string name, font base2):

    \ \ font_rep (name, base2), base (base2),

    \ \ big_flag (supports_big_operators (base2-\<gtr\>res_name))

    {

    \ \ this-\<gtr\>copy_math_pars (base);

    \ \ initialized \<less\>\<less\> true;

    \ \ larger \<less\>\<less\> base;

    \ \ for (int i=1; i\<less\>=2*MAGNIFIED_NUMBER+5; i++) {

    \ \ \ \ initialized \<less\>\<less\> false;

    \ \ \ \ larger \<less\>\<less\> base;

    \ \ }

    \ \ virt= load_translator ("emu-large");

    }
  </cpp-code>

  The boolean field <cpp|big_flag> is <cpp|true> according to the result of
  <cpp|supports_big_operators>:

  <\cpp-code>
    bool

    supports_big_operators (string res_name) {

    \ \ if (occurs (" Math", res_name))

    \ \ \ \ return occurs ("TeX Gyre ", res_name);

    \ \ if (occurs ("mathitalic", res_name))

    \ \ \ \ return occurs ("bonum", res_name) \|\|

    \ \ \ \ \ \ \ \ \ \ \ occurs ("pagella", res_name) \|\|

    \ \ \ \ \ \ \ \ \ \ \ occurs ("schola", res_name) \|\|

    \ \ \ \ \ \ \ \ \ \ \ occurs ("termes", res_name);

    \ \ return false;

    }
  </cpp-code>

  It indicates whether the font is capable of rendering bigger version of
  standard operators like sums, products, direct sums, etc<text-dots>
  (<math|<big|sum>>, <math|<big|prod>>, \<oplus\>, <text-dots>). Essentially
  only math fonts are capable of that and in the current version of TeXmacs
  only the math features for TeX Gyre fonts are implemented.

  The field <cpp|larger> is an array of <cpp|2*MAGNIFIED_NUMBER+5> fonts. The
  meaning of each slot is determined by the <cpp|search_font> function, which
  tries to locate the appropriate subfont (as return value) for a given
  TeXmacs entity <cpp|s>, eventually mapping it to another entity <cpp|r>.

  <\cpp-code>
    int

    poor_rubber_font_rep::search_font (string s, string& r) {

    \ \ if (starts (s, "\<less\>big-") && (ends (s, "-1\<gtr\>") \|\| ends
    (s, "-2\<gtr\>"))) {

    \ \ \ \ r= s;

    \ \ \ \ if (starts (s, "\<less\>big-iint") \|\| starts (s,
    "\<less\>big-iiint") \|\|

    \ \ \ \ \ \ \ \ starts (s, "\<less\>big-iiiint") \|\| starts (s,
    "\<less\>big-oint") \|\|

    \ \ \ \ \ \ \ \ starts (s, "\<less\>big-oiint") \|\| starts (s,
    "\<less\>big-oiiint") \|\|

    \ \ \ \ \ \ \ \ starts (s, "\<less\>big-upiint") \|\| starts (s,
    "\<less\>big-upiiint") \|\|

    \ \ \ \ \ \ \ \ starts (s, "\<less\>big-upiiiint") \|\| starts (s,
    "\<less\>big-upoint") \|\|

    \ \ \ \ \ \ \ \ starts (s, "\<less\>big-upoiint") \|\| starts (s,
    "\<less\>big-upoiiint") \|\|

    \ \ \ \ \ \ \ \ starts (s, "\<less\>big-amalg") \|\| starts (s,
    "\<less\>big-pluscup"))

    \ \ \ \ \ \ if (!big_flag) return 2*MAGNIFIED_NUMBER + 5;

    \ \ \ \ if (starts (s, "\<less\>big-idotsint") \|\| starts (s,
    "\<less\>big-upidotsint") \|\|

    \ \ \ \ \ \ \ \ starts (s, "\<less\>big-triangleup") \|\| starts (s,
    "\<less\>big-box") \|\|

    \ \ \ \ \ \ \ \ starts (s, "\<less\>big-parallel") \|\| starts (s,
    "\<less\>big-interleave"))

    \ \ \ \ \ \ return 2*MAGNIFIED_NUMBER + 5;

    \ \ \ \ if (big_flag && ends (s, "-1\<gtr\>") && base-\<gtr\>supports
    (s)) return 0;

    \ \ \ \ return 2*MAGNIFIED_NUMBER + 4;

    \ \ }

    \ \ if (starts (s, "\<less\>mid-")) s= "\<less\>left-" * s (5, N(s));

    \ \ if (starts (s, "\<less\>right-")) s= "\<less\>left-" * s (7, N(s));

    \ \ if (starts (s, "\<less\>large-")) s= "\<less\>left-" * s (7, N(s));

    \ \ if (starts (s, "\<less\>left-")) {

    \ \ \ \ int pos= search_backwards ("-", N(s), s), num;

    \ \ \ \ if (pos \<gtr\> 6) { r= s (6, pos); num= as_int (s (pos+1,
    N(s)-1)); }

    \ \ \ \ else { r= s (6, N(s)-1); num= 0; }

    \ \ \ \ //cout \<less\>\<less\> "Search " \<less\>\<less\>
    base-\<gtr\>res_name \<less\>\<less\> ", " \<less\>\<less\> s

    \ \ \ \ // \ \ \ \ \<less\>\<less\> ", " \<less\>\<less\> r
    \<less\>\<less\> ", " \<less\>\<less\> num \<less\>\<less\> LF;

    \ \ \ \ int nr= max (num - 5, 0);

    \ \ \ \ int thin= (is_thin (r)? 1: 0);

    \ \ \ \ int code;

    \ \ \ \ if (num \<less\>= MAGNIFIED_NUMBER \|\|

    \ \ \ \ \ \ \ \ r == "/" \|\| r == "\\\\" \|\|

    \ \ \ \ \ \ \ \ r == "langle" \|\| r == "rangle" \|\|

    \ \ \ \ \ \ \ \ r == "llangle" \|\| r == "rrangle") {

    \ \ \ \ \ \ num= min (num, MAGNIFIED_NUMBER);

    \ \ \ \ \ \ if (N(r) \<gtr\> 1) r= "\<less\>" * r * "\<gtr\>";

    \ \ \ \ \ \ if (N(r)\<gtr\>1 && !base-\<gtr\>supports (r)) {

    \ \ \ \ \ \ \ \ if (r == "\<less\>\|\|\<gtr\>") r=
    "\<less\>emu-dbar\<gtr\>";

    \ \ \ \ \ \ \ \ else if (r == "\<less\>interleave\<gtr\>") r=
    "\<less\>emu-tbar\<gtr\>";

    \ \ \ \ \ \ \ \ else if (r == "\<less\>llbracket\<gtr\>") r=
    "\<less\>emu-dlbracket\<gtr\>";

    \ \ \ \ \ \ \ \ else if (r == "\<less\>rrbracket\<gtr\>") r=
    "\<less\>emu-drbracket\<gtr\>";

    \ \ \ \ \ \ \ \ else r= "\<less\>emu-" * r (1, N(r)-1) * "\<gtr\>";

    \ \ \ \ \ \ }

    \ \ \ \ \ \ else if (r == "\\\\" && base-\<gtr\>supports ("/")) {

    \ \ \ \ \ \ \ \ metric ex1, ex2;

    \ \ \ \ \ \ \ \ base -\<gtr\> get_extents ("/", ex1);

    \ \ \ \ \ \ \ \ base -\<gtr\> get_extents ("\\\\", ex2);

    \ \ \ \ \ \ \ \ double h1= ex1-\<gtr\>y2 - ex1-\<gtr\>y1;

    \ \ \ \ \ \ \ \ double h2= ex2-\<gtr\>y2 - ex2-\<gtr\>y1;

    \ \ \ \ \ \ \ \ if (fabs ((h2/h1) - 1.0) \<gtr\> 0.05) r=
    "\<less\>emu-backslash\<gtr\>";

    \ \ \ \ \ \ }

    \ \ \ \ \ \ return 2*num + thin;

    \ \ \ \ }

    \ \ \ \ else if (r == "(")

    \ \ \ \ \ \ code= virt-\<gtr\>dict ["\<less\>rubber-lparenthesis-#\<gtr\>"];

    \ \ \ \ else if (r == ")")

    \ \ \ \ \ \ code= virt-\<gtr\>dict ["\<less\>rubber-rparenthesis-#\<gtr\>"];

    \ \ \ \ else if (r == "[")

    \ \ \ \ \ \ code= virt-\<gtr\>dict ["\<less\>rubber-lbracket-#\<gtr\>"];

    \ \ \ \ else if (r == "]")

    \ \ \ \ \ \ code= virt-\<gtr\>dict ["\<less\>rubber-rbracket-#\<gtr\>"];

    \ \ \ \ else if (r == "{")

    \ \ \ \ \ \ code= virt-\<gtr\>dict ["\<less\>rubber-lcurly-#\<gtr\>"];

    \ \ \ \ else if (r == "}")

    \ \ \ \ \ \ code= virt-\<gtr\>dict ["\<less\>rubber-rcurly-#\<gtr\>"];

    \ \ \ \ else if (r == "\|")

    \ \ \ \ \ \ code= virt-\<gtr\>dict ["\<less\>rubber-bar-#\<gtr\>"];

    \ \ \ \ else if (r == "\|\|") {

    \ \ \ \ \ \ if (base-\<gtr\>supports ("\<less\>\|\|\<gtr\>"))

    \ \ \ \ \ \ \ \ code= virt-\<gtr\>dict
    ["\<less\>rubber-parallel-#\<gtr\>"];

    \ \ \ \ \ \ else code= virt-\<gtr\>dict
    ["\<less\>rubber-parallel*-#\<gtr\>"];

    \ \ \ \ }

    \ \ \ \ else if (r == "interleave") {

    \ \ \ \ \ \ if (base-\<gtr\>supports ("\<less\>interleave\<gtr\>"))

    \ \ \ \ \ \ \ \ code= virt-\<gtr\>dict
    ["\<less\>rubber-interleave-#\<gtr\>"];

    \ \ \ \ \ \ else code= virt-\<gtr\>dict
    ["\<less\>rubber-interleave*-#\<gtr\>"];

    \ \ \ \ }

    \ \ \ \ else if (r == "lfloor" \|\| r == "rfloor" \|\|

    \ \ \ \ \ \ \ \ \ \ \ \ \ r == "lceil" \|\| r == "rceil" \|\|

    \ \ \ \ \ \ \ \ \ \ \ \ \ r == "llbracket" \|\| r == "rrbracket") {

    \ \ \ \ \ \ if (base-\<gtr\>supports ("\<less\>" * r * "\<gtr\>"))

    \ \ \ \ \ \ \ \ code= virt-\<gtr\>dict ["\<less\>rubber-" * r *
    "-#\<gtr\>"];

    \ \ \ \ \ \ else code= virt-\<gtr\>dict ["\<less\>rubber-" * r *
    "*-#\<gtr\>"];

    \ \ \ \ }

    \ \ \ \ else if (r == "dlfloor" \|\| r == "drfloor" \|\|

    \ \ \ \ \ \ \ \ \ \ \ \ \ r == "dlceil" \|\| r == "drceil" \|\|

    \ \ \ \ \ \ \ \ \ \ \ \ \ r == "tlbracket" \|\| r == "trbracket" \|\|

    \ \ \ \ \ \ \ \ \ \ \ \ \ r == "tlfloor" \|\| r == "trfloor" \|\|

    \ \ \ \ \ \ \ \ \ \ \ \ \ r == "tlceil" \|\| r == "trceil")

    \ \ \ \ \ \ code= virt-\<gtr\>dict ["\<less\>rubber-" * r * "-#\<gtr\>"];

    \ \ \ \ else if (r == "sqrt") {

    \ \ \ \ \ \ code= virt-\<gtr\>dict ["\<less\>rubber-sqrt-#\<gtr\>"];

    \ \ \ \ \ \ r= string ((char) code) * as_string (nr + HUGE_ADJUST) *
    "\<gtr\>";

    \ \ \ \ \ \ return 2*MAGNIFIED_NUMBER + 5;

    \ \ \ \ }

    \ \ \ \ else

    \ \ \ \ \ \ code= virt-\<gtr\>dict ["\<less\>rubber-lparenthesis-#\<gtr\>"];

    \ \ \ \ 

    \ \ \ \ r= string ((char) code) * as_string (nr + HUGE_ADJUST) *
    "\<gtr\>";

    \ \ \ \ return 2*MAGNIFIED_NUMBER + 2 + thin;

    \ \ }

    \ \ r= s;

    \ \ return 0;

    }
  </cpp-code>

  The coding of this function is relatively straighfoward.

  For entities of the form <verbatim|\<less\>big-XXXX-N\<gtr\>> with
  <verbatim|N=1,2> we use the subfont of index <cpp|2*MAGNIFIED_NUMBER + 5>
  is used if <cpp|big_flag> is <cpp|false> or in case <cpp|big_flag> is
  <cpp|true>, for the big variants with <verbatim|N=2> while for those at
  <verbatim|N=1> the base font is used. The subfont at index
  <cpp|2*MAGNIFIED_NUMBER + 4> is used in this case for the <verbatim|N=2>
  sized glyphs.\ 

  Otherwise we normalize all entities of the form
  \ <verbatim|\<less\>left-XXXX-N\<gtr\>>,
  \ <verbatim|\<less\>mid-XXXX-N\<gtr\>>,
  \ <verbatim|\<less\>right-XXXX-N\<gtr\>>, into
  \ <verbatim|\<less\>large-XXXX-N\<gtr\>> and extract the value of
  <verbatim|N>. For small values of <verbatim|N> we use the subfont at index
  <cpp|2*N+thin> where <cpp|thin=0,1> according to the return value of the
  <cpp|is_thin> function:

  <\cpp-code>
    static hashset\<less\>string\<gtr\> thin_delims;

    \;

    static bool

    is_thin (string s) {

    \ \ if (N(thin_delims) == 0)

    \ \ \ \ thin_delims \<less\>\<less\> string ("\|") \<less\>\<less\>
    string ("\|\|") \<less\>\<less\> string ("interleave")

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \<less\>\<less\> string ("[")
    \<less\>\<less\> string ("]")

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \<less\>\<less\> string ("lfloor")
    \<less\>\<less\> string ("rfloor")

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \<less\>\<less\> string ("lceil")
    \<less\>\<less\> string ("rceil")

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \<less\>\<less\> string ("llbracket")
    \<less\>\<less\> string ("rrbracket")

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \<less\>\<less\> string ("dlfloor")
    \<less\>\<less\> string ("drfloor")

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \<less\>\<less\> string ("dlceil")
    \<less\>\<less\> string ("drceil")

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \<less\>\<less\> string ("tlbracket")
    \<less\>\<less\> string ("trbracket")

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \<less\>\<less\> string ("tlfloor")
    \<less\>\<less\> string ("trfloor")

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \<less\>\<less\> string ("tlceil")
    \<less\>\<less\> string ("trceil");

    \ \ return thin_delims-\<gtr\>contains (s);

    }
  </cpp-code>

  For larger glyphs we fallback to the appropriate parametrized glyph in the
  virtual font encoding the value of the size parameter in the rewriting
  entity <cpp|r> (see the virtual font for how this precisely works).

  The physical font associated to each subfont index is determined by the
  <cpp|get_font> method: \ 

  <\cpp-code>
    font

    poor_rubber_font_rep::get_font (int nr) {

    \ \ ASSERT (nr \<less\> N(larger), "wrong font number");

    \ \ if (initialized[nr]) return larger[nr];

    \ \ initialized[nr]= true;

    \ \ if (nr \<less\>= 2*MAGNIFIED_NUMBER + 1) {

    \ \ \ \ int hnr= nr / 2;

    \ \ \ \ double zoomy= pow (2.0, ((double) hnr) / 4.0);

    \ \ \ \ double zoomx= sqrt (zoomy);

    \ \ \ \ if ((nr & 1) == 1) zoomx= sqrt (zoomx);

    \ \ \ \ larger[nr]= poor_stretched_font (base, zoomx, zoomy);

    \ \ \ \ //larger[nr]= base-\<gtr\>magnify (zoomx, zoomy);

    \ \ }

    \ \ else if (nr == 2*MAGNIFIED_NUMBER + 2 \|\| nr == 2*MAGNIFIED_NUMBER +
    3) {

    \ \ \ \ int hdpi= (72 * base-\<gtr\>wpt + (PIXEL/2)) / PIXEL;

    \ \ \ \ int vdpi= (72 * base-\<gtr\>hpt + (PIXEL/2)) / PIXEL;

    \ \ \ \ font vfn= virtual_font (base, "emu-large", base-\<gtr\>size,
    hdpi, vdpi, false);

    \ \ \ \ double zoomy= pow (2.0, ((double) MAGNIFIED_NUMBER) / 4.0);

    \ \ \ \ double zoomx= sqrt (zoomy);

    \ \ \ \ if ((nr & 1) == 1) zoomx= sqrt (zoomx);

    \ \ \ \ larger[nr]= poor_stretched_font (vfn, zoomx, zoomy);

    \ \ \ \ //larger[nr]= vfn-\<gtr\>magnify (zoomx, zoomy);

    \ \ }

    \ \ else if (nr == 2*MAGNIFIED_NUMBER + 5) {

    \ \ \ \ int hdpi= (72 * this-\<gtr\>wpt + (PIXEL/2)) / PIXEL;

    \ \ \ \ int vdpi= (72 * this-\<gtr\>hpt + (PIXEL/2)) / PIXEL;

    \ \ \ \ font vfn= virtual_font (this, "emu-large", this-\<gtr\>size,
    hdpi, vdpi, false);

    \ \ \ \ larger[nr]= vfn;

    \ \ }

    \ \ else

    \ \ \ \ larger[nr]= rubber_unicode_font (base);

    \ \ return larger[nr];

    }
  </cpp-code>

  which dispatches as follows:

  <\itemize>
    <item>it associates magnified versions of the font to all indexed from
    <cpp|0> to <cpp|2*MAGNIFIED_NUMBER + 1> with the index of the form
    <cpp|2*n+0> horizontally zoomed via the square root of the vertical zoom
    and those with index \ <cpp|2*n+1>, zoomed horizontally with the fourth
    root of the vertical zoom to make them more elongated;

    <item>the index <cpp|2*MAGNIFIED_NUMBER + 2> and <cpp|2*MAGNIFIED_NUMBER
    + 3> are associated to normal and thin versions of magnified
    <cpp|"emu-large"> virtual glyphs;

    <item>while <cpp|2*MAGNIFIED_NUMBER + 5> to normal versions of the
    virtual font;

    <item>and finally <cpp|2*MAGNIFIED_NUMBER + 4> to the
    <cpp|rubber_unicode_font> based on the same font as this rubbert font.
  </itemize>

  <subsection|Unicode fonts><label|sec:unicode-font>

  Unicode fontsare capable of indexing unicode glyphs in physical fonts (i.e.
  modern TrueType, or OpenType font files which can handle the whole unicode
  space without special encodings)\ 

  <\cpp-code>
    struct unicode_font_rep: font_rep {

    \ \ string \ \ \ \ \ family;

    \ \ int \ \ \ \ \ \ \ \ hdpi;

    \ \ int \ \ \ \ \ \ \ \ vdpi;

    \ \ font_metric fnm;

    \ \ font_glyphs fng;

    \ \ int \ \ \ \ \ \ \ \ ligs;

    \;

    \ \ hashmap\<less\>string,int\<gtr\> native; // additional native (non
    unicode) characters

    \ \ 

    \ \ unicode_font_rep (string name, string family, int size, int hdpi, int
    vdpi);

    \ \ void tex_gyre_operators ();

    \;

    \ \ unsigned int read_unicode_char (string s, int& i);

    \ \ unsigned int ligature_replace (unsigned int c, string s, int& i);

    \ \ 

    \ \ // + virtual functions from the base class

    };
  </cpp-code>

  The constructors set the <cpp|font_rep::type> field to
  <cpp|FONT_TYPE_UNICODE>, load the metric and glyph informatations from the
  font file which is (ultimately) retrieved via the function

  <\cpp-code>
    tt_face load_tt_face (string name);
  </cpp-code>

  and initializes the various metric information with values from the
  physical font and suitable heuristics for the mathematical measurements:

  <\cpp-code>
    \ \ // in unicode_font_rep::unicode_font_rep (...)\ 

    \;

    \ \ // get main font parameters

    \ \ metric ex;

    \ \ get_extents ("f", ex);

    \ \ y1= ex-\<gtr\>y1;

    \ \ y2= ex-\<gtr\>y2;

    \ \ get_extents ("p", ex);

    \ \ y1= min (y1, ex-\<gtr\>y1);

    \ \ y2= max (y2, ex-\<gtr\>y2);

    \ \ get_extents ("d", ex);

    \ \ y1= min (y1, ex-\<gtr\>y1);

    \ \ y2= max (y2, ex-\<gtr\>y2);

    \ \ display_size = y2-y1;

    \ \ design_size \ = size \<less\>\<less\> 8;

    \;

    \ \ // get character dimensions

    \ \ get_extents ("x", ex);

    \ \ yx \ \ \ \ \ \ \ \ \ \ = ex-\<gtr\>y2;

    \ \ get_extents ("M", ex);

    \ \ wquad \ \ \ \ \ \ \ = ex-\<gtr\>x2;

    \;

    \ \ // compute other heights

    \ \ yfrac \ \ \ \ \ \ \ = yx \<gtr\>\<gtr\> 1;

    \ \ ysub_lo_base = -yx/3;

    \ \ ysub_hi_lim \ = (5*yx)/6;

    \ \ ysup_lo_lim \ = yx/2;

    \ \ ysup_lo_base = (5*yx)/6;

    \ \ ysup_hi_lim \ = yx;

    \ \ yshift \ \ \ \ \ \ = yx/6;

    \;

    \ \ // compute other widths

    \ \ wpt \ \ \ \ \ \ \ \ \ = (hdpi*PIXEL)/72;

    \ \ hpt \ \ \ \ \ \ \ \ \ = (vdpi*PIXEL)/72;

    \ \ wfn \ \ \ \ \ \ \ \ \ = (wpt*design_size) \<gtr\>\<gtr\> 8;

    \ \ wline \ \ \ \ \ \ \ = wfn/20;

    \;

    \ \ // get fraction bar parameters; reasonable compromise between several
    fonts

    \ \ if (supports ("\<less\>#2212\<gtr\>")) get_extents
    ("\<less\>#2212\<gtr\>", ex);

    \ \ else if (supports ("+")) get_extents ("+", ex);

    \ \ else if (supports ("-")) get_extents ("-", ex);

    \ \ else get_extents ("x", ex);

    \ \ yfrac= (ex-\<gtr\>y1 + ex-\<gtr\>y2) \<gtr\>\<gtr\> 1;

    \ \ if (supports ("\<less\>#2212\<gtr\>") \|\| supports ("+") \|\|
    supports ("-")) {

    \ \ \ \ wline= ex-\<gtr\>y2 - ex-\<gtr\>y1;

    \ \ \ \ if (supports ("\<less\>#2212\<gtr\>"));

    \ \ \ \ else if (supports ("\<less\>#2013\<gtr\>")) {

    \ \ \ \ \ \ get_extents ("\<less\>#2013\<gtr\>", ex);

    \ \ \ \ \ \ wline= min (wline, ex-\<gtr\>y2 - ex-\<gtr\>y1);

    \ \ \ \ }

    \ \ \ \ wline= max (min (wline, wfn/8), wfn/48);

    \ \ \ \ if (!supports ("\<less\>#2212\<gtr\>")) yfrac += wline/4;

    \ \ }

    \ \ if (starts (res_name, "unicode:Papyrus.")) wline= (2*wline)/3;

    \;

    \ \ // get space length

    \ \ get_extents (" ", ex);

    \ \ spc \ = space ((3*(ex-\<gtr\>x2-ex-\<gtr\>x1))\<gtr\>\<gtr\>2,
    ex-\<gtr\>x2-ex-\<gtr\>x1, (3*(ex-\<gtr\>x2-ex-\<gtr\>x1))\<gtr\>\<gtr\>1);

    \ \ extra= spc/2;

    \ \ mspc = spc;

    \ \ sep \ = wfn/10;

    \;

    \ \ // get_italic space

    \ \ get_extents ("f", ex);

    \ \ SI italic_spc= (ex-\<gtr\>x4-ex-\<gtr\>x3)-(ex-\<gtr\>x2-ex-\<gtr\>x1);

    \ \ slope= ((double) italic_spc) / ((double) display_size) - 0.05;

    \ \ if (slope\<less\>0.15) slope= 0.0;

    \;

    \ \ // determine whether we are dealing with a monospaced font

    \ \ get_extents ("m", ex);

    \ \ SI em= ex-\<gtr\>x2 - ex-\<gtr\>x1;

    \ \ get_extents ("i", ex);

    \ \ SI ei= ex-\<gtr\>x2 - ex-\<gtr\>x1;

    \ \ bool mono= (em == ei);
  </cpp-code>

  sets the available common ligatures

  <\cpp-code>
    \ \ // available standard ligatures

    \ \ if (!mono) {

    \ \ \ \ if (fnm-\<gtr\>exists (0xfb00)) ligs += LIGATURE_FF;

    \ \ \ \ if (fnm-\<gtr\>exists (0xfb01)) ligs += LIGATURE_FI;

    \ \ \ \ if (fnm-\<gtr\>exists (0xfb02)) ligs += LIGATURE_FL;

    \ \ \ \ if (fnm-\<gtr\>exists (0xfb03)) ligs += LIGATURE_FFI;

    \ \ \ \ if (fnm-\<gtr\>exists (0xfb04)) ligs += LIGATURE_FFL;

    \ \ \ \ if (fnm-\<gtr\>exists (0xfb05)) ligs += LIGATURE_FT;

    \ \ \ \ //if (fnm-\<gtr\>exists (0xfb06)) ligs += LIGATURE_ST;

    \ \ }

    \ \ if (family == "Times New Roman")

    \ \ \ \ ligs= LIGATURE_FI + LIGATURE_FL;

    \ \ if (family == "Zapfino")

    \ \ \ \ ligs= LIGATURE_FF + LIGATURE_FI + LIGATURE_FL + LIGATURE_FFI;

    \ \ //cout \<less\>\<less\> "ligs= " \<less\>\<less\> ligs
    \<less\>\<less\> ", " \<less\>\<less\> family \<less\>\<less\> ", "
    \<less\>\<less\> size \<less\>\<less\> "\\n";
  </cpp-code>

  initialize the translation table for Unicode native glyphs for TeX Gyre
  fonts, which at the moment are the only ones with this particular feature
  implemented in TeXmacs,

  <\cpp-code>
    \ \ // direct translations for certain characters without Unicode names

    \ \ if (starts (family, "texgyre") && ends (family, "-math"))

    \ \ \ \ tex_gyre_operators ();
  </cpp-code>

  and finally initialize microtypographic adjustements (in
  <cpp|lsub_correct>, <cpp|lsup_correct>, <text-dots> fields of
  <cpp|font_rep>) which are hard-coded in TeXmacs for some of the \Pcurated\Q
  fonts, for example:

  <\cpp-code>
    \ \ if (starts (family, "STIX-")) {

    \ \ \ \ if (!ends (family, "italic")) {

    \ \ \ \ \ \ global_rsub_correct= (SI) (0.04 * wfn);

    \ \ \ \ \ \ global_rsup_correct= (SI) (0.04 * wfn);

    \ \ \ \ \ \ lsub_correct= lsub_stix_table ();

    \ \ \ \ \ \ lsup_correct= lsup_stix_table ();

    \ \ \ \ \ \ rsub_correct= rsub_stix_table ();

    \ \ \ \ \ \ rsup_correct= rsup_stix_table ();

    \ \ \ \ \ \ above_correct= above_stix_table ();

    \ \ \ \ }

    \ \ \ \ else {

    \ \ \ \ \ \ global_rsub_correct= (SI) (0.04 * wfn);

    \ \ \ \ \ \ global_rsup_correct= (SI) (0.04 * wfn);

    \ \ \ \ \ \ lsub_correct= lsub_stix_italic_table ();

    \ \ \ \ \ \ lsup_correct= lsup_stix_italic_table ();

    \ \ \ \ \ \ rsub_correct= rsub_stix_italic_table ();

    \ \ \ \ \ \ rsup_correct= rsup_stix_italic_table ();

    \ \ \ \ \ \ above_correct= above_stix_italic_table ();

    \ \ \ \ }

    \ \ }

    \ \ // other cases for TeX Gyre fonts, Papyrus, Linux Libertine &
    Biolinum, Fira, not shown

    }
  </cpp-code>

  \;

  The <cpp|tex_gyre_native> function initialize lookup table to find entities
  (for mathematical typography) which are not mapped in the standardized
  unicode points but in the private areas and in a font-dependent manner. It
  might be interesting to see how it is coded to haev an idea of the range of
  glyphs involved in the re-mapping:

  <\wide-tabular>
    <tformat|<cwith|1|1|1|-1|cell-valign|t>|<cwith|1|1|1|1|cell-width|0.45par>|<cwith|1|1|1|1|cell-hmode|exact>|<table|<row|<\cell>
      <\cpp-code>
        static hashmap\<less\>string,int\<gtr\>

        tex_gyre_native () {

        \ \ static hashmap\<less\>string,int\<gtr\> native;

        \ \ if (N(native) != 0) return native;

        \ \ native ("\<less\>big-prod-2\<gtr\>")= 4215;

        \ \ native ("\<less\>big-amalg-2\<gtr\>")= 4216;

        \ \ native ("\<less\>big-sum-2\<gtr\>")= 4217;

        \ \ native ("\<less\>big-int-2\<gtr\>")= 4149;

        \ \ native ("\<less\>big-iint-2\<gtr\>")= 4150;

        \ \ native ("\<less\>big-iiint-2\<gtr\>")= 4151;

        \ \ native ("\<less\>big-iiiint-2\<gtr\>")= 4152;

        \ \ native ("\<less\>big-oint-2\<gtr\>")= 4153;

        \ \ native ("\<less\>big-oiint-2\<gtr\>")= 4154;

        \ \ native ("\<less\>big-oiiint-2\<gtr\>")= 4155;

        \ \ native ("\<less\>big-wedge-2\<gtr\>")= 3833;

        \ \ native ("\<less\>big-vee-2\<gtr\>")= 3835;

        \ \ native ("\<less\>big-cap-2\<gtr\>")= 3827;

        \ \ native ("\<less\>big-cup-2\<gtr\>")= 3829;

        \ \ native ("\<less\>big-odot-2\<gtr\>")= 3864;

        \ \ native ("\<less\>big-oplus-2\<gtr\>")= 3868;

        \ \ native ("\<less\>big-otimes-2\<gtr\>")= 3873;

        \ \ native ("\<less\>big-pluscup-2\<gtr\>")= 3861;

        \ \ native ("\<less\>big-sqcap-2\<gtr\>")= 3852;

        \ \ native ("\<less\>big-sqcup-2\<gtr\>")= 3854;

        \ \ native ("\<less\>big-intlim-2\<gtr\>")= 4149;

        \ \ native ("\<less\>big-iintlim-2\<gtr\>")= 4150;

        \ \ native ("\<less\>big-iiintlim-2\<gtr\>")= 4151;

        \ \ native ("\<less\>big-iiiintlim-2\<gtr\>")= 4152;

        \ \ native ("\<less\>big-ointlim-2\<gtr\>")= 4153;

        \ \ native ("\<less\>big-oiintlim-2\<gtr\>")= 4154;

        \ \ native ("\<less\>big-oiiintlim-2\<gtr\>")= 4155;

        \ \ native ("\<less\>big-upint-2\<gtr\>")= 4149;

        \ \ native ("\<less\>big-upiint-2\<gtr\>")= 4150;

        \ \ native ("\<less\>big-upiiint-2\<gtr\>")= 4151;

        \ \ native ("\<less\>big-upiiiint-2\<gtr\>")= 4152;

        \ \ native ("\<less\>big-upoint-2\<gtr\>")= 4153;

        \ \ native ("\<less\>big-upoiint-2\<gtr\>")= 4154;

        \ \ native ("\<less\>big-upoiiint-2\<gtr\>")= 4155;

        \ \ native ("\<less\>big-upintlim-2\<gtr\>")= 4149;

        \ \ native ("\<less\>big-upiintlim-2\<gtr\>")= 4150;

        \ \ native ("\<less\>big-upiiintlim-2\<gtr\>")= 4151;

        \ \ native ("\<less\>big-upiiiintlim-2\<gtr\>")= 4152;

        \ \ native ("\<less\>big-upointlim-2\<gtr\>")= 4153;

        \ \ native ("\<less\>big-upoiintlim-2\<gtr\>")= 4154;

        \ \ native ("\<less\>big-upoiiintlim-2\<gtr\>")= 4155;

        \ \ 

        \ \ 

        \ \ native ("\<less\>large-sqrt-1\<gtr\>")= 4136;

        \ \ native ("\<less\>large-sqrt-2\<gtr\>")= 4148;

        \ \ native ("\<less\>large-sqrt-3\<gtr\>")= 4160;

        \ \ native ("\<less\>large-sqrt-4\<gtr\>")= 4172;

        \ \ native ("\<less\>large-sqrt-5\<gtr\>")= 4184;

        \ \ native ("\<less\>large-sqrt-6\<gtr\>")= 4196;

        \;
      </cpp-code>
    </cell>|<\cell>
      <\small>
        <\cpp-code>
          \;

          \;

          \ \ bracket (native, "(", 1, 5, 3461, 22);

          \ \ bracket (native, ")", 1, 5, 3462, 22);

          \ \ bracket (native, "{", 1, 5, 3465, 22);

          \ \ bracket (native, "}", 1, 5, 3466, 22);

          \ \ bracket (native, "[", 1, 5, 3467, 22);

          \ \ bracket (native, "]", 1, 5, 3468, 22);

          \ \ bracket (native, "lceil", 1, 5, 3469, 22);

          \ \ bracket (native, "rceil", 1, 5, 3470, 22);

          \ \ bracket (native, "lfloor", 1, 5, 3471, 22);

          \ \ bracket (native, "rfloor", 1, 5, 3472, 22);

          \ \ bracket (native, "llbracket", 1, 5, 3473, 22);

          \ \ bracket (native, "rrbracket", 1, 5, 3474, 22);

          \ \ bracket (native, "langle", 1, 6, 3655, 4);

          \ \ bracket (native, "rangle", 1, 6, 3656, 4);

          \ \ bracket (native, "llangle", 1, 6, 3657, 4);

          \ \ bracket (native, "rrangle", 1, 6, 3658, 4);

          \ \ bracket (native, "/", 1, 6, 3742, 7);

          \ \ bracket (native, "\\\\", 1, 6, 3743, 7);

          \ \ bracket (native, "\|", 1, 6, 3745, 7);

          \ \ bracket (native, "\|\|", 1, 6, 3746, 7);

          \;

          \ \ native ("\<less\>wide-hat-0\<gtr\>")= 125;

          \ \ native ("\<less\>wide-tilde-0\<gtr\>")= 126;

          \ \ native ("\<less\>wide-breve-0\<gtr\>")= 128;

          \ \ native ("\<less\>wide-check-0\<gtr\>")= 135;

          \ \ wide (native, "breve", 1, 6, 3378, 10);

          \ \ wide (native, "invbreve", 1, 6, 3380, 10);

          \ \ wide (native, "check", 1, 6, 3382, 10);

          \ \ wide (native, "hat", 1, 6, 3384, 10);

          \ \ wide (native, "tilde", 1, 6, 3386, 10);

          \ \ wide (native, "overbrace", 0, 5, 3453, 22);

          \ \ wide (native, "overbrace*", 0, 5, 3453, 22);

          \ \ wide (native, "underbrace", 0, 5, 3454, 22);

          \ \ wide (native, "underbrace*", 0, 5, 3454, 22);

          \ \ wide (native, "poverbrace", 0, 5, 3455, 22);

          \ \ wide (native, "poverbrace*", 0, 5, 3455, 22);

          \ \ wide (native, "punderbrace", 0, 5, 3456, 22);

          \ \ wide (native, "punderbrace*", 0, 5, 3456, 22);

          \ \ wide (native, "sqoverbrace", 0, 5, 3457, 22);

          \ \ wide (native, "sqoverbrace*", 0, 5, 3457, 22);

          \ \ wide (native, "squnderbrace", 0, 5, 3458, 22);

          \ \ wide (native, "squnderbrace*", 0, 5, 3458, 22);

          \ \ return native;

          }

          \;

          \;

          \;

          \;

          \;

          \;

          \;

          \;

          \;
        </cpp-code>
      </small>
    </cell>>>>
  </wide-tabular>

  \;

  The dispatching function is\ 

  <\cpp-code>
    unsigned int

    unicode_font_rep::read_unicode_char (string s, int& i) {

    \ \ if (s[i] == '\<less\>') {

    \ \ \ \ i++;

    \ \ \ \ int start= i, n= N(s);

    \ \ \ \ while (true) {

    \ \ \ \ \ \ if (i == n) {

    \ \ \ \ \ \ \ \ i= start;

    \ \ \ \ \ \ \ \ return (int) '\<less\>';

    \ \ \ \ \ \ }

    \ \ \ \ \ \ if (s[i] == '\<gtr\>') break;

    \ \ \ \ \ \ i++;

    \ \ \ \ }

    \ \ \ \ if (s[start] == '#') {

    \ \ \ \ \ \ start++;

    \ \ \ \ \ \ return (unsigned int) from_hexadecimal (s (start, i++));

    \ \ \ \ }

    \ \ \ \ else {

    \ \ \ \ \ \ string ss= s (start-1, ++i);

    \ \ \ \ \ \ string uu= strict_cork_to_utf8 (ss);

    \ \ \ \ \ \ if (uu == ss) {

    \ \ \ \ \ \ \ \ if (native-\<gtr\>contains (ss)) return 0xc000000 +
    native[ss];

    \ \ \ \ \ \ \ \ return 0;

    \ \ \ \ \ \ }

    \ \ \ \ \ \ int j= 0;

    \ \ \ \ \ \ return decode_from_utf8 (uu, j);

    \ \ \ \ }

    \ \ }

    \ \ else {

    \ \ \ \ unsigned int c= (unsigned int) s[i++];

    \ \ \ \ if (c \<gtr\>= 32 && c \<less\>= 127) return c;

    \ \ \ \ string ss= s (i-1, i);

    \ \ \ \ string uu= strict_cork_to_utf8 (ss);

    \ \ \ \ int j= 0;

    \ \ \ \ return decode_from_utf8 (uu, j);

    \ \ }

    }
  </cpp-code>

  which maps entities of the form <verbatim|\<less\>#XXXX\<gtr\>> in the
  Unicode code point <verbatim|XXXX>, while tries to use the
  <cpp|strict_cork_to_utf8> function to map other entities into a meaningful
  Unicode code point and if this fails check the <cpp|native> lookup table
  for possible glyph indexes and return a \Pfake\Q unicode point of the form
  <cpp|0xc000000 + glyph_index>. The function <cpp|decode_from_utf8> converts
  <verbatim|UTF8> into a <cpp|unsigned int> Unicode point.

  This function is used by <cpp|supports>:

  <\cpp-code>
    bool

    unicode_font_rep::supports (string c) {

    \ \ if (N(c) == 0) return false;

    \ \ int i= 0;

    \ \ unsigned int uc= read_unicode_char (c, i);

    \ \ if (uc == 0 \|\| !fnm-\<gtr\>exists (uc)) return false;

    \ \ if (uc \<gtr\>= 0x42 && uc \<less\>= 0x5a && !fnm-\<gtr\>exists
    (0x41)) return false;

    \ \ if (uc \<gtr\>= 0x62 && uc \<less\>= 0x7a && !fnm-\<gtr\>exists
    (0x61)) return false;

    \ \ metric_struct* m= fnm-\<gtr\>get (uc);

    \ \ return m-\<gtr\>x1 \<less\> m-\<gtr\>x2 && m-\<gtr\>y1 \<less\>
    m-\<gtr\>y2;

    }
  </cpp-code>

  Note that <cpp|fnm-\<gtr\>exists (uc)> refers to

  <\cpp-code>
    bool tt_font_metric_rep::exists (int i);
  </cpp-code>

  which uses <cpp|decode_index> to retrieve the glyph number (and decode the
  \Pfake\Q unicode points into direct glyph numbers)

  <\cpp-code>
    inline FT_UInt

    decode_index (FT_Face face, int i) {

    \ \ if (i \<less\> 0xc000000) return ft_get_char_index (face, i);

    \ \ return i - 0xc000000; \ 

    }
  </cpp-code>

  Ligature replacement is implemented as follow

  <\cpp-code>
    unsigned int

    unicode_font_rep::ligature_replace (unsigned int uc, string s, int& i) {

    \ \ int n= N(s);

    \ \ if (((char) uc) == 'f') {

    \ \ \ \ if (i\<less\>n && s[i] == 'i' && (ligs & LIGATURE_FI) != 0) {

    \ \ \ \ \ \ i++; return 0xfb01; }

    \ \ \ \ else if (i\<less\>n && s[i] == 'l' && (ligs & LIGATURE_FL) != 0)
    {

    \ \ \ \ \ \ i++; return 0xfb02; }

    \ \ \ \ else if (i\<less\>n && s[i] == 't' && (ligs & LIGATURE_FT) != 0)
    {

    \ \ \ \ \ \ i++; return 0xfb05; }

    \ \ \ \ else if ((i+1)\<less\>n && s[i] == 'f' && s[i+1] == 'i' &&

    \ \ \ \ \ \ \ \ \ \ \ \ \ (ligs & LIGATURE_FFI) != 0) {

    \ \ \ \ \ \ i+=2; return 0xfb03; }

    \ \ \ \ else if ((i+1)\<less\>n && s[i] == 'f' && s[i+1] == 'l' &&

    \ \ \ \ \ \ \ \ \ \ \ \ \ (ligs & LIGATURE_FFL) != 0) {

    \ \ \ \ \ \ i+=2; return 0xfb04; }

    \ \ \ \ else if (i\<less\>n && s[i] == 'f' && (ligs & LIGATURE_FF) != 0)
    {

    \ \ \ \ \ \ i++; return 0xfb00; }

    \ \ \ \ else return uc;

    \ \ }

    \ \ else if (((char) uc) == 's') {

    \ \ \ \ if (i\<less\>n && s[i] == 't' && (ligs & LIGATURE_ST) != 0) {

    \ \ \ \ \ \ i++; return 0xfb06; }

    \ \ \ \ else return uc;

    \ \ }

    \ \ else return uc;

    }
  </cpp-code>

  All these mechanisms works together in virtual methods like
  <cpp|draw_fixed> to produce a series of glyphs on the rendering surface via
  the <cpp|draw> method of <cpp|render_rep>:

  <\cpp-code>
    void renderer_rep::draw (int c, font_glyphs fng, SI x, SI y)
  </cpp-code>

  specifically the code of <cpp|unicode_font_rep::draw_fixed> reads:

  <\cpp-code>
    void

    unicode_font_rep::draw_fixed (renderer ren, string s, SI x, SI y, bool
    ligf) {

    \ \ int i= 0, n= N(s);

    \ \ unsigned int uc= 0xffffffff;

    \ \ while (i\<less\>n) {

    \ \ \ \ unsigned int pc= uc;

    \ \ \ \ uc= read_unicode_char (s, i);

    \ \ \ \ if (ligs \<gtr\> 0 && ligf && (((char) uc) == 'f' \|\| ((char)
    uc) == 's'))

    \ \ \ \ \ \ uc= ligature_replace (uc, s, i);

    \ \ \ \ if (pc != 0xffffffff) x += ROUND (fnm-\<gtr\>kerning (pc, uc));

    \ \ \ \ ren-\<gtr\>draw (uc, fng, x, y);

    \ \ \ \ metric_struct* ex= fnm-\<gtr\>get (uc);

    \ \ \ \ x += ROUND (ex-\<gtr\>x2);

    \ \ \ \ //if (fnm-\<gtr\>kerning (pc, uc) != 0)

    \ \ \ \ //cout \<less\>\<less\> "Kerning " \<less\>\<less\> ((char) pc)
    \<less\>\<less\> ((char) uc) \<less\>\<less\> " " \<less\>\<less\> ROUND
    (fnm-\<gtr\>kerning (pc, uc)) \<less\>\<less\> ", " \<less\>\<less\>
    ROUND (ex-\<gtr\>x2) \<less\>\<less\> "\\n";

    \ \ }

    }
  </cpp-code>

  <subsection|Rubber Unicode fonts><label|sec:rubber-unicode>

  Rubber Unicode fonts are implemented similarly to rubber fonts. They
  dispatch according to the <cpp|search_font> function which caches the
  subfont index and rewriting returned by <cpp|search_font_sub>:

  <\cpp-code>
    int

    rubber_unicode_font_rep::search_font_sub (string s, string& rew) {

    \ \ if (starts (s, "\<less\>big-") && ends (s, "-1\<gtr\>")) {

    \ \ \ \ string r= s (5, N(s) - 3);

    \ \ \ \ if (ends (r, "lim")) r= r (0, N(r) - 3);

    \ \ \ \ if (starts (r, "up")) r= r (2, N(r));

    \ \ \ \ r= "\<less\>" * r * "\<gtr\>";

    \ \ \ \ if (base-\<gtr\>supports (r)) {

    \ \ \ \ \ \ rew= r;

    \ \ \ \ \ \ if (r == "\<less\>sum\<gtr\>" \|\| r == "\<less\>prod\<gtr\>"
    \|\| ends (r, "int\<gtr\>"))

    \ \ \ \ \ \ \ \ if (big_sums) return 0;

    \ \ \ \ \ \ return 2;

    \ \ \ \ }

    \ \ }

    \ \ if (starts (s, "\<less\>big-") && ends (s, "-2\<gtr\>")) {

    \ \ \ \ if (big_flag && base-\<gtr\>supports (s)) {

    \ \ \ \ \ \ rew= s;

    \ \ \ \ \ \ return 0;

    \ \ \ \ }

    \ \ \ \ string r= s (5, N(s) - 3);

    \ \ \ \ if (ends (r, "lim")) r= r (0, N(r) - 3);

    \ \ \ \ if (starts (r, "up")) r= r (2, N(r));

    \ \ \ \ if (big_flag && base-\<gtr\>supports ("\<less\>big-" * r *
    "-1\<gtr\>")) {

    \ \ \ \ \ \ rew= "\<less\>big-" * r * "-1\<gtr\>";

    \ \ \ \ \ \ return 2;

    \ \ \ \ }

    \ \ \ \ r= "\<less\>" * r * "\<gtr\>";

    \ \ \ \ if (base-\<gtr\>supports (r)) {

    \ \ \ \ \ \ rew= r;

    \ \ \ \ \ \ if (r == "\<less\>sum\<gtr\>" \|\| r == "\<less\>prod\<gtr\>"
    \|\| ends (r, "int\<gtr\>"))

    \ \ \ \ \ \ \ \ if (big_sums) return 2;

    \ \ \ \ \ \ return 3;

    \ \ \ \ }

    \ \ }

    \ \ if (starts (s, "\<less\>mid-")) s= "\<less\>left-" * s (5, N(s));

    \ \ if (starts (s, "\<less\>right-")) s= "\<less\>left-" * s (7, N(s));

    \ \ if (starts (s, "\<less\>large-")) s= "\<less\>left-" * s (7, N(s));

    \ \ if (starts (s, "\<less\>left-")) {

    \ \ \ \ int pos= search_backwards ("-", N(s), s);

    \ \ \ \ if (pos \<gtr\> 6) {

    \ \ \ \ \ \ if (s[pos-1] == '-') pos--;

    \ \ \ \ \ \ string r= s (6, pos);

    \ \ \ \ \ \ if (r == ".") { rew= ""; return 0; }

    \ \ \ \ \ \ if ((r == "(" && base-\<gtr\>supports
    ("\<less\>#239C\<gtr\>")) \|\|

    \ \ \ \ \ \ \ \ \ \ (r == ")" && base-\<gtr\>supports
    ("\<less\>#239F\<gtr\>")) \|\|

    \ \ \ \ \ \ \ \ \ \ (r == "[" && base-\<gtr\>supports
    ("\<less\>#23A2\<gtr\>")) \|\|

    \ \ \ \ \ \ \ \ \ \ (r == "]" && base-\<gtr\>supports
    ("\<less\>#23A5\<gtr\>")) \|\|

    \ \ \ \ \ \ \ \ \ \ ((r == "{" \|\| r == "}") && base-\<gtr\>supports
    ("\<less\>#23AA\<gtr\>")) \|\|

    \ \ \ \ \ \ \ \ \ \ (r == "sqrt" && base-\<gtr\>supports
    ("\<less\>#23B7\<gtr\>"))) {

    \ \ \ \ \ \ \ \ rew= s;

    \ \ \ \ \ \ \ \ return 4;

    \ \ \ \ \ \ }

    \ \ \ \ \ \ rew= r;

    \ \ \ \ \ \ if (N(rew) \<gtr\> 1) rew= "\<less\>" * rew * "\<gtr\>";

    \ \ \ \ \ \ if (ends (s, "-0\<gtr\>")) return 0;

    \ \ \ \ \ \ return 0;

    \ \ \ \ }

    \ \ }

    \ \ rew= s;

    \ \ return 0;

    }
  </cpp-code>

  There are <cpp|5> subfonts which are instantiated as follows:

  <\cpp-code>
    font

    rubber_unicode_font_rep::get_font (int nr) {

    \ \ ASSERT (nr \<less\> N(subfn), "wrong font number");

    \ \ if (initialized[nr]) return subfn[nr];

    \ \ initialized[nr]= true;

    \ \ switch (nr) {

    \ \ case 0:

    \ \ \ \ break;

    \ \ case 1:

    \ \ \ \ subfn[nr]= base-\<gtr\>magnify (sqrt (0.5));

    \ \ \ \ break;

    \ \ case 2:

    \ \ \ \ subfn[nr]= base-\<gtr\>magnify (sqrt (2.0));

    \ \ \ \ break;

    \ \ case 3:

    \ \ \ \ subfn[nr]= base-\<gtr\>magnify (2.0);

    \ \ \ \ break;

    \ \ case 4:

    \ \ \ \ subfn[nr]= rubber_assemble_font (base);

    \ \ \ \ break;

    \ \ }

    \ \ return subfn[nr];

    }
  </cpp-code>

  and are given by progressively zoomed versions of the base font plus an
  additional <cpp|rubber_assemble_font> used to create synthetic rubber from
  pieces of the base Unicode font. Its implementation is relatively
  straighforward: for the first few sizes it uses magnified variants of the
  base font:

  <\cpp-code>
    #define MAGNIFIED_NUMBER 4

    \ \ \ \ \ \ \ \ 

    font

    rubber_assemble_font_rep::get_font (int nr) {

    \ \ ASSERT (nr \<less\> N(larger), "wrong font number");

    \ \ if (initialized[nr]) return larger[nr];

    \ \ initialized[nr]= true;

    \ \ larger[nr]= base-\<gtr\>magnify (pow (2.0, ((double) nr) / 4.0));

    \ \ return larger[nr];

    }
  </cpp-code>

  while for larger variants it uses the virtual glyphs described in the
  <cpp|"emu-alt-large"> virtual font according to the following dispatching
  <cpp|search_font> function:

  <\cpp-code>
    int

    rubber_assemble_font_rep::search_font (string s, string& r) {

    \ \ if (starts (s, "\<less\>mid-")) s= "\<less\>left-" * s (5, N(s));

    \ \ if (starts (s, "\<less\>right-")) s= "\<less\>left-" * s (7, N(s));

    \ \ if (starts (s, "\<less\>large-")) s= "\<less\>left-" * s (7, N(s));

    \ \ if (starts (s, "\<less\>left-")) {

    \ \ \ \ int pos= search_backwards ("-", N(s), s);

    \ \ \ \ if (pos \<gtr\> 6) {

    \ \ \ \ \ \ if (s[pos-1] == '-') pos--;

    \ \ \ \ \ \ r= s (6, pos);

    \ \ \ \ \ \ int num= as_int (s (pos+1, N(s)-1));

    \ \ \ \ \ \ int nr= num - 5;

    \ \ \ \ \ \ int code;

    \ \ \ \ \ \ if (num \<less\>= MAGNIFIED_NUMBER) return num;

    \ \ \ \ \ \ else if (r == "(")

    \ \ \ \ \ \ \ \ code= virt-\<gtr\>dict
    ["\<less\>rubber-lparenthesis-#\<gtr\>"];

    \ \ \ \ \ \ else if (r == ")")

    \ \ \ \ \ \ \ \ code= virt-\<gtr\>dict
    ["\<less\>rubber-rparenthesis-#\<gtr\>"];

    \ \ \ \ \ \ else if (r == "[")

    \ \ \ \ \ \ \ \ code= virt-\<gtr\>dict
    ["\<less\>rubber-lbracket-#\<gtr\>"];

    \ \ \ \ \ \ else if (r == "]")

    \ \ \ \ \ \ \ \ code= virt-\<gtr\>dict
    ["\<less\>rubber-rbracket-#\<gtr\>"];

    \ \ \ \ \ \ else if (r == "{")

    \ \ \ \ \ \ \ \ code= virt-\<gtr\>dict
    ["\<less\>rubber-lcurly-#\<gtr\>"];

    \ \ \ \ \ \ else if (r == "}")

    \ \ \ \ \ \ \ \ code= virt-\<gtr\>dict
    ["\<less\>rubber-rcurly-#\<gtr\>"];

    \ \ \ \ \ \ else if (r == "lfloor")

    \ \ \ \ \ \ \ \ code= virt-\<gtr\>dict
    ["\<less\>rubber-lfloor-#\<gtr\>"];

    \ \ \ \ \ \ else if (r == "rfloor")

    \ \ \ \ \ \ \ \ code= virt-\<gtr\>dict
    ["\<less\>rubber-rfloor-#\<gtr\>"];

    \ \ \ \ \ \ else if (r == "lceil")

    \ \ \ \ \ \ \ \ code= virt-\<gtr\>dict ["\<less\>rubber-lceil-#\<gtr\>"];

    \ \ \ \ \ \ else if (r == "rceil")

    \ \ \ \ \ \ \ \ code= virt-\<gtr\>dict ["\<less\>rubber-rceil-#\<gtr\>"];

    \ \ \ \ \ \ else if (r == ".")

    \ \ \ \ \ \ \ \ code= virt-\<gtr\>dict
    ["\<less\>rubber-nosymbol-#\<gtr\>"];

    \ \ \ \ \ \ else if (r == "nosymbol")

    \ \ \ \ \ \ \ \ code= virt-\<gtr\>dict
    ["\<less\>rubber-nosymbol-#\<gtr\>"];

    \ \ \ \ \ \ else if (r == "\|")

    \ \ \ \ \ \ \ \ code= virt-\<gtr\>dict ["\<less\>rubber-bar-#\<gtr\>"];

    \ \ \ \ \ \ else if (r == "\|\|")

    \ \ \ \ \ \ \ \ code= virt-\<gtr\>dict
    ["\<less\>rubber-parallel-#\<gtr\>"];

    \ \ \ \ \ \ else if (r == "interleave")

    \ \ \ \ \ \ \ \ code= virt-\<gtr\>dict
    ["\<less\>rubber-interleave-#\<gtr\>"];

    \ \ \ \ \ \ else if (r == "sqrt")

    \ \ \ \ \ \ \ \ code= virt-\<gtr\>dict ["\<less\>rubber-sqrt-#\<gtr\>"];

    \ \ \ \ \ \ else

    \ \ \ \ \ \ \ \ code= virt-\<gtr\>dict
    ["\<less\>rubber-lparenthesis-#\<gtr\>"];

    \ \ \ \ \ \ r= string ((char) code) * as_string (nr) * "\<gtr\>";

    \ \ \ \ \ \ return MAGNIFIED_NUMBER + 1;

    \ \ \ \ }

    \ \ }

    \ \ r= s;

    \ \ return 0;

    }
  </cpp-code>

  <subsection|Virtual fonts><label|sec:virtual-font>

  Virtual fonts provide a mechanism to extend the set of available glyphs by
  synthetizing new glyphs from operations on those of a base font. The
  programs which describe the sequence of (parametrized) operations to
  perform are formulated in a domain-specific language of s-expressions.\ 

  The main entry point is the function

  <\cpp-code>
    font virtual_font (font base, string name, int size, int hdpi, int vdpi,
    bool extend);
  </cpp-code>

  The <cpp|extend> flag allows to control if the virtual font behaves as an
  overlay over the base font allowing to access the base-defined glyphs or
  not.

  Virtual fonts definitions are collected in the
  <verbatim|$TEXMACS_PATH/fonts/virtual> directory with suffix
  <verbatim|.vfn>. As an example of the DSL, here the
  <verbatim|emu-bracket.vfn> font which describes the synthetic large
  brackets:

  <\verbatim-code>
    (virtual-font

    \ \ (emu-backslash (hor-flip /))

    \ \ (emu-tslash (unindent (crop (part (crop /) * * 0.5 *))))

    \ \ (emu-tbackslash (hor-flip emu-tslash))

    \ \ (emu-bslash (unindent (crop (part (crop /) * * * 0.5))))

    \ \ (emu-bbackslash (hor-flip emu-bslash))

    \ \ (emu-langle-pre (unindent (join (unindent emu-bbackslash)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (unindent
    emu-tslash))))

    \ \ (emu-rangle-pre (unindent (join (unindent* emu-bslash)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (unindent*
    emu-tbackslash))))

    \ \ (emu-langle-bis (with sc (/ (height (crop [)) (height
    emu-langle-pre))

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (align* (magnify emu-langle-pre *
    sc) [ * 0.5)))

    \ \ (emu-rangle-bis (with sc (/ (height (crop ])) (height
    emu-rangle-pre))

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (align* (magnify emu-rangle-pre *
    sc) ] * 0.5)))

    \ \ (emu-langle (unindent (enlarge emu-langle-bis 0.1 0.1 0 0)))

    \ \ (emu-rangle (unindent (enlarge emu-rangle-bis 0.1 0.1 0 0)))

    \ \ (emu-llangle (join (0 0 emu-langle) (0.2 0 emu-langle)))

    \ \ (emu-rrangle (join (0 0 emu-rangle) (0.2 0 emu-rangle)))

    \ \ (emu-lfloor (join (part [ * * * 0.5) (part [ * * 0.25 0.75 0
    \ 0.25)))

    \ \ (emu-rfloor (join (part ] * * * 0.5) (part ] * * 0.25 0.75 0
    \ 0.25)))

    \ \ (emu-lceil \ (join (part [ * * 0.5 *) (part [ * * 0.25 0.75 0
    -0.25)))

    \ \ (emu-rceil \ (join (part ] * * 0.5 *) (part ] * * 0.25 0.75 0
    -0.25)))

    \ \ (emu-dlbracket (glue [ [))

    \ \ (emu-drbracket (glue ] ]))

    \ \ (emu-dlfloor (join (part emu-dlbracket * * * 0.5)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (part emu-dlbracket * * 0.25
    0.75 0 \ 0.25)))

    \ \ (emu-drfloor (join (part emu-drbracket * * * 0.5)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (part emu-drbracket * * 0.25
    0.75 0 \ 0.25)))

    \ \ (emu-dlceil \ (join (part emu-dlbracket * * 0.5 *)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (part emu-dlbracket * * 0.25
    0.75 0 -0.25)))

    \ \ (emu-drceil \ (join (part emu-drbracket * * 0.5 *)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (part emu-drbracket * * 0.25
    0.75 0 -0.25)))

    \ \ (emu-tlbracket (glue [ emu-dlbracket))

    \ \ (emu-trbracket (glue ] emu-drbracket))

    \ \ (emu-tlfloor (join (part emu-tlbracket * * * 0.5)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (part emu-tlbracket * * 0.25
    0.75 0 \ 0.25)))

    \ \ (emu-trfloor (join (part emu-trbracket * * * 0.5)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (part emu-trbracket * * 0.25
    0.75 0 \ 0.25)))

    \ \ (emu-tlceil \ (join (part emu-tlbracket * * 0.5 *)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (part emu-tlbracket * * 0.25
    0.75 0 -0.25)))

    \ \ (emu-trceil \ (join (part emu-trbracket * * 0.5 *)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (part emu-trbracket * * 0.25
    0.75 0 -0.25)))

    \ \ (emu-dbar (join #7C (part #7C * * * * 0.6 0)))

    \ \ (emu-tbar (join #7C (part #7C * * * * 0.6 0)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (part #7C * * * * 1.2 0))))
  </verbatim-code>

  As we see the file is composed by a single S-expression with head
  <verbatim|virtual-font> and a sequence of glyph definitions in the form
  <verbatim|(glyph-name glyph-code)>. The code itself is composed recursively
  by operators with arguments given by further subexpressions.

  One of the interpreters of the language is <cpp|draw_tree>:

  <\cpp-code>
    void virtual_font_rep::draw_tree (renderer ren, scheme_tree t, SI x, SI
    y);
  </cpp-code>

  The code expressions are evaluated as follows. We indicate with a
  dollar-prefixed label like <verbatim|$val> variables which match
  subexpressions in the templates.

  An atomic value (not a list) refers to a glyph in the base font or to
  another virtual glyph.\ 

  A list of the form <verbatim|($x $y $s)> where <verbatim|$x>, <verbatim|$y>
  are floating-point numbers and <verbatim|$s> a symbol, evaluate in the
  glyph associated to <verbatim|$s> and shifted according to the pair
  <verbatim|$x>, <verbatim|$y>.

  <verbatim|(with $var $val $body)> evaluates <verbatim|$body> with the
  symbol <verbatim|$var> replaced by the value of the expression
  <verbatim|$val>.\ 

  <verbatim|(or $el1 $el2 <text-dots>)> evaluates in the first valid
  expression in the list (as determined by the <cpp|supported> method)

  <verbatim|(join $el1 $el2 <text-dots>)> evaluates in the superposition of
  the result of all the expressions, in sequence, in the list;

  <verbatim|(intersect $glyph1 $glyph2)>, <verbatim|(exclude $glyph1
  $glyph2)> compose glyph bitmaps with raster operators

  <verbatim|(bitmap $glyph)> evaluates in the result of <verbatim|$s>;

  <verbatim|(glue $glyph1 $glyph2)>, <verbatim|(glue* $glyph1 $glyph2)> glue
  virtual glyphs horizontally with different alignements

  <verbatim|(glue-above $glyph1 $glyph2 $dy)>, <verbatim|(glue-below $glyph1
  $glyph2 $dy)> glue glyphs vertically with an optional shift

  In the following we list most of the other available operators, for details
  on their meaning please refer to the source code of
  <verbatim|virtual_font_rep>.

  <verbatim|(row $e1 $e2)>

  <verbatim|(stack $glyph1 $glyph2 $e3)>, <verbatim|(stack-equal $glyph1
  $glyph2 $e3)>, <verbatim|(stack-less $glyph1 $glyph2 $e3)>

  <verbatim|(right-fit $glyph1 $glyph2 $e3)>, <verbatim|(left-fit $glyph1
  $glyph2 $e3)>

  <verbatim|(add $glyph1 $glyph2)>

  <verbatim|(magnify $e1 $e2 $e3)>

  <verbatim|(enlarge $e1)>

  <verbatim|(unindent $e1)>, <verbatim|(unindent* $e1)>

  <verbatim|(crop $e1)>, <verbatim|(hor-crop $e1)>, <verbatim|(ver-crop
  $e1)>, <verbatim|(left-crop $e1)>,<verbatim|(right-crop $e1)>,
  <verbatim|(top-crop $e1)>, <verbatim|(bottom-crop $e1)>

  <verbatim|(clip $glyph $x1 $y1 $x2 $y2)>

  <verbatim|(part $glyph $x1 $y1 $x2 $y2 $dx $dy)>

  <verbatim|(copy $e1)>

  <verbatim|(hor-flip $e1)>, <verbatim|(ver-flip $e1)>, <verbatim|(rot-left
  $e1)>, <verbatim|(rot-right $e1)>

  <\verbatim>
    (rotate $glyph $angle $xf $yf)
  </verbatim>

  <verbatim|(hor-extend $glyph $xx $yy $zz)>, <verbatim|(ver-extend $glyph
  $xx $yy $zz)>

  <\verbatim>
    (ver-take $glyph $xx $yy $zz)
  </verbatim>

  <verbatim|(align $glyph $xx $yy)>, <verbatim|(align* $glyph $xx $yy)>

  <verbatim|(scale $glyph1 $glyph2 $sx $sy)>, <verbatim|(scale* $glyph1
  $glyph2 $sx $sy)>

  <\verbatim>
    (hor-scale $glyph1 $glyph2)
  </verbatim>

  <verbatim|(pretend $glyph1 $glyph2)>, <verbatim|(hor-pretend $glyph1
  $glyph2)>, <verbatim|(left-pretend $glyph1 $glyph2)>,
  <verbatim|(right-pretend $glyph1 $glyph2)>, <verbatim|(ver-pretend $glyph1
  $glyph2)>

  <\verbatim>
    (relash $glyph1 $glyph2)
  </verbatim>

  <\verbatim>
    (negate $glyph1 $glyph2)
  </verbatim>

  <verbatim|(min-width $glyph1 $glyph2)>, <verbatim|(max-width $glyph1
  $glyph2)>, <verbatim|(min-height $glyph1 $glyph2)>, <verbatim|(max-height
  $glyph1 $glyph2)>

  <verbatim|(font $p1 $p2 $p3 ...)>

  <verbatim|(italic $p1 $p2 $p3)>

  <verbatim|(circle $r $w)>

  <subsection|TeX fonts>

  TeX fonts are physical fonts are handled via specific mechanisms which
  decoded the TeX font files and metrrics to produce metric informations for
  the typesetter and bitmaps for the renderer. They work similarly to Unicode
  fonts, but the specifics of the encoding of the various TeXmacs entities is
  complex due to the limitations in the design of the font files and a
  logical font must be reconstructed gluing together several physical fonts
  and taking care of rubber, mathematical alphabeths, etc<text-dots>

  <subsection|Compound fonts for mathematics>

  The <cpp|math_font> class represent a compound font which can render all
  the usual entities for mathematical document preparation. It is modelled
  around <TeX> math fonts to map several physical fonts to cover all math
  alphabets.\ 

  <section|From logical to physical font>

  As we already discusses, TeXmacs implements a font substitution mechanism
  that tries to find a physical font which better fits a given series of
  characteristics. This is used to find replacements for missing features
  (like a bold alphabeth, or upright Greek letters, etc<text-dots>) or glyph
  sets (e.g. Greek, Cyrillic, asian fonts, mathematical letters, mathematical
  symbols)

  The entrypoint of this system is the function

  <\cpp-code>
    font closest_font (string family, string variant, string series, string
    shape,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ int sz, int dpi, int attempt)
  </cpp-code>

  which returns a physical font which fits certain characteristics (i.e.
  family, variant, series, shape). The <cpp|attempt> variable is used to
  iterate amont the possibile return values according to the order given by a
  distance function defined among all fonts. The function <cpp|closest_font>
  calls <cpp|find_closest> to do caching and the actual search of a physical
  font with suitable characteristics:

  <\cpp-code>
    bool

    find_closest (string& family, string& variant, string& series, string&
    shape,

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ int attempt) {

    \ \ static hashmap\<less\>tree,tree\<gtr\> closest_cache (UNINIT);

    \ \ tree val= tuple (copy (family), variant, series, shape);

    \ \ tree key= tuple (copy (family), variant, series, shape, as_string
    (attempt));

    \ \ if (closest_cache-\<gtr\>contains (key)) {

    \ \ \ \ tree t = closest_cache[key];

    \ \ \ \ family = t[0]-\<gtr\>label;

    \ \ \ \ variant= t[1]-\<gtr\>label;

    \ \ \ \ series = t[2]-\<gtr\>label;

    \ \ \ \ shape \ = t[3]-\<gtr\>label;

    \ \ \ \ return t != val;

    \ \ }

    \ \ else {

    \ \ \ \ //cout \<less\>\<less\> "\<less\> " \<less\>\<less\> family
    \<less\>\<less\> ", " \<less\>\<less\> variant

    \ \ \ \ // \ \ \ \ \<less\>\<less\> ", " \<less\>\<less\> series
    \<less\>\<less\> ", " \<less\>\<less\> shape \<less\>\<less\> "\\n";

    \ \ \ \ array\<less\>string\<gtr\> lfn= logical_font (family, variant,
    series, shape);

    \ \ \ \ lfn= apply_substitutions (lfn);

    \ \ \ \ array\<less\>string\<gtr\> pfn= search_font (lfn, attempt);

    \ \ \ \ array\<less\>string\<gtr\> nfn= logical_font (pfn[0], pfn[1]);

    \ \ \ \ array\<less\>string\<gtr\> gfn= guessed_features (pfn[0],
    pfn[1]);

    \ \ \ \ //cout \<less\>\<less\> lfn \<less\>\<less\> " -\<gtr\> "
    \<less\>\<less\> pfn \<less\>\<less\> ", " \<less\>\<less\> nfn
    \<less\>\<less\> ", " \<less\>\<less\> gfn \<less\>\<less\> "\\n";

    \ \ \ \ gfn \<less\>\<less\> nfn;

    \ \ \ \ family= get_family (nfn);

    \ \ \ \ variant= get_variant (nfn);

    \ \ \ \ series= get_series (nfn);

    \ \ \ \ shape= get_shape (nfn);

    \ \ \ \ if ( contains (string ("outline"), lfn) &&

    \ \ \ \ \ \ \ \ !contains (string ("outline"), gfn))

    \ \ \ \ \ \ variant= variant * "-poorbbb";

    \ \ \ \ if ( contains (string ("bold"), lfn) &&

    \ \ \ \ \ \ \ \ !contains (string ("bold"), gfn))

    \ \ \ \ \ \ series= series * "-poorbf";

    \ \ \ \ if ( contains (string ("smallcaps"), lfn) &&

    \ \ \ \ \ \ \ \ !contains (string ("smallcaps"), gfn))

    \ \ \ \ \ \ shape= shape * "-poorsc";

    \ \ \ \ if ((contains (string ("italic"), lfn) \|\|

    \ \ \ \ \ \ \ \ \ contains (string ("oblique"), lfn)) &&

    \ \ \ \ \ \ \ \ !contains (string ("italic"), gfn) &&

    \ \ \ \ \ \ \ \ !contains (string ("oblique"), gfn))

    \ \ \ \ \ \ shape= shape * "-poorit";

    \ \ \ \ //cout \<less\>\<less\> "\<gtr\> " \<less\>\<less\> family
    \<less\>\<less\> ", " \<less\>\<less\> variant

    \ \ \ \ // \ \ \ \ \<less\>\<less\> ", " \<less\>\<less\> series
    \<less\>\<less\> ", " \<less\>\<less\> shape \<less\>\<less\> "\\n";

    \ \ \ \ tree t= tuple (family, variant, series, shape);

    \ \ \ \ closest_cache (key)= t;

    \ \ \ \ return t != val;

    \ \ }

    }
  </cpp-code>

  As we see, this function uses <cpp|search_font> to determine available
  fonts with similar characteristics (as specified by <cpp|logical_font> and
  after performing some substitutions via <cpp|apply_substitutions>). If the
  selected font does not posses features (outline, bold, smallcaps, italic)
  of the required font, we synthetize them via \Ppoor\Q replacements.\ 

  Font substitutions are collected in the file
  <verbatim|$TEXMACS_PATH/fonts/font-substitutions.scm> whose format is a
  list of Scheme expressions like

  <\verbatim-code>
    \;

    ((Bodoni\\ 72 smallcaps) (Bodoni\\ 72\\ Smallcaps))

    ((Bodoni\\ 72\\ Oldstyle smallcaps) (Bodoni\\ 72\\ Smallcaps))

    ((Linux\\ Libertine sansserif) (Linux\\ Biolinum))

    ((TeX\\ Gyre\\ Pagella typewriter) (roman typewriter))

    \;

    ((Calibri typewriter) (Consolas))

    ((Cambria sansserif) (Calibri))

    ((Cambria typewriter) (Consolas))

    ((Constantia sansserif) (Corbel))

    ((Constantia typewriter) (Consolas))

    ((Corbel typewriter) (Consolas))

    \;
  </verbatim-code>

  which specify replacement families for a given combination of family and
  feature of a logical font. For example the correct <verbatim|sansserif>
  version of <verbatim|Linux Libertine> is <verbatim|Linux Biolinum>,
  etc<text-dots>

  The other important configuration files which control the selection of
  physical fonts are <verbatim|font-features.scm>,
  <verbatim|font-database.scm> and <verbatim|font-characteristics.scm> all
  located in the folder <verbatim|$TEXMACS_PATH/fonts>. These are computer
  generated and cache several important informations obtained by analyzing
  the available font files, those local to the specific installation of
  TeXmacs are kept in <verbatim|$TEXMACS_HOME_PATH/fonts>.\ 

  The file <verbatim|font-database.scm> associate to each font identifier a
  the filename and a subfont number:

  <\verbatim-code>
    ((TeXmacs\\ Computer\\ Modern\\ Sans Bold) ((ecsx10.tfm 0 3132)))

    ((TeXmacs\\ Computer\\ Modern\\ Sans Bold\\ Condensed) ((ecssdc10.tfm 0
    3128)))

    ((TeXmacs\\ Computer\\ Modern\\ Sans Bold\\ Flat) ((eclb10.tfm 0 3584)))

    ((TeXmacs\\ Computer\\ Modern\\ Sans Bold\\ Italic\\ Flat) ((eclo10.tfm 0
    3584)))

    ((TeXmacs\\ Computer\\ Modern\\ Sans Bold\\ Oblique) ((ecso10.tfm 0
    3352)))

    ((TeXmacs\\ Computer\\ Modern\\ Sans Flat) ((eclq10.tfm 0 3584)))

    ((TeXmacs\\ Computer\\ Modern\\ Sans Italic\\ Flat) ((ecli10.tfm 0
    3584)))

    ((TeXmacs\\ Computer\\ Modern\\ Sans Oblique) ((ecsi10.tfm 0 3360)))

    ((TeXmacs\\ Computer\\ Modern\\ Sans Regular) ((ecss10.tfm 0 3140)))

    ((TeXmacs\\ Concrete Bold) ((ecbx10.tfm 0 3200)))

    ((TeXmacs\\ Concrete Bold\\ Condensed) ((ecrb10.tfm 0 3196)))

    ((TeXmacs\\ Concrete Bold\\ Italic) ((ecbi10.tfm 0 2900)))

    ((TeXmacs\\ Concrete Bold\\ Oblique) ((ecbl10.tfm 0 3412)))
  </verbatim-code>

  The file <verbatim|<verbatim|font-features.scm>> records the available
  features for each font identifier, for example:\ 

  <\verbatim-code>
    (Tangerine Tangerine Italic ArtPen Calligraphic)

    (Telugu\\ MN Telugu\\ MN)

    (Telugu\\ Sangam\\ MN Telugu\\ Sangam\\ MN SansSerif)

    (Tempora Tempora)

    (TeX\\ AMS\\ Blackboard\\ Bold Bbb Outline)

    (TeX\\ Bard bard Ancient)

    (TeX\\ Blackboard\\ Bold Bbb* Outline)

    (TeX\\ Blackboard\\ Bold\\ Sans Bbb* SansSerif Outline)

    (TeX\\ Blackboard\\ Bold\\ Variant Bbb** Outline)

    (TeX\\ Blackletter blackletter Ancient Gothic)

    (TeX\\ Calligraphic calligraphic Italic ArtPen Attached Calligraphic)

    (TeX\\ Calligraphic\\ Capitals cal Calligraphic)
  </verbatim-code>

  While the <verbatim|font-characteristics.scm> file records several
  attributes associated to each font, which are used to determine
  similar-looking fonts and their relative distance:

  <\verbatim-code>
    ((TeX\\ Gothic Regular) (mono=no sans=no slant=17 italic=no case=mixed
    regular=no ex=83 em=187 lvw=27 lhw=19 uvw=15 uhw=144 fillp=40 vcnt=47
    lasprat=66 pasprat=65 loasc=134 lodes=139 dides=104))

    ((TeX\\ Gyre\\ Adventor Bold) (Ascii Latin Greek mono=no sans=yes slant=0
    italic=no case=mixed regular=yes ex=92 em=163 lvw=23 lhw=21 uvw=25 uhw=23
    fillp=56 vcnt=62 lasprat=99 pasprat=85 loasc=139 lodes=140 dides=102))

    ((TeX\\ Gyre\\ Adventor Bold\\ Italic) (Ascii Latin Greek mono=no
    sans=yes slant=18 italic=no case=mixed regular=yes ex=92 em=163 lvw=23
    lhw=21 uvw=23 uhw=23 fillp=48 vcnt=56 lasprat=99 pasprat=97 loasc=139
    lodes=140 dides=102))

    ((TeX\\ Gyre\\ Adventor Italic) (Ascii Latin Greek mono=no sans=yes
    slant=20 italic=no case=mixed regular=yes ex=91 em=168 lvw=14 lhw=12
    uvw=14 uhw=12 fillp=30 vcnt=35 lasprat=99 pasprat=95 loasc=135 lodes=139
    dides=102))

    ((TeX\\ Gyre\\ Adventor Regular) (Ascii Latin Greek mono=no sans=yes
    slant=0 italic=no case=mixed regular=yes ex=91 em=168 lvw=13 lhw=12
    uvw=13 uhw=12 fillp=36 vcnt=38 lasprat=99 pasprat=83 loasc=135 lodes=139
    dides=102))

    ((TeX\\ Gyre\\ Bonum Bold) (Ascii Latin Greek mono=no sans=no slant=0
    italic=no case=mixed regular=yes ex=84 em=186 lvw=35 lhw=19 uvw=38 uhw=20
    fillp=55 vcnt=60 lasprat=115 pasprat=110 loasc=152 lodes=148 dides=102))
  </verbatim-code>

  \;

  An alternative font selection mechanism, active in particular when
  <cpp|new_fonts> is <cpp|false>, is a macro-based font-selection scheme
  (using the <scheme> syntax), which allows the user to decide which
  parameters should be considered meaningful. At the lowest level, TeXmacs
  provides a fixed number of macros which directly correspond to the above
  types of concrete fonts. For instance, the macro\ 

  <\scm>
    \ \ \ \ (tex $name $size $dpi)
  </scm>

  corresponds to the constructor

  <\cpp-code>
    font tex_font (display dis, string fam, int size, int dpi, int dsize=10);
  </cpp-code>

  of a <TeX> text font.\ 

  At the middle level, it is possible to specify some rewriting rules like\ 

  <\scm-code>
    ((roman rm medium right $s $d) (ec ecrm $s $d))

    ((avant-garde rm medium right $s $d) (tex rpagk $s $d 0))

    ((x-times rm medium right $s $d) (ps adobe-times-medium-r-normal $s $d))
  </scm-code>

  When a left hand pattern is matched, it is recursively substituted by the
  right hand side. The files in the directory <verbatim|progs/fonts> contain
  a large number of rewriting rules.

  At the top level, <TeXmacs> calls (via the <cpp|find_font> function) a
  macro of the form\ 

  <\scm-code>
    ($name $family $series $shape $size $dpi)
  </scm-code>

  as a function of the current environment in the text.

  \;

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
    <associate|auto-1|<tuple|?|3>>
    <associate|auto-10|<tuple|1|10>>
    <associate|auto-11|<tuple|5|11>>
    <associate|auto-12|<tuple|6|11>>
    <associate|auto-13|<tuple|7|11>>
    <associate|auto-14|<tuple|7.1|13>>
    <associate|auto-15|<tuple|8|15>>
    <associate|auto-16|<tuple|8.1|19>>
    <associate|auto-17|<tuple|8.2|26>>
    <associate|auto-18|<tuple|8.3|26>>
    <associate|auto-19|<tuple|8.4|32>>
    <associate|auto-2|<tuple|1|5>>
    <associate|auto-20|<tuple|8.5|40>>
    <associate|auto-21|<tuple|8.6|44>>
    <associate|auto-22|<tuple|9|48>>
    <associate|auto-23|<tuple|9|48>>
    <associate|auto-24|<tuple|9|48>>
    <associate|auto-3|<tuple|2|6>>
    <associate|auto-4|<tuple|3|6>>
    <associate|auto-5|<tuple|3|6>>
    <associate|auto-6|<tuple|3|6>>
    <associate|auto-7|<tuple|1|8>>
    <associate|auto-8|<tuple|1|8>>
    <associate|auto-9|<tuple|4|9>>
    <associate|font-base-size|<tuple|1|8>>
    <associate|font-size|<tuple|1|8>>
    <associate|sec:other|<tuple|8|26>>
    <associate|sec:rubber|<tuple|8.1|26>>
    <associate|sec:rubber-unicode|<tuple|8.3|40>>
    <associate|sec:unicode-font|<tuple|8.2|32>>
    <associate|sec:virtual-font|<tuple|8.4|44>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|figure>
      <tuple|normal|<\surround|<hidden-binding|<tuple>|1>|>
        Emulation of bold, italic, small capitals and blackboard bold.

        <no-indent>* These declinations are already supported by the original
        font.
      </surround>|<pageref|auto-10>>

      <tuple|normal|<\surround|<hidden-binding|<tuple>|2>|>
        Emulation of various mathematical symbols in various fonts.
      </surround>|<pageref|auto-11>>

      <tuple|normal|<surround|<hidden-binding|<tuple>|3>||Assorted rubber
      symbols from various fonts.>|<pageref|auto-12>>
    </associate>
    <\associate|idx>
      <tuple|<tuple|<with|font-family|<quote|ss>|Document>|<with|font-family|<quote|ss>|Font>>|<pageref|auto-5>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Format>|<with|font-family|<quote|ss>|Font>>|<pageref|auto-6>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Format>|<with|font-family|<quote|ss>|Size>>|<pageref|auto-7>>
    </associate>
    <\associate|table>
      <tuple|normal|<surround|<hidden-binding|<tuple>|1>||Standard font
      sizes.>|<pageref|auto-8>>
    </associate>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Font
      mechanics> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-1><vspace|0.5fn>

      1.<space|2spc>Fonts in TeXmacs <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2>

      2.<space|2spc>String encodings <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3>

      3.<space|2spc>Specifying the current font
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4>

      4.<space|2spc>Font substition and emulation
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-9>

      5.<space|2spc>The abstract font class
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-13>

      6.<space|2spc>Font selection <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-14>

      7.<space|2spc>Smart fonts <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-15>

      <with|par-left|<quote|1tab>|7.1.<space|2spc>Entity resolution
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-16>>

      8.<space|2spc>Other fonts <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-17>

      <with|par-left|<quote|1tab>|8.1.<space|2spc>Rubber fonts
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-18>>

      <with|par-left|<quote|1tab>|8.2.<space|2spc>Unicode fonts
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-19>>

      <with|par-left|<quote|1tab>|8.3.<space|2spc>Rubber Unicode fonts
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-20>>

      <with|par-left|<quote|1tab>|8.4.<space|2spc>Virtual fonts
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-21>>

      <with|par-left|<quote|1tab>|8.5.<space|2spc>TeX fonts
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-22>>

      <with|par-left|<quote|1tab>|8.6.<space|2spc>Compound fonts for
      mathematics <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-23>>

      9.<space|2spc>From logical to physical font
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-24>
    </associate>
  </collection>
</auxiliary>