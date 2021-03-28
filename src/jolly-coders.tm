<TeXmacs|1.99.19>

<style|notes>

<\body>
  <\hide-preamble>
    \;
  </hide-preamble>

  <notes-header>

  <chapter*|Jolly coders>

  <notes-abstract|This page gather informations on the activities of the
  TeXmacs hacking group.>\ 

  \;

  <with|font-series|bold|Jolly coders> is a group of people interested in
  learning, hacking and in general exchanging about TeXmacs internal
  structure. The group started random gatherings in March 2021 and hope to
  continue to meet quasi-regularly for long time. For the moment the focus is
  to learn together about TeXmacs internal structure, the C++ and Scheme
  codebase, the interaction with external libraries and the various plugins,
  the behaviour of the converters, and many other topics related to TeXmacs.

  \;

  Meetings are announced in a private mailing list. Write to
  <hlink|m.gubinelli@gmail.com|mailto:m.gubinelli@gmail.com> to ask to be
  included in the communications. Recordings of the meetings are kept
  whenever possible.

  <\with|font-shape|italic>
    \;

    Current members
  </with>

  Basile Audoly, Massimiliano Gubinelli, \ Joris van der Hoeven, Pierre-Henri
  Jondot, Marc Lalaude-Labayle, Sebastian Miele, Giovanni Piredda, Joy Yang
  Qiping, Peter Rap£an, Darcy Shen, Jeroen Wouters.

  \;

  <with|font-shape|italic|Journal of past gatherings>

  <\itemize>
    <item>12.3.2021 \U The Xcode project, working on a bug related to
    exporting PDF images to the clipboard on a Mac.

    <item>13.3.2021 \U General structure of the C++ codebase, various
    directories, abstract interfaces to the user interface, handling of
    events, \ example of the close window event.

    <item>14.3.2021 \U Scheme/C++ interface, patching the S7 Scheme
    interpreter, generation of menus and widgets between C++ and Scheme.

    <item>19.3.2021 \U The build systems. How the makefile works. Demo of the
    old widget library and of the Guile 3 port. Discussion on the Scheme
    code, the module system, the differences between Guile 1.8 and Guile 2/3.

    <item>20.3.2021 \U Various aspects of the use of Scheme in TeXmacs,
    including embedding Scheme, the various dialects and the status of the
    Guile 3 and Chez Scheme ports. The design and use of tm-define. Features
    currently absent in TeXmacs like a structured table of contents or a
    double view on a document. Design choices in TeXmacs' user interface.
    Joris demonstrated the use of the search tool, including template
    variables and the filtering option.

    <item>28.3.2021 \U Hacking session on improving the navigation of the
    structure of the document (sections, subsections<text-dots>). We modified
    the scheme code of the UI to produce properly indented structures for the
    menu listing all the sections and added some keybindings. Some
    screenshots in the <hlink|twitter feed|https://twitter.com/gnu_texmacs/status/1376205283102502917>.
    We had also some (not recorded) discussion on live editing of documents
    and on versioning of documents. We will discuss these topics also in a
    further session.
  </itemize>

  \;

  <with|font-shape|italic|Other sources for technical informations>

  <\itemize>
    <item>A couple of videos recorded during the 2012 TeXmacs workshop. In
    <hlink|video 5|http://magix.lix.polytechnique.fr/local/videos/TeXmacs-5.mp4>
    and <hlink|video 6|http://magix.lix.polytechnique.fr/local/videos/TeXmacs-6.mp4>
    Joris talks about TeXmacs internals, the C++ and Scheme code and how to
    write plugins. There is also \ <hlink|video
    4|http://magix.lix.polytechnique.fr/local/videos/TeXmacs-4.mp4> \ on the
    TeXmacs document format, style files, and converters. For all the series
    go <hlink|here|http://magix.lix.polytechnique.fr/magix/workshop/workshop-videos.en.html>.

    <item>The developer pages in this blog (from the <hlink|main|./main.tm>
    page)

    <item>The list of developments resources & ideas
    (<hlink|here|./dev-notes.tm>)\ 
  </itemize>

  <with|font-shape|italic|List of topics of interest to the group members>

  <\itemize>
    <item>Conversion to HTML/MathML. Creating accessible math content is
    creating major headaches in many maths departments in the UK , as legal
    requirements to do so are increasing. Providing HTML with MathML or
    MathJax is generally considered to be the best way to go, as users can
    control the font type and size, increase contrast or use screen readers
    to read out the document (<hlink|URL|]<nbsp><hlink|https://stem-enable.github.io/Accessibility-of-maths-e-resources/index.html|https://stem-enable.github.io/Accessibility-of-maths-e-resources/index.html>>)

    <item>Plugins (Jupyter, Sage, Octave and Python)

    <item>How to write templates for conference paper. and macro writing in
    general, e.g., how do you write a macro to add a new floating
    environment? Suggestion: write during a session a new style file, which
    we could then put somewhere where other people can use it. In addition to
    templates for conference papers, a style file for a curriculum vitae
    could be interesting.

    <item>Using TeXmacs is the lack of autocompletion and error correction
    for English words.

    <item>Get accustomed to TeXmacs codebase, configuring developing tools
    like Xcode.

    <item>Bugfixing. Example, how to investigate bugs that result in
    segfaults, e.g. <hlink|bug #<hlink|60125|https://savannah.gnu.org/bugs/?60125>|https://savannah.gnu.org/bugs/?60125>
    and <hlink|bug #<hlink|60015|https://savannah.gnu.org/bugs/?60015>|https://savannah.gnu.org/bugs/?60125>.
  </itemize>
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
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Jolly
      coders> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-1><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>