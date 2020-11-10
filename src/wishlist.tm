<TeXmacs|1.99.12>

<style|notes>

<\body>
  <notes-header>

  <chapter*|Wishlist>

  <hrule>

  From <hlink|[bug#59433]|https://savannah.gnu.org/bugs/?59433>.

  Is it possible to make support to apsrev4-1.bst? This style has very useful
  feature. It is possible to combine multiple references into single number.
  It is realized by star operation: \\cite{paper1,*paper2,*paper3}. Three
  papers will be collected in References under single number [1].\ 

  Some more context on collapsing multiple citations in <LaTeX> here:
  <hlink|http://www.texfaq.org/FAQ-mcite|http://www.texfaq.org/FAQ-mcite>.

  \ <hrule>

  Sometimes, one has to produce quite compacts documents, where space is key
  (e.g.<nbsp>a short report, an exercice sheet or correction<text-dots>). One
  very important feature you be to put figures on the left or the right of
  the page, in a floating manner. To emulate this, tables can be used, with
  one cell for the text and one cell for the figure, but it does not work
  well at all with figure legends, footnotes<text-dots>

  More generally, mouse-movable floating minipages would be a killer feature
  and solve many issues at the same time.

  <hrule>

  An user-friendly interface to create/modify shortcuts.

  <hrule>

  Being able to easily create macros, at least non-parametrical ones, with a
  single menu action. It is already possible, but the syntax not easy for
  begginers (and non-programmers in general).

  <hrule>

  Being able to adjust the math typesetting parameters. For example, by
  default, I find formulas too compact, and I really like to have more space
  around (in)equality signs, so I always include 0.2em spaces around them.
  Looks nice, but semantically horrible.

  <hrule>

  A variant for underbraces and overbraces with <verbatim|\\smash> ;
  currently <verbatim|\<less\>resize\<gtr\>> can be used but it is slow to
  use and content can't be really modified afterwards.

  <hrule>

  Configuration option for pasting / drag-dropping images as integrated
  images, not mere links to external file.

  <hrule>

  More complete menus : some objects are accessible only by keyboard, and
  some took litteraly years to find them by accident or by chance in the
  documentation.

  <hrule>

  A set of shortcuts for common colors (red, dark green, blue, grey).

  <hrule>

  A set of shotcuts for commonly used unicode symbols, such as
  \<Rightarrow\>, \<rightarrow\>, <text-dots>

  <hrule>

  Performance : Editing large documents is a pain on a not-very-recent
  computer.

  <hrule>

  The "draw image" feature is heavily bugged. It may be wiser to not loose
  developement time on it. This may be the job of external programs such as
  Inkscape. A killer feature would be to place inline formulas and text
  floating (with relative positions/sizes) on top of figures, movable by
  mouse. This would eliminiate the use of, eg., latexit in Inkscape.
</body>

<initial|<\collection>
</collection>>

<\references>
  <\collection>
    <associate|auto-1|<tuple|?|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Wishlist>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-1><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>