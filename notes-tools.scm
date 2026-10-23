;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MODULE      : notes-tools.scm
;; DESCRIPTION : Tools to maintain the "Notes on TeXmacs" website
;; COPYRIGHT   : (C) 2020 Massimiliano Gubinelli
;;
;; This software falls under the GNU general public license version 3 or later.
;; It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
;; in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;(texmacs-module (notes-tools))

(use-modules (ice-9 popen)) ;; for open-pipe*
(use-modules (ice-9 rdelim)) ;; for read-line

(define notes-url "https://texmacs.github.io/notes/")

(if (not (getenv "NOTES"))
  (setenv "NOTES" (getenv "PWD")))

(define (src-dir) (url->string (url-expand "$NOTES/src")))
(define (dest-dir) (url->string (url-expand "$NOTES/docs")))

;; Git does not preserve modification times, and a checkout, copy, or restore
;; can make an unchanged page appear newer than its last content change.  Use
;; Git's author dates for clean tracked pages: the newest commit is the update
;; date and the oldest one the publication date.  Only consult the filesystem
;; for a genuinely dirty or untracked page.
;;
;; This needs the full history: in CI, check out with fetch-depth 0, otherwise
;; every page gets the date of the last commit.

(define (read-lines port)
  (let loop ((lines '()))
    (let ((line (read-line port)))
      (if (eof-object? line)
          (reverse lines)
          (loop (cons line lines))))))

(define (command-lines program . args)
  (let* ((port (apply open-pipe* (append (list OPEN_READ program) args)))
         (lines (read-lines port))
         (status (close-pipe port)))
    (if (equal? status 0) lines '())))

(define (git-lines . args)
  (apply command-lines
         (append (list "git" "-C" (getenv "NOTES")) args)))

(define (numeric-lines lines)
  (filter number? (map string->number lines)))

(define (git-dirty? repo-file)
  (not (null? (git-lines "status" "--porcelain=v1"
                         "--untracked-files=normal" "--" repo-file))))

(define (article-dates fname repo-file)
  (let* ((fdate (stat:mtime (stat fname)))
         (history (numeric-lines
                    (git-lines "log" "--follow" "--format=%at"
                               "--" repo-file))))
    (if (null? history)
        ;; Git may be unavailable, or this may be a new untracked page.
        `(,fdate ,fdate)
        (let* ((last-committed (car history))
               (first-committed (apply min history))
               (updated (if (git-dirty? repo-file)
                            (max fdate last-committed)
                            last-committed)))
          `(,updated ,first-committed)))))

(define (collect-articles dir)
  (map
    (lambda (furl)
        (let* ((fname (url->system furl))
               (file (url->string
                       (url-delta (url-append dir "./") furl)))
               (repo-file (string-append "src/" file))
               (dates (article-dates fname repo-file))
               (doc (tmfile-extract (tree-import fname "texmacs") 'body))
               (title (nonempty-selection (select doc '(:* chapter* :%1))))
               (abs (select doc '(:* notes-abstract :%1))))
          `(,(car dates) ,(second dates) ,file ,title ,abs)))
  (filter
    (lambda (furl)
        (let ((fname (url->string (url-delta (url-append dir "./") furl))))
          (not (or (equal? fname "main.tm")
                   (equal? fname "list-articles.tm")))))
    (url->list (url-expand
            (url-complete (url-append dir (url-wildcard "*.tm")) "fr"))))))

(define (make-article-list-entry mdate cdate file title abs)
    `(notes-entry ,file
        ,(if (null? title) "(no title)" (car title))
        ,(if (null? abs) "(no abstract)" (car abs))
        ,(strftime "%d %b %Y" (gmtime mdate))))

(define (make-article-list dir)
  (sort (collect-articles dir)
        (lambda (x y) (>= (car x) (car y)))))

;; Titles and abstracts are TeXmacs trees; the feed needs plain text.
;; Newlines must go before cork->utf8, which maps byte 10 to a dot accent.

(define (feed-text selection fallback)
  (if (null? selection)
      fallback
      (let ((content (car selection)))
        (xml-escape
          (cork->utf8
            (string-trim-both
              (string-replace
                (if (string? content)
                    content
                    (convert (stree->tree content) "texmacs-tree" "verbatim-snippet"
                             (cons "texmacs->verbatim:encoding" "cork")))
                "\n" " ")))))))

(define (xml-escape text)
  (string-replace
    (string-replace
      (string-replace text "&" "&amp;")
      "<" "&lt;")
    ">" "&gt;"))

(define (nonempty-selection selection)
  (filter (lambda (content)
            (not (equal? "" (string-trim-both
                               (feed-text (list content) "")))))
          selection))

(define (output-article-list-doc articles)
    (tree-export (tm->tree
        `(document
            (TeXmacs ,(texmacs-version))
            (style (tuple "notes"))
            (body (document
                (notes-header)
                (chapter* "List of all the articles")
                (notes-abstract "A list of all the articles in the website, ordered by the most recent modification time.")
                (hrule)
                ,@(map (lambda (entry) (apply make-article-list-entry entry))
                        articles)
                (hrule)))))
        (string-append (src-dir) "/list-articles.tm") "texmacs"))

;; Entry ids must not change when an article is updated, otherwise feed
;; readers show every rebuild as a new post.

(define (make-atom-entry mdate cdate file title abs)
    `(entry
        (!document
            (title ,(feed-text title "(no title)"))
            (link (@ (rel "alternate") (type "text/html") (hreflang "en") (href
                ,(string-append notes-url "docs/"
                                (string-drop-right file 3) ".html" ))))
            (id ,(string-append "tag:texmacs.github.io,2020:notes/" file))
            (updated   ,(strftime "%Y-%m-%dT%H:%M:%SZ" (gmtime mdate)))
            (published ,(strftime "%Y-%m-%dT%H:%M:%SZ" (gmtime cdate)))
            ,@(if (null? abs) '() `((summary ,(feed-text abs ""))))
            )))

(define (output-article-feed articles)
    (let ((feed-date (if (null? articles)
                         (current-time)
                         (apply max (map car articles)))))
      (string-save (serialize-tmml
        `(*TOP* (!document
            (*PI* xml "version=\"1.0\" encoding=\"utf-8\"")
            (feed (@ (xmlns "http://www.w3.org/2005/Atom") (xml:lang "en")) (!document
                (title "Notes on TeXmacs")
                (link (@ (rel "alternate") (type "text/html")
                         (href ,notes-url)))
                (link (@ (rel "self") (type "application/atom+xml")
                         (href ,(string-append notes-url "docs/notes.atom"))))
                (updated ,(strftime "%Y-%m-%dT%H:%M:%SZ" (gmtime feed-date)))
                (author (!document
                    (name "The TeXmacs organisation")
                    (uri "https://www.texmacs.org")))
                (id "tag:texmacs.github.io,2020:notes")
                (icon ,(string-append notes-url "resources/blog-icon.png"))
                (logo ,(string-append notes-url "resources/texmacs-blog-transparent.png"))
                ,@(map (lambda (entry) (apply make-atom-entry entry)) articles))))))
        (string-append (dest-dir) "/notes.atom"))))

(define (notes-run update?)
    (display* "Source dir :" (src-dir) "\n")
    (display* "Dest dir   :" (dest-dir) "\n")
    (let ((articles (make-article-list (src-dir))))
        (display* "* Making article list\n")
        (output-article-list-doc articles)
        (display* "* Making article feed\n")
        (output-article-feed articles))
    (if update?
        (begin
            (display* "* Updating website\n")
            (tmweb-update-dir (src-dir) (dest-dir)))
        (begin
            (display* "* Building website\n")
            (tmweb-convert-dir (src-dir) (dest-dir))))
    (display* "Done."))

(define (notes-update) (notes-run #t))
(define (notes-build) (notes-run #f))
