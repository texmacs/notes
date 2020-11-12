<TeXmacs|1.99.14>

<style|notes>

<\body>
  <notes-header>

  <chapter*|TeXmacs and HTML>

  <small|In this article we discuss question related to conversion from/to
  <name|HTML>.>

  Since <TeXmacs> 1.99.14 we support an improved converter to <name|HTML>.
  The new converter is stylable using <name|CSS>, which should allow you to
  produce nice web versions of your papers that are readable on multiple
  devices. Joris' personal website shows what you can do:
  <hlink|https://www.texmacs.org/joris/main/joris.html|https://www.texmacs.org/joris/main/joris.html>\ 

  For a random math paper, see: <hlink|https://www.texmacs.org/joris/ffnlogn/ffnlogn.html|https://www.texmacs.org/joris/ffnlogn/ffnlogn.html>

  The precise <name|CSS> style can be selected in the user preferences
  dialog: <menu|Preferences<text-dots>|Convert|Html|CSS style sheet>.\ 

  If someone with <name|CSS> design skills wants to contribute other styles,
  then we would be happy to include them in the official distribution.

  \;

  Note that <TeXmacs> can both export formulas as <name|MathML> as well (as
  noted in the discussion) and as <name|MathJax> (not clearly mentioned so
  far).

  It should be noted that both <name|MathML> and <name|MathJax> come with
  their problems (and that is why a prefer the less error-prone solution of
  images):\ 

  <\itemize>
    <item>Both the rendering quality of <name|MathML> and <name|MathJax> is
    not as good as with <TeXmacs>

    <item>MathML lacks support for formula integration in the main text. For
    instance, equation arrays are a pain. Joris found a way to hack this with
    <name|CSS> in the case of images, but <name|MathML> is not sufficiently
    widely used for duplicating this effort.

    <item><name|MathJax> lacks several <LaTeX> constructs, so the standard
    <LaTeX> export filter would need to be hacked quite a bit for various
    exotic constructs and we don't have currently enough developer time and
    energy for doing the <LaTeX> export filters twice.
  </itemize>

  Concerning copy&paste, we might annotate images with <LaTeX> formulas. That
  would not be very hard to implement, although it would take some time, of
  course.

  \;
</body>

<initial|<\collection>
</collection>>

<\references>
  <\collection>
    <associate|auto-1|<tuple|?|?|wishlist.tm>>
    <associate|auto-2|<tuple|?|?|wishlist.tm>>
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