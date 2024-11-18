<TeXmacs|1.99.16>

<style|source>

<\body>
  <\active*>
    <\src-title>
      <src-style-file|notes|1.0>

      <src-purpose|Style file for blogging.>

      <src-copyright|2020|Massimiliano Gubinelli>

      <\src-license>
        This software falls under the <hlink|GNU general public license,
        version 3 or later|$TEXMACS_PATH/LICENSE>. It comes WITHOUT ANY
        WARRANTY WHATSOEVER. You should have received a copy of the license
        which the software. If not, see <hlink|http://www.gnu.org/licenses/gpl-3.0.html|http://www.gnu.org/licenses/gpl-3.0.html>.
      </src-license>
    </src-title>
  </active*>

  <use-package|tmmanual|html-font-size|libertine-font>

  <\active*>
    <\src-comment>
      Style parameters.
    </src-comment>
  </active*>

  <assign|full-screen-mode|false>

  <assign|font-base-size|12>

  <assign|page-medium|papyrus>

  \;

  <assign|html-title|TeXmacs notes>

  <assign|html-css|../resources/notes-base.css>

  <assign|html-head-favicon|../resources/blog-icon.png>

  <assign|html-extra-javascript-src|<tuple|../resources/highlight.pack.js|../resources/notes-base.js>>

  \;

  \;

  <\active*>
    <\src-comment>
      Macro definitions.
    </src-comment>
  </active*>

  <assign|hlink-tm|<macro|body|target|<hlink|<arg|body>|<merge|<arg|target>|.tm>>>>

  <assign|notes-header-name|Notes on TeXmacs>

  <assign|notes-header-image|<image|../resources/texmacs-blog-transparent.png|20pt|||>>

  <assign|notes-header-links|<macro|<hlink|[main]|./main.tm>>>

  <assign|notes-header-table|<\macro|body>
    <\wide-tabular>
      <tformat|<cwith|1|1|1|1|cell-halign|c>|<cwith|1|1|1|1|cell-width|30pt>|<cwith|1|1|1|1|cell-hmode|exact>|<cwith|1|1|1|-1|cell-valign|c>|<cwith|1|1|3|3|cell-halign|r>|<table|<row|<\cell>
        <notes-header-image>
      </cell>|<\cell>
        <space|0pt><arg|body>
      </cell>|<\cell>
        <em|<notes-header-name>>
      </cell>>>>
    </wide-tabular>
  </macro>>

  <assign|notes-header|<macro|<notes-header-table|<notes-header-links>>>>

  <assign|tmhtml-notes-header-table|<\macro|body>
    <\html-div-class|notes-header>
      <notes-header-image><space|2pt><arg|body><html-class|notes-header-name|<em|<notes-header-name>>>
    </html-div-class>
  </macro>>

  <assign|tmhtml-notes-header-xxx|<macro|<html-div-class|notes-header|<notes-header-image><space|2pt><notes-header-links><html-div-class|notes-header-name|<notes-header-name>>>>>

  <assign|notes-abstract|<macro|body|<small|<arg|body>>>>

  <assign|tmhtml-notes-abstract|<\macro|body>
    <style-with|src-compact|all|<html-div-class|notes-abstract|<arg|body>>>
  </macro>>

  <assign|notes-entry-date|<macro|date|<hflush><compound|very-small|[<arg|date>]>>>

  <assign|notes-entry-abstract|<\macro|abs>
    <\with|color|dark grey|par-left|2fn>
      <compound|tiny|<arg|abs>>
    </with>
  </macro>>

  <assign|notes-entry|<\macro|file|title|abs|date>
    <hlink|<arg|title>|<arg|file>><notes-entry-date|<arg|date>>

    <notes-entry-abstract|<arg|abs>>
  </macro>>

  \;

  <assign|tmhtml-notes-entry-date|<macro|date|<html-class|tmweb-entry-date|<arg|date>>>>

  <assign|tmhtml-notes-entry-abstract|<macro|abs|<compound|html-div-class|tmweb-entry-abstract|<arg|abs>>>>

  <\active*>
    <\src-comment>
      Other customizations
    </src-comment>
  </active*>

  <assign|tmhtml-render-code|<macro|body|<html-div-class|tmweb-code|<arg|body>>>>

  <assign|tmhtml-pseudo-code|<macro|body|<html-div-class|tmweb-code|<arg|body>>>>

  <assign|tmhtml-framed-code|<macro|body|<html-div-class|tmweb-code|<arg|body>>>>

  <assign|tmhtml-framed-fragment|<macro|body|<html-div-class|tmweb-code|<arg|body>>>>

  <assign|tmhtml-render-key|<macro|key|<html-class|tmweb-key|<arg|key>>>>

  <assign|tmhtml-menu-item|<macro|body|<html-class|tmweb-menu|<with|font-family|ss|<localize|<arg|body>>>>>>

  <assign|tmhtml-menu-extra|<macro|body|\<rightarrow\><menu-item|<arg|body>>>>

  <assign|tmhtml-markup|<macro|body|<html-class|tmweb-markup|<arg|body>>>>

  <assign|tmhtml-hlink-tm|<macro|body|target|<hlink|<arg|body>|<merge|<arg|target>|.texmacs>>>>

  <assign|tmhtml-cpp|<macro|body|<html-class|cpp|<with|mode|prog|prog-language|cpp|font-family|rm|<arg|body>>>>>

  <assign|tmhtml-scm|<macro|body|<html-class|scheme|<with|mode|prog|prog-language|scheme|font-family|rm|<arg|body>>>>>

  \;
</body>

<initial|<\collection>
</collection>>