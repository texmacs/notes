<TeXmacs|2.1.1>

<style|notes>

<\body>
  <\hide-preamble>
    \;
  </hide-preamble>

  <notes-header>

  <chapter*|Compiling TeXmacs on Ubuntu 22 with Guile3 and Qt5 >

  <notes-abstract|This guide describes how to compile TeXmacs on Ubuntu 22
  with Guile 3 support and Qt 5.>

  \;

  Guile 1.8.8 is no longer supported on modern distributions. Let us build
  mgubi's Guile3 scheme TeXmacs fork.

  <section|Dependencies>

  You need git to download the sources, cmake and g++ to compile them and
  Guile 3, Qt 5 and freetype as dependencies.

  <\verbatim>
    sudo apt install git cmake g++ guile-3.0 guile-3.0-dev libfreetype-dev\ 

    sudo apt install qtbase5-dev libqt5svg5-dev libfreetype-dev libsqlite-dev
    libjpeg-dev\ 

    sudo apt install libgmp-dev libltdl-dev
  </verbatim>

  <section|Compiling>

  Navigate to the directory where you want TeXmacs' sources to be placed in.

  Clone mgubi's repo and navigate into it.

  <verbatim|git clone https://github.com/mgubi/texmacs.git texmacs-guile3 \ >

  <verbatim|cd \ texmacs-guile3>

  Checkout the Guile 3 branch.

  <verbatim|git checkout guile3>

  Go into the src directory.

  <verbatim|cd src>

  Run the configure command (the first dashes are double dashes -- it is just
  weird HTML rendering \<less\>dash\<gtr\>\<less\>dash\<gtr\>with\<less\>dash\<gtr\>guile2
  etc.).

  .<verbatim|/configure --with-guile2 --enable-guile2>

  Compile TeXmacs.

  <verbatim|make -j4>

  It took me around 2 minutes to compile the sources with -j12. I guess the
  scaling is nonlinear so with -j4 it should take no more than 6 minutes or
  so (just a guess).

  The texmacs binary is placed in <verbatim|\<less\>repodirectory\<gtr\>/src/TeXmacs/bin/texmacs>

  <section|Running>

  To run texmacs you have to setup the <verbatim|TEXMACS_PATH> variable. Run

  <verbatim|export TEXMACS_PATH=\<less\>repodirectory\<gtr\>/src/TeXmacs>

  then you can run \ 

  <verbatim|<verbatim|\<less\>repodirectory\<gtr\>/src/TeXmacs/bin/texmacs>>

  and TeXmacs should start after it compiled its modules. To make
  <verbatim|TEXMACS_PATH> setting persistent, put the command:

  <verbatim|export TEXMACS_PATH=\<less\>repodirectory\<gtr\>/src/TeXmacs>

  into your <verbatim|~/.bashrc>.

  \;

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
    <associate|auto-2|<tuple|1|?>>
    <associate|auto-3|<tuple|2|?>>
    <associate|auto-4|<tuple|3|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Compiling
      TeXmacs on Ubuntu 22 with Guile3 and Qt5 >
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-1><vspace|0.5fn>

      1.<space|2spc>Dependencies <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2>

      2.<space|2spc>Compiling <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3>
    </associate>
  </collection>
</auxiliary>