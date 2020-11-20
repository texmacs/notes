<TeXmacs|1.99.16>

<style|generic>

<\body>
  Use this command to regenerate the website

  <\session|scheme|default>
    <\input|Scheme] >
      (define src-dir (url-expand (url-append (current-buffer) \ "../src")))
    </input>

    <\input|Scheme] >
      (define dest-dir (url-expand (url-append (current-buffer) \ "../src")))
    </input>

    <\input|Scheme] >
      \;
    </input>

    <\input|Scheme] >
      \;
    </input>
  </session>

  <\session|scheme|default>
    <\input>
      Scheme]\ 
    <|input>
      (tmweb-update-dir (url-\<gtr\>string src-dir) (url-\<gtr\>string
      dest-dir))
    </input>
  </session>

  \;

  <\session|scheme|default>
    <\input>
      Scheme]\ 
    <|input>
      (tmweb-convert-dir (url-\<gtr\>string src-dir) (url-\<gtr\>string
      dest-dir))
    </input>
  </session>
</body>

<\initial>
  <\collection>
    <associate|page-medium|paper>
  </collection>
</initial>