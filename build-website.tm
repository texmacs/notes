<TeXmacs|1.99.16>

<style|<tuple|generic|libertine-font>>

<\body>
  <\larger>
    <TeXmacs> notes building tool
  </larger>

  <with|font-shape|italic|Use this document to regenerate the
  website<with|font-series|bold|>>

  First, set the paths.

  <\session|scheme|default>
    <\unfolded-io|Scheme] >
      (tm-define (src-dir) (:secure #t) (url-\<gtr\>string (url-expand
      (url-append (current-buffer) \ "../src"))))
    <|unfolded-io>
      ((() #t))
    </unfolded-io>

    <\unfolded-io|Scheme] >
      (tm-define (dest-dir) (:secure #t) (url-\<gtr\>string (url-expand
      (url-append (current-buffer) \ "../docs-build"))))
    <|unfolded-io>
      ((() #t))
    </unfolded-io>

    <\input|Scheme] >
      \;
    </input>

    <\input|Scheme] >
      \;
    </input>
  </session>

  \;

  <\wide-tabular>
    <tformat|<cwith|1|1|1|1|cell-tborder|1ln>|<cwith|1|1|1|1|cell-bborder|1ln>|<cwith|1|1|1|1|cell-lborder|1ln>|<cwith|1|1|1|1|cell-rborder|1ln>|<cwith|1|1|1|1|cell-lsep|0.5em>|<cwith|1|1|1|1|cell-rsep|0.5em>|<cwith|1|1|1|1|cell-bsep|0.5em>|<cwith|1|1|1|1|cell-tsep|0.5em>|<table|<row|<\cell>
      <with|font-series|bold|Source directory:> <extern|src-dir>

      <with|font-series|bold|Destination directory:> <extern|dest-dir>
    </cell>>>>
  </wide-tabular>

  \;

  Run the following Scheme command to update the website:

  <\session|scheme|default>
    <\input|Scheme] >
      (tmweb-update-dir (src-dir) (dest-dir))
    </input>

    <\input|Scheme] >
      \;
    </input>
  </session>

  Run this command to regenerate the full site:

  <\session|scheme|default>
    <\input|Scheme] >
      (tmweb-convert-dir (src-dir) (dest-dir))
    </input>

    <\input|Scheme] >
      \;
    </input>
  </session>

  \;

  \;
</body>

<\initial>
  <\collection>
    <associate|page-medium|paper>
  </collection>
</initial>