<TeXmacs|2.1.1>

<style|notes>

<\body>
  <\hide-preamble>
    \;
  </hide-preamble>

  <notes-header>

  <chapter*|Standard Output and Standard Error on Microsoft Windows>

  <notes-abstract|We show how to see <TeXmacs>' standard output and standard
  error on Microsoft Windows.>

  [6.1.2021]

  On Windows, <TeXmacs> does not show standard output and standard error:
  neither when it is run from the Command shell nor from the Powershell.

  It is still possible to see standard output and standard error if one
  redirects them to a file. Here is the command that does it for the
  Powershell

  <\verbatim-code>
    Start-Process -FilePath "C:\\Program Files
    (x86)\\TeXmacs\\bin\\texmacs.exe" -RedirectStandardOutput stdout.txt
    -RedirectStandardError stderr.txt
  </verbatim-code>

  to be given in a single Powershell line.

  In this command, one has to substitute for <shell|"C:\\Program Files
  (x86)\\TeXmacs\\bin\\texmacs.exe"> the location of the <TeXmacs> executable
  in their system; <shell|stdout.txt> and <shell|stderr.txt> will be created
  in the current working directory of the Powershell session.
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
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Standard
      Output and Standard Error on Microsoft Windows>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-1><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>