<TeXmacs|2.1.1>

<style|<tuple|notes|framed-session>>

<\body>
  <notes-header>

  <chapter*|Keyboard shortcuts for menu items>

  <notes-abstract|How to write a keyboard shortcut for a menu item\Vand
  searching for text in <TeXmacs> <scheme> files.>

  <paragraph|Strategy>\ 

  Following up from this <hlink|forum post|http://forum.texmacs.cn/t/inserting-footnotes-via-keyboard-shortcuts/1025>,
  let us see how to write a keyboard shortcut for a command available from a
  menu item.

  The forum post asks how to define a keyboard shortcut for inserting a
  footnote, which can be done through the menu item
  <menu|Insert|Note|Footnote>.

  To do so, we need to find out which Scheme command is associated to the
  menu item and then write a keyboard shortcut for that command in
  <scm|my-init-texmacs.scm> (see Section 12.4 of the <hlink|TeXmacs
  manual|https://www.texmacs.org/tmweb/documents/manuals/texmacs-manual.en.pdf>
  for the definition of personal keyboard shortcuts).

  I don't think a list of commands associated to menu items exists and I am
  not aware of an automatic way for generating it (<em|id est>, if one wants
  such an automatic way, one needs to write a program that does that :-)).

  Listing these commands by hand takes time and patience and if the files
  where the menus are defined change from release to release the list becomes
  outdated when there are new releases.

  Here is what I do: I do a search on the TeXmacs GitHub repository using as
  search key the menu item name (in this case \Pfootnote\Q), in the search
  results I select only the Scheme files and I go through them looking for
  the menu item.

  For \Pfootnote\Q I found in the file <shell|progs/generic/insert-menu.scm>
  the Scheme list <scm|("Footnote" (make 'footnote))> and by placing

  <\scm-code>
    (kbd-map ("A-e f"\ 

    (make 'footnote)))
  </scm-code>

  in <shell|my-init-texmacs.scm> I obtained a shortcut for placing footnotes.

  <paragraph|Searching for text in TeXMacs Scheme files>

  Forum member <hlink|@jeroen|http://forum.texmacs.cn/u/jeroen> uses
  <hlink|ack|https://beyondgrep.com/> for searching through the TeXmacs
  Scheme files on the local disk, perhaps you like that more than the GitHub
  search I do. Here are the advantages and disadvantages of the two search
  methods as I see them.

  Searching on GitHub is intuitive; enter the search term into the search box
  when at the repository one wants to search in, one is offered the option to
  search \PIn this repository\Q and clicking on the option starts the search.
  One can then filter the search results by file type, for example one can
  choose only Scheme files).

  One can also limit the search to a path by means of the <shell|path:>
  option; here is how one searches for \Pfootnote\Q within the <shell|progs>
  directory of TeXmacs:\ 

  <\shell-code>
    footnote path:texmacs/progs
  </shell-code>

  On the other search is not case sensitive and \P(a)t most, search results
  can show two fragments from the same file, but there may be more results
  within the file\Q (from <hlink|GitHub code search online
  manual|https://docs.github.com/en/search-github/searching-on-github/searching-code>,
  and here is the <hlink|main page for the GitHub
  search|https://docs.github.com/en/search-github> as well); if one does not
  see the code lines they are looking for in the search results, they have to
  open each file GitHub has found and repeat the search in there (maybe with
  the browser's search facility).

  With <shell|ack> one types

  <\shell-code>
    ack Footnote
  </shell-code>

  (case sensitive: it helps, because the menu item we are looking for is
  uppercase) from the terminal when in the <shell|progs> directory of the
  TeXmacs installation and gets all the matching lines classified according
  to the file they are in. In the short tests I did, I got the impression
  that ack can match more precisely what the user wants: I was able to match
  <scm|(make 'footnote)> with ack but not with the GitHub search, where I got
  results for the consecutive words <shell|make footnote> within a string as
  well. On the other hand, with ack one does not have the immediacy of a
  search box.

  \;

  \;
</body>

<\initial>
  <\collection>
    <associate|page-medium|papyrus>
    <associate|page-screen-margin|false>
    <associate|preamble|false>
    <associate|prog-scripts|scheme>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|auto-1|<tuple|?|?>>
    <associate|auto-2|<tuple|1|?>>
    <associate|auto-3|<tuple|1|?>>
    <associate|auto-4|<tuple|2|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|idx>
      <tuple|<tuple|<with|font-family|<quote|ss>|Insert>|<with|font-family|<quote|ss>|Note>|<with|font-family|<quote|ss>|Footnote>>|<pageref|auto-3>>
    </associate>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|keyboard
      shortcuts for menu items> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-1><vspace|0.5fn>

      <with|par-left|<quote|4tab>|Strategy
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2><vspace|0.15fn>>

      <with|par-left|<quote|4tab>|Searching for text in TeXMacs Scheme files
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4><vspace|0.15fn>>
    </associate>
  </collection>
</auxiliary>