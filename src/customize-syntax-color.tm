<TeXmacs|1.99.15>

<style|<tuple|notes|british>>

<\body>
  <notes-header>

  By default, the preprocessor directives in C++ code snippets is rendered in
  green:

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

  Restart <TeXmacs> and type some C++ code below:

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

  <\cpp-code>
    #include "stdio.h"

    int main() {

    \ \ return 0;

    }
  </cpp-code>

  \;

  \;
</body>

<\initial>
  <\collection>
    <associate|page-medium|paper>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|auto-1|<tuple|1|?>>
    <associate|auto-2|<tuple|2|?>>
  </collection>
</references>