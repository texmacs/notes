<TeXmacs|1.99.19>

<style|notes>

<\body>
  <\hide-preamble>
    \;
  </hide-preamble>

  <notes-header>

  <chapter*|Development resources and ideas>

  <notes-abstract|This page contains idea and resources pertaining to the
  development of TeXmacs.>

  [Last update 22.3.2021]

  <section|Incremental computing>

  Modifications to the documents are incremental, so one would like to take
  this into account when recomputing both the typesetting and the rendering
  onscreen. This problem is also relevant when syncronizing live-editing
  document across a network connection. Some infrastructure is already
  present in TeXmacs (details?). Here are gathered some approaches to
  incremental computations in a general context.

  <\itemize>
    <item>The paper \PPurely Functional Incremental Computing\Q
    (<hlink|PDF|http://firsov.ee/incremental/incremental.pdf>).

    <item>Talk on implementing Data-driven incremental UIs (in OCAML)
    (<hlink|youtube|https://www.youtube.com/watch?v=R3xX37RGJKE>). And a
    longer talk with more details (<hlink|youtube|https://www.youtube.com/watch?v=G6a5G5i4gQU>).

    <item>A blog post at Jane Street (<hlink|URL|https://blog.janestreet.com/introducing-incremental/>)

    <item>Adaptive computation library in JS
    (<hlink|link|https://github.com/rkirov/adapt-comp>)
  </itemize>

  <section|Syntax highlighting>

  We need syntax highlighting computations when rendering verbatim code
  snippets and also when exporting to HTML, for example. Currently there is
  some parsing library written in C++ inside TeXmacs (see the
  <tt|src/System/Language> directory), but this does not cover HTML output
  and it is quite rudimentary. In this blog for example we achieve
  syntax-highlighting for HTML via an external JavaScript library. It would
  be useful just to output the appropriate elaborated text (together with a
  plain-text version for copy/paste). In general it could be maybe
  interesting to evaluate the use of external libraries for syntax analysis
  of programming languages.\ 

  <\itemize>
    <item>Tree-sitter is a recent interesting library for computing
    incrementally an AST for a piece of text, including error recovery. It is
    written in C/C++ with no external dependencies (as it is claimed) which
    make relatively easy an inclusion in TeXmacs. The github
    <hlink|link|https://tree-sitter.github.io/tree-sitter/>, and a
    presentation <hlink|talk|https://www.youtube.com/watch?v=Jes3bD6P0To> on
    youtube.

    <item>The KDE project has a syntax-highlighting engine
    <hlink|here|https://invent.kde.org/frameworks/syntax-highlighting/> where
    languages descriptions comes in external XML files. \ 
  </itemize>

  <section|Parsing Markdown and other languages>

  It could be useful for us to be able to parse the
  <hlink|Markdown|https://www.markdownguide.org> format. There are various
  available parsers which could be integrated as plugins in the codebase, for
  example <hlink|PEG-markdown|https://github.com/jgm/peg-markdown>,
  <hlink|sundown|https://github.com/vmg/sundown>,
  <hlink|libsoldout|https://fossil.instinctive.eu/libsoldout/index>,
  <hlink|md4c|https://github.com/mity/md4c> and also some native scheme
  implementations like <hlink|lowdown|https://bitbucket.org/DerGuteMoritz/lowdown/src/master/>
  for Chicken Scheme. Currently in TeXmacs we do not have a generic way to
  parse external languages: for example internally the parsing of HTML or TeX
  is done via C++ code without any common parsing substrate (as far as I can
  see). There is some support for packrat parsing but it is used only in the
  semantic checking of math formulas and it seems that the packrat parser is
  not capable of semantic actions, i.e. can only report if a string (or
  tree?) belongs to some language or not. Tree-sitter could also be an option
  as generic parsing mechanism. It could be useful to think how to factor and
  restructure the parsing mechanisms in TeXmacs to avoid duplicating
  code/efforts/know-how.

  <section|Spellchecking and grammar-checking>

  This could be an area where we can improve substantially over LaTeX-based
  workflows, probably. We need to check what is done in other text-processing
  software. Some interesting resources

  <\itemize>
    <item><hlink|Languagetool|https://github.com/languagetool-org/languagetool>
    is a (big) open source Java system for grammar correction in various
    languages. Maybe it is conceivable to offer the possibility to use it as
    an external service (on the web or locally).

    <item>A list of grammar-checking resources in github:
    <hlink|URL|https://github.com/topics/grammar-checker>.

    <item>Programs that link to Languagetools for LaTeX documents:
    <hlink|texidote|https://github.com/sylvainhalle/textidote>,
    <hlink|vscode-ltex|https://github.com/valentjn/vscode-ltex>.

    <item>Spellchecking alternatives: <hlink|nuspell|https://nuspell.github.io>,
    <hlink|hunspell|http://hunspell.github.io>,
    <hlink|symspell|https://github.com/wolfgarbe/SymSpell> <text-dots> which
    to pick, if any? We would need to survey tradeoffs and opportunities.
  </itemize>

  <section|General plugin mechanisms>

  A strategical goal would be to improve support for general mechanisms to
  talk to external programs:

  <\itemize>
    <item><hlink|Jupyter|https://jupyter.org> is a protocol to interface
    clients to computational kernels (Python, Julia, Haskell,<text-dots>). We
    already have a very primitive plugin here
    <hlink|tm_jupyter|https://github.com/mgubi/tm_jupyter> (written in
    Python). It could potentially replace many of our various plugins and
    allow easier maintenance. Moreover it could allow TeXmacs to be an
    alternative to Jupyter notebooks or <hlink| Jupyter Qt
    Console|https://github.com/mgubi/tm_jupyter>. One can look to these
    projects to understand which features have to be supported. Jeroen has
    improved the tm_jupyter plugin <hlink|here|https://github.com/woutersj/tm_jupyter/commits/master>.
    \ 

    <item><hlink|Language Server Protocol|https://microsoft.github.io/language-server-protocol/>
    allows to connect to various programming language servers to obtain
    semantic informations, code completions, etc<text-dots> For example it
    could be useful to provide an interface to theorem provers like
    <hlink|Lean|https://leanprover.github.io> or
    <hlink|Isabelle/HOL|https://isabelle.in.tum.de>. In general this could be
    related to literate programming capabilities/projects.
  </itemize>

  <section|General attachments to documents and to PDF files>

  PDF gives the possibility to embed arbitrary content within the document as
  \PEmbedded file\Q streams. This possibility is exploited by the <LaTeX>
  package <hlink|attachfile|https://mirror.ibcp.fr/pub/CTAN/macros/latex/contrib/attachfile/attachfile.pdf>
  which allows to associate to typesetted parts of the document arbitrary
  attachments with the possibility to recover it. We could introduce a
  similar feature in <TeXmacs> documents, i.e. include external content in
  the document. Another possibility is to include a <TeXmacs> document within
  a generated PDF file in such a way that it is possible to open the PDF from
  <TeXmacs> and edit its source. Another use could be to include TeXmacs
  snippets in copied PDF files so that they could be reopened in TeXmacs and
  modified.

  <section|Random and unsorted resources>

  <\itemize>
    <item>An interesting talk about open source
    community<nbsp>(<hlink|video|https://www.youtube.com/watch?v=o_4EX4dPppA>).
  </itemize>

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
    <associate|auto-1|<tuple|?|?>>
    <associate|auto-2|<tuple|1|?>>
    <associate|auto-3|<tuple|2|?>>
    <associate|auto-4|<tuple|3|?>>
    <associate|auto-5|<tuple|4|?>>
    <associate|auto-6|<tuple|5|?>>
    <associate|auto-7|<tuple|6|?>>
    <associate|auto-8|<tuple|7|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Development
      resources and ideas> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-1><vspace|0.5fn>

      1.<space|2spc>Incremental computing
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2>

      2.<space|2spc>Syntax highlighting <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3>

      3.<space|2spc>Parsing Markdown and other languages
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4>

      4.<space|2spc>Spellchecking and grammar-checking
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-5>

      5.<space|2spc>General plugin mechanisms
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6>

      6.<space|2spc>Random and unsorted resources
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-7>
    </associate>
  </collection>
</auxiliary>