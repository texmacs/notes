(define (collect-articles dir)
  (map 
    (lambda (furl)       
        (let* ((fname (url->system furl))
            (doc (tmfile-extract (tree-import fname "texmacs") 'body))
            (title (select doc '(:* chapter* :%1)))  
            (abs (select doc '(:* notes-abstract :%1)))
            (mdate (stat:mtime (stat fname)))
            (mdatestr (strftime "%c %Z"  (gmtime mdate))))
        `(,mdate (notes-entry ,(url->string (url-delta (url-append dir "./") furl))
                      ,(if (null? title) "(no title)" (car title))
                      ,(if (null? abs) "(no abstract)" (car abs))
                      ,mdatestr))))
    (url->list (url-expand (url-complete (url-append dir (url-wildcard "*.tm")) "fr")))))


;;(car (collect-articles "/Users/mgubi/t/git-notes/src"))

(define (make-article-list)
    (let* (
        (material (map cadr (sort (collect-articles "/Users/mgubi/t/git-notes/src") (lambda (x y) (>= (car x) (car y))))))
        (material2 (filter (lambda (x) (not (== (second x) "list-articles.tm"))) material)))
    (tree-export (tm->tree 
        `(document 
            (TeXmacs ,(texmacs-version)) 
            (style (tuple "notes")) 
            (body (document  
                (notes-header) 
                (chapter* "List of all the articles")
                (notes-abstract "A list of all the articles in the website, ordered by the most recent modification time.")
                (hrule)
                ,@material2
                (hrule))))) 
        "/Users/mgubi/t/git-notes/src/list-articles.tm" "texmacs")))


