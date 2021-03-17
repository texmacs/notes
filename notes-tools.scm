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

(use-modules (ice-9 popen)) ;; for open-input-pipe
(use-modules (ice-9 rdelim)) ;; for read-line

;; TODO:
;; * avoid to use absolute paths
;; * improve conversion of strings (spurious <concat> elements in atom output)

(define (src-dir) (url->string (url-expand "$PWD/src")))
(define (dest-dir) (url->string (url-expand "$PWD/docs")))

;; git does not preserve modification time for files so we need to retrieve it from the 
;; commit log. Note we need the "author time", not the "commit time" (in git parlance)
;; However there is a problem: if the file is not yet commited we get a wrong answer
;; so we have to commit our modification and *then* generate the digest. 
;; This requires two commits... However one can just ignore this problem.
;;
;; If the file is not in the git log then we get the date from the filesystem.

(define (git-date fname)
 (let* ((port (open-input-pipe (string-append "git log --pretty=%at " fname " | head -1")))
                 (str  (read-line port)))
            (if (equal? 0 (close-pipe port))
                (string->number str)
                (stat:mtime (stat fname)))))

(define (collect-articles dir)
  (map 
    (lambda (furl)       
        (let* ((fname (url->system furl))
            (doc (tmfile-extract (tree-import fname "texmacs") 'body))
            (title (select doc '(:* chapter* :%1)))  
            (abs (select doc '(:* notes-abstract :%1)))
            (mdate (stat:mtime (stat fname))) ;; not used
            (gdate (git-date fname)) 
            (cdate (stat:ctime (stat fname)))) ;; not used
        `(,gdate ,cdate 
            ,(url->string (url-delta (url-append dir "./") furl)) 
            ,title ,abs)))
    (url->list (url-expand 
            (url-complete (url-append dir (url-wildcard "*.tm")) "fr")))))

(define (make-article-list-entry mdate cdate file title abs)
    `(notes-entry ,file 
        ,(if (null? title) "(no title)" (car title))
        ,(if (null? abs) "(no abstract)" (car abs))
        ,(strftime "%c %Z"  (localtime mdate "UTC"))))

;;(car (collect-articles "/Users/mgubi/t/git-notes/src"))

(define (make-article-list dir)
    (let* (
        (material (sort 
            (collect-articles dir) 
            (lambda (x y) (>= (car x) (car y)))))
        (material2 (filter 
            (lambda (x) (not (member (second x) '("list-articles.tm" "main.tm")))) 
            material)))
    material2))

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

(define (make-atom-entry mdate cdate file title abs)
    `(entry 
        (!document 
            (title ,(if (null? title) "(no title)" (car title)))
            (link (@ (rel "alternate") (type "text/html") (hreflang "en") (href 
                ,(string-append "http://texmacs.github.io/notes/docs/" 
                                (string-drop-right file 3) ".html" ))))
            (id ,(string-append "texmacs.github.io/notes/" file ":" 
                                (strftime "%Y-%m-%dT%H:%M:%SZ"  (localtime mdate "UTC"))))
            (updated   ,(strftime "%Y-%m-%dT%H:%M:%SZ"  (localtime mdate "UTC")))
            (published ,(strftime "%Y-%m-%dT%H:%M:%SZ"  (localtime cdate "UTC")))
            ,@(if (null? abs) '() `((summary ,(car abs)))) 
            )))

(define (output-article-feed articles)
    (string-save (serialize-tmml
        `(*TOP* (!document 
            (*PI* xml "version=\"1.0\" encoding=\"utf-8\"") 
            (feed (@ (xmlns "http://www.w3.org/2005/Atom") (xml:lang "en")) (!document
                (title "Notes on TeXmacs")
                (link (@ (rel "alternate") (type "text/html") 
                         (href "http://texmacs.github.io/notes")))
                (link (@ (rel "self") (type "application/atom+xml") 
                         (href "http://texmacs.github.io/notes/docs/notes.atom")))
                (updated ,(strftime "%Y-%m-%dT%H:%M:%SZ"  (gmtime (current-time))))
                (author (!document
                    (name "The TeXmacs organisation")
                    (uri "http://www.texmacs.org")))
                (id "texmacs.github.io/notes,2020,1")
                (icon "http://texmacs.github.io/notes/misc/blog-icon.ico")
                (logo "http://texmacs.github.io/notes/misc/texmacs-blog-transparent.png")
                ,@(map (lambda (entry) (apply make-atom-entry entry)) articles))))))
        (string-append (dest-dir) "/notes.atom")))

(define (notes-run update?)
    (display* "Source dir :" (src-dir) "\n")
    (display* "Dest dir   :" (dest-dir) "\n")
    (let ((articles (make-article-list (src-dir))))
        (display* "* Making article list\n")
        (output-article-list-doc articles)
        (display* "* Making article feed\n")
        (output-article-feed articles))
    (display* "* Updating website\n")
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

