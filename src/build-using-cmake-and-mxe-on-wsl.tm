<TeXmacs|2.1>

<style|<tuple|generic|chinese|notes>>

<\body>
  <\hide-preamble>
    \;

    <assign|section-sep|<macro|<the-section><sectional-sep>>>
  </hide-preamble>

  <notes-header><chapter*|Build <TeXmacs> using CMake and MXE on WSL for
  Windows >

  There are three major steps to build <TeXmacs> on WSL:

  <section*|Step 1. Install Ubuntu on Windows 10>

  Ubuntu is available in the Windows Store. Just click to install it. You may
  first need to install WSL as described <hlink|here|https://docs.microsoft.com/en-us/windows/wsl/install>.
  When running Ubuntu for the first time, you will be prompted to provide a
  username and a password for the installed Ubuntu on Windows. The following
  steps should be executed inside the newly-installed Ubuntu.

  <section|Step 2. Install MXE>

  <subsection*|Download the source code of MXE to
  <shell|$HOME/github/mxe/mxe>>

  <\shell-code>
    mkdir -p $HOME/github/mxe/

    cd $HOME/github/mxe/

    git clone https://github.com/mxe/mxe.git
  </shell-code>

  <subsection*|Install dependencies for MXE>

  <\shell-code>
    sudo apt update

    \;

    sudo apt install autoconf automake autopoint bash \\

    \ bison bzip2 flex g++ g++-multilib gettext git gperf \\

    \ intltool libgdk-pixbuf2.0-dev libltdl-dev libssl-dev \\

    \ libtool-bin libxml-parser-perl lzip make openssl \\

    \ p7zip-full patch perl python ruby sed unzip wget xz-utils \\

    \ python3-mako libc6-dev-i386-cross
  </shell-code>

  <subsection*|Build qtbase and guile using MXE>

  <\shell-code>
    export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

    make qtbase qtsvg guile dlfcn-win32 # use -jN (-j8/-j12) to speed up
  </shell-code>

  <section|Step 3: Build GNU <TeXmacs>>

  <\shell-code>
    export PATH=$PATH:$HOME/github/mxe/mxe/usr/bin

    \;

    # Download the source code

    mkdir -p $HOME/github/texmacs/

    cd $HOME/github/texmacs/

    git clone https://github.com/texmacs/texmacs.git

    \;

    # Build

    mkdir build && cd build/

    i686-w64-mingw32.static-cmake .. \\

    \ \ -DCMAKE_INSTALL_PREFIX=$HOME/win \\

    \ \ -DQT_CMAKE_DIR=$HOME/github/mxe/mxe/usr/i686-w64-mingw32.static/qt5/lib/cmake/

    make -j4 && make install -j4

    \;

    # Move the built result to the Documents folder

    cp -r $HOME/github/mxe/mxe/usr/i686-w64-mingw32.static/share/guile/1.8/ice-9/
    $HOME/win/progs/

    mv $HOME/win /mnt/c/Users/xxxx/Documents/texmacs_build_`date +%Y%m%d%H`

    \;

    # please replace xxxx with your Windows user name
  </shell-code>

  To launch the built <TeXmacs>, just click the <shell|bin/texmacs.exe>.

  NOTICE: This is a build guide but not a package guide, the binary
  dependencies (wget.exe/gs.exe/<text-dots>) of a <TeXmacs> Windows
  installation are not automatically prepared in the <shell|bin/> for GNU
  <TeXmacs> v2.1.

  \;
</body>

<\initial>
  <\collection>
    <associate|page-medium|paper>
    <associate|prog-scripts|python>
    <associate|section-display-numbers|false>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|auto-1|<tuple|?|1>>
    <associate|auto-2|<tuple|?|1>>
    <associate|auto-3|<tuple|1|1>>
    <associate|auto-4|<tuple|1|1>>
    <associate|auto-5|<tuple|1|1>>
    <associate|auto-6|<tuple|1|2>>
    <associate|auto-7|<tuple|2|2>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Build
      T<rsub|<space|-0.4spc><move|<resize|<with|math-level|<quote|0>|E>||||0.5fn>|0fn|-0.1fn>><space|-0.4spc>X<rsub|<space|-0.4spc><move|<resize|M<space|-0.2spc>A<space|-0.4spc>CS||||0.5fn>|0fn|-0.1fn>>
      using CMake and MXE on WSL for Windows >
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-1><vspace|0.5fn>

      Step 1. Install Ubuntu 18.04 on Windows 10
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2>

      Step 2. Install MXE <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3>

      <with|par-left|<quote|1tab>|Download the source code of MXE to
      <with|mode|<quote|prog>|prog-language|<quote|shell>|<with|font|<quote|roman>|font-family|<quote|tt>|magnification|<quote|1.06>|$HOME/github/mxe/mxe>>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4>>

      <with|par-left|<quote|1tab>|Install dependencies for MXE
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-5>>

      <with|par-left|<quote|1tab>|Build qtbase and guile using MXE
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6>>

      Step 3: Build GNU T<rsub|<space|-0.4spc><move|<resize|<with|math-level|<quote|0>|E>||||0.5fn>|0fn|-0.1fn>><space|-0.4spc>X<rsub|<space|-0.4spc><move|<resize|M<space|-0.2spc>A<space|-0.4spc>CS||||0.5fn>|0fn|-0.1fn>>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-7>
    </associate>
  </collection>
</auxiliary>