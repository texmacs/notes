<TeXmacs|1.99.14>

<style|notes>

<\body>
  <\hide-preamble>
    \;
  </hide-preamble>

  <hlink|[index]|./index.tm>

  <section*|Implementing previews for link targets>

  [last revision: 2020.11.9]

  Let us see how Joris implemented a preview for link target in
  <hlink|r13081|https://svn.savannah.gnu.org/viewvc/texmacs?view=revision&revision=13081>.
  This requires adding new functionatilities at several levels.

  Preview have to be shown in a popup balloon as soon as the user hovers the
  associate reference locus with the mouse. So we need to modify the
  <markup|reference> and <markup|pageref> tags. There are \Pprimitive\Q tags
  defined in the <name|C++> source <code*|src/Typeset/Env/env_default.cpp>
  with

  <\cpp-code>
    tree ln3 (LINK, "hyperlink", copy (ref_id), copy (dest_ref));

    \;

    env ("reference") = tree (MACRO, "Id",\ 

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ tree
    (LOCUS, copy (ref_id),\ 

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ln3,
    reftxt));

    \;

    env ("pageref") = tree (MACRO, "Id",\ 

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ tree
    (LOCUS, copy (ref_id),\ 

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ copy
    (ln3), preftxt));
  </cpp-code>

  A new package at <code*|packages/utilities/preview-ref.ts> containing a
  redefinition of the <markup|reference> and <markup|pageref> tags:

  <\tm-fragment>
    <\inactive*>
      <use-module|(link ref-edit)>

      \;

      <assign|reference|<macro|Id|<locus|<id|<hard-id|<arg|Id>>>|<link|hyperlink|<id|<hard-id|<arg|Id>>>|<url|<merge|#|<arg|Id>>>>|<link|mouse-over|<id|<hard-id|<arg|Id>>>|<script|preview-reference|<quote-arg|Id>|<arg|Id>>>|<get-binding|<arg|Id>>>>>

      \;

      <assign|pageref|<macro|Id|<locus|<id|<hard-id|<arg|Id>>>|<link|hyperlink|<id|<hard-id|<arg|Id>>>|<url|<merge|#|<arg|Id>>>>|<link|mouse-over|<id|<hard-id|<arg|Id>>>|<script|preview-reference|<quote-arg|Id>|<arg|Id>>>|<get-binding|<arg|Id>|1>>>>
    </inactive*>
  </tm-fragment>

  Note the use of the <markup|use-module> tag to indicate that the <scheme>
  module <scm|(link ref-edit)> must be made available to <TeXmacs> beforehand
  in order to be able to call the <scheme> procedure <scm|preview-reference>.
  The module <scm|(link ref-edit)>, defined in the <scheme> source
  <code*|/progs/link/ref-edit.scm>, being with

  <\scm-code>
    (texmacs-module (link ref-edit)

    \ \ (:use (generic generic-edit)

    \ \ \ \ \ \ \ \ (generic document-part)

    \ \ \ \ \ \ \ \ (text text-drd)))
  </scm-code>

  and contains the definition of <scm|preview-reference> as a <scm|tm-define>
  (i.e. a global symbol visible in all the program). Note the <scm|(:secure
  #t)> which indicates to <TeXmacs> that this producedure does not perform
  any <with|font-shape|italic|dangerous> operation and therefore can be
  called without notifying the user.

  <\scm-code>
    <\code>
      (tm-define (preview-reference body body*)

      \ \ (:secure #t)

      \ \ (and-with ref (tree-up body)

      \ \ \ \ (with (x1 y1 x2 y2) (tree-bounding-rectangle ref)

      \ \ \ \ \ \ (and-let* ((packs (get-style-list))

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (pre (document-get-preamble
      (buffer-tree)))

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (id (and (tree-atomic? body*)\ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (tree-\<gtr\>string
      body*)))

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (balloon (ref-preview id))

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (zf (get-window-zoom-factor))

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (sf (/ 4.0 zf))

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (mag (number-\<gtr\>string (/ zf
      1.5)))

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (balloon* `(with "magnification" ,mag
      ,balloon))

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (w (widget-texmacs-output

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ `(surround (hide-preamble
      ,pre) "" ,balloon*)

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ `(style (tuple ,@packs)))))

      \ \ \ \ \ \ \ \ (show-balloon w x1 (- y1 1280))))))
    </code>
  </scm-code>

  This procedure invoke <scm|show-balloon> to display a popup to the user
  which contains a widget to output <TeXmacs> documents (built via
  <scm|widget-texmacs-output>) after suitably scaling it via a
  <markup|magnification> tag. The content itself is produced by the procedure
  <scm|ref-preview> :

  <\scm-code>
    <\code>
      (tm-define (ref-preview id)

      \ \ (and-with l (and-nnull? (search-label (buffer-tree) id))

      \ \ \ \ (label-preview (car l))))
    </code>
  </scm-code>

  which in turn calls the helper procedure <scm|label-preview> (internal to
  the module):

  <\scm-code>
    <\code>
      (define (label-preview t)

      \ \ (and-with doc (tree-search-upwards t preview-context?)

      \ \ \ \ (with math? (tree-search-upwards t math-context?)

      \ \ \ \ \ \ (when (and (tree-up doc) (tree-up (tree-up doc))

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (tree-is? (tree-up doc) 'document)

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (preview-expand-context? (tree-up
      (tree-up doc))))

      \ \ \ \ \ \ \ \ (set! doc (tree-up doc)))

      \ \ \ \ \ \ (when (tm-is? doc 'row)

      \ \ \ \ \ \ \ \ (set! doc (apply tmconcat (map uncell (tm-children
      doc)))))

      \ \ \ \ \ \ (set! doc (clean-preview doc))

      \ \ \ \ \ \ (when math?

      \ \ \ \ \ \ \ \ (set! doc `(with ``math-display'' ``true'' (math
      ,doc))))

      \ \ \ \ \ \ `(preview-balloon ,doc))))
    </code>
  </scm-code>

  The construction of the preview content is performed by the snippet
  <scm|`(preview-balloon ,doc)> which evaluates to a <TeXmacs> s-tree
  containing a singe <markup|preview-balloon> tag for the rendering of the
  preview. This is defined at the macro language level in
  <code*|packages/standard/std-fold.ts> as

  <\tm-fragment>
    <inactive*|<assign|preview-balloon|<macro|body|<tabular|<tformat|<cwith|1|1|1|1|cell-hyphen|t>|<cwith|1|1|1|1|cell-background|#edc>|<twith|table-width|40em>|<twith|table-hmode|min>|<table|<row|<\cell>
      <arg|body>
    </cell>>>>>>>>
  </tm-fragment>

  This markup provides a custom style \ and background color for the preview
  area, including a minimum width.\ 

  The <src-arg|body> argument is feed with a meaningful snippet of the source
  of the link. This is determined by the <scm|label-preview> procedure by
  navigating the document tree from the source position (as indicated by the
  <scm|t> parameter) towards higher levels of the structure hierarchy via
  <scm|(tree-search-upwards t preview-context?)>. The predicate
  <scm|preview-context?> looks for meaningful context: a row of a table or a
  leaf of a <markup|document> tag:

  <\scm-code>
    <\code>
      (define (preview-context? t)

      \ \ (or (tree-is? t 'row)

      \ \ \ \ \ \ (and (tree-up t) (tree-is? (tree-up t) 'document))))
    </code>
  </scm-code>

  We want also to include some major markup in the preview, e.g. theorems,
  etc<text-dots>

  <\scm-code>
    (define (preview-expand-context? t)

    \ \ (tree-in? t '(theorem proposition lemma corollary conjecture

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ theorem* proposition* lemma* corollary*
    conjecture*

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ definition axiom

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ definition* axiom*)))
  </scm-code>

  The procedure <scm|clean-preview> preforms some recursive cleaning on the
  source snippet:

  <\scm-code>
    <\code>
      (define (clean-preview t)

      \ \ (cond ((tm-is? t 'document)

      \ \ \ \ \ \ \ \ \ `(document ,@(map clean-preview (tm-children t))))

      \ \ \ \ \ \ \ \ ((tm-is? t 'concat)

      \ \ \ \ \ \ \ \ \ (apply tmconcat (map clean-preview (tm-children t))))

      \ \ \ \ \ \ \ \ ((tm-in? t (section-tag-list))

      \ \ \ \ \ \ \ \ \ (with l (symbol-append (tm-label t) '*)

      \ \ \ \ \ \ \ \ \ \ \ `(,l ,@(tm-children t))))

      \ \ \ \ \ \ \ \ ((tm-in? t '(label item item*\ 

      \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ bibitem bibitem*
      eq-number)) "")

      \ \ \ \ \ \ \ \ ((or (tm-func? t 'equation 1) (tm-func? t 'equation*
      1))

      \ \ \ \ \ \ \ \ \ `(equation* ,(clean-preview (tm-ref t 0))))

      \ \ \ \ \ \ \ \ ((tm-in? t '(eqnarray eqnarray* tformat table row
      cell))

      \ \ \ \ \ \ \ \ \ `(,(tm-label t) ,@(map clean-preview (tm-children
      t))))

      \ \ \ \ \ \ \ \ (else t)))
    </code>
  </scm-code>

  \;
</body>

<\initial>
  <\collection>
    <associate|page-medium|papyrus>
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
      Implementing previews for link targets
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1>
    </associate>
  </collection>
</auxiliary>