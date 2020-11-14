<TeXmacs|1.99.15>

<style|<tuple|notes|british>>

<\body>
  <notes-header>

  <chapter*|Devnotes on macOS>

  <notes-abstract|This article serves as a guide for <TeXmacs> contributors
  and developers using macOS. We talk about how to build, test, package GNU
  <TeXmacs> on macOS.>

  <section*|Build using CMake>

  Here is a detailed guide to build GNU <TeXmacs> using CMake and Homebrew.

  <subsection*|Install build tools and necessary dependencies>

  <subsubsection*|Install Homebrew and build essentials>

  Homebrew is a package manger for macOS. Typically, we install Homebrew
  first, and then use the <shell|brew> command line to install build tools
  and dependencies to build <TeXmacs>.

  Xcode Command Line Tools provide the C/C++ compiler. It is required.
  <TeXmacs> can not be built without a C/C++ compiler. And <TeXmacs> is
  designed to be customizable using Scheme. If you want to be a power user of
  <TeXmacs> but not want to compile <TeXmacs>, please browse the built-in
  documents under <menu|Help|Scheme extensions>.

  The rest part of this guide is maintained in a Shell session
  (<menu|Insert|Session|Shell>). Yes, if you are browsing this guide using
  <TeXmacs>, the commands can be executed.

  <paragraph|Check Homebrew installation>

  <\session|shell|default>
    <\unfolded-io|Shell] >
      brew --version
    <|unfolded-io>
      Homebrew 2.5.6-82-g6d8978e

      Homebrew/homebrew-core (git revision b86ad9; last commit 2020-08-01)

      Homebrew/homebrew-cask (git revision 1ce1c7; last commit 2020-10-20)
    </unfolded-io>

    <\unfolded-io|Shell] >
      alias install="brew install -q"
    <|unfolded-io>
      alias install="brew install -q"
    </unfolded-io>

    <\input|Shell] >
      \;
    </input>
  </session>

  <paragraph|Check Xcode Command Line Tools installation>

  <\session|shell|default>
    <\unfolded-io|Shell] >
      $(xcode-select --print-path)/usr/bin/cc --version
    <|unfolded-io>
      Apple clang version 11.0.0 (clang-1100.0.33.8)

      Target: x86_64-apple-darwin19.2.0

      Thread model: posix

      InstalledDir: /Library/Developer/CommandLineTools/usr/bin
    </unfolded-io>

    <\input|Shell] >
      \;
    </input>
  </session>

  <paragraph|Install CMake and check>

  <\session|shell|default>
    <\unfolded-io|Shell] >
      brew install cmake
    <|unfolded-io>
      brew install cmake

      [31mError:[0m Unknown command: -q
    </unfolded-io>

    <\unfolded-io|Shell] >
      cmake --version
    <|unfolded-io>
      cmake version 3.18.1

      \;

      CMake suite maintained and supported by Kitware (kitware.com/cmake).
    </unfolded-io>

    <\input|Shell] >
      \;
    </input>
  </session>

  <subsubsection*|Install GNU Guile 1.8>

  <paragraph|Clone <shell|texmacs/homebrew>>

  <\session|shell|default>
    <\input|Shell] >
      GROUP_DIR=$HOME/texmacs
    </input>

    <\input|Shell] >
      T_HOMEBREW_DIR=$GROUP_DIR/homebrew
    </input>

    <\unfolded-io|Shell] >
      [[ -ne $T_HOMEBREW_DIR ]] && echo "Please clone texmacs/homebrew first"
    <|unfolded-io>
      Please clone texmacs/homebrew first
    </unfolded-io>

    <\folded-io|Shell] >
      [[ -ne $T_HOMEBREW_DIR ]] && git clone
      <code|<code*|git@github.com:texmacs/homebrew.git>> $T_HOMEBREW_DIR
    <|folded-io>
      Cloning into '/Users/rendong/texmacs/homebrew'...

      remote: Enumerating objects: 6, done. \ \ \ \ \ \ \ 

      remote: Total 6 (delta 0), reused 0 (delta 0), pack-reused 6
      \ \ \ \ \ \ \ 

      Receiving objects: \ 16% (1/6) \ \ 

      Receiving objects: \ 33% (2/6) \ \ 

      Receiving objects: \ 50% (3/6) \ \ 

      Receiving objects: \ 66% (4/6) \ \ 

      Receiving objects: \ 83% (5/6) \ \ 

      Receiving objects: 100% (6/6) \ \ 

      Receiving objects: 100% (6/6), done.

      Resolving deltas: \ \ 0% (0/1) \ \ 

      Resolving deltas: 100% (1/1) \ \ 

      Resolving deltas: 100% (1/1), done.
    </folded-io>

    <\folded-io|Shell] >
      [[ -ne $T_HOMEBREW_DIR ]] && git clone
      https://github.com/texmacs/guile.git $T_HOMEBREW_DIR
    <|folded-io>
      fatal: destination path '/Users/rendong/texmacs/homebrew' already
      exists and is not an empty directory.
    </folded-io>

    <\unfolded-io|Shell] >
      [[ -ne $T_HOMEBREW_DIR ]] && echo "texmacs/homebrew is cloned"
    <|unfolded-io>
      texmacs/homebrew is cloned
    </unfolded-io>

    <\input|Shell] >
      \;
    </input>
  </session>

  <paragraph|Install guile 1.8 using <shell|brew>>

  <\session|shell|default>
    <\input|Shell] >
      cd $T_HOMEBREW_DIR && brew install guile@1.8.rb
    </input>
  </session>

  <subsubsection*|Install Qt>

  \;

  \;

  <section*|>

  \;

  \;
</body>

<\initial>
  <\collection>
    <associate|page-medium|papyrus>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|auto-1|<tuple|?|1>>
    <associate|auto-10|<tuple|3|2>>
    <associate|auto-11|<tuple|1|2>>
    <associate|auto-12|<tuple|2|2>>
    <associate|auto-13|<tuple|2|2>>
    <associate|auto-14|<tuple|2|?>>
    <associate|auto-2|<tuple|?|1>>
    <associate|auto-3|<tuple|?|1>>
    <associate|auto-4|<tuple|?|1>>
    <associate|auto-5|<tuple|?|1>>
    <associate|auto-6|<tuple|?|1>>
    <associate|auto-7|<tuple|1|1>>
    <associate|auto-8|<tuple|2|1>>
    <associate|auto-9|<tuple|3|2>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|idx>
      <tuple|<tuple|<with|font-family|<quote|ss>|Help>|<with|font-family|<quote|ss>|Scheme
      extensions>>|<pageref|auto-5>>

      <tuple|<tuple|<with|font-family|<quote|ss>|Insert>|<with|font-family|<quote|ss>|Session>|<with|font-family|<quote|ss>|Shell>>|<pageref|auto-6>>
    </associate>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-1><vspace|0.5fn>

      Build using CMake <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2>

      <with|par-left|<quote|1tab>|Install build tools and necessary
      dependencies <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3>>

      <with|par-left|<quote|2tab>|Install Homebrew and build essentials
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4>>

      <with|par-left|<quote|4tab>|Check Homebrew installation
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-7><vspace|0.15fn>>

      <with|par-left|<quote|4tab>|Check Xcode Command Line Tools installation
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-8><vspace|0.15fn>>

      <with|par-left|<quote|4tab>|Install CMake and check
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-9><vspace|0.15fn>>

      <with|par-left|<quote|2tab>|Install GNU Guile 1.8
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-10>>

      <with|par-left|<quote|4tab>|Clone <with|mode|<quote|prog>|prog-language|<quote|shell>|font-family|<quote|rm>|texmacs/homebrew>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-11><vspace|0.15fn>>

      <with|par-left|<quote|4tab>|Install guile 1.8 using
      <with|mode|<quote|prog>|prog-language|<quote|shell>|font-family|<quote|rm>|brew>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-12><vspace|0.15fn>>

      <with|par-left|<quote|2tab>|Install Qt
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-13>>

      \ <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-14>
    </associate>
  </collection>
</auxiliary>