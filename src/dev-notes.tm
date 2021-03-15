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

  [Last update 15.3.2021]

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

    <item>A talk on implementing Data-driven incremental UIs (in OCAML)
    (<hlink|youtube|https://www.youtube.com/watch?v=R3xX37RGJKE>)

    <item>Adaptive computation library in JS
    (<hlink|link|https://github.com/rkirov/adapt-comp>)
  </itemize>

  <section|Syntax highlighting>

  We need syntax highlighting computations when rendering verbatim code
  snippets and also when exporting to HTML, for example. Currently there is
  some parsing library written in C++ inside TeXmacs, but this does not cover
  HTML output. In this blog for example we achieve syntax-highlighting for
  HTML via an external JavaScript library. It would be useful just to output
  the appropriate elaborated text (together with a plain-text version for
  copy/paste). In general it could be maybe interesting to evaluate the use
  of external libraries for syntax analysis of programming languages.\ 

  <\itemize>
    <item>Tree-sitter is a recent interesting library for computing
    incrementally an AST for a piece of text, including error recovery. It is
    written in C/C++ with no external dependencies (as it is claimed) which
    make relatively easy an inclusion in TeXmacs. The github
    <hlink|link|https://tree-sitter.github.io/tree-sitter/>, and a
    presentation <hlink|talk|https://www.youtube.com/watch?v=Jes3bD6P0To> on
    youtube.\ 
  </itemize>

  <section|Various random material>

  <\itemize>
    <item>An interesting talk about open source
    community<nbsp>(<hlink|video|https://www.youtube.com/watch?v=o_4EX4dPppA>).

    <item>
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
    </associate>
  </collection>
</auxiliary>