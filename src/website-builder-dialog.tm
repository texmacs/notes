<TeXmacs|1.99.15>

<style|notes>

<\body>
  <\hide-preamble>
    \;
  </hide-preamble>

  <notes-header>

  <chapter*|Adding a dialog to build websites>

  <notes-abstract|In this article we document the construction of a user
  interface to the website building facilities of <TeXmacs>.>

  <section*|Generating websites>

  <TeXmacs> can be used to build websites, in fact
  <hlink|this|https://texmacs.github.io/notes> blog, the main
  <hlink|<TeXmacs> website|www.texmacs.org> and a couple of other websites
  (e.g. one <hlink|here|https://www.texmacs.org/joris/main/joris.html> and
  another one <hlink|here|http://www.mathemagix.org/www/mmdoc/doc/html/main/index.en.html>)
  are currently written and maintained exclusively within <TeXmacs>.\ 

  To avoid the need of exporting manually every single page to HTML, some
  support has been added to build websites in the form of Scheme procedures,
  to be found in the module <scm|(doc tmweb)> (which can be found at
  <shell|TeXmacs/progs/doc/tmweb.scm>). The two relevant exported procedures
  are <scm|tmweb-update-dir> and <scm|tmweb-convert-dir>.\ 

  For example the user can invoke <TeXmacs> for the command line with
  something like

  <\shell-code>
    texmacs -x "(tmweb-convert-dir \\"sourcedir\\" \\"target-dir\\")" -q
  </shell-code>

  which executes (option <shell|-x>) the Scheme command\ 

  <\scm-code>
    (tmweb-convert-dir "sourcedir" "target-dir")
  </scm-code>

  and then exits (option <shell|-q>). Here <var|source-dir> and
  <var|target-dir> are two filesystem paths to the source and target
  directories for the conversion. The procedure <scm|tmweb-convert-dir> will
  take every <shell|.tm> file in <var|source-dir>, convert it to its HTML
  counterpart \ and save it in <var|target-dir>, all the other file types are
  just copied (see the sources for more details). <scm|tmweb-update-dir> will
  convert only files which are newer than their counterpart in
  <var|target-dir>, if it exists. This is suitable for incremental updating a
  website which has been already generated at least once with
  <scm|tmweb-convert-dir>.

  <TeXmacs> (here we refer to version 1.99.15 but this functionality existed
  already for some time) disposes of menu items to initiate both operations
  (creation and update). They can be found in <menu|Tools|Web|Create web
  site<text-dots>> and <menu|Tools|Web|Update web site<text-dots>>. The dots
  (<text-dots>) indicate that both items will execute some operation only
  after an interaction with the user (this is standard for all menu items,
  see e.g. <menu|File|Save as<text-dots>>). In particular in this case these
  items calls the scheme procedures <scm|tmweb-interactive-build> or
  <scm|tmweb-interactive-update>. The first, for example, looks like

  <\scm-code>
    (tm-define (tmweb-interactive-build)

    \ \ (:interactive #t)

    \ \ (user-url "Source directory" "directory"\ 

    \ \ \ \ (lambda (src) \ (user-url "Destination directory" "directory"

    \ \ \ \ \ \ (lambda (dest) (tmweb-convert-directory src dest #f #f))))))
  </scm-code>

  The declaration <scm|(:interactive #t)> indicates to <TeXmacs> that this
  procedur will prompt the user for some information. In particular, the dots
  in the menu item are added automatically by <TeXmacs> to reflect this
  declaration. The meaning of the actual code is quite intuitive: the
  procedure <scm|user-url> prompt the user for some information, the UI is
  supposed to show somehow the string <scm|"Source directory"> to give an
  hint to the user about the content of the information required. The
  argument <scm|"directory"> indicates that valid results should be an \ URL
  pointing to a directory in the filesystem. Finally the third argument to
  <scm|user-url> is a Scheme closure accepting one argument. When this
  procedure is evaluated, it initiate a UI dialog with the user which can
  select a directory and then press \POk\Q to confirm the selection. At this
  point the closure is called with an argument given by a string representing
  the URL just chosen. In the case above this result appears in the variable
  <scm|src>. Subsequently the closure evaluate an additional <scm|user-url>
  invocation, which asks for a destination directory an provide a second
  closure which looks like

  <\scm-code>
    (lambda (dest) (tmweb-convert-directory src dest #f #f))
  </scm-code>

  This closure receives the destination directory in the variable <scm|dest>
  and has also access to the variable <scm|src> because this last variable is
  visible (thanks to the lexical scoping of Scheme) to all the expressions
  inside the first <scm|lambda>. As a result the procedure
  <scm|tmweb-convert-directory> will be invocated with the user provided
  values for <scm|src> and <scm|dest> and two additional boolean arguments
  (the first indicates whether we need to update or not and we will ignore
  the second here).

  Albeit <scm|tmweb-interactive-build> is easy to understand and write, it is
  not very convenient, since it does not remember the user's choices from
  previous interactions and oblige the user to repetitive actions, for
  example when developing some new feature of the site which requires
  frequent updating.\ 

  \ <section*|A new interface>

  The goal of this article is to use \ <TeXmacs> Scheme widgets to develop a
  new dialog which allow a nicer interaction with the user.\ 

  In particular we want to remember previous choices and give a more
  comprehensive perspective of the parameters in a single window, instead of
  proposint to the users a sequence of questions without any trace of the
  current state of the interaction. The following picture shows the design we
  aim for for this dialog:

  <\big-figure|<image|../resources/website-builder-dialog/website-builder-dialog-image-1.png|1par|||>>
    <label|fig:dialog>The new dialog widget
  </big-figure>

  This dialog will have to be initiated by a procedure (with no parameters)
  which we will call <scm|website-interactive-builder>. Later on we can
  associate this function to some menu item to give easy access to the user
  to it. We have to manage three values: the source directory, the target
  directory and a boolean value to indicate creation or update. The function
  must read \ these values from a store (persistent through executions of the
  program), set up the dialog with these values, run the interaction, retrive
  the values after it and proceed with the suitable actions according to the
  new values. In particular, if the user didn't canceled the operation, we
  need to store away the new values for future invocations. This persistency
  of the information can be obtained by leveraging <TeXmacs> preference
  system, in particular we have two procedures <scm|get-preference> and
  <scm|set-preference> at our disposal. Their use is very simple: we can
  associate strings to given labels (also strings), the associations will
  persist across executions. If a label do not have any associated values so
  far <scm|get-preference> will return the string <scm|"default">. A possible
  form of <scm|website-interactive-builder> is then the following:

  <\scm-code>
    (tm-define (website-interactive-builder)

    \ \ \ \ (let ((src (get-preference "website:src-dir"))

    \ \ \ \ \ \ \ \ \ \ (dest (get-preference "website:dest-dir"))

    \ \ \ \ \ \ \ \ \ \ (update? (get-boolean-preference
    "website:update-flag")))

    \ \ \ \ \ \ 

    \ \ \ \ (dialogue-window (website-widget src dest update?)

    \ \ \ \ \ \ \ (lambda (flag src dest update?)\ 

    \ \ \ \ \ \ \ \ \ \ \ (if flag (begin\ 

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ (set-preference "website:src-dir" src)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ (set-preference "website:dest-dir" dest)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ (set-boolean-preference "website:update-flag"
    update?)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ (if update?\ 

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (tmweb-update-dir src dest)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (tmweb-convert-dir src dest)))))

    \ \ \ \ \ \ \ \ "Website tool")))
  </scm-code>

  We choose labels <scm|"website:src-dir">, <scm|"website:dest-dir">,
  <scm|"website:update-flag"> for the three parameters. The <scm|let>
  initialises local variable with the previous values of the parameters and
  then we invoke <scm|(dialogue-window widget func)>. This procedure takes
  two arguments <scm|widget> and <scm|func>: the first is a
  <with|font-shape|italic|widget> constructed via <scm|tm-widget> and the
  second is a closure which will be passed to the widget. \ The actual widget
  is constructed in the invocation to <scm|(website-widget src dest update?)>
  which returns the executable code which will eventually display the dialog
  in Fig.<nbsp><reference|fig:dialog>.\ 

  This is achieved thanks to a custom description language accessed via the
  <scm|tm-widget> macro.

  <section*|Describing widgets in Scheme>

  The macro <scm|tm-widget> allows to use Scheme forms to construct a wide
  variety of UI elements from a set of basic
  <with|font-shape|italic|primitive> elements. For detailed information
  please refert to <menu|Help|Scheme extensions|Customizing and exending the
  user interface>. Our goal here is to provide an example of how the
  technique described in the help pages apply to our present problem.

  Let us give right away a possibile definition for <scm|(website-widget src
  dest update?)>:

  <\scm-code>
    \;

    (tm-widget ((website-widget src-dir dest-dir update?) \ cmd)

    \ (padded

    \ \ (vertical

    \ \ \ (hlist \<gtr\>\<gtr\>\<gtr\> (text "Website creation tool")
    \<gtr\>\<gtr\>\<gtr\>)

    \ \ \ ===

    \ \ \ (refreshable "website-tool-dialog-source" \ (hlist\ 

    \ \ \ \ \ (text "Source dir \ \ \ \ \ :") // //

    \ \ \ \ \ \ \ (hlist

    \ \ \ \ \ \ \ \ \ (input (when answer (set! src-dir answer))

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "file" (list src-dir) "40em")

    \ \ \ \ \ \ \ \ \ // //

    \ \ \ \ \ \ \ \ \ (explicit-buttons\ 

    \ \ \ \ \ \ \ \ \ \ \ \ ("choose"\ 

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ (cpp-choose-file\ 

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (lambda (u)\ 

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (set! src-dir (url-\<gtr\>string
    u))

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (refresh-now
    "website-tool-dialog-source"))\ 

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "Choose source dir" "directory" ""\ 

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (string-\<gtr\>url src-dir)))))))

    \ \ \ \ ===

    \ \ \ \ (refreshable "website-tool-dialog-dest" \ 

    \ \ \ \ \ \ (hlist\ 

    \ \ \ \ \ \ \ \ (text "Destination dir:") // //

    \ \ \ \ \ \ \ \ (hlist

    \ \ \ \ \ \ \ \ \ \ (input (when answer (set! dest-dir answer))

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "file" (list dest-dir) "40em")

    \ \ \ \ \ \ \ \ \ \ // //

    \ \ \ \ \ \ \ \ \ \ (explicit-buttons\ 

    \ \ \ \ \ \ \ \ \ \ \ \ ("choose"\ 

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (cpp-choose-file\ 

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (lambda (u)\ 

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (set! dest-dir
    (url-\<gtr\>string u))

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (refresh-now
    "website-tool-dialog-dest"))\ 

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "Choose dest dir" "directory" ""\ 

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (string-\<gtr\>url dest-dir)))))))

    \ \ \ \ ===

    \ \ \ \ (hlist

    \ \ \ \ \ \ (text "Update:") //

    \ \ \ \ \ \ (toggle (begin (set! update? answer)\ 

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (refresh-now
    "website-tool-dialog-buttons"))

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ update?))

    \ \ \ \ ===

    \ \ \ \ (refreshable "website-tool-dialog-buttons" \ 

    \ \ \ \ \ \ \ (bottom-buttons \<gtr\>\<gtr\>\<gtr\>

    \ \ \ \ \ \ \ \ \ \ ("Cancel" (cmd #f src-dir dest-dir update?)) // //

    \ \ \ \ \ \ \ \ \ \ (if update?\ 

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ ("Update" (cmd #t src-dir dest-dir update?)))\ 

    \ \ \ \ \ \ \ \ \ \ (if (not update?)\ 

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ ("Create" (cmd #t src-dir dest-dir
    update?))))))))

    \;
  </scm-code>

  \;

  Note that all this should not be understood as
  <with|font-shape|italic|standard> Scheme code: the evaluation rules of
  Scheme are superseded by the macro <scm|tm-widget> which will receive in
  input the description above and will use it to
  <with|font-shape|italic|compile> this description of a widget to a sequence
  of invocation of Scheme procedures. In this way we can provide a high-level
  description of widgets without need to code them in Scheme with all the
  gory details. <scm|tm-widget> will take care of this for us.\ 

  Let us describe the meaning of some of markup tags used above

  <\itemize>
    <item> <scm|(padded ...)> describes a widget which contains other UI
    elements and pad them with some space around;

    <item><scm|(vertical ...)> compose its arguments in a vertical list of UI
    elements;

    <item><scm|(hlist ...)> do the same but horizontally;

    <item><scm|\<gtr\>\<gtr\>\<gtr\>>, <scm|===>, <scm|//> are primitive
    elements (i.e. their definition is complete without referring to other
    content) which indicate various kind of spacing among the sorrounding
    elements;

    <item> <scm|(text "a string")> define a UI element which show the given
    string;

    <item><scm|(refreshable "label" w)> indicates that the widget <scm|w>
    must be refreshed when the procedure <scm|(refresh-now "label")> is
    evaluated. It allow widgets to dynamically change in response to some
    action happening elsewhere in the code.

    <item><scm|(input code "file" (list choice1 choice2 ...) "40em")>
    represents an text input UI element which accepts file names and which
    will have a horizontal size of 40em. The <scm|code> form will be
    evaluated every time the text field change, within that form the symbol
    <scm|answer> refers to the value of the text field, if <scm|answer> is
    <scm|#f> then the evaluation is not a result of an interaction with the
    user, so one has to check for this (It is not clear to me the reasons of
    this design, but it happens to be so, a deeper analysis of
    <scm|tm-widget> inner design would be needed to get a grasp on this).

    <item> <scm|(explicit-buttons ("label1" form1) ("label2" form2) ...)>
    describe a row of buttons with various labels. When they are pushed the
    respective forms are evaluated. For example, in the code above, the first
    button calls the function <scm|cpp-choose-file> with parameters as
    follows:

    <\scm-code>
      (cpp-choose-file\ 

      \ \ \ \ (lambda (u) (set! src-dir (url-\<gtr\>string (url-\<gtr\>string
      u)) \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (refresh-now
      "website-tool-dialog-source"))\ 

      \ \ \ \ "Choose source dir" "directory" ""\ 

      \ \ \ \ (string-\<gtr\>url src-dir))))
    </scm-code>

    This function (implemented in C++) opens the GUI file chooser dialog and
    initiate the modal interaction with the user to ask her a path of kind
    <scm|"directory">. The default directory is given by
    <scm|(string-\<gtr\>url src-dir)>. When the user terminates the dialog
    pressing the \POpen\Q button, then the chosen URL is passed to the
    closure in the variable <scm|u>, we store this value in the <scm|src-dir>
    variable (which is visible in all the syntactic context of
    <scm|(website-widget src-dir dest-dir update?)>, i.e. in the whole
    definition of the widget, and then we invoke <scm|(refresh-now
    "website-tool-dialog-source")> to update the corresponding
    <scm|refreshable> widget, i.e. update the text field with the appropriate
    value.

    <item><scm|(toogle form value)> describes a UI checkbox which takes its
    value from the <scm|value> and which when switched (i.e. toggle its
    state) evaluates the form <scm|form> with the symbol <scm|answer>
    evaluating to the current state of the checkbox.

    <item><scm|(bottom-buttons ...)> describe the buttons which should be
    located in the bottom right corner of the dialog. Typically these are the
    \PCancel\Q and \POk\Q buttons. In our case we want to show a different
    label whether we are going to \PCreate\Q the site or only \PUpdate\Q it.
  </itemize>

  Note the use of the parameter <scm|cmd> which will be passed to
  <scm|(website-widget src-dir dest-dir update?)> by <scm|dialogue-window>.
  That is, <scm|(dialogue-window a b)> expects as its argument <scm|a> a
  closure with one argument (i.e. <scm|(lambda (cmd) ...)>) and <scm|b>
  another closure (with arbitrary many arguments) and upon execution, it call
  the closure <scm|a> with <scm|b> as argument. Therefore in the widget we
  have that <scm|cmd> points to the closure <scm|b>. In our case calling
  <scm|(cmd #t src-dir dest-dir update?)> inside the widget will result in
  the evaluation of the closure

  <\scm-code>
    (lambda (flag src dest update?)\ 

    \ \ \ \ \ \ \ \ \ \ \ (if flag (begin\ 

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ (set-preference "website:src-dir" src)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ (set-preference "website:dest-dir" dest)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ (set-boolean-preference "website:update-flag"
    update?)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ (if update?\ 

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (tmweb-update-dir src dest)

    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (tmweb-convert-dir src dest)))))
  </scm-code>

  with <scm|flag> set to <scm|#t> and with the other three argument set to
  the appropriate values. We can then finalize the interaction by storing
  away the values into the program's preferences and either call
  <scm|tmweb-update-dir> or <scm|tmweb-convert-dir>.

  \;
</body>

<\initial>
  <\collection>
    <associate|page-medium|papyrus>
    <associate|preamble|false>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|auto-1|<tuple|?|?>>
    <associate|auto-2|<tuple|?|?>>
    <associate|auto-3|<tuple|?|?>>
    <associate|auto-4|<tuple|?|?>>
    <associate|auto-5|<tuple|?|?>>
    <associate|auto-6|<tuple|?|?>>
    <associate|auto-7|<tuple|1|?>>
    <associate|auto-8|<tuple|1|?>>
    <associate|auto-9|<tuple|1|?>>
    <associate|fig:dialog|<tuple|1|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|figure>
      <tuple|normal|<\surround|<hidden-binding|<tuple>|1>|>
        The new dialog widget
      </surround>|<pageref|auto-7>>
    </associate>
    <\associate|idx>
      <tuple|<tuple|<with|font-family|<quote|ss>|Tools>|<with|font-family|<quote|ss>|Web>|<with|font-family|<quote|ss>|Create
      web site<hspace|0.3333spc>.<hspace|0.3333spc>.<hspace|0.3333spc>.<hspace|0.3333spc>>>|<pageref|auto-3>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Tools>|<with|font-family|<quote|ss>|Web>|<with|font-family|<quote|ss>|Update
      web site<hspace|0.3333spc>.<hspace|0.3333spc>.<hspace|0.3333spc>.<hspace|0.3333spc>>>|<pageref|auto-4>>

      <tuple|<tuple|<with|font-family|<quote|ss>|File>|<with|font-family|<quote|ss>|Save
      as<hspace|0.3333spc>.<hspace|0.3333spc>.<hspace|0.3333spc>.<hspace|0.3333spc>>>|<pageref|auto-5>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Help>|<with|font-family|<quote|ss>|Scheme
      extensions>|<with|font-family|<quote|ss>|Customizing and exending the
      user interface>>|<pageref|auto-9>>
    </associate>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Adding
      a dialog to build websites> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-1><vspace|0.5fn>

      Generating websites <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2>

      A new interface <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6>

      Describing widgets in Scheme <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-8>
    </associate>
  </collection>
</auxiliary>