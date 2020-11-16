<TeXmacs|1.99.15>

<style|notes>

<\body>
  <notes-header>

  <chapter*|Wishlist>

  <notes-abstract|This wishlist collects suggestions for improvements and
  nice ideas for addition to TeXmacs. These should be of limited scope and
  somewhat reasonable technical difficulty. It is mostly meant for developers
  or technically savyy users to collect good ideas. It should be clear that
  the functionality is not already provided in some form. This wishlist must
  not be used for very broad and vague requests (e.g. ``make the program more
  versatile and powerful").>

  <hrule>

  From <hlink|[bug#59433]|https://savannah.gnu.org/bugs/?59433>.

  Is it possible to make support to apsrev4-1.bst? This style has very useful
  feature. It is possible to combine multiple references into single number.
  It is realized by star operation: \\cite{paper1,*paper2,*paper3}. Three
  papers will be collected in References under single number [1].\ 

  Some more context on collapsing multiple citations in <LaTeX> here:
  <hlink|http://www.texfaq.org/FAQ-mcite|http://www.texfaq.org/FAQ-mcite>.

  \ <hrule>

  <with|font-shape|italic|Easy:> Implement a <name|Lilipond> backend for the
  <name|Graph> plugin. See this <hlink|post in the
  forum|http://forum.texmacs.cn/t/write-music-in-texmacs/167>. There is an
  open bug for this at [<hlink|bug#59001|https://savannah.gnu.org/bugs/?59001>].

  <hrule>

  Modify the way circles are created in the graphical editor. See
  [<hlink|bug#57882|https://savannah.gnu.org/bugs/?57882>].

  <hrule>

  Add possibility for automatic line numbers (even approximate) for easy
  refeering.

  See <slink|https://texblog.org/2012/02/08/adding-line-numbers-to-documents/>

  (Seem complicate, maybe need adding appropriate hooks in the typesetter, to
  detect line breaks)

  <hrule>

  \;
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