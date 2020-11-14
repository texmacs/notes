<TeXmacs|1.99.5>

<style|<tuple|book|chinese|doc>>

<\body>
  \;

  <\doc-data|<doc-title|<TeXmacs>\<#56FE\>\<#5F62\>\<#7F16\>\<#7A0B\>>>
    \;
  <|doc-data|<doc-author|<author-data|<author-name|\<#6C88\>\<#8FBE\>>|<author-email|sadhen@zoho.com>>>|<doc-date|<date>>>
    \;
  </doc-data>

  <section|\<#7B80\>\<#4ECB\>>

  \<#56E0\>\<#4E3A\><TeXmacs>\<#7684\>\<#4ECB\>\<#7ECD\>\<#8D44\>\<#6599\>\<#4E0D\>\<#591A\>\<#FF0C\>\<#6240\>\<#4EE5\>\<#6253\>\<#7B97\>\<#8FB9\>\<#5B66\>\<#8FB9\>\<#5199\>\<#FF0C\>\<#5199\>\<#4E00\>\<#7CFB\>\<#5217\>\<#7528\><name|Scheme>\<#4F5C\>\<#56FE\>\<#7684\>\<#5C0F\>\<#6587\>\<#7AE0\>\<#3002\>\<#65E9\>\<#5148\>\<#6211\>\<#5728\>\<#81EA\>\<#5DF1\>\<#7684\>\<#535A\>\<#5BA2\>\<#4E0A\>\<#5199\>\<#8FC7\>\<#4E24\>\<#7BC7\>\<#FF1A\>\<#4F7F\>\<#7528\>Scheme\<#5728\>TeXmacs\<#4E2D\>\<#751F\>\<#6210\>\<#56FE\>\<#7247\><\footnote>
    <href|http://sadhen.com/blog/2014/11/04/texmacs-graphics.html>
  </footnote>\<#548C\>\<#4F7F\>\<#7528\>Scheme\<#5728\>TeXmacs\<#4E2D\>\<#753B\>\<#5185\>\<#6838\>\<#4EE3\>\<#7801\>\<#7ED3\>\<#6784\>\<#4F53\>\<#5173\>\<#7CFB\>\<#56FE\><\footnote>
    <href|http://sadhen.com/blog/2014/11/09/texmacs-graphics-struct.html>
  </footnote>\<#FF0C\>\<#5BF9\>\<#5176\>\<#56FE\>\<#5F62\>\<#7CFB\>\<#7EDF\>\<#7684\>\<#6587\>\<#6863\>\<#6811\>\<#6709\>\<#4E00\>\<#4E2A\>\<#5927\>\<#6982\>\<#7684\>\<#4E86\>\<#89E3\>\<#3002\>\<#8FD9\>\<#6B21\>\<#6253\>\<#7B97\>\<#7CFB\>\<#7EDF\>\<#6027\>\<#5730\>\<#4ECB\>\<#7ECD\>\<#4F5C\>\<#56FE\>\<#65B9\>\<#6CD5\>\<#5E76\>\<#6784\>\<#5EFA\>\<#7528\><name|Scheme>\<#7F16\>\<#7A0B\>\<#4F5C\>\<#56FE\>\<#7684\>\<#914D\>\<#7F6E\>\<#6587\>\<#4EF6\>\<#3002\>

  \<#672C\>\<#6587\>\<#5BF9\>\<#8BFB\>\<#8005\>\<#7684\>\<#57FA\>\<#672C\>\<#8981\>\<#6C42\>\<#5C31\>\<#662F\>\<#719F\>\<#6089\><TeXmacs>\<#7684\>\<#57FA\>\<#672C\>\<#4F7F\>\<#7528\>\<#548C\><name|Scheme>\<#8BED\>\<#8A00\>\<#7684\>\<#57FA\>\<#7840\>\<#3002\><TeXmacs>\<#76F8\>\<#5173\>\<#7684\>\<#64CD\>\<#4F5C\>\<#548C\>\<#5185\>\<#90E8\>\<#539F\>\<#7406\>\<#FF0C\>\<#6211\>\<#5C3D\>\<#91CF\>\<#4F1A\>\<#4F7F\>\<#7528\>\<#81EA\>\<#5DF1\>\<#8BED\>\<#8A00\>\<#9610\>\<#8FF0\>\<#6E05\>\<#695A\>\<#FF0C\>\<#6216\>\<#8005\>\<#7ED9\>\<#51FA\><TeXmacs>\<#5B98\>\<#65B9\>\<#6587\>\<#6863\>\<#7684\>\<#5177\>\<#4F53\>\<#4F4D\>\<#7F6E\>\<#3002\>\<#53E6\>\<#5916\>\<#FF0C\>\<#672C\>\<#6587\>\<#539F\>\<#59CB\>\<#6587\>\<#6863\>\<#6258\>\<#7BA1\>\<#5728\>Github<\footnote>
    <href|https://github.com/sadhen/articles-and-notes-by-TeXmacs>
  </footnote>\<#4E0A\>\<#FF0C\>\<#6240\>\<#4F7F\>\<#7528\>\<#7684\><TeXmacs>\<#7248\>\<#672C\>\<#4E3A\><TeXmacs-version>\<#3002\>

  <with|ornament-color|#efefef|<\ornamented>
    <\remark>
      \<#7531\>\<#4E8E\>\<#6587\>\<#4E2D\>\<#4F7F\>\<#7528\>\<#4E86\>\<#5927\>\<#91CF\>\<#4EA4\>\<#4E92\>\<#5F0F\><name|Scheme>\<#8FDB\>\<#7A0B\>\<#FF0C\>\<#5728\>\<#539F\>\<#59CB\>\<#6587\>\<#6863\>\<#4E2D\>\<#624D\>\<#80FD\>\<#591F\>\<#5BF9\>\<#5176\>\<#6C42\>\<#503C\>\<#5E76\>\<#4F5C\>\<#56FE\>\<#FF0C\>\<#6240\>\<#4EE5\>\<#8BF7\>\<#4F7F\>\<#7528\><TeXmacs>\<#9605\>\<#8BFB\>\<#539F\>\<#59CB\>\<#6587\>\<#6863\>\<#3002\>
    </remark>
  </ornamented>>

  \<#672C\>\<#6587\>\<#7684\>\<#4EA4\>\<#4E92\>\<#5F0F\>\<#4EE3\>\<#7801\>\<#7684\>\<#6267\>\<#884C\>\<#5047\>\<#5B9A\>\<#8BFB\>\<#8005\>\<#662F\>\<#4E00\>\<#6B21\>\<#6027\>\<#4ECE\>\<#4E0A\>\<#5230\>\<#4E0B\>\<#8BFB\>\<#5B8C\>\<#5168\>\<#6587\>\<#FF0C\>\<#5F53\>\<#7136\>\<#8FD9\>\<#662F\>\<#4E0D\>\<#73B0\>\<#5B9E\>\<#7684\>\<#FF0C\>\<#6240\>\<#4EE5\>\<#9644\>\<#5F55\>\<#7684\>\<#5C0F\>\<#8D34\>\<#58EB\>\<#5EFA\>\<#8BAE\>\<#4F18\>\<#5148\>\<#9605\>\<#8BFB\>\<#FF0C\>\<#4EE5\>\<#65B9\>\<#4FBF\>\<#4F60\>\<#7B2C\>\<#4E8C\>\<#6B21\>\<#9605\>\<#8BFB\>\<#672C\>\<#6587\>\<#4E2D\>\<#672B\>\<#8282\>\<#65F6\>\<#5FEB\>\<#901F\>\<#8FDB\>\<#5165\>\<#72B6\>\<#6001\>\<#3002\>

  <section|\<#57FA\>\<#672C\>\<#539F\>\<#7406\>>

  \<#9996\>\<#5148\>\<#FF0C\>\<#5047\>\<#8BBE\>\<#6211\>\<#4EEC\>\<#5DF2\>\<#7ECF\>\<#4E86\>\<#89E3\>\<#5230\>\<#FF1A\>\<#4E00\>\<#7BC7\><TeXmacs>\<#6587\>\<#6863\>\<#5B9E\>\<#9645\>\<#4E0A\>\<#5C31\>\<#662F\>\<#4E00\>\<#957F\>\<#4E32\><name|Scheme>\<#4EE3\>\<#7801\>\<#FF0C\>\<#901A\>\<#8FC7\>\<#6E32\>\<#67D3\>\<#5F15\>\<#64CE\>\<#7684\>\<#52A0\>\<#5DE5\>\<#FF0C\>\<#8FD9\>\<#4E9B\>\<#4EE3\>\<#7801\>\<#5F97\>\<#4EE5\>\<#5C55\>\<#73B0\>\<#5728\>\<#6211\>\<#4EEC\>\<#7B14\>\<#8BB0\>\<#672C\>\<#7684\>\<#5C4F\>\<#5E55\>\<#4E0A\>\<#3002\>\<#8FD9\>\<#4E9B\>\<#4EE3\>\<#7801\>\<#6211\>\<#4EEC\>\<#79F0\>\<#4E4B\>\<#4E3A\><TeXmacs>
  <name|Scheme>\<#3002\>\<#4E3A\>\<#4E86\>\<#533A\>\<#5206\>\<#FF0C\>\<#6211\>\<#4EEC\>\<#5C06\>\<#5728\><name|Guile>\<#4E2D\>\<#8FD0\>\<#884C\>\<#7684\>\<#4EE3\>\<#7801\>\<#79F0\>\<#4E3A\><name|Guile>
  <name|Scheme>\<#3002\>

  \<#901A\>\<#8FC7\><menu|insert|session|Scheme>\<#FF0C\>\<#6211\>\<#4EEC\>\<#5F97\>\<#5230\>\<#4E00\>\<#4E2A\><name|Scheme>
  <name|REPL>\<#3002\>\<#6211\>\<#4EEC\>\<#5B9A\>\<#4E49\>\<#7B2C\>\<#4E00\>\<#4E2A\>\<#51FD\>\<#6570\>

  <\session|scheme|default>
    <\input|Scheme] >
      (define (plot l) (stree-\<gtr\>tree l))
      ;\<#6309\>\<#4E0B\>\<#56DE\>\<#8F66\>\<#FF0C\>\<#5B9A\>\<#4E49\>\<#8FD9\>\<#4E2A\>\<#51FD\>\<#6570\>
    </input>
  </session>

  \<#4E00\>\<#4E32\><name|Scheme>\<#4EE3\>\<#7801\>\<#5BF9\>\<#5E94\>\<#7684\>\<#7ED3\>\<#6784\>\<#662F\>\<#4E00\>\<#68F5\>\<#6811\>\<#FF0C\>\<#8FD9\>\<#91CC\>\<#7684\><scm|stree-\<gtr\>tree>\<#5C31\>\<#662F\>\<#5C06\><name|Guile>
  <scheme>\<#6811\>\<#8F6C\>\<#53D8\>\<#6210\><TeXmacs>
  <scheme>\<#6811\>\<#FF0C\>\<#4EE5\>\<#4FBF\>\<#5728\>\<#6587\>\<#6863\>\<#4E2D\>\<#663E\>\<#793A\>\<#3002\>\<#6BD4\>\<#5982\>\<#FF0C\>\<#6211\>\<#4EEC\>\<#77E5\>\<#9053\><frac|1|2>\<#7684\>\<#5185\>\<#90E8\>\<#8868\>\<#793A\>\<#5B9E\>\<#9645\>\<#4E0A\>\<#5C31\>\<#662F\><scm|(frac
  1 2)>\<#3002\>\<#4E8E\>\<#662F\>\<#FF0C\>\<#5728\><name|REPL>\<#4E2D\>\<#FF0C\>\<#6211\>\<#4EEC\>\<#5C31\>\<#53EF\>\<#4EE5\>\<#901A\>\<#8FC7\>

  <\session|scheme|default>
    <\folded-io|Scheme] >
      (plot `(frac 1 2)) ;\<#5149\>\<#6807\>\<#653E\>\<#5728\>\<#8FD9\>\<#884C\>\<#4E0A\>\<#FF0C\>\<#6309\>\<#4E0B\>\<#56DE\>\<#8F66\>\<#5C31\>\<#80FD\>\<#5F97\>\<#5230\>1/2
    <|folded-io>
      \;
    </folded-io>
  </session>

  <subsection|\<#539F\>\<#8BED\>>

  \<#4E0A\>\<#9762\>\<#4ECB\>\<#7ECD\>\<#7684\>\<#539F\>\<#8BED\><verbatim|frac>\<#5B9E\>\<#9645\>\<#4E0A\>\<#7528\>\<#4E8E\>\<#6570\>\<#5B66\>\<#6A21\>\<#5F0F\>\<#FF0C\>\<#4E0B\>\<#9762\>\<#6211\>\<#4EEC\>\<#4ECB\>\<#7ECD\>\<#56FE\>\<#5F62\>\<#6A21\>\<#5F0F\>\<#4E0B\>\<#7684\>\<#539F\>\<#8BED\>\<#3002\>\<#5148\>\<#5168\>\<#90E8\>\<#5217\>\<#51FA\>\<#6765\>\<#FF1A\>

  <\big-table|<tabular|<tformat|<table|<row|<cell|>>>>><block*|<tformat|<cwith|1|-1|1|-1|cell-hyphen|c>|<table|<row|<\cell>
    \<#539F\>\<#8BED\>
  </cell>|<\cell>
    \<#793A\>\<#4F8B\>
  </cell>|<\cell>
    \<#529F\>\<#80FD\>
  </cell>>|<row|<\cell>
    <markup|point>
  </cell>|<\cell>
    <verbatim|<code*|(point \P0\Q \P0\Q)>>
  </cell>|<\cell>
    \<#5750\>\<#6807\>(0,0)\<#5904\>\<#7684\>\<#4E00\>\<#4E2A\>\<#70B9\>
  </cell>>|<row|<\cell>
    <markup|line>
  </cell>|<\cell>
    <verbatim|<\code*>
      (line (point \P0\Q \P0\Q) (point \P0\Q \P1\Q)

      (point \P1\Q \P1\Q))
    </code*>>
  </cell>|<\cell>
    (0,0)<math|\<rightarrow\>>(0,1)<math|\<rightarrow\>>(1,1)

    \<#7684\>\<#4E00\>\<#6761\>\<#6298\>\<#7EBF\>
  </cell>>|<row|<\cell>
    <markup|cline>
  </cell>|<\cell>
    <\code*>
      (cline (point \P0\Q \P0\Q) (point \P0\Q \P1\Q)

      (point \P1\Q \P1\Q))
    </code*>
  </cell>|<\cell>
    <math|(0,0)\<rightarrow\>(0,1)\<rightarrow\>(1,1)\<rightarrow\>(0,0)>

    \<#7684\>\<#4E00\>\<#6761\>\<#95ED\>\<#5408\>\<#6298\>\<#7EBF\>
  </cell>>|<row|<\cell>
    <markup|spline>
  </cell>|<\cell>
    <\code*>
      (spline (point \P0\Q \P0\Q) (point \P0\Q \P1\Q)

      (point \P1\Q \P1\Q))
    </code*>
  </cell>|<\cell>
    <math|(0,0)\<rightarrow\>(0,1)\<rightarrow\>(1,1)>

    \<#7684\>\<#4E00\>\<#6761\>\<#6837\>\<#6761\>\<#66F2\>\<#7EBF\>
  </cell>>|<row|<\cell>
    <markup|cspline>
  </cell>|<\cell>
    <\code*>
      (cspline (point \P0\Q \P0\Q) (point \P0\Q \P1\Q)

      (point \P1\Q \P1\Q))
    </code*>
  </cell>|<\cell>
    <math|(0,0)\<rightarrow\>(0,1)\<rightarrow\>(1,1)\<rightarrow\>(0,0)>

    \<#7684\>\<#4E00\>\<#6761\>\<#95ED\>\<#5408\>\<#6837\>\<#6761\>\<#66F2\>\<#7EBF\>
  </cell>>|<row|<\cell>
    <markup|arc>
  </cell>|<\cell>
    <\code*>
      (arc (point \P0\Q \P0\Q) (point \P0\Q \P1\Q)

      (point \P1\Q \P1\Q))
    </code*>
  </cell>|<\cell>
    \<#8FC7\>\<#8FD9\>\<#4E09\>\<#70B9\>\<#7684\>\<#4E00\>\<#6761\>\<#5F27\>
  </cell>>|<row|<\cell>
    <markup|carc>
  </cell>|<\cell>
    <\code*>
      (carc (point \P0\Q \P0\Q) (point \P0\Q \P1\Q)

      (point \P1\Q \P1\Q))
    </code*>
  </cell>|<\cell>
    \<#8FC7\>\<#8FD9\>\<#4E09\>\<#70B9\>\<#7684\>\<#4E00\>\<#4E2A\>\<#5706\>
  </cell>>|<row|<\cell>
    <markup|text-at>
  </cell>|<\cell>
    <\code*>
      (text-at (texmacs-markup)

      (point \P0\Q \P0\Q))
    </code*>
  </cell>|<\cell>
    \<#8FD9\>\<#4E2A\>\<#539F\>\<#8BED\>\<#7684\>\<#91CD\>\<#8981\>\<#4E4B\>\<#5904\>\<#5728\>\<#4E8E\>\<#63D0\>

    \<#4F9B\>\<#4E86\>\<#4E00\>\<#79CD\>\<#5728\>\<#56FE\>\<#7247\>\<#4E0A\>\<#653E\>\<#7F6E\>

    \<#56FE\>\<#7247\>\<#7684\>\<#65B9\>\<#6CD5\>\<#FF0C\>\<#653E\>\<#5728\>\<#5176\>\<#4E0A\>

    \<#7684\>\<#56FE\>\<#7247\>\<#6240\>\<#5904\>\<#7684\>\<#4F4D\>\<#7F6E\>\<#662F\>\<#70B9\>

    (0,0)\<#7684\>\<#53F3\>\<#8FB9\>\<#FF0C\>\<#5176\>\<#7AD6\>\<#76F4\>\<#65B9\>\<#5411\>

    \<#4E0A\>\<#7684\>\<#5BF9\>\<#79F0\>\<#8F74\>\<#6B63\>\<#597D\>\<#8FC7\>\<#70B9\>(0,0)
  </cell>>>>>>
    \;
  </big-table>

  \<#63A5\>\<#7740\>\<#FF0C\>\<#6211\>\<#4EEC\>\<#5728\>\<#8FD9\>\<#4E9B\>\<#539F\>\<#8BED\><\footnote>
    \<#8FD9\>\<#4E9B\>\<#539F\>\<#8BED\>\<#7684\>\<#4EE3\>\<#7801\>\<#5B9E\>\<#73B0\>\<#53EF\>\<#4EE5\>\<#5728\><verbatim|src/Graphics/Types/>\<#4E0B\>\<#627E\>\<#5230\>
  </footnote>\<#7684\>\<#57FA\>\<#7840\>\<#4E0A\>\<#6784\>\<#5EFA\>\<#4F5C\>\<#56FE\>\<#6240\>\<#9700\>\<#7684\>\<#57FA\>\<#672C\>\<#5143\>\<#7D20\>\<#3002\>\<#9996\>\<#5148\>\<#662F\>\<#70B9\>\<#FF0C\>\<#7EBF\>\<#6BB5\>\<#FF0C\>\<#77E9\>\<#5F62\>\<#548C\>\<#5706\>\<#FF1A\>

  <\session|scheme|default>
    <\input|Scheme] >
      (define (point x y)

      \ \ ; number-\<gtr\>string\<#7684\>\<#4F5C\>\<#7528\>\<#662F\>\<#5C06\>\<#6811\>\<#53D8\>\<#6210\>\<#6587\>\<#6863\>\<#4E2D\>\<#8868\>\<#793A\>\<#6570\>\<#636E\>\<#7684\>\<#5B57\>\<#7B26\>\<#4E32\>

      \ \ `(point ,(number-\<gtr\>string x) ,(number-\<gtr\>string y)))
    </input>

    <\input|Scheme] >
      (define (point.x point)

      \ \ (string-\<gtr\>number (list-ref point 1)))
    </input>

    <\input|Scheme] >
      (define (point.y point)

      \ \ (string-\<gtr\>number (list-ref point 2)))
    </input>

    <\input|Scheme] >
      (define (line . points)

      \ \ (cond ((nlist? points) `())

      \ \ \ \ \ \ \ \ ((== points '()) `())

      \ \ \ \ \ \ \ \ (else `(line ,@points))))
    </input>

    <\input|Scheme] >
      (define (rectangle leftdown rightup)

      \ \ (let ((leftup (point (point.x leftdown) (point.y rightup)))

      \ \ \ \ \ \ \ \ (rightdown (point (point.x rightup) (point.y
      leftdown))))

      \ \ \ \ `(cline ,leftdown ,leftup ,rightup ,rightdown)))
    </input>

    <\input|Scheme] >
      (define (circle center radius)

      \ \ (let ((p1 (point (- (point.x center) radius) (point.y center)))

      \ \ \ \ \ \ \ \ (p2 (point (point.x center) (+ (point.y center)
      radius)))

      \ \ \ \ \ \ \ \ (p3 (point (+ (point.x center) radius) (point.y
      center))))

      \ \ \ \ `(carc ,p1 ,p2 ,p3)))
    </input>
  </session>

  \<#7528\><verbatim|plot>\<#7ED8\>\<#5236\>\<#70B9\>\<#3001\>\<#77E9\>\<#5F62\>\<#548C\>\<#5706\>\<#FF1A\>

  <\session|scheme|default>
    <\unfolded-io|Scheme] >
      (plot (point 0 0))
    <|unfolded-io>
      <text|<point|0|0>>
    </unfolded-io>

    <\unfolded-io|Scheme] >
      (plot (rectangle (point 0 0) (point 1 1)))
    <|unfolded-io>
      <text|<cline|<point|0|0>|<point|0|1>|<point|1|1>|<point|1|0>>>
    </unfolded-io>

    <\unfolded-io|Scheme] >
      (plot (circle (point 0 0) 1))
    <|unfolded-io>
      <text|<carc|<point|-1|0>|<point|0|1>|<point|1|0>>>
    </unfolded-io>
  </session>

  <subsection|\<#64CD\>\<#7EB5\>\<#6837\>\<#5F0F\>\<#5C5E\>\<#6027\>>

  \<#4F7F\>\<#7528\><markup|with>\<#539F\>\<#8BED\>\<#53EF\>\<#4EE5\>\<#7ED9\><TeXmacs>\<#5BF9\>\<#8C61\>\<#9644\>\<#4E0A\>\<#5404\>\<#79CD\>\<#5C5E\>\<#6027\>\<#3002\>\<#6BD4\>\<#5982\>

  <\session|scheme|default>
    <\unfolded-io|Scheme] >
      (plot `(with color "red" fill-color "#eeeeee" ,(circle (point 0 0) 1)))
    <|unfolded-io>
      <text|<with|color|red|fill-color|#eeeeee|<carc|<point|-1|0>|<point|0|1>|<point|1|0>>>>
    </unfolded-io>

    <\unfolded-io|Scheme] >
      (plot `(with arrow-begin "\<less\>gtr\<gtr\>" dash-style "11100"
      \<#FF0C\>(line (point 0 1) (point 0 0) (point 1 1))))
    <|unfolded-io>
      <text|<with|arrow-begin|\<gtr\>|dash-style|11100|<line|<point|0|1>|<point|0|0>|<point|1|1>>>>
    </unfolded-io>

    <\unfolded-io|Scheme] >
      (plot `(with point-style "star" ,(point 0 0)))
    <|unfolded-io>
      <text|<with|point-style|star|<point|0|0>>>
    </unfolded-io>
  </session>

  \<#6839\>\<#636E\>\<#6E90\>\<#7801\><\footnote>
    <verbatim|TeXmacs/progs/graphics/graphics-drd.scm>
  </footnote>\<#4E2D\>\<#7684\>\<#5B9A\>\<#4E49\>\<#FF0C\>\<#53EF\>\<#4EE5\>\<#603B\>\<#7ED3\>\<#51FA\>\<#FF1A\>

  <big-table|<block*|<tformat|<cwith|1|-1|1|-1|cell-hyphen|c>|<cwith|2|2|2|2|cell-row-span|2>|<cwith|2|2|2|2|cell-col-span|1>|<cwith|8|8|2|2|cell-row-span|2>|<cwith|8|8|2|2|cell-col-span|1>|<cwith|1|-1|1|-1|cell-vcorrect|b>|<table|<row|<\cell>
    \<#5C5E\>\<#6027\>
  </cell>|<\cell>
    \<#503C\>
  </cell>|<\cell>
    \<#4F5C\>\<#7528\>
  </cell>>|<row|<\cell>
    color
  </cell>|<\cell>
    \;

    \<#989C\>\<#8272\>\<#FF0C\>\<#5982\><verbatim|"red">\<#FF0C\><verbatim|"#eeeee">
  </cell>|<\cell>
    \<#5BF9\>\<#8C61\>\<#672C\>\<#8EAB\>\<#7684\>\<#989C\>\<#8272\>
  </cell>>|<row|<\cell>
    fill-color
  </cell>|<\cell>
    \;
  </cell>|<\cell>
    \<#586B\>\<#5145\>\<#8272\>
  </cell>>|<row|<\cell>
    magnify
  </cell>|<\cell>
    \<#6D6E\>\<#70B9\>\<#6570\>\<#FF0C\>\<#5982\><verbatim|"1.1">
  </cell>|<\cell>
    \<#653E\>\<#5927\>\<#6216\>\<#7F29\>\<#5C0F\>\<#7684\>\<#500D\>\<#7387\>
  </cell>>|<row|<\cell>
    opacity
  </cell>|<\cell>
    \<#767E\>\<#5206\>\<#6BD4\>\<#FF0C\>\<#5982\><verbatim|"100%">
  </cell>|<\cell>
    \<#900F\>\<#660E\>\<#5EA6\>
  </cell>>|<row|<\cell>
    point-style
  </cell>|<\cell>
    <verbatim|default,round,square,diamond,triangle,star>
  </cell>|<\cell>
    \<#70B9\>\<#7684\>\<#6837\>\<#5F0F\>
  </cell>>|<row|<\cell>
    dash-style
  </cell>|<\cell>
    <verbatim|"10","11100","1111010">
  </cell>|<\cell>
    \<#7EBF\>\<#7684\>\<#6837\>\<#5F0F\>
  </cell>>|<row|<\cell>
    arrow-begin
  </cell>|<\cell>
    <verbatim|"\<less\>less\<gtr\>","\<less\>less\<gtr\>\|","\<less\>less\<gtr\>\<less\>less\<gtr\>",>

    <verbatim|"\<less\>gtr\<gtr\>","\|\<less\>gtr\<gtr\>","\<less\>gtr\<gtr\>\<less\>gtr\<gtr\>">

    \;
  </cell>|<\cell>
    \<#5F00\>\<#59CB\>\<#5904\>\<#7684\>\<#7BAD\>\<#5934\>
  </cell>>|<row|<\cell>
    arrow-end
  </cell>|<\cell>
    \;
  </cell>|<\cell>
    \<#7ED3\>\<#675F\>\<#5904\>\<#7684\>\<#7BAD\>\<#5934\>
  </cell>>>>>|\<#90E8\>\<#5206\>\<#5BF9\>\<#8C61\>\<#5C5E\>\<#6027\>>

  \<#5149\>\<#770B\>\<#8868\>\<#683C\>\<#4E2D\>\<#7684\>\<#603B\>\<#7ED3\>\<#4E0D\>\<#514D\>\<#5931\>\<#4E4B\>\<#76F4\>\<#89C2\>\<#FF0C\>\<#63A8\>\<#8350\>\<#9605\>\<#8BFB\><menu|help|manual|\<#5185\>\<#7F6E\>\<#4F5C\>\<#56FE\>\<#5DE5\>\<#5177\>>\<#8FD9\>\<#7AE0\>\<#4E2D\>\<#6837\>\<#5F0F\>\<#5C5E\>\<#6027\>\<#8BE6\>\<#8FF0\>\<#8FD9\>\<#4E00\>\<#8282\>\<#3002\>

  \<#4E0B\>\<#9762\>\<#FF0C\>\<#5B9A\>\<#4E49\>\<#4E00\>\<#4E9B\>\<#51FD\>\<#6570\>\<#FF0C\>\<#65B9\>\<#4FBF\>\<#6211\>\<#4EEC\>\<#64CD\>\<#7EB5\>\<#4E0A\>\<#4E00\>\<#8282\>\<#4E2D\>\<#70B9\>\<#3001\>\<#5706\>\<#548C\>\<#77E9\>\<#5F62\>\<#7684\>\<#6837\>\<#5F0F\>\<#3002\>\<#9996\>\<#5148\>\<#662F\>\<#989C\>\<#8272\>\<#FF0C\>\<#6211\>\<#4EEC\>\<#5B9A\>\<#4E49\><verbatim|fill>\<#6765\>\<#8BBE\>\<#7F6E\>\<#80CC\>\<#666F\>\<#8272\>\<#FF0C\>\<#5B9A\>\<#4E49\><verbatim|colorize>\<#6765\>\<#8BBE\>\<#7F6E\>\<#524D\>\<#666F\>\<#8272\>\<#3002\>\<#7C97\>\<#7CD9\>\<#7684\>\<#60F3\>\<#6CD5\>\<#662F\>\<#5728\>\<#56FE\>\<#5F62\>\<#5BF9\>\<#8C61\>\<#524D\>\<#589E\>\<#52A0\><markup|with>\<#6807\>\<#7B7E\>\<#4EE5\>\<#53CA\>\<#76F8\>\<#5E94\>\<#7684\>\<#5C5E\>\<#6027\>\<#FF0C\><em|\<#4F46\>\<#662F\>\<#5982\>\<#679C\>\<#6211\>\<#4EEC\>\<#5BF9\>\<#540C\>\<#4E00\>\<#4E2A\>\<#5BF9\>\<#8C61\>\<#589E\>\<#52A0\>\<#4E86\>\<#8BB8\>\<#591A\>\<#6B21\><markup|with>\<#6807\>\<#7B7E\>\<#4F1A\>\<#600E\>\<#6837\>\<#5462\>\<#FF1F\>>
  \<#8FD9\>\<#4E2A\>\<#95EE\>\<#9898\>\<#53EF\>\<#4EE5\>\<#7528\>\<#51FD\>\<#6570\><verbatim|merge-with>\<#89E3\>\<#51B3\>\<#FF0C\>\<#53E6\>\<#5916\>\<#6211\>\<#4EEC\>\<#5B9A\>\<#4E49\><verbatim|decorate>\<#6765\>\<#8BBE\>\<#7F6E\>\<#4EFB\>\<#610F\>\<#5C5E\>\<#6027\>\<#FF1A\>

  <\session|scheme|default>
    <\input|Scheme] >
      (define (merge-with l par val subs)

      \ \ (cond ((== (length l) 0) '())

      \ \ \ \ \ \ \ \ ((== (length l) 1) (append (list par val) l))

      \ \ \ \ \ \ \ \ ((== par (car l))

      \ \ \ \ \ \ \ \ \ (if subs (set-car! (cdr l) val)) l)

      \ \ \ \ \ \ \ \ (else\ 

      \ \ \ \ \ \ \ \ \ \ (let ((t (list (car l) (cadr l))))

      \ \ \ \ \ \ \ \ \ \ \ \ (append t (merge-with (cddr l) par val
      subs))))))
    </input>

    <\input|Scheme] >
      (define (decorate l par val subs)

      \ \ (cond ((or (nlist? l) (null? l)) '())

      \ \ \ \ \ \ \ \ ((list? (car l))\ 

      \ \ \ \ \ \ \ \ \ (append (list (decorate (car l) par val subs))\ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (decorate (cdr l) par val subs)))

      \ \ \ \ \ \ \ \ ((== (car l) 'with)\ 

      \ \ \ \ \ \ \ \ \ (append '(with) (merge-with (cdr l) par val subs)))

      \ \ \ \ \ \ \ \ ((or (== (car l) 'line) (== (car l) 'cline) (== (car l)
      'carc) (== (car l) 'point) (== (car l) 'graphics))

      \ \ \ \ \ \ \ \ \ (append '(with) (merge-with (list l) par val
      subs)))))
    </input>

    <\input|Scheme] >
      (define (fill fig bc)

      \ \ (decorate fig "fill-color" bc #f))
    </input>

    <\input|Scheme] >
      (define (force-fill fig bc)

      \ \ (decorate fig "fill-color" bc #t))
    </input>

    <\input|Scheme] >
      (define (colorize fig fc)

      \ \ (decorate fig "color" fc #f))
    </input>

    <\input|Scheme] >
      (define (force-colorize fig fc)

      \ \ (decorate fig "color" fc #t))
    </input>

    <\input|Scheme] >
      (define (arrow-begin fig style)

      \ \ (decorate fig "arrow-begin" style #f))
    </input>

    <\input|Scheme] >
      (define (force-arrow-begin fig style)

      \ \ (decorate fig "arrow-begin" style #t))
    </input>

    <\input|Scheme] >
      (define (arrow-end fig style)

      \ \ (decorate fig "arrow-end" style #f))
    </input>

    <\input|Scheme] >
      (define (force-arrow-end fig style)

      \ \ (decorate fig "arrow-end" style #t))
    </input>

    <\input|Scheme] >
      (define (dash-style fig style)

      \ \ (decorate fig "dash-style" style #f))
    </input>

    <\input|Scheme] >
      (define (force-dash-style fig style)

      \ \ (decorate fig "dash-style" style #t))
    </input>

    <\unfolded-io|Scheme] >
      (plot (dash-style (fill (colorize (circle (point 0 0) 1) "blue")
      "green") "1111010"))
    <|unfolded-io>
      <text|<with|color|blue|fill-color|green|dash-style|1111010|<carc|<point|-1|0>|<point|0|1>|<point|1|0>>>>
    </unfolded-io>

    <\unfolded-io|Scheme] >
      (plot (arrow-end (line (point -2 0) (point 0 0) (point 1 1))
      "\|\<less\>gtr\<gtr\>"))
    <|unfolded-io>
      <text|<with|arrow-end|\|\<gtr\>|<line|<point|-2|0>|<point|0|0>|<point|1|1>>>>
    </unfolded-io>
  </session>

  <subsection|\<#6446\>\<#5F04\>\<#753B\>\<#5E03\>>

  \<#524D\>\<#6587\>\<#6240\>\<#4F5C\>\<#4E4B\>\<#56FE\>\<#FF0C\>\<#6211\>\<#4EEC\>\<#90FD\>\<#53EA\>\<#662F\>\<#5C06\>\<#56FE\>\<#5F62\>\<#5BF9\>\<#8C61\>\<#751F\>\<#6210\>\<#51FA\>\<#6765\><TeXmacs>\<#6587\>\<#6863\>\<#6811\>\<#653E\>\<#5728\><scheme>\<#8FDB\>\<#7A0B\>\<#7684\>\<#8F93\>\<#51FA\>\<#4E0A\>\<#FF0C\>\<#6211\>\<#4EEC\>\<#89C2\>\<#5BDF\>\<#5230\>\<#5750\>\<#6807\>\<#7684\>\<#539F\>\<#70B9\>\<#5C31\>\<#5728\>\<#6587\>\<#6863\>\<#6A2A\>\<#622A\>\<#7EBF\>\<#7684\>\<#4E2D\>\<#70B9\>\<#4E0A\>\<#3002\>\<#7528\>\<#5149\>\<#6807\>\<#9009\>\<#4E2D\>\<#8FD9\>\<#4E2A\>\<#56FE\>\<#6848\>\<#FF0C\>\<#53EF\>\<#4EE5\>\<#770B\>\<#5230\>\<#5DE6\>\<#8FB9\>\<#7684\>\<#4E00\>\<#5927\>\<#622A\>\<#7A7A\>\<#767D\>\<#3002\>\<#5728\>\<#4E0A\>\<#4E00\>\<#8282\>\<#4F5C\>\<#51FA\>\<#7684\>\<#7BAD\>\<#5934\>\<#56FE\>\<#6848\>\<#524D\>\<#8F93\>\<#5165\>\<#4E86\>\<#5355\>\<#8BCD\>left\<#540E\>\<#FF0C\>\<#4F60\>\<#53EF\>\<#4EE5\>\<#6E05\>\<#6670\>\<#5730\>\<#770B\>\<#5230\>\<#8FD9\>\<#4E9B\>\<#7A7A\>\<#767D\>\<#3002\>

  left<with|arrow-end|\|\<gtr\>|<line|<point|-2|0>|<point|0|0>|<point|1|1>>>

  \<#7531\>\<#6B64\>\<#53EF\>\<#4EE5\>\<#77E5\>\<#9053\>\<#FF0C\>\<#5728\>\<#6CA1\>\<#6709\>\<#753B\>\<#5E03\>\<#7684\>\<#60C5\>\<#51B5\>\<#4E0B\>\<#FF0C\><TeXmacs>\<#4F1A\>\<#5206\>\<#914D\>\<#4E00\>\<#4E2A\>\<#52A8\>\<#6001\>\<#5927\>\<#5C0F\>\<#7684\>\<#753B\>\<#5E03\>\<#FF0C\>\<#4EE5\>\<#9002\>\<#5E94\>\<#56FE\>\<#5F62\>\<#7684\>\<#5C3A\>\<#5BF8\>\<#3002\>

  \<#524D\>\<#6587\>\<#4E2D\>\<#7684\>\<#56FE\>\<#50CF\>\<#90FD\>\<#53EA\>\<#662F\>\<#5355\>\<#4E2A\>\<#56FE\>\<#5F62\>\<#5BF9\>\<#8C61\>\<#5728\>\<#9ED8\>\<#8BA4\>\<#753B\>\<#5E03\>\<#4E0A\>\<#7684\>\<#663E\>\<#793A\>\<#3002\>\<#5F15\>\<#5165\>\<#753B\>\<#5E03\>\<#4E4B\>\<#540E\>\<#FF0C\>\<#6211\>\<#4EEC\>\<#5C31\>\<#53EF\>\<#4EE5\>\<#5C06\>\<#591A\>\<#4E2A\>\<#56FE\>\<#5F62\>\<#5BF9\>\<#8C61\>\<#53E0\>\<#52A0\>\<#5728\>\<#540C\>\<#4E00\>\<#4E2A\>\<#753B\>\<#5E03\>\<#4E0A\>\<#3002\>\<#901A\>\<#8FC7\>\<#9006\>\<#5411\>\<#5DE5\>\<#7A0B\><\footnote>
    \<#65B9\>\<#6CD5\>\<#8BF7\>\<#53C2\>\<#8003\>\<#9644\>\<#5F55\>\<#4E2D\>\<#7684\>\<#5C0F\>\<#8D34\>\<#58EB\>
  </footnote>\<#FF0C\>\<#53EF\>\<#4EE5\>\<#4E3E\>\<#51FA\>\<#8FD9\>\<#4E2A\>\<#4F8B\>\<#5B50\>\<#FF1A\>

  <\session|scheme|default>
    <\input|Scheme] >
      (define (graphics . objects)

      \ \ (cond ((nlist? objects) '(graphics "" ""))

      \ \ \ \ \ \ \ \ ((== objects '()) '(graphics "" ""))

      \ \ \ \ \ \ \ \ (else `(graphics "" ,@objects))))
    </input>

    <\input|Scheme] >
      (define (geometry fig x y)

      \ \ (decorate fig "gr-geometry" `(tuple "geometry" ,x ,y "center") #f))
    </input>

    <\unfolded-io|Scheme] >
      (plot (geometry (graphics\ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (fill (rectangle (point -2 -1) (point
      1 1)) "blue")

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (fill (rectangle (point -1 -1) (point
      2 1)) "red")

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (dash-style (line (point 1 -1) (point
      1 1)) "11100"))

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "5cm" "3cm"))
    <|unfolded-io>
      <text|<with|gr-geometry|<tuple|geometry|5cm|3cm|center>|<graphics||<with|fill-color|blue|<cline|<point|-2|-1>|<point|-2|1>|<point|1|1>|<point|1|-1>>>|<with|fill-color|red|<cline|<point|-1|-1>|<point|-1|1>|<point|2|1>|<point|2|-1>>>|<with|dash-style|11100|<line|<point|1|-1>|<point|1|1>>>>>>
    </unfolded-io>
  </session>

  \<#73B0\>\<#5728\>\<#6211\>\<#4EEC\>\<#5C31\>\<#80FD\>\<#591F\>\<#7528\>\<#51FD\>\<#6570\><verbatim|graphics>\<#FF0C\>\<#5C06\>\<#591A\>\<#4E2A\>\<#56FE\>\<#5F62\>\<#5BF9\>\<#8C61\>\<#53E0\>\<#52A0\>\<#5728\>\<#540C\>\<#4E00\>\<#4E2A\>\<#753B\>\<#5E03\>\<#4E0A\>\<#FF0C\>\<#800C\>\<#4E14\>\<#FF0C\>\<#56FE\>\<#5F62\>\<#5BF9\>\<#8C61\>\<#7684\>\<#987A\>\<#5E8F\>\<#51B3\>\<#5B9A\>\<#4E86\>\<#6E32\>\<#67D3\>\<#7684\>\<#987A\>\<#5E8F\>\<#FF0C\>\<#540E\>\<#8005\>\<#4F1A\>\<#8986\>\<#76D6\>\<#524D\>\<#8005\>\<#3002\>\<#5982\>\<#4E0A\>\<#56FE\>\<#6240\>\<#793A\>\<#FF0C\>\<#865A\>\<#7EBF\>\<#8868\>\<#793A\>\<#539F\>\<#6765\>\<#84DD\>\<#8272\>\<#77E9\>\<#5F62\>\<#7684\>\<#53F3\>\<#8FB9\>\<#754C\>\<#FF0C\>\<#73B0\>\<#5728\>\<#88AB\>\<#7EA2\>\<#8272\>\<#77E9\>\<#5F62\>\<#8986\>\<#76D6\>\<#4E86\>\<#3002\>

  \<#800C\><verbatim|geometry>\<#51FD\>\<#6570\>\<#53EF\>\<#4EE5\>\<#63A7\>\<#5236\>\<#753B\>\<#5E03\>\<#7684\>\<#5927\>\<#5C0F\>\<#3002\>\<#6CE8\>\<#610F\>\<#FF0C\>\<#524D\>\<#6587\>\<#4E2D\>\<#90FD\>\<#6CA1\>\<#6709\>\<#8BA8\>\<#8BBA\>\<#957F\>\<#5EA6\>\<#5355\>\<#4F4D\>\<#8FD9\>\<#4E00\>\<#56E0\>\<#7D20\>\<#3002\>\<#4F46\>\<#5B9E\>\<#9645\>\<#4E0A\>\<#524D\>\<#6587\>\<#4E2D\>\<#6240\>\<#6709\>\<#7684\>\<#5750\>\<#6807\>\<#7684\>\<#5355\>\<#4F4D\>\<#90FD\>\<#662F\><verbatim|cm>\<#3002\>\<#6240\>\<#4EE5\>\<#5728\>\<#6307\>\<#5B9A\>\<#753B\>\<#5E03\>\<#7684\>\<#5BBD\>\<#5EA6\>\<#548C\>\<#9AD8\>\<#5EA6\>\<#7684\>\<#65F6\>\<#5019\>\<#FF0C\>\<#6211\>\<#4EEC\>\<#9700\>\<#8981\>\<#52A0\>\<#4E0A\><verbatim|cm>\<#8FD9\>\<#4E2A\>\<#5355\>\<#4F4D\>\<#FF0C\>\<#56E0\>\<#4E3A\>\<#8FD9\>\<#91CC\>\<#7684\>\<#9ED8\>\<#8BA4\>\<#5355\>\<#4F4D\>\<#4E0D\>\<#662F\><verbatim|cm>\<#3002\>

  \<#53E6\>\<#5916\>\<#FF0C\>\<#6211\>\<#4EEC\>\<#8FD8\>\<#53EF\>\<#4EE5\>\<#526A\>\<#88C1\>\<#753B\>\<#5E03\>\<#FF0C\>\<#5C3D\>\<#53EF\>\<#80FD\>\<#51CF\>\<#5C11\>\<#753B\>\<#5E03\>\<#5468\>\<#56F4\>\<#7684\>\<#7A7A\>\<#767D\>\<#3002\>

  <\session|scheme|default>
    <\input|Scheme] >
      (define (crop fig)

      \ \ (decorate fig "gr-auto-crop" "true" #f))
    </input>

    <\unfolded-io|Scheme] >
      (plot (crop (graphics\ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (fill (rectangle (point -2 -1) (point
      1 1)) "blue")

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (fill (rectangle (point -1 -1) (point
      2 1)) "red")

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (dash-style (line (point 1 -1) (point
      1 1)) "11100"))))
    <|unfolded-io>
      <text|<with|gr-auto-crop|true|<graphics||<with|fill-color|blue|<cline|<point|-2|-1>|<point|-2|1>|<point|1|1>|<point|1|-1>>>|<with|fill-color|red|<cline|<point|-1|-1>|<point|-1|1>|<point|2|1>|<point|2|-1>>>|<with|dash-style|11100|<line|<point|1|-1>|<point|1|1>>>>>>
    </unfolded-io>
  </session>

  \<#9009\>\<#4E2D\>\<#6700\>\<#8FD1\>\<#7684\>\<#8FD9\>\<#4E24\>\<#4E2A\>\<#4E00\>\<#6837\>\<#7684\>\<#56FE\>\<#50CF\>\<#FF0C\>\<#4F60\>\<#5C31\>\<#53EF\>\<#4EE5\>\<#770B\>\<#5230\>\<#533A\>\<#522B\>\<#3002\>

  <section|\<#753B\>\<#5ECA\>>

  \<#8FD9\>\<#4E00\>\<#7AE0\>\<#4E3B\>\<#8981\>\<#5229\>\<#7528\>\<#524D\>\<#6587\>\<#5B9A\>\<#4E49\>\<#597D\>\<#7684\>\<#51FD\>\<#6570\>\<#FF0C\>\<#7ED8\>\<#5236\>\<#5404\>\<#79CD\>\<#5404\>\<#6837\>\<#6709\>\<#8DA3\>\<#7684\>\<#56FE\>\<#6848\>\<#3002\>

  <subsection|\<#91D1\>\<#521A\>\<#77F3\>\<#56FE\>\<#6848\>>

  \<#5C06\>\<#534A\>\<#5F84\>\<#4E3A\>R\<#7684\>\<#5706\>\<#5468\>n\<#7B49\>\<#5206\>\<#FF0C\>\<#7136\>\<#540E\>\<#7528\>\<#76F4\>\<#7EBF\>\<#5C06\>\<#5404\>\<#4E2A\>\<#7B49\>\<#5206\>\<#70B9\>\<#4E24\>\<#4E24\>\<#76F8\>\<#8FDE\>\<#3002\>

  <subsection|\<#5706\>\<#73AF\>\<#56FE\>\<#6848\>>

  \<#5C06\>\<#534A\>\<#5F84\>\<#4E3A\><math|R<rsub|1>>\<#7684\>\<#5706\>\<#5468\>n\<#7B49\>\<#5206\>\<#FF0C\>\<#7136\>\<#540E\>\<#4EE5\>\<#6BCF\>\<#4E2A\>\<#7B49\>\<#5206\>\<#70B9\>\<#4E3A\>\<#5706\>\<#5FC3\>\<#FF0C\>\<#4EE5\><math|R<rsub|2>>\<#4E3A\>\<#534A\>\<#5F84\>\<#753B\>n\<#4E2A\>\<#5706\>\<#3002\>

  <subsection|\<#80BE\>\<#5F62\>\<#56FE\>\<#6848\>>

  <subsection|\<#5FC3\>\<#810F\>\<#5F62\>\<#56FE\>\<#6848\>>

  <subsection|\<#5206\>\<#5F62\>\<#56FE\>\<#6848\>>

  <subsubsection|\<#6811\>>

  <subsubsection|Koch snowflake<\footnote>
    <href|https://en.wikipedia.org/wiki/Koch_snowflake>
  </footnote>>

  <subsubsection|Sierpinski carpet<\footnote>
    <href|https://en.wikipedia.org/wiki/Sierpinski_carpet>
  </footnote> and triangle<\footnote>
    <href|https://en.wikipedia.org/wiki/Sierpinski_triangle>
  </footnote>>

  <subsubsection|Mandelbrot set<\footnote>
    <href|https://en.wikipedia.org/wiki/Mandelbrot_set>
  </footnote>>

  <section|\<#9644\>\<#5F55\>>

  <subsection|\<#5C0F\>\<#8D34\>\<#58EB\>>

  <subsubsection|\<#5BF9\>\<#672C\>\<#6587\>\<#6240\>\<#6709\>\<#7684\><scheme>\<#8868\>\<#8FBE\>\<#5F0F\>\<#6C42\>\<#503C\>>

  \<#5F53\>\<#4F60\>\<#521A\>\<#521A\>\<#7528\>\<#7F16\>\<#8F91\>\<#5668\>\<#6253\>\<#5F00\>\<#672C\>\<#6587\>\<#65F6\>\<#FF0C\>\<#5982\>\<#679C\>\<#4F60\>\<#8DF3\>\<#5230\>\<#4E2D\>\<#95F4\>\<#7684\>\<#67D0\>\<#8282\>\<#53BB\>\<#6267\>\<#884C\>\<#4EE3\>\<#7801\>\<#FF0C\>\<#5F88\>\<#6709\>\<#53EF\>\<#80FD\>\<#4F1A\>\<#51FA\>\<#9519\>\<#FF0C\>\<#56E0\>\<#4E3A\>\<#5F53\>\<#524D\>\<#7684\>\<#4EE3\>\<#7801\>\<#5F88\>\<#6709\>\<#53EF\>\<#80FD\>\<#4F9D\>\<#8D56\>\<#4E0A\>\<#524D\>\<#6587\>\<#4E2D\>\<#5DF2\>\<#7ECF\>\<#51FA\>\<#73B0\>\<#8FC7\>\<#7684\>\<#51FD\>\<#6570\>\<#548C\>\<#53D8\>\<#91CF\>\<#3002\>\<#800C\>\<#5C06\>\<#524D\>\<#6587\>\<#4E2D\>\<#6240\>\<#6709\>\<#7684\>\<#4EE3\>\<#7801\>\<#90FD\>\<#6267\>\<#884C\>\<#4E00\>\<#904D\>\<#8FD9\>\<#4E2A\>\<#64CD\>\<#4F5C\>\<#5B9E\>\<#9645\>\<#4E0A\>\<#975E\>\<#5E38\>\<#7E41\>\<#7410\>\<#3002\>\<#542F\>\<#7528\><menu|\<#5DE5\>\<#5177\>|\<#5F00\>\<#53D1\>\<#83DC\>\<#5355\>>\<#FF0C\>\<#5C06\>\<#5149\>\<#6807\>\<#7F6E\>\<#4E8E\>\<#672C\>\<#6587\>\<#7684\>\<#67D0\>\<#4E2A\><scheme>\<#8FDB\>\<#7A0B\>\<#4E2D\>\<#FF0C\>\<#7136\>\<#540E\><menu|Developer|Export
  Sessions...>\<#5C31\>\<#53EF\>\<#4EE5\>\<#5BFC\>\<#51FA\>\<#6240\>\<#6709\>\<#7684\>\<#4EE3\>\<#7801\>\<#5230\>\<#5355\>\<#4E2A\>\<#6587\>\<#4EF6\><verbatim|code.scm>\<#4E2D\>\<#3002\>\<#7136\>\<#540E\><menu|\<#8F6C\>\<#5230\>|\<#65E0\>\<#6807\>\<#9898\>\<#6587\>\<#4EF6\>>\<#FF0C\>\<#5F00\>\<#542F\>\<#4E00\>\<#4E2A\><scheme>\<#8FDB\>\<#7A0B\>\<#5E76\>\<#8F93\>\<#5165\><scm|(load
  "/path/to/code.scm")>\<#FF0C\>\<#56DE\>\<#8F66\>\<#4E4B\>\<#540E\>\<#FF0C\>\<#6587\>\<#4E2D\>\<#6240\>\<#6709\>\<#7684\>\<#4EE3\>\<#7801\>\<#5C31\>\<#90FD\>\<#88AB\>\<#52A0\>\<#8F7D\>\<#4E86\>\<#3002\>

  <subsubsection|\<#9006\>\<#5411\>\<#5DE5\>\<#7A0B\>>

  <subsection|\<#53C2\>\<#8003\>\<#8D44\>\<#6599\>>

  <\itemize>
    <item>A TeXmacs graphics tutorial<\footnote>
      <href|http://texmacs.org/tmweb/documents/tutorials/TeXmacs-graphics-tutorial.pdf>
    </footnote>, by Henri Lesourd.

    <item>Turtle schemes<\footnote>
      <href|http://www.texmacs.org/tmweb/miguel/snippet-logo.en.html>
    </footnote>, by Ana Cañizares García and Miguel de Benito Delgado

    <item>Fractal turtles<\footnote>
      <href|http://www.texmacs.org/tmweb/miguel/snippet-fractal-1.en.html>
    </footnote>, by Ana Cañizares García and Miguel de Benito Delgado
  </itemize>

  \;
</body>

<\initial>
  <\collection>
    <associate|src-style|scheme>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|auto-1|<tuple|1|3>>
    <associate|auto-10|<tuple|3|7>>
    <associate|auto-11|<tuple|3.1|7>>
    <associate|auto-12|<tuple|3.2|7>>
    <associate|auto-13|<tuple|3.3|7>>
    <associate|auto-14|<tuple|3.4|7>>
    <associate|auto-15|<tuple|3.5|7>>
    <associate|auto-16|<tuple|3.5.1|7>>
    <associate|auto-17|<tuple|3.5.2|7>>
    <associate|auto-18|<tuple|3.5.3|?>>
    <associate|auto-19|<tuple|3.5.4|?>>
    <associate|auto-2|<tuple|2|3>>
    <associate|auto-20|<tuple|4|?>>
    <associate|auto-21|<tuple|4.1|?>>
    <associate|auto-22|<tuple|4.1.1|?>>
    <associate|auto-23|<tuple|4.1.1|?>>
    <associate|auto-24|<tuple|4.1.1|?>>
    <associate|auto-25|<tuple|4.1.1|?>>
    <associate|auto-26|<tuple|4.1.2|?>>
    <associate|auto-27|<tuple|4.2|?>>
    <associate|auto-3|<tuple|2|3>>
    <associate|auto-4|<tuple|2.1|3>>
    <associate|auto-5|<tuple|1|3>>
    <associate|auto-6|<tuple|2.2|4>>
    <associate|auto-7|<tuple|2|5>>
    <associate|auto-8|<tuple|2|5>>
    <associate|auto-9|<tuple|2.3|6>>
    <associate|footnote-1|<tuple|1|3>>
    <associate|footnote-10|<tuple|10|?>>
    <associate|footnote-11|<tuple|11|?>>
    <associate|footnote-12|<tuple|12|?>>
    <associate|footnote-13|<tuple|13|?>>
    <associate|footnote-14|<tuple|14|?>>
    <associate|footnote-15|<tuple|15|?>>
    <associate|footnote-16|<tuple|16|?>>
    <associate|footnote-17|<tuple|17|?>>
    <associate|footnote-18|<tuple|18|?>>
    <associate|footnote-19|<tuple|19|?>>
    <associate|footnote-2|<tuple|2|3>>
    <associate|footnote-20|<tuple|20|?>>
    <associate|footnote-21|<tuple|21|?>>
    <associate|footnote-3|<tuple|3|3>>
    <associate|footnote-4|<tuple|4|4>>
    <associate|footnote-5|<tuple|5|5>>
    <associate|footnote-6|<tuple|6|6>>
    <associate|footnote-7|<tuple|7|7>>
    <associate|footnote-8|<tuple|8|7>>
    <associate|footnote-9|<tuple|9|7>>
    <associate|footnr-1|<tuple|1|3>>
    <associate|footnr-14|<tuple|14|?>>
    <associate|footnr-15|<tuple|15|?>>
    <associate|footnr-18|<tuple|18|?>>
    <associate|footnr-19|<tuple|19|?>>
    <associate|footnr-2|<tuple|2|3>>
    <associate|footnr-20|<tuple|20|?>>
    <associate|footnr-21|<tuple|21|?>>
    <associate|footnr-3|<tuple|3|3>>
    <associate|footnr-4|<tuple|4|4>>
    <associate|footnr-5|<tuple|5|5>>
    <associate|footnr-6|<tuple|6|6>>
    <associate|footnr-9|<tuple|9|7>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|idx>
      <tuple|<tuple|<with|font-family|<quote|ss>|\<#63D2\>\<#5165\>>|<with|font-family|<quote|ss>|\<#8FDB\>\<#7A0B\>>|<with|font-family|<quote|ss>|Scheme>>|<pageref|auto-3>>

      <tuple|<tuple|<with|font-family|<quote|ss>|\<#5E2E\>\<#52A9\>>|<with|font-family|<quote|ss>|\<#7528\>\<#6237\>\<#624B\>\<#518C\>>|<with|font-family|<quote|ss>|\<#5185\>\<#7F6E\>\<#4F5C\>\<#56FE\>\<#5DE5\>\<#5177\>>>|<pageref|auto-8>>

      <tuple|<tuple|<with|font-family|<quote|ss>|\<#5DE5\>\<#5177\>>|<with|font-family|<quote|ss>|\<#5F00\>\<#53D1\>\<#83DC\>\<#5355\>>>|<pageref|auto-23>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Developer>|<with|font-family|<quote|ss>|Export
      Sessions...>>|<pageref|auto-24>>

      <tuple|<tuple|<with|font-family|<quote|ss>|\<#8F6C\>\<#5230\>>|<with|font-family|<quote|ss>|\<#65E0\>\<#6807\>\<#9898\>\<#6587\>\<#4EF6\>>>|<pageref|auto-25>>
    </associate>
    <\associate|table>
      <tuple|normal|<\surround|<hidden|<tuple>>|>
        \;
      </surround>|<pageref|auto-5>>

      <tuple|normal|<surround|<hidden|<tuple>>||\<#90E8\>\<#5206\>\<#5BF9\>\<#8C61\>\<#5C5E\>\<#6027\>>|<pageref|auto-7>>
    </associate>
    <\associate|toc>
      1<space|2spc>\<#7B80\>\<#4ECB\> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1>

      2<space|2spc>\<#57FA\>\<#672C\>\<#539F\>\<#7406\>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2>

      <with|par-left|<quote|1tab>|2.1<space|2spc>\<#539F\>\<#8BED\>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4>>

      <with|par-left|<quote|1tab>|2.2<space|2spc>\<#64CD\>\<#7EB5\>\<#6837\>\<#5F0F\>\<#5C5E\>\<#6027\>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6>>

      <with|par-left|<quote|1tab>|2.3<space|2spc>\<#6446\>\<#5F04\>\<#753B\>\<#5E03\>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-9>>

      3<space|2spc>\<#753B\>\<#5ECA\> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-10>

      <with|par-left|<quote|1tab>|3.1<space|2spc>\<#91D1\>\<#521A\>\<#77F3\>\<#56FE\>\<#6848\>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-11>>

      <with|par-left|<quote|1tab>|3.2<space|2spc>\<#5706\>\<#73AF\>\<#56FE\>\<#6848\>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-12>>

      <with|par-left|<quote|1tab>|3.3<space|2spc>\<#80BE\>\<#5F62\>\<#56FE\>\<#6848\>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-13>>

      <with|par-left|<quote|1tab>|3.4<space|2spc>\<#5FC3\>\<#810F\>\<#5F62\>\<#56FE\>\<#6848\>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-14>>

      <with|par-left|<quote|1tab>|3.5<space|2spc>\<#5206\>\<#5F62\>\<#56FE\>\<#6848\>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-15>>

      <with|par-left|<quote|2tab>|3.5.1<space|2spc>\<#6811\>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-16>>

      <with|par-left|<quote|2tab>|3.5.2<space|2spc>Koch
      snowflake<assign|footnote-nr|7><hidden|<tuple>><\float|footnote|>
        <with|font-size|<quote|0.771>|<with|par-mode|<quote|justify>|par-left|<quote|0cm>|par-right|<quote|0cm>|font-shape|<quote|right>|dummy|<quote|1.0fn>|dummy|<quote|7.5fn>|<\surround|<locus|<id|%35EE6338-36566658>|<link|hyperlink|<id|%35EE6338-36566658>|<url|#footnr-7>>|7>.
        |<hidden|<tuple|footnote-7>><htab|0fn|first>>
          <locus|<id|%35EE6338-365665C8>|<link|hyperlink|<id|%35EE6338-365665C8>|<url|https://en.wikipedia.org/wiki/Koch_snowflake>>|<with|font-family|<quote|tt>|language|<quote|verbatim>|https://en.wikipedia.org/wiki/Koch_snowflake>>
        </surround>>>
      </float><space|0spc><rsup|<with|font-shape|<quote|right>|<reference|footnote-7>>>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-17>>

      <with|par-left|<quote|2tab>|3.5.3<space|2spc>Sierpinski
      carpet<assign|footnote-nr|10><hidden|<tuple>><\float|footnote|>
        <with|font-size|<quote|0.771>|<with|par-mode|<quote|justify>|par-left|<quote|0cm>|par-right|<quote|0cm>|font-shape|<quote|right>|dummy|<quote|1.0fn>|dummy|<quote|7.5fn>|<\surround|<locus|<id|%35EE6338-36456C50>|<link|hyperlink|<id|%35EE6338-36456C50>|<url|#footnr-10>>|10>.
        |<hidden|<tuple|footnote-10>><htab|0fn|first>>
          <locus|<id|%35EE6338-36545368>|<link|hyperlink|<id|%35EE6338-36545368>|<url|https://en.wikipedia.org/wiki/Sierpinski_carpet>>|<with|font-family|<quote|tt>|language|<quote|verbatim>|https://en.wikipedia.org/wiki/Sierpinski_carpet>>
        </surround>>>
      </float><space|0spc><rsup|<with|font-shape|<quote|right>|<reference|footnote-10>>>
      and triangle<assign|footnote-nr|11><hidden|<tuple>><\float|footnote|>
        <with|font-size|<quote|0.771>|<with|par-mode|<quote|justify>|par-left|<quote|0cm>|par-right|<quote|0cm>|font-shape|<quote|right>|dummy|<quote|1.0fn>|dummy|<quote|7.5fn>|<\surround|<locus|<id|%35EE6338-36559FB0>|<link|hyperlink|<id|%35EE6338-36559FB0>|<url|#footnr-11>>|11>.
        |<hidden|<tuple|footnote-11>><htab|0fn|first>>
          <locus|<id|%35EE6338-36568EB8>|<link|hyperlink|<id|%35EE6338-36568EB8>|<url|https://en.wikipedia.org/wiki/Sierpinski_triangle>>|<with|font-family|<quote|tt>|language|<quote|verbatim>|https://en.wikipedia.org/wiki/Sierpinski_triangle>>
        </surround>>>
      </float><space|0spc><rsup|<with|font-shape|<quote|right>|<reference|footnote-11>>>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-18>>

      <with|par-left|<quote|2tab>|3.5.4<space|2spc>Mandelbrot
      set<assign|footnote-nr|16><hidden|<tuple>><\float|footnote|>
        <with|font-size|<quote|0.771>|<with|par-mode|<quote|justify>|par-left|<quote|0cm>|par-right|<quote|0cm>|font-shape|<quote|right>|dummy|<quote|1.0fn>|dummy|<quote|7.5fn>|<\surround|<locus|<id|%35EE6338-36568CB0>|<link|hyperlink|<id|%35EE6338-36568CB0>|<url|#footnr-16>>|16>.
        |<hidden|<tuple|footnote-16>><htab|0fn|first>>
          <locus|<id|%35EE6338-36569160>|<link|hyperlink|<id|%35EE6338-36569160>|<url|https://en.wikipedia.org/wiki/Mandelbrot_set>>|<with|font-family|<quote|tt>|language|<quote|verbatim>|https://en.wikipedia.org/wiki/Mandelbrot_set>>
        </surround>>>
      </float><space|0spc><rsup|<with|font-shape|<quote|right>|<reference|footnote-16>>>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-19>>

      4<space|2spc>\<#9644\>\<#5F55\> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-20>

      <with|par-left|<quote|1tab>|4.1<space|2spc>\<#5C0F\>\<#8D34\>\<#58EB\>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-21>>

      <with|par-left|<quote|2tab>|4.1.1<space|2spc>\<#5BF9\>\<#672C\>\<#6587\>\<#6240\>\<#6709\>\<#7684\><with|font-shape|<quote|small-caps>|Scheme>\<#8868\>\<#8FBE\>\<#5F0F\>\<#6C42\>\<#503C\>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-22>>

      <with|par-left|<quote|2tab>|4.1.2<space|2spc>\<#9006\>\<#5411\>\<#5DE5\>\<#7A0B\>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-26>>

      <with|par-left|<quote|1tab>|4.2<space|2spc>\<#53C2\>\<#8003\>\<#8D44\>\<#6599\>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-27>>
    </associate>
  </collection>
</auxiliary>