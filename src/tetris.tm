<TeXmacs|1.99.14>

<style|notes>

<\body>
  <hlink|[index]|./index.tm><chapter*|Tetris with <TeXmacs> tables>

  <image|../docs/tetris/screenshot.png|600px|||>

  This example is taken from a presentation of Miguel de Benito

  You can find the files here: <hlink|[Source directory]|tetris/.>.

  The TeXmacs source <code*|tetris.tm> \ loads the scheme file
  <hlink|tetris-with-tables.scm|./resources/tetris/tetris-with-tables.scm>
  which defines the procedures needed to play tetris. The game surface is
  implemented via a document table and the tiles by changing the color of the
  cells. This is not the most efficient implementation but it is a nice
  example of several features of TeXmacs:

  <\itemize>
    <item>handle keyboard interaction in a context-dependent way

    <item>programmatically modify a document

    <item>schedule actions to a later moment
  </itemize>

  Enjoy!

  <with|font-shape|italic|mgubi>
</body>

<initial|<\collection>
</collection>>

<\attachments>
  <\collection>
    <\associate|bib-bibliography>
      <\db-entry|+2E9XdEJ4gneMkXs|book|TeXmacs:vdH:book>
        <db-field|contributor|root>

        <db-field|modus|imported>

        <db-field|date|1604849819>
      <|db-entry>
        <db-field|author|J. van der <name|Hoeven>>

        <db-field|title|The Jolly Writer. Your Guide to GNU TeXmacs>

        <db-field|publisher|Scypress>

        <db-field|year|2020>
      </db-entry>
    </associate>
  </collection>
</attachments>

<\references>
  <\collection>
    <associate|auto-1|<tuple|?|?|index.tm>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Tetris
      with T<rsub|<space|-0.4spc><move|<resize|<with|math-level|<quote|0>|E>||||0.5fn>|0fn|-0.1fn>><space|-0.4spc>X<rsub|<space|-0.4spc><move|<resize|M<space|-0.2spc>A<space|-0.4spc>CS||||0.5fn>|0fn|-0.1fn>>
      tables> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-1><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>