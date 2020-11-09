<TeXmacs|1.99.14>

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