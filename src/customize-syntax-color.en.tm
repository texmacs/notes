<TeXmacs|1.99.15>

<style|<tuple|notes|british>>

<\body>
  <notes-header>

  <chapter*|Customizing the color of code snippets>

  By default, the preprocessor directives in <name|C++> code snippets are
  rendered in green:

  <\cpp-code>
    #include "stdio.h"
  </cpp-code>

  It is controlled by the following preference:

  <\session|scheme|default>
    <\unfolded-io|Scheme] >
      (get-preference "syntax:cpp:preprocessor_directive")
    <|unfolded-io>
      "dark green"
    </unfolded-io>

    <\input|Scheme] >
      \;
    </input>
  </session>

  And the preferences can be changed:

  <\session|scheme|default>
    <\input|Scheme] >
      (set-preference "syntax:cpp:preprocessor_directive" "black")
    </input>

    <\unfolded-io|Scheme] >
      (get-preference "syntax:cpp:preprocessor_directive")
    <|unfolded-io>
      "black"
    </unfolded-io>

    <\input|Scheme] >
      \;
    </input>
  </session>

  Preferences are stored when we set it. For GNU <TeXmacs> v1.99.15, a
  re-render trigger (eg. Restart) is required for your changes to take
  effect.

  <paragraph|Decolorize>

  To decolorize all C++ code snippet, we need to know all the preferences for
  the C++ language. Some of them can be found in
  <math|><slink|$TEXMACS_PATH/progs/prog/cpp-lang.scm>. A complete list can
  be found at <hlink|texmacs@v1.99.15:src/System/Language.cpp#L259|https://github.com/texmacs/texmacs/blob/a803cfbbf4a2e75e6621dbc2133f5da153b1c5d9/src/System/Language/language.cpp#L258>.

  <\session|scheme|default>
    <\unfolded-io|Scheme] >
      (map

      \ (lambda (key) (set-preference key "black"))

      \ (list

      \ \ "syntax:cpp:comment"

      \ \ "syntax:cpp:keyword"

      \ \ "syntax:cpp:constant_string"

      \ \ "syntax:cpp:constant_number"

      \ \ "syntax:cpp:constant_type"

      \ \ "syntax:cpp:preprocessor_directive"

      \ \ "syntax:cpp:preprocessor"

      \ \ "syntax:cpp:error"))
    <|unfolded-io>
      (#\<less\>unspecified\<gtr\> #\<less\>unspecified\<gtr\>
      #\<less\>unspecified\<gtr\> #\<less\>unspecified\<gtr\>
      #\<less\>unspecified\<gtr\> #\<less\>unspecified\<gtr\>
      #\<less\>unspecified\<gtr\> #\<less\>unspecified\<gtr\>)
    </unfolded-io>

    <\input|Scheme] >
      \;
    </input>
  </session>

  Restart <TeXmacs> or type some C++ code below to trigger recoloring:

  <\cpp-code>
    #include "stdio.h"

    int main() {

    \ \ return 0;

    }
  </cpp-code>

  <paragraph|Reset>

  To reset the colorizer:

  <\session|scheme|default>
    <\unfolded-io|Scheme] >
      (map

      \ (lambda (key) (reset-preference key))

      \ (list

      \ \ "syntax:cpp:comment"

      \ \ "syntax:cpp:keyword"

      \ \ "syntax:cpp:constant_string"

      \ \ "syntax:cpp:constant_number"

      \ \ "syntax:cpp:constant_type"

      \ \ "syntax:cpp:preprocessor_directive"

      \ \ "syntax:cpp:preprocessor"

      \ \ "syntax:cpp:error"))
    <|unfolded-io>
      (#\<less\>unspecified\<gtr\> #\<less\>unspecified\<gtr\>
      #\<less\>unspecified\<gtr\> #\<less\>unspecified\<gtr\>
      #\<less\>unspecified\<gtr\> #\<less\>unspecified\<gtr\>
      #\<less\>unspecified\<gtr\> #\<less\>unspecified\<gtr\>)
    </unfolded-io>

    <\input|Scheme] >
      \;
    </input>
  </session>

  Restart <TeXmacs> or type something below to see the effects:

  <\cpp-code>
    #include "stdio.h"

    int main() {

    \ \ return 0;

    }
  </cpp-code>
</body>

<\initial>
  <\collection>
    <associate|page-medium|papyrus>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|auto-1|<tuple|?|1>>
    <associate|auto-2|<tuple|1|2>>
    <associate|auto-3|<tuple|2|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Customizing
      the color of code snippets> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-1><vspace|0.5fn>

      <with|par-left|<quote|4tab>|Decolorize
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2><vspace|0.15fn>>

      <with|par-left|<quote|4tab>|Reset <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3><vspace|0.15fn>>
    </associate>
  </collection>
</auxiliary>