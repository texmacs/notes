<TeXmacs|2.1.4>

<style|notes>

<\body>
  <\hide-preamble>
    <assign|tm-src|<macro|path|<hlink|<verbatim|<arg|path>>|<merge|https://github.com/texmacs/texmacs/blob/svn_mirror/|<arg|path>>>>>
  </hide-preamble>

  <notes-header>

  <chapter*|Customizing <TeXmacs> with Scheme: a commented collection of
  snippets>

  <notes-abstract|Many aspects of the behaviour of <TeXmacs> can be changed
  with a few lines of Scheme in your personal initialization files. We
  explain where such code goes, how <TeXmacs> loads its own Scheme code and
  why this matters for your customizations, and then present a collection of
  tested snippets for keyboard shortcuts, menus, export, sessions and new
  documents.>

  [Version 1.0 of 24.10.2026. Based on the forum wiki thread <hlink|Assorted
  code snippets to customize TeXmacs' behaviour|http://forum.texmacs.cn/t/wiki-assorted-code-snippets-to-customize-texmacs-behaviour/465>
  and its contributors.]

  The forum wiki thread on which this article is based was started in 2021 by
  <hlink|jeroen|http://forum.texmacs.cn/u/jeroen> to collect small pieces of
  Scheme code that users put in their initialization files, and it was
  extended and debugged by <hlink|pireddag|http://forum.texmacs.cn/u/pireddag>,
  <hlink|mgubi|http://forum.texmacs.cn/u/mgubi> and others. Here we take its
  content one step further: we explain the mechanisms that the snippets rely
  on, we check every snippet against the source code, we fix those that do
  not work (or work only by luck), and we add a few more.

  Everything was tested with <TeXmacs> 2.1.4, using a fresh user
  configuration, and checked against the development version (SVN trunk,
  revision 15370, October 2026), whose Scheme code is essentially identical.
  Links to the sources point to the <hlink|GitHub
  mirror|https://github.com/texmacs/texmacs> of the official repository.

  <section|Where your code goes><label|sec-where>

  <TeXmacs> reads two personal Scheme files, both in the <verbatim|progs>
  subdirectory of your <TeXmacs> home directory (<verbatim|~/.TeXmacs> on
  Linux and macOS, <verbatim|%APPDATA%\\TeXmacs> on Windows):

  <\description>
    <item*|<verbatim|my-init-texmacs.scm>>is executed once, when <TeXmacs>
    starts, right after the system file <verbatim|init-texmacs.scm>. This is
    the place for keyboard shortcuts, menus and new commands. Changes take
    effect after a restart.

    <item*|<verbatim|my-init-buffer.scm>>is executed each time a document is
    opened in a new view, both for new and for existing documents, after the
    system file <verbatim|init-buffer.scm>. This is the place for settings of
    new documents. Changes take effect for the next document you open,
    without a restart.
  </description>

  The easiest way to edit them is from <TeXmacs> itself: enable
  <menu|Tools|Developer tool>; a <menu|Developer> menu appears, with the
  entries <menu|Open my-init-texmacs.scm> and <menu|Open my-init-buffer.scm>
  (which create the files if they do not exist yet). When you paste code from
  a web page, <menu|Edit|Paste from|Verbatim> avoids surprises with
  formatting.

  One important fact: <em|an error in <verbatim|my-init-texmacs.scm> stops
  the execution of the rest of the file>. The error message is printed on the
  terminal (if you started <TeXmacs> from one), together with the line of the
  offending expression. If a customization seems to have no effect, check
  that nothing before it fails. Section <reference|sec-debug> explains how to
  investigate.

  <section|How <TeXmacs> loads its Scheme code><label|sec-lazy>

  Most surprises with personal customizations come from one design decision:
  to start quickly, <TeXmacs> loads most of its Scheme modules <em|lazily>.
  At startup, <verbatim|init-texmacs.scm> (in
  <tm-src|TeXmacs/progs/init-texmacs.scm>) loads a few essential modules,
  such as the main menus, and otherwise mostly declares where things are
  defined:

  <\itemize>
    <item><verbatim|lazy-define> declares functions; the module which defines
    them is loaded the first time one of them is called.

    <item><verbatim|lazy-keyboard> declares keymaps; they are loaded when
    <TeXmacs> is idle for a moment, or when the corresponding mode becomes
    active.

    <item><verbatim|lazy-menu>, <verbatim|lazy-format> and
    <verbatim|lazy-initialize> do the same for menus, file formats and other
    initializations, all of them loaded after a short idle time.
  </itemize>

  Your <verbatim|my-init-texmacs.scm> runs <em|before> these idle-time loads.
  This has three consequences, which we observed in our tests:

  <\enumerate>
    <item>A keyboard shortcut defined at the top level of your file can be
    <em|overridden> by a standard keymap loaded later. For instance, a
    binding for <verbatim|C-s> is replaced by the standard binding which
    makes text strong (on macOS, in text mode) or saves the document (on
    Linux and Windows, in all modes).

    <item>A menu which you extend at the top level of your file may not be
    defined yet when your file runs, and its module may be loaded later.
    Whether your additions survive then depends on details of the loading
    order, so it is better not to rely on it.

    <item>A function of a module which has not been loaded, and which is not
    declared with <verbatim|lazy-define>, is not defined at all, and calling
    it is an error, which also aborts the rest of your file.
  </enumerate>

  <\scm-code>
    ;; Does NOT work as intended in my-init-texmacs.scm:

    (kbd-map ("C-s" (kbd-up))) \ \ \ \ \ \ \ ; later overridden by a standard
    keymap

    (output-set-line-length 1000000) \ ; error: unbound variable
  </scm-code>

  There are two remedies, both used throughout the snippets below:

  <\itemize>
    <item><scm|(delayed ...)> runs its body later, from the event loop.
    Combined with <scm|(lazy-keyboard-force #t)>, which loads all the pending
    keymaps immediately, it makes sure that your bindings are installed
    <em|after> the standard ones (keymaps of plugins loaded even later could
    still override them). (<scm|delayed> accepts options such as <scm|(:idle
    1000)> to wait until the user is idle for a second, or <scm|(:pause
    100)>.)

    <item><scm|(import-from (module name))> loads a given module immediately,
    so that its functions and menus are defined before you use or extend
    them. The name of the module is the path of its file under
    <verbatim|progs>: <verbatim|(convert tools output)> is the file
    <verbatim|progs/convert/tools/output.scm>.
  </itemize>

  <\scm-code>
    ;; Run after the standard keymaps have been loaded:

    (delayed

    \ \ (lazy-keyboard-force #t)

    \ \ (kbd-map ("C-s" (kbd-up))))

    \;

    ;; Load the module which defines a function before using it:

    (import-from (convert tools output))

    (output-set-line-length 1000000)
  </scm-code>

  The <scm|delayed> variant was used in the original forum snippets, and is
  the right choice for keyboard shortcuts; <scm|import-from> is more
  predictable for functions and menus.

  <section|The customization vocabulary><label|sec-vocabulary>

  A handful of Scheme forms cover almost all customizations.

  <paragraph|Keyboard shortcuts.><scm|(kbd-map (key action) ...)> binds key
  sequences to actions. A key sequence is a string of keys separated by
  spaces, like <verbatim|"M-e p"> (first <verbatim|M-e>, then <verbatim|p>).
  The modifiers are written <verbatim|S-> (Shift), <verbatim|C-> (Control),
  <verbatim|A-> (Alt, or Option on a Mac) and <verbatim|M-> (Meta: the
  Windows or Super key, or Command on a Mac). If your system intercepts a
  combination, the <verbatim|Escape> key can be used as a modifier: on Linux
  and Windows it stands for <verbatim|M->, and pressed twice for
  <verbatim|A->; on macOS it stands for <verbatim|A-> (Option), twice for
  <verbatim|C->, three times for <verbatim|M-> (Command). Since the
  conventional modifier for commands differs between systems, <TeXmacs> also
  offers portable prefixes: <verbatim|std> is <verbatim|C-> on Linux and
  Windows and <verbatim|M-> (Command) on a Mac, so that <verbatim|"std s"> is
  the usual \Psave\Q shortcut everywhere; <verbatim|cmd>, <verbatim|altcmd>
  and <verbatim|extra> are further portable combinations. These prefixes are
  defined by a lazily loaded keymap, so they only work once that keymap is
  loaded, that is after <scm|(lazy-keyboard-force #t)>; we always do this
  inside <scm|delayed>, which is the safest choice.

  A <scm|kbd-map> may start with <scm|(:mode in-math?)> (or <scm|in-text?>,
  <scm|in-session?>, <scm|in-prog?>, ...) to restrict the bindings to a mode.
  When several bindings apply, the one defined last wins, which is again why
  the order of loading matters.

  <paragraph|Editor commands.><scm|(kbd-commands (name help action) ...)>
  defines commands that you type as <verbatim|\\name> followed by
  <verbatim|Return>, like the built-in <verbatim|\\red> which inserts red
  text.

  <paragraph|Menus.><scm|(menu-bind name entries ...)> redefines a menu. The
  special entry <scm|(former)> stands for the previous content of the menu,
  so that you can add entries instead of replacing everything. In menus,
  <verbatim|\<#2D\>\<#2D\>\<#2D\>> is a separator, <scm|("label" action)> an
  entry, <scm|(-\<gtr\> "label" ...)> a submenu, <scm|(=\<gtr\> "label" ...)>
  a pull-down menu (as in the menu bar) and <scm|(group "text")> a heading.

  <paragraph|Functions and contextual overloading.><scm|tm-define> defines a
  function, like <scm|define>, but it can be redefined in specific contexts.
  With <scm|(:require condition)>, the new definition is used only when the
  condition holds; otherwise the previous definition is called. This example
  from the <TeXmacs> developer documentation defines a command which behaves
  differently in math mode (to try it, bind <scm|(hello)> to a key of your
  choice with <scm|kbd-map>, and press it in text and in math mode):

  <\scm-code>
    (tm-define (hello) (insert "Hello"))

    \;

    (tm-define (hello)

    \ \ (:require (in-math?))

    \ \ (insert-go-to "hello()" '(6)))
  </scm-code>

  In the body of a redefinition, <scm|former> refers to the previous
  definition, so that you can extend a function instead of replacing it:

  <\scm-code>
    (tm-define (save-buffer . args)

    \ \ (apply former args)

    \ \ (set-message "Saved!" "my-init-texmacs.scm"))
  </scm-code>

  Much of <TeXmacs> is organized this way. For instance, the
  <verbatim|Return> key calls <scm|(kbd-enter t shift?)>, where <scm|t> is
  the innermost structure around the cursor, and each kind of structure
  (sessions, tables, lists...) overloads <scm|kbd-enter> with a
  <scm|:require> clause. Your own definitions can join in.

  <paragraph|Preferences.><scm|(get-preference "name")> and
  <scm|(set-preference "name" "value")> read and write the preferences stored
  in <verbatim|system/preferences.scm> in your <TeXmacs> home directory.
  Values are strings, and <scm|set-preference> saves the preferences file
  when a value changes; for settings that should simply persist, it is more
  natural to call it once, in a Scheme session, than at every start. You can
  invent your own preference names, as we do below.

  <section|Keyboard snippets><label|sec-keyboard>

  <paragraph|Emacs-like cursor movements.>Use <verbatim|C-a>, <verbatim|C-f>,
  <verbatim|C-s> and <verbatim|C-d> as arrow keys (from the forum thread).
  Without <scm|delayed>, most of the four bindings are overridden by the
  standard ones. Note that this replaces standard shortcuts: on Linux and
  Windows <verbatim|C-a>, <verbatim|C-f> and <verbatim|C-s> are \Pselect
  all\Q, \Pfind\Q and \Psave\Q, and on Linux <verbatim|C-d> deletes the next
  character; on macOS <verbatim|C-a>, <verbatim|C-s> and <verbatim|C-d>
  insert an abbreviation, strong text and a description list.

  <\scm-code>
    (delayed

    \ \ (lazy-keyboard-force #t)

    \ \ (kbd-map

    \ \ \ \ ("C-a" (kbd-left))

    \ \ \ \ ("C-f" (kbd-right))

    \ \ \ \ ("C-s" (kbd-up))

    \ \ \ \ ("C-d" (kbd-down))))
  </scm-code>

  <paragraph|Subscripts and superscripts in sessions.>Type <verbatim|\\ _> or
  <verbatim|\\ ^> followed by <verbatim|Tab> (Jupyter style) to insert a
  subscript or a superscript, only inside sessions. The key name
  <verbatim|var> stands for <verbatim|Tab>.

  <\scm-code>
    (delayed

    \ \ (lazy-keyboard-force #t)

    \ \ (kbd-map

    \ \ \ \ (:mode in-session?)

    \ \ \ \ ("\\\\ _ var" (make-script #f #t))

    \ \ \ \ ("\\\\ ^ var" (make-script #t #t))))
  </scm-code>

  <paragraph|A shortcut for a color.>With this definition, typing
  <verbatim|\\darkgreen> and <verbatim|Return> starts dark green text, just
  like the built-in <verbatim|\\red>. Command names cannot contain spaces.

  <\scm-code>
    (kbd-commands

    \ \ ("darkgreen" "" (make-with "color" "dark green")))
  </scm-code>

  <paragraph|Insert today's date.>Typing <verbatim|\\today> and
  <verbatim|Return> inserts the current date as text (unlike the
  <markup|date> tag, it does not change later).

  <\scm-code>
    (kbd-commands

    \ \ ("today" "insert today's date"

    \ \ \ (insert (strftime "%Y-%m-%d" (localtime (current-time))))))
  </scm-code>

  <paragraph|Alternative shortcuts for the source mode.>Some window managers
  (the forum mentions Sway) do not pass the default shortcut for
  <menu|Document|Source|Edit source tree> (<verbatim|M-A-s>, that is
  Command+Option+S on a Mac and Super+Alt+S elsewhere) to <TeXmacs>. Keep
  only the line you want. Note that with the developer tool enabled,
  <verbatim|A-F1> normally shows the documentation of the Scheme symbol at
  the cursor. The <scm|delayed> makes sure that your choice wins over
  standard bindings: on macOS <verbatim|A-space> enlarges the selection, and
  on Linux and Windows <verbatim|A-s> makes text strong (or inserts a square
  root in math mode), which these bindings replace.

  <\scm-code>
    (delayed

    \ \ (lazy-keyboard-force #t)

    \ \ (kbd-map

    \ \ \ \ ("A-space" (toggle-source-mode))

    \ \ \ \ ("A-F1" (toggle-source-mode))

    \ \ \ \ ("A-s" (toggle-source-mode))))
  </scm-code>

  <paragraph|Shortcuts that insert structures.>Bind a key to the insertion of
  a theorem in text mode (with the portable <verbatim|std> prefix), and
  <verbatim|; ;> to a fraction in math mode. Any tag can be inserted with
  <scm|(make 'tag-name)>. The second binding replaces the standard meaning of
  <verbatim|; ;> in math mode.

  <\scm-code>
    (delayed

    \ \ (lazy-keyboard-force #t)

    \ \ (kbd-map (:mode in-text?)

    \ \ \ \ ("std T" (make 'theorem))) \ \ \ \ ; Ctrl+Shift+T, or Cmd+Shift+T
    on a Mac

    \ \ (kbd-map (:mode in-math?)

    \ \ \ \ ("; ;" (make-fraction))))
  </scm-code>

  <section|Menus and toolbars><label|sec-menus>

  <paragraph|More fonts in the font menu of the toolbar.>The forum snippet
  used <scm|delayed>; loading the module that defines the menu is more
  robust. The fonts must be installed on your system.

  <\scm-code>
    (import-from (generic document-menu))

    \;

    (menu-bind document-short-font-menu

    \ \ (former)

    \ \ ---

    \ \ (group "My fonts")

    \ \ ("Cantarell" (init-font "Cantarell"))

    \ \ ("Garamond" (init-font "Garamond Libre"))

    \ \ ("Montserrat" (init-font "Montserrat")))
  </scm-code>

  <paragraph|A menu of your own.>The empty menu <verbatim|texmacs-extra-menu>
  is a hook, provided by <TeXmacs> for additions to the menu bar. Here we use
  it for a <menu|My tools> menu (the first entry is defined in Section
  <reference|sec-export>):

  <\scm-code>
    (menu-bind texmacs-extra-menu

    \ \ (former)

    \ \ (=\<gtr\> "My tools"

    \ \ \ \ \ \ ("Export PDF next to document" (export-to-same-name-pdf))

    \ \ \ \ \ \ ("Toggle source mode" (toggle-source-mode))

    \ \ \ \ \ \ ---

    \ \ \ \ \ \ ("Edit my-init-texmacs.scm"

    \ \ \ \ \ \ \ (load-document "$TEXMACS_HOME_PATH/progs/my-init-texmacs.scm"))))
  </scm-code>

  <paragraph|A toolbar button.>The main toolbar is the menu
  <verbatim|texmacs-main-icons>; <verbatim|/> is a separator between icons.
  The command is again the one of Section <reference|sec-export> (the order
  of the definitions in the file does not matter, since the action only runs
  when the button is clicked):

  <\scm-code>
    (menu-bind texmacs-main-icons

    \ \ (former)

    \ \ /

    \ \ ((balloon (icon "tm_print.xpm") "Export PDF next to document")

    \ \ \ (export-to-same-name-pdf)))
  </scm-code>

  An entry in the context menu (the menu that appears with a right click) is
  added in the same way, through <verbatim|texmacs-popup-menu>; see the
  sessions snippet in Section <reference|sec-sessions>.

  <section|Export><label|sec-export>

  <paragraph|Export to a PDF file next to the document.>The first snippet of
  the forum thread binds <verbatim|M-e p> to an export of the current
  document to a PDF file with the same name. The snippet in the thread builds
  the name of the PDF file from the name of the document:

  <\scm-code>
    (define (propose-pdf-name)

    \ \ (with name (propose-name-buffer)

    \ \ \ \ (if (string-ends? name ".tm")

    \ \ \ \ \ \ \ \ (string-append (string-drop-right name 3) ".pdf"))))
  </scm-code>

  This works on Linux and macOS but fails on Windows with a \PCould not
  concretize tuple\Q error, as found by <hlink|pireddag|http://forum.texmacs.cn/u/pireddag>
  (<hlink|post 6|http://forum.texmacs.cn/t/wiki-assorted-code-snippets-to-customize-texmacs-behaviour/465/6>
  to <hlink|post 14|http://forum.texmacs.cn/t/wiki-assorted-code-snippets-to-customize-texmacs-behaviour/465/14>).
  The reason is instructive. Inside <TeXmacs>, file names are not strings but
  <em|urls>, structured values which know about the conventions of the
  operating system. <scm|propose-name-buffer> converts the url of the
  document into a Unix-style string, so that on Windows
  <verbatim|C:\\Users\\me\\x.tm> becomes <verbatim|/C/Users/me/x.tm>, without
  the colon after the drive letter. When the modified string is later
  converted back into a url, it is read with the Windows conventions, and
  without the colon it is no longer recognized as an absolute path. The
  lesson is general: <em|do not build file names by string manipulation; keep
  them as urls and use the url functions> (<scm|url-relative>,
  <scm|url-basename>, <scm|url-glue>, <scm|url-exists?>, ...).

  Here is a version which follows this advice, also checks that the document
  has been saved (and is a <verbatim|.tm> file), and uses the same function
  as <menu|File|Export|Pdf>:

  <\scm-code>
    (tm-define (same-name-pdf-url)

    \ \ (with u (current-buffer)

    \ \ \ \ \ \ \ \ (and (not (url-scratch? u))

    \ \ \ \ \ \ \ \ \ (== (url-suffix u) "tm")

    \ \ \ \ \ \ \ \ \ (url-relative u (string-append (url-basename u)
    ".pdf")))))

    \;

    (tm-define (export-to-same-name-pdf)

    \ \ (with pdf (same-name-pdf-url)

    \ \ \ \ (cond ((not pdf)

    \ \ \ \ \ \ \ \ \ \ \ (set-message "Save the document first" "Export to
    PDF"))

    \ \ \ \ \ \ \ \ \ \ ((url-exists? pdf)

    \ \ \ \ \ \ \ \ \ \ \ (user-confirm "File already exists. Really
    overwrite?" #f

    \ \ \ \ \ \ \ \ \ \ \ \ \ (lambda (answ) (when answ
    (wrapped-print-to-file pdf)))))

    \ \ \ \ \ \ \ \ \ \ (else (wrapped-print-to-file pdf)))))

    \;

    (kbd-map ("M-e p" (export-to-same-name-pdf)))
  </scm-code>

  On Windows, <verbatim|M-e> is <verbatim|Win+E>, which the system uses to
  open the file explorer; choose another key there, or press
  <verbatim|Escape> <verbatim|e p>.

  <paragraph|Update the PDF at every save.>Building on the previous snippet
  (it uses <scm|same-name-pdf-url>, so keep both), we can extend
  <scm|save-buffer> with <scm|former> so that the PDF is updated whenever the
  document is saved, if a preference of our own is set. It calls
  <scm|wrapped-print-to-file> directly, so that saving does not ask every
  time whether to overwrite the PDF:

  <\scm-code>
    (tm-define (save-buffer . args)

    \ \ (apply former args)

    \ \ (when (== (get-preference "my:pdf on save") "on")

    \ \ \ \ (with pdf (same-name-pdf-url)

    \ \ \ \ \ \ (when pdf (wrapped-print-to-file pdf)))))
  </scm-code>

  Turn it on and off from a Scheme session (<menu|Insert|Session|Scheme>):

  <\scm-code>
    (set-preference "my:pdf on save" "on") \ \ \ ; turn it on

    (set-preference "my:pdf on save" "off") \ \ ; turn it off
  </scm-code>

  <paragraph|Long lines in LaTeX export.>By default the LaTeX exporter breaks
  lines after 79 characters, which can be annoying when the LaTeX file is
  later edited or put under version control. This sets the line length to a
  huge value:

  <\scm-code>
    (import-from (convert tools output))

    (output-set-line-length 1000000000)
  </scm-code>

  The forum version, <scm|(delayed (:idle 1000) (output-set-line-length
  1000000000))>, usually works too, but only if the module has been loaded
  within one second; the explicit <scm|import-from> removes the guesswork.

  <section|Sessions><label|sec-sessions>

  <paragraph|Multiline input by default.>In a multiline session,
  <verbatim|Return> inserts a new line and <verbatim|S-return> evaluates. The
  arguments are the plugin and the session name, as in <menu|Insert|Session>:

  <\scm-code>
    (import-from (dynamic session-edit))

    (set-session-multiline-input "python" "default" #t)

    (set-session-multiline-input "julia" "default" #t)
  </scm-code>

  <paragraph|Evaluate all the sessions of a document.>The command below,
  bound to <verbatim|A-e> and added to the context menu inside sessions,
  evaluates every session of the document in turn. (On Linux and Windows,
  <verbatim|A-e> normally inserts an enumeration in text mode; pick another
  key if you use that.) Compared with the forum version, it searches for
  <scm|session-document-context?> instead of
  <scm|subsession-document-context?>, so that unfolded subsessions are not
  evaluated twice, and it drops an import of <scm|tree-search> from the
  module <verbatim|(link link-extract)>: <scm|tree-search> is now a standard
  function, and the old import raises an error in current versions.

  <\scm-code>
    (tm-define (evaluate-all-sessions)

    \ \ (for-each (lambda (doc)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ (tree-go-to doc :last 1 :end)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ (session-evaluate-all))

    \ \ \ \ \ \ \ \ \ \ \ \ (tree-search (buffer-tree)
    session-document-context?)))

    \;

    (delayed

    \ \ (lazy-keyboard-force #t)

    \ \ (kbd-map ("A-e" (evaluate-all-sessions))))

    \;

    (tm-menu (texmacs-popup-menu)

    \ \ (:require (inside? 'session))

    \ \ (former)

    \ \ ---

    \ \ ("Evaluate all sessions in document" (evaluate-all-sessions)))
  </scm-code>

  <paragraph|Evaluate without creating a new input field.>At the end of the
  thread, <hlink|hamorabi|http://forum.texmacs.cn/u/hamorabi> asked how to
  avoid the empty input field that appears after each evaluation (<hlink|post
  24|http://forum.texmacs.cn/t/wiki-assorted-code-snippets-to-customize-texmacs-behaviour/465/24>
  and <hlink|post 26|http://forum.texmacs.cn/t/wiki-assorted-code-snippets-to-customize-texmacs-behaviour/465/26>).
  There is no option for this: the new field is part of the protocol with the
  plugin, which writes its next prompt into it (see
  <verbatim|field-process-input> in <tm-src|TeXmacs/progs/dynamic/session-edit.scm>).
  We can, however, remove it once the evaluation is finished. The following
  redefines <verbatim|C-return> inside session inputs (using contextual
  overloading of <scm|kbd-control-enter>) to evaluate the current field, keep
  the cursor in it, and remove the empty field that was appended, if any.
  Plain <verbatim|Return> keeps the usual behaviour; to add a new field when
  you need one, use <menu|Insert field below> in the <menu|Focus> menu or on
  the focus toolbar.

  <\scm-code>
    (import-from (dynamic session-edit))

    \;

    (define (my-field-busy? t)

    \ \ (with out (and (tree? t) (\<gtr\> (tree-arity t) 2) (tree-ref t 2))

    \ \ \ \ (and out (tree-is? out 'document) (\<gtr\> (tree-arity out) 0)

    \ \ \ \ \ \ \ \ \ (tree-is? (tree-ref out :last) 'script-busy))))

    \;

    (define (my-empty-input? u)

    \ \ (and (tree? u) (tree-\<gtr\>path u)

    \ \ \ \ \ \ \ (tree-in? u '(input input-math input-text))

    \ \ \ \ \ \ \ (tree-empty? (tree-ref u 1))))

    \;

    (tm-define (session-evaluate-in-place)

    \ \ (with-innermost t field-input-context?

    \ \ \ \ (with last? (not (tree-ref t :next))

    \ \ \ \ \ \ (session-evaluate) \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ; may
    append a new field u

    \ \ \ \ \ \ (with u (and last? (tree-ref t :next))

    \ \ \ \ \ \ \ \ (tree-go-to t 1 :end) \ \ \ \ \ \ \ \ \ \ \ \ ; stay in
    the evaluated field

    \ \ \ \ \ \ \ \ (when u

    \ \ \ \ \ \ \ \ \ \ (delayed

    \ \ \ \ \ \ \ \ \ \ \ \ (:pause 100)

    \ \ \ \ \ \ \ \ \ \ \ \ (:require (not (my-field-busy? t))) \ ; wait for
    the output

    \ \ \ \ \ \ \ \ \ \ \ \ (when (my-empty-input? u)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ (tree-remove (tree-ref u :up) (tree-index u)
    1))))))))

    \;

    (tm-define (kbd-control-enter t shift?)

    \ \ (:require (field-input-context? t))

    \ \ (session-evaluate-in-place))
  </scm-code>

  We tested it with the Scheme plugin; other plugins use the same mechanism,
  but check it with yours.

  <section|New documents><label|sec-new>

  The following snippets go into <verbatim|my-init-buffer.scm>. Since that
  file is run for every document that is opened, they first check that the
  document is new, using <scm|(buffer-has-name? (current-buffer))>, and end
  with <scm|buffer-pretend-saved>, so that an untouched new document is not
  considered modified.

  <paragraph|Add a style package to every new document.>From the forum, for a
  package (<verbatim|no-solutions-in-html>) written by the user:

  <\scm-code>
    (when (not (buffer-has-name? (current-buffer)))

    \ \ (add-style-package "no-solutions-in-html")

    \ \ (buffer-pretend-saved (current-buffer)))
  </scm-code>

  <paragraph|Default style, language and fonts.>Every new document is an
  article in British English, set in the TeX Gyre Termes fonts at 11 points:

  <\scm-code>
    (when (not (buffer-has-name? (current-buffer)))

    \ \ (init-style "article")

    \ \ (add-style-package "british")

    \ \ (init-font "termes" "math-termes")

    \ \ (init-env "font-base-size" "11")

    \ \ (buffer-pretend-saved (current-buffer)))
  </scm-code>

  The manual of <TeXmacs> gives a similar example using a function
  <verbatim|buffer-newly-created?>; this function does not exist in current
  versions, use <scm|buffer-has-name?> as above.

  <section|When something goes wrong><label|sec-debug>

  <\itemize>
    <item>Try your code in a Scheme session (<menu|Insert|Session|Scheme>)
    before putting it in an initialization file: you see errors and results
    immediately.

    <item>Start <TeXmacs> from a terminal to see the messages printed during
    startup, including errors in <verbatim|my-init-texmacs.scm> (on macOS,
    run <verbatim|/Applications/TeXmacs.app/Contents/MacOS/TeXmacs>). On
    Windows, standard output is not available this way (see the
    <hlink|article on standard output on Windows|windows-output-error.tm>).

    <item>Enable <menu|Tools|Debugging tool>: the <menu|Debug> menu gives
    access to the error console (<menu|Debug|Consoles>), and can open it
    automatically on errors.

    <item>A few useful questions to ask in a Scheme session:
  </itemize>

  <\scm-code>
    (defined? 'output-set-line-length) \ \ \ \ \ \ \ ; is the function
    loaded?

    (procedure-sources kbd-control-enter) \ \ \ \ ; all its definitions

    (with b (kbd-find-key-binding (kbd-pre-rewrite "std s"))

    \ \ (and b (promise-source (car b)))) \ \ \ \ \ ; what does a key do?

    (debug-message "std-warning" "my-init: reached line 42\\n")
  </scm-code>

  When you find the definition of a function you want to change, the pattern
  is almost always the same: load its module with <scm|import-from>, then
  redefine it with <scm|tm-define>, using a <scm|:require> clause or
  <scm|former> to keep the original behaviour where you do not need to change
  it.

  <section|Corrections to older advice><label|sec-corrections>

  While testing the snippets we found a few pieces of advice, in the forum
  and in the official documentation, which are no longer accurate:

  <\itemize>
    <item>The function <verbatim|url-system>, suggested in the thread, does
    not exist; the conversion functions are <scm|url-\<gtr\>system>,
    <scm|url-\<gtr\>unix>, <scm|system-\<gtr\>url> and <scm|unix-\<gtr\>url>.

    <item>The import <scm|(use-modules ((link link-extract) #:select
    (tree-search)))>, proposed for older versions, now raises an error.

    <item>The example of <verbatim|my-init-buffer.scm> in the manual uses
    <verbatim|buffer-newly-created?>, which does not exist.

    <item>The developer documentation on lazy loading states that
    mode-specific keyboard bindings take precedence over general ones; in
    current versions the binding defined last wins, whatever its mode.
  </itemize>

  The forum thread is still open, and new snippets are welcome there or as
  pull requests to the <hlink|repository of this
  website|https://github.com/texmacs/notes>.
</body>

<initial|<\collection>
</collection>>

<\references>
  <\collection>
    <associate|auto-1|<tuple|?|?>>
    <associate|auto-10|<tuple|1|?>>
    <associate|auto-11|<tuple|2|?>>
    <associate|auto-12|<tuple|3|?>>
    <associate|auto-13|<tuple|4|?>>
    <associate|auto-14|<tuple|5|?>>
    <associate|auto-15|<tuple|4|?>>
    <associate|auto-16|<tuple|1|?>>
    <associate|auto-17|<tuple|2|?>>
    <associate|auto-18|<tuple|3|?>>
    <associate|auto-19|<tuple|4|?>>
    <associate|auto-2|<tuple|1|?>>
    <associate|auto-20|<tuple|5|?>>
    <associate|auto-21|<tuple|5|?>>
    <associate|auto-22|<tuple|6|?>>
    <associate|auto-23|<tuple|5|?>>
    <associate|auto-24|<tuple|1|?>>
    <associate|auto-25|<tuple|2|?>>
    <associate|auto-26|<tuple|2|?>>
    <associate|auto-27|<tuple|3|?>>
    <associate|auto-28|<tuple|6|?>>
    <associate|auto-29|<tuple|1|?>>
    <associate|auto-3|<tuple|<with|language|<quote|verbatim>|<with|font|<quote|roman>|font-family|<quote|tt>|magnification|<quote|1.06>|my-init-buffer.scm>>|?>>
    <associate|auto-30|<tuple|1|?>>
    <associate|auto-31|<tuple|2|?>>
    <associate|auto-32|<tuple|2|?>>
    <associate|auto-33|<tuple|3|?>>
    <associate|auto-34|<tuple|7|?>>
    <associate|auto-35|<tuple|1|?>>
    <associate|auto-36|<tuple|1|?>>
    <associate|auto-37|<tuple|2|?>>
    <associate|auto-38|<tuple|3|?>>
    <associate|auto-39|<tuple|3|?>>
    <associate|auto-4|<tuple|<with|language|<quote|verbatim>|<with|font|<quote|roman>|font-family|<quote|tt>|magnification|<quote|1.06>|my-init-buffer.scm>>|?>>
    <associate|auto-40|<tuple|3|?>>
    <associate|auto-41|<tuple|8|?>>
    <associate|auto-42|<tuple|1|?>>
    <associate|auto-43|<tuple|2|?>>
    <associate|auto-44|<tuple|9|?>>
    <associate|auto-45|<tuple|<with|mode|<quote|math>|\<bullet\>>|?>>
    <associate|auto-46|<tuple|<with|mode|<quote|math>|\<bullet\>>|?>>
    <associate|auto-47|<tuple|<with|mode|<quote|math>|\<bullet\>>|?>>
    <associate|auto-48|<tuple|<with|mode|<quote|math>|\<bullet\>>|?>>
    <associate|auto-49|<tuple|10|?>>
    <associate|auto-5|<tuple|<with|language|<quote|verbatim>|<with|font|<quote|roman>|font-family|<quote|tt>|magnification|<quote|1.06>|my-init-buffer.scm>>|?>>
    <associate|auto-6|<tuple|<with|language|<quote|verbatim>|<with|font|<quote|roman>|font-family|<quote|tt>|magnification|<quote|1.06>|my-init-buffer.scm>>|?>>
    <associate|auto-7|<tuple|<with|language|<quote|verbatim>|<with|font|<quote|roman>|font-family|<quote|tt>|magnification|<quote|1.06>|my-init-buffer.scm>>|?>>
    <associate|auto-8|<tuple|2|?>>
    <associate|auto-9|<tuple|3|?>>
    <associate|sec-corrections|<tuple|10|?>>
    <associate|sec-debug|<tuple|9|?>>
    <associate|sec-export|<tuple|6|?>>
    <associate|sec-keyboard|<tuple|4|?>>
    <associate|sec-lazy|<tuple|2|?>>
    <associate|sec-menus|<tuple|5|?>>
    <associate|sec-new|<tuple|8|?>>
    <associate|sec-sessions|<tuple|7|?>>
    <associate|sec-vocabulary|<tuple|3|?>>
    <associate|sec-where|<tuple|1|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|idx>
      <tuple|<tuple|<with|font-family|<quote|ss>|Tools>|<with|font-family|<quote|ss>|Developer
      tool>>|<pageref|auto-3>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Developer>>|<pageref|auto-4>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Open
      my-init-texmacs.scm>>|<pageref|auto-5>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Open
      my-init-buffer.scm>>|<pageref|auto-6>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Edit>|<with|font-family|<quote|ss>|Paste
      from>|<with|font-family|<quote|ss>|Verbatim>>|<pageref|auto-7>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Document>|<with|font-family|<quote|ss>|Source>|<with|font-family|<quote|ss>|Edit
      source tree>>|<pageref|auto-21>>

      <tuple|<tuple|<with|font-family|<quote|ss>|My
      tools>>|<pageref|auto-26>>

      <tuple|<tuple|<with|font-family|<quote|ss>|File>|<with|font-family|<quote|ss>|Export>|<with|font-family|<quote|ss>|Pdf>>|<pageref|auto-30>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Insert>|<with|font-family|<quote|ss>|Session>|<with|font-family|<quote|ss>|Scheme>>|<pageref|auto-32>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Insert>|<with|font-family|<quote|ss>|Session>>|<pageref|auto-36>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Insert field
      below>>|<pageref|auto-39>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Focus>>|<pageref|auto-40>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Insert>|<with|font-family|<quote|ss>|Session>|<with|font-family|<quote|ss>|Scheme>>|<pageref|auto-45>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Tools>|<with|font-family|<quote|ss>|Debugging
      tool>>|<pageref|auto-46>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Debug>>|<pageref|auto-47>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Debug>|<with|font-family|<quote|ss>|Consoles>>|<pageref|auto-48>>
    </associate>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Customizing
      T<rsub|<space|-0.4spc><move|<resize|<with|math-level|<quote|0>|E>||||0.5fn>|0fn|-0.1fn>><space|-0.4spc>X<rsub|<space|-0.4spc><move|<resize|M<space|-0.2spc>A<space|-0.4spc>CS||||0.5fn>|0fn|-0.1fn>>
      with Scheme: a commented collection of snippets>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-1><vspace|0.5fn>

      1.<space|2spc>Where your code goes <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2>

      2.<space|2spc>How T<rsub|<space|-0.4spc><move|<resize|<with|math-level|<quote|0>|E>||||0.5fn>|0fn|-0.1fn>><space|-0.4spc>X<rsub|<space|-0.4spc><move|<resize|M<space|-0.2spc>A<space|-0.4spc>CS||||0.5fn>|0fn|-0.1fn>>
      loads its Scheme code <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-8>

      3.<space|2spc>The customization vocabulary
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-9>

      <with|par-left|<quote|3tab>|Keyboard shortcuts.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-10>>

      <with|par-left|<quote|3tab>|Editor commands.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-11>>

      <with|par-left|<quote|3tab>|Menus. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-12>>

      <with|par-left|<quote|3tab>|Functions and contextual overloading.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-13>>

      <with|par-left|<quote|3tab>|Preferences.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-14>>

      4.<space|2spc>Keyboard snippets <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-15>

      <with|par-left|<quote|3tab>|Emacs-like cursor movements.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-16>>

      <with|par-left|<quote|3tab>|Subscripts and superscripts in sessions.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-17>>

      <with|par-left|<quote|3tab>|A shortcut for a color.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-18>>

      <with|par-left|<quote|3tab>|Insert today's date.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-19>>

      <with|par-left|<quote|3tab>|Alternative shortcuts for the source mode.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-20>>

      <with|par-left|<quote|3tab>|Shortcuts that insert structures.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-22>>

      5.<space|2spc>Menus and toolbars <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-23>

      <with|par-left|<quote|3tab>|More fonts in the font menu of the toolbar.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-24>>

      <with|par-left|<quote|3tab>|A menu of your own.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-25>>

      <with|par-left|<quote|3tab>|A toolbar button.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-27>>

      6.<space|2spc>Export <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-28>

      <with|par-left|<quote|3tab>|Export to a PDF file next to the document.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-29>>

      <with|par-left|<quote|3tab>|Update the PDF at every save.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-31>>

      <with|par-left|<quote|3tab>|Long lines in LaTeX export.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-33>>

      7.<space|2spc>Sessions <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-34>

      <with|par-left|<quote|3tab>|Multiline input by default.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-35>>

      <with|par-left|<quote|3tab>|Evaluate all the sessions of a document.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-37>>

      <with|par-left|<quote|3tab>|Evaluate without creating a new input
      field. <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-38>>

      8.<space|2spc>New documents <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-41>

      <with|par-left|<quote|3tab>|Add a style package to every new document.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-42>>

      <with|par-left|<quote|3tab>|Default style, language and fonts.
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-43>>

      9.<space|2spc>When something goes wrong
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-44>

      10.<space|2spc>Corrections to older advice
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-49>
    </associate>
  </collection>
</auxiliary>