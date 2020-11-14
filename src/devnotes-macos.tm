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
    <\unfolded-io|Shell] >
      GROUP_DIR=$HOME/texmacs
    <|unfolded-io>
      <timing|52 msec>
    </unfolded-io>

    <\input|Shell] >
      T_HOMEBREW_DIR=$GROUP_DIR/homebrew
    </input>

    <\unfolded-io|Shell] >
      [[ -d "$T_HOMEBREW_DIR" ]] && echo "texmacs/homebrew is cloned" \|\|
      echo "Please clone texmacs/homebrew first"
    <|unfolded-io>
      texmacs/homebrew is cloned
    </unfolded-io>

    <\input|Shell] >
      [[ ! -d $T_HOMEBREW_DIR ]] && git clone
      <code|<code*|git@github.com:texmacs/homebrew.git>> $T_HOMEBREW_DIR
    </input>

    <\input|Shell] >
      [[ ! -d $T_HOMEBREW_DIR ]] && git clone
      https://github.com/texmacs/guile.git $T_HOMEBREW_DIR
    </input>

    <\unfolded-io|Shell] >
      [[ -d $T_HOMEBREW_DIR ]] && echo "texmacs/homebrew is cloned"
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

  <paragraph|Install Qt 4>

  For GNU <TeXmacs> 1.99.15, please use Qt 4 if you want to build and package
  <TeXmacs> by yourself. Qt 4 has been removed in the official homebrew repo.
  We need extra steps to install Qt 4 via <shell|brew>:

  <\session|shell|default>
    <\input>
      Shell]\ 
    <|input>
      brew tap cartr/qt4
    </input>

    <\input|Shell] >
      brew tap-pin <code|cartr/qt4>
    </input>

    <\unfolded-io|Shell] >
      brew install qt@4 \ # will link qt
    <|unfolded-io>
      brew install qt@4 \ # will link qt

      Updating Homebrew...

      [33mWarning:[0m cartr/qt4/qt@4 4.8.7_6 is already installed and
      up-to-date

      To reinstall 4.8.7_6, run `brew reinstall qt@4`
    </unfolded-io>

    <\unfolded-io|Shell] >
      <code*|/usr/local/Cellar/qt@4/4.8.7_6/bin/qmake> --version
    <|unfolded-io>
      /usr/local/Cellar/qt@4/4.8.7_6/bin/qmake --version

      QMake version 2.01a

      Using Qt version 4.8.7 in /usr/local/lib
    </unfolded-io>

    <\input|Shell] >
      \;
    </input>
  </session>

  <paragraph|Switch between Qt 4 and Qt 5>

  Sometimes, we need to keep both Qt 4 and Qt 5 installed by homebrew. To
  switch between Qt 4 and Qt 5:

  <\session|shell|default>
    <\unfolded-io|Shell] >
      qmake --version
    <|unfolded-io>
      qmake --version

      QMake version 2.01a

      Using Qt version 4.8.7 in /usr/local/lib
    </unfolded-io>

    <\unfolded-io|Shell] >
      brew unlink qt@4 && brew link qt --force
    <|unfolded-io>
      brew unlink qt@4 && brew link qt --force

      Unlinking /usr/local/Cellar/qt@4/4.8.7_6... 666 symlinks removed

      Linking /usr/local/Cellar/qt/5.15.0... 510 symlinks created

      \;

      If you need to have this software first in your PATH instead consider
      running:

      \ \ echo 'export PATH="/usr/local/opt/qt/bin:$PATH"' \<gtr\>\<gtr\>
      ~/.zshrc
    </unfolded-io>

    <\unfolded-io|Shell] >
      qmake --version
    <|unfolded-io>
      brew link qt --force

      Linking /usr/local/Cellar/qt/5.15.0... 510 symlinks created

      \;

      If you need to have this software first in your PATH instead consider
      running:

      \ \ echo 'export PATH="/usr/local/opt/qt/bin:$PATH"' \<gtr\>\<gtr\>
      ~/.zshrc
    </unfolded-io>

    <\unfolded-io|Shell] >
      brew unlink qt && brew link qt@4
    <|unfolded-io>
      brew unlink qt && brew link qt@4

      Unlinking /usr/local/Cellar/qt/5.15.0... 510 symlinks removed

      Linking /usr/local/Cellar/qt@4/4.8.7_6... 666 symlinks created
    </unfolded-io>

    <\unfolded-io|Shell] >
      qmake --version
    <|unfolded-io>
      qmake --version

      QMake version 2.01a

      Using Qt version 4.8.7 in /usr/local/lib
    </unfolded-io>

    <\input|Shell] >
      \;
    </input>
  </session>

  If you have trouble on <shell|brew link qt --force> and <shell|brew unlink
  qt>. Make sure that you have installed Qt before using homebrew:

  <\session|shell|default>
    <\input>
      Shell]\ 
    <|input>
      brew install qt
    </input>
  </session>

  <subsubsection*|Install Ghostscript>

  <\session|shell|default>
    <\input>
      Shell]\ 
    <|input>
      brew install ghostscript
    </input>

    <\unfolded-io|Shell] >
      gs --version
    <|unfolded-io>
      gs --version

      9.52
    </unfolded-io>

    <\input|Shell] >
      \;
    </input>
  </session>

  <subsubsection*|Missing dependencies>

  Please tell me by creating PR for any missing dependencies.

  <subsection*|Build>

  <paragraph|Clone <shell|texmacs/texmacs>>and build it

  <\session|shell|default>
    <\unfolded-io|Shell] >
      T_TEXMACS_DIR=$GROUP_DIR/texmacs
    <|unfolded-io>
      <timing|40 msec>
    </unfolded-io>

    <\input|Shell] >
      [[ ! -d $T_TEXMACS_DIR ]] && git clone
      git@github.com:texmacs/texmacs.git $T_TEXMACS_DIR
    </input>

    <\input|Shell] >
      mkdir -p $T_TEXMACS_DIR/build
    </input>

    <\folded-io|Shell] >
      cd $T_TEXMACS_DIR/build && cmake -DQT_QMAKE_EXECUTABLE=/usr/local/Cellar/qt@4/4.8.7_6/bin/qmake
      -DCMAKE_INSTALL_PREFIX=./TeXmacs.app/Contents/Resources ..
    <|folded-io>
      CMake Warning (dev) at /usr/local/Cellar/cmake/3.18.1/share/cmake/Modules/FindPackageHandleStandardArgs.cmake:273
      (message):

      \ \ The package name passed to `find_package_handle_standard_args`
      (SQLITE3)

      \ \ does not match the name of the calling package (SQLite3). \ This
      can lead to

      \ \ problems in calling code that expects `find_package` result
      variables

      \ \ (e.g., `_FOUND`) to follow a certain pattern.

      Call Stack (most recent call first):

      \ \ cmake/FindSQLite3.cmake:26 (FIND_PACKAGE_HANDLE_STANDARD_ARGS)

      \ \ CMakeLists.txt:75 (find_package)

      This warning is for project developers. \ Use -Wno-dev to suppress it.

      \;

      -- Check if we are on a 64-bits computer

      -- \<gtr\>\<gtr\>\<gtr\>\<gtr\>\<gtr\>\<gtr\>\<gtr\>\<gtr\>\<gtr\>/usr/local/lib/libguile.dylib

      -- \<gtr\>\<gtr\>\<gtr\>\<gtr\>\<gtr\>\<gtr\>\<gtr\>\<gtr\>\<gtr\>/usr/local/lib/libgmp.dylib

      -- \<gtr\>\<gtr\>\<gtr\>\<gtr\>\<gtr\>\<gtr\>\<gtr\>\<gtr\>\<gtr\>/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/usr/lib/libm.tbd

      -- \<gtr\>\<gtr\>\<gtr\>\<gtr\>\<gtr\>\<gtr\>\<gtr\>\<gtr\>\<gtr\>/usr/local/lib/libltdl.dylib

      -- Using GUILE_C: 1.8.8

      -- Checking whether ... arguments behave correctly

      -- Performing Test _guile_dots_test

      -- Performing Test _guile_dots_test - Failed

      -- Enabling experimental \ Qt port

      -- Enabling experimental Cocoa port

      CMake Warning (dev) at /usr/local/Cellar/cmake/3.18.1/share/cmake/Modules/FindThreads.cmake:57
      (include):

      \ \ File /usr/local/Cellar/cmake/3.18.1/share/cmake/Modules/FindThreads.cmake

      \ \ includes /Users/rendong/texmacs/texmacs/cmake/CheckCSourceCompiles.cmake

      \ \ (found via CMAKE_MODULE_PATH) which shadows

      \ \ /usr/local/Cellar/cmake/3.18.1/share/cmake/Modules/CheckCSourceCompiles.cmake.

      \ \ This may cause errors later on .

      \;

      \ \ Policy CMP0017 is not set: Prefer files from the CMake module
      directory

      \ \ when including from there. \ Run "cmake --help-policy CMP0017" for
      policy

      \ \ details. \ Use the cmake_policy command to set the policy and
      suppress this

      \ \ warning.

      Call Stack (most recent call first):

      \ \ tests/gtest/googletest/cmake/internal_utils.cmake:65 (find_package)

      \ \ tests/gtest/googletest/CMakeLists.txt:93
      (config_compiler_and_linker)

      This warning is for project developers. \ Use -Wno-dev to suppress it.

      \;

      -- Performing Test CMAKE_HAVE_LIBC_PTHREAD

      -- Performing Test CMAKE_HAVE_LIBC_PTHREAD - Success

      CMake Warning (dev) at /usr/local/Cellar/cmake/3.18.1/share/cmake/Modules/FindThreads.cmake:57
      (include):

      \ \ File /usr/local/Cellar/cmake/3.18.1/share/cmake/Modules/FindThreads.cmake

      \ \ includes /Users/rendong/texmacs/texmacs/cmake/CheckCSourceCompiles.cmake

      \ \ (found via CMAKE_MODULE_PATH) which shadows

      \ \ /usr/local/Cellar/cmake/3.18.1/share/cmake/Modules/CheckCSourceCompiles.cmake.

      \ \ This may cause errors later on .

      \;

      \ \ Policy CMP0017 is not set: Prefer files from the CMake module
      directory

      \ \ when including from there. \ Run "cmake --help-policy CMP0017" for
      policy

      \ \ details. \ Use the cmake_policy command to set the policy and
      suppress this

      \ \ warning.

      Call Stack (most recent call first):

      \ \ tests/gtest/googletest/cmake/internal_utils.cmake:65 (find_package)

      \ \ tests/gtest/googlemock/CMakeLists.txt:70
      (config_compiler_and_linker)

      This warning is for project developers. \ Use -Wno-dev to suppress it.

      \;

      -- Performing Test CMAKE_HAVE_LIBC_PTHREAD

      -- Performing Test CMAKE_HAVE_LIBC_PTHREAD - Success

      -- TeXmacs_Libraries/usr/local/lib/libguile.dylib/usr/local/lib/libgmp.dylib/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/usr/lib/libm.tbd/usr/local/lib/libltdl.dylib/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/usr/lib/libz.tbd/usr/local/lib/libjpeg.dylib/usr/local/lib/libpng.dylib/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/usr/lib/libz.tbd-lpthread/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/usr/lib/libsqlite3.tbd/usr/local/lib/libfreetype.dylib/usr/local/lib/QtGui.framework/usr/local/lib/QtCore.framework-framework
      ApplicationServices-framework CoreFoundation-framework
      Security-framework Carbon-framework AppKit-framework Cocoa-framework
      IOKit-framework CoreGraphics-framework CoreServices-framework
      CoreText-framework Foundation-framework ImageIO

      -- Configuring done

      -- Generating done

      -- Build files have been written to:
      /Users/rendong/texmacs/texmacs/build
    </folded-io>

    <\input|Shell] >
      cd $T_TEXMACS_DIR/build && make -j8 install
    </input>
  </session>

  <paragraph|Test it>

  <\session|shell|default>
    <\input|Shell] >
      cd $T_TEXMACS_DIR/build && ctest
    </input>

    <\unfolded-io|Shell] >
      $T_TEXMACS_DIR/build/TeXmacs.app/Contents/MacOS/TeXmacs --version
    <|unfolded-io>
      \;

      TeXmacs version 1.99.15

      SVN version 1.99.15

      (c) 1999-2020 by Joris van der Hoeven and others

      \;
    </unfolded-io>

    <\unfolded-io|Shell] >
      $T_TEXMACS_DIR/build/TeXmacs.app/Contents/MacOS/TeXmacs --help
    <|unfolded-io>
      \;

      Options for TeXmacs:

      \;

      \ \ -b [file] \ Specify scheme buffers initialization file

      \ \ -c [i] [o] Convert file 'i' into file 'o'

      \ \ -d \ \ \ \ \ \ \ \ For debugging purposes

      \ \ -fn [font] Set the default TeX font

      \ \ -g [geom] \ Set geometry of window in pixels

      \ \ -h \ \ \ \ \ \ \ \ Display this help message

      \ \ -i [file] \ Specify scheme initialization file

      \ \ -p \ \ \ \ \ \ \ \ Get the TeXmacs path

      \ \ -q \ \ \ \ \ \ \ \ Shortcut for -x "(quit-TeXmacs)"

      \ \ -r \ \ \ \ \ \ \ \ Reverse video mode

      \ \ -s \ \ \ \ \ \ \ \ Suppress information messages

      \ \ -S \ \ \ \ \ \ \ \ Rerun TeXmacs setup program before starting

      \ \ -v \ \ \ \ \ \ \ \ Display current TeXmacs version

      \ \ -V \ \ \ \ \ \ \ \ Show some informative messages

      \ \ -x [cmd] \ \ Execute scheme command

      \ \ -Oc \ \ \ \ \ \ \ TeX characters bitmap clipping off

      \ \ +Oc \ \ \ \ \ \ \ TeX characters bitmap clipping on (default)

      \;

      Please report bugs to \<less\>bugs@texmacs.org\<gtr\>

      \;
    </unfolded-io>

    <\unfolded-io|Shell] >
      open $T_TEXMACS_DIR/build # click the app to test it as a user
    <|unfolded-io>
      <timing|137 msec>
    </unfolded-io>

    <\input|Shell] >
      \;
    </input>
  </session>

  <paragraph|Use ccache for faster build>

  Toggle the menu entry <menu|Focus|Output options|Show timings> as checked.

  <\session|shell|default>
    <\unfolded-io|Shell] >
      sleep 2
    <|unfolded-io>
      <timing|2.015 sec>
    </unfolded-io>

    <\input|Shell] >
      \;
    </input>
  </session>

  Execute the sleep command, and you will find the timings are listed on the
  right side.

  Compile <TeXmacs> without or with ccache, the elapse time should be reduced
  with ccache.

  <\session|shell|default>
    <\input|Shell] >
      cd $T_TEXMACS_DIR/build && make -j8
    </input>

    <\input|Shell] >
      brew install ccache
    </input>

    <\unfolded-io|Shell] >
      ccache --version
    <|unfolded-io>
      ccache version 3.7.11

      \;

      Copyright (C) 2002-2007 Andrew Tridgell

      Copyright (C) 2009-2020 Joel Rosdahl

      \;

      This program is free software; you can redistribute it and/or modify it
      under

      the terms of the GNU General Public License as published by the Free
      Software

      Foundation; either version 3 of the License, or (at your option) any
      later

      version.

      <timing|40 msec>
    </unfolded-io>

    <\input|Shell] >
      cd $T_TEXMACS_DIR/build && make -j8
    </input>
  </session>

  As long as ccache is available, CMake will use it to boost the compilation.

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
    <associate|auto-14|<tuple|1|?>>
    <associate|auto-15|<tuple|2|?>>
    <associate|auto-16|<tuple|2|?>>
    <associate|auto-17|<tuple|2|?>>
    <associate|auto-18|<tuple|2|?>>
    <associate|auto-19|<tuple|1|?>>
    <associate|auto-2|<tuple|?|1>>
    <associate|auto-20|<tuple|2|?>>
    <associate|auto-21|<tuple|3|?>>
    <associate|auto-22|<tuple|3|?>>
    <associate|auto-23|<tuple|3|?>>
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
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Devnotes
      on macOS> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
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

      <with|par-left|<quote|4tab>|Install Qt 4
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-14><vspace|0.15fn>>

      <with|par-left|<quote|4tab>|Switch between Qt 4 and Qt 5
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-15><vspace|0.15fn>>

      <with|par-left|<quote|2tab>|Install Ghostscript
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-16>>

      <with|par-left|<quote|2tab>|Missing dependencies
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-17>>

      <with|par-left|<quote|1tab>|Build <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-18>>

      <with|par-left|<quote|4tab>|Clone <with|mode|<quote|prog>|prog-language|<quote|shell>|font-family|<quote|rm>|texmacs/texmacs>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-19><vspace|0.15fn>>

      \ <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-20>
    </associate>
  </collection>
</auxiliary>