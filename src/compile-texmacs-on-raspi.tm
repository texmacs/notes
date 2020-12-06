<TeXmacs|1.99.14>

<style|notes>

<\body>
  <notes-header><chapter*|Compile <TeXmacs> on the Raspberry Pi>

  Unfortunately, there is no prepackaged <TeXmacs> for RaspberryPi OS,
  because of its ARM chipset. Likewise there are no precompiled binaries, but
  it is not hard to do it yourself.

  The following is a step by step guide to install the required tools to
  compile <TeXmacs> yourself from source and install it. Theis guide was
  writte for the latest version of Raspberry Pi OS from December 2020. It
  will work on version 3, 4 and 400 of the RaspberryPi.

  Start by opening a terminal and installing the required components to
  compile by entering:

  <with|color|blue|<code*|sudo apt install build-essential libfreetype-dev
  libltdl-dev libgmp-dev qt4-default qt4-config>>

  Now, that everything is ready to download and build we start by making a
  building directory:

  <with|color|blue|<code*|makedir texmacs-builddir>>

  Change the working directory to it:

  <with|color|blue|<code*|cd texmacs-builddir>>

  <math|<TeXmacs>> depends on a Guile, so we need to build guile first. For
  this enter the following commands. Each step might take some time depending
  on your internet connection and the exact model of the Raspberry Pi.

  <with|color|blue|<\code*>
    <with|color|blue|<code*|>>wget https://ftp.gnu.org/gnu/guile/guile-1.8.8.tar.gz

    <code*|tar xzf guile-1.8.8.tar.gz>

    cd guile-1.8.8

    ./configure --disable-error-on-warning

    make -j 4

    sudo make install
  </code*>>

  The last step will ask for your password to install guile to your system.

  Now, we can go on to get and compile <TeXmacs>

  <with|color|blue|<\code*>
    <with|color|blue|<code*|>>cd ..

    wget www.texmacs.org/Download/ftp/tmftp/source/TeXmacs-1.99.16-src.tar.gz

    tar xzf TeXmacs-1.99.16-src.tar.gz

    cd TeXmacs-1.99.16-src/

    ./configure --enable-qtpipes

    make -j 4

    sudo make install
  </code*>>

  Again the last step will ask for your password.\ 

  Now, you should be able to run <TeXmacs> either from the terminal by
  entering

  <with|color|blue|<code*|texmacs>>

  or from the normal menu.

  \;
</body>

<initial|<\collection>
</collection>>

<\attachments>
  <\collection>
    <\associate|bib-bibliography>
      <\db-entry|+2E9XdEJ4gneMkXs|book|TeXmacs:vdH:book>
        <db-field|contributor|root>

        <db-field|modus|imported>

        <db-field|date|1604849819>
      <|db-entry>
        <db-field|author|J. van der <name|Hoeven>>

        <db-field|title|The Jolly Writer. Your Guide to GNU TeXmacs>

        <db-field|publisher|Scypress>

        <db-field|year|2020>
      </db-entry>
    </associate>
  </collection>
</attachments>

<\references>
  <\collection>
    <associate|auto-1|<tuple|?|?|a-tikz-example.tm>>
    <associate|auto-2|<tuple|?|?|a-tikz-example.tm>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|idx>
      <tuple|<tuple|<with|font-family|<quote|ss>|Insert>|<with|font-family|<quote|ss>|Session>|<with|font-family|<quote|ss>|Graph>>|<pageref|auto-2>>
    </associate>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Example
      of TikZ figure generation with the Graph plugin>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-1><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>