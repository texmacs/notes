<TeXmacs|1.99.18>

<style|notes>

<\body>
  <\hide-preamble>
    \;
  </hide-preamble>

  <notes-header>

  <chapter*|Scheming>

  <notes-abstract|We discuss some aspects of the choice of the Scheme
  language implementation used in <TeXmacs>.>

  [6.1.2021]

  In <TeXmacs> we use <hlink|GNU Guile|https://www.gnu.org/software/guile/>
  version 1.8 as embedded Scheme interpreter. Lately, this has been a source
  of problems, mostly related to packaging. On one hand Guile<nbsp>1.8 is no
  more supported in standard Linux distributions. This implies that we have
  either to ship Guile in our codebase or maintain a private repository for
  Guile<nbsp>1.8. On the other hand more recent versions of Guile compile the
  sources to bytecode and introduce a separated expansion and evaluation
  phases which break part of our codebase. Moreover while Guile<nbsp>2 has a
  fine compiler, it has been for some time quite slow in interpreting code
  and only recently with the introduction of a JIT compiler in Guile<nbsp>3
  the interpreted code runs as fast as in Guile<nbsp>1.8. Finally we have
  some difficulties in compiling Guile<nbsp>2 on Windows and Guile<nbsp>3
  seems not yet be supported there. The <hlink|GNU
  Lilypond|http://lilypond.org> project seems to have run into similar issues
  with Guile and they also remained with Guile 1.8.8 (see
  <hlink|here|http://lilypond.org/doc/v2.21/Documentation/contributor/requirements-for-running-lilypond>).

  This situation is not very nice and we would like to move forward and
  remove these problems. Therefore we are currently evaluating various
  possible strategies to evolve the way we run Scheme code within <TeXmacs>.
  The following are the criteria we want to take into account.

  <\itemize-dot>
    <item>We use Scheme as an extension language to run on top of the GUI and
    the typesetting code in order to implement the dynamical and programmable
    UI. Additionally, if the implementation speed allows we can shift some of
    the conversion code in Scheme. We have C++ at our disposal anyway so we
    can always drop there for speed-critical tasks, but is nicer to be able
    to write Scheme code instead of C++.

    <item><TeXmacs> already needs a huge library like <name|Qt> in order to
    be cross-platform, so in this respect we would like not to carry over a
    huge all-purpose Scheme implementation which would come with all its own
    libraries dependencies (e.g. Guile needs GMP).

    <item>We need to be cross-platform so we would like to minimize the
    problem related to porting the Scheme implementation on the various OSs
    and architectures.

    <item>Guile 1.8 speed is OK so far. However we cannot loose performance
    (especially at boot time and for standard operations like moving the
    cursor around). We could even hope to gain some speed by using an
    alternative implementation.

    <item>TeXmacs do not currently use Unicode for its internal string
    representations but a custom formate (TeXmacs universal representation),
    so marshaling data to Unicode-aware Schemes is a mildly issue for us.
  </itemize-dot>

  As for the available alternatives, the situation so far is the following.

  <\itemize-dot>
    <item>An easy choice would be to just integrate in our codebase the
    sources of Guile 1.8 (which is not more maintained) in <TeXmacs>. This
    would not require changes to our scheme code. However the packaging
    problems remains, moreover there are large portions of the library we do
    not use.\ 

    <item>We can go with Guile<nbsp>3 and get the nice speed improvement
    wrt.<nbsp>1.8. See <hlink|here|https://www.wingolog.org/archives/2020/06/03/a-baseline-compiler-for-guile>
    for some updates on the development of Guile. This will require more or
    less extensive changes to our Scheme code. These changes are been
    implemented in a git development branch and so far the situation seems
    promising. One drawback of this choice is the fact that support for
    platforms like Windows is not the primary goal of the Guile developers
    (as far as we understand) and also that Guile is become a large
    standalone scheme with many library dependencies, far from its origin as
    <with|font-shape|italic|extension language>. So the benefits of the
    compiler should be weighted against the difficulty of packaging and also
    the stability of the cross-platform support. Also Guile<nbsp>2/3 has
    encoding-aware strings which poses a (small) problem for us and would
    require some hackery to get around.

    <item>An attractive option is to switch to another small, embeddable
    Scheme interpreter like <hlink|<name|Chibi>
    Scheme|https://github.com/ashinn/chibi-scheme/> or <hlink|S7
    Scheme|https://cm-gitlab.stanford.edu/bil/s7.git>. For performance
    reasons it seems that the clear winner for us is S7 which is a very
    compact interpreter written in C with no external dependencies. We are
    currently experimenting in integrating S7 with TeXmacs and we have a
    working development branch (with still some issue).

    <item>A radical alternative is to consider the embedding of a
    full-fledged Scheme compiler. By looking at the multitude of Scheme
    implementations around we singled out <hlink|<name|Chez
    Scheme>|https://github.com/cisco/chezscheme> as a compiled system which
    seems flexible enough to be able to be embedded in our setting. Its main
    features are: compactness, speed, industrial quality, open-source (Apache
    2.0), cross-platform and with no external dependencies. (For an
    interesting history of this implementation refer to <hlink|this
    paper|http://www.cs.indiana.edu/~dyb/pubs/hocs.pdf>.)
  </itemize-dot>

  The development branches of <TeXmacs> for Guile 3 and S7 can be found here:

  <\itemize-dot>
    <item><slink|https://github.com/mgubi/texmacs/tree/s7/src>

    <item><slink|https://github.com/mgubi/texmacs/tree/guile3/src>
  </itemize-dot>

  We performed some test of these alternative implementations to help us make
  a preliminary picture. We used some standard R7RS benchmarks found
  <hlink|here|https://github.com/ecraven/r7rs-benchmarks> and we got the
  results shown below on a MacBook Air (2019). They show that S7 is
  consistently the fastest interpreter wrt. Chibi or Guile 1.8. We also see
  that, as expected, Chez is among the fastest implementations available with
  consistent timings all across the benchmarks.

  We currently have working implementations of TeXmacs with Guile 1.8, S7 and
  Guile 3.0.4 and what we see from preliminary tests is that boot time of S7
  is comparable to that of Guile 3.0.4 (0.4 sec) and half of that of Guile
  1.8 (0.8 sec). Also compile the full manual require the roughly the same
  time to all the three implementations (~15 sec). We would need to consider
  more intensive tests to discriminate the tradeoffs in performances of the
  various choices.

  Here are the results of the R7RS benchmarks. The symbol \<varnothing\>
  denotes that the program exceeded a conventional time limit and was
  interrupted.

  <\with|par-mode|center>
    <small|<tabular|<tformat|<twith|table-hmode|min>|<twith|table-width|1par>|<cwith|1|-1|1|-1|cell-hyphen|t>|<cwith|1|9|1|1|cell-bsep|0.3em>|<cwith|1|9|1|1|cell-tsep|0.3em>|<cwith|1|-1|1|-1|cell-tborder|0.5ln>|<cwith|1|-1|1|-1|cell-bborder|0.5ln>|<cwith|1|-1|1|-1|cell-lborder|0ln>|<cwith|1|-1|1|-1|cell-rborder|0ln>|<cwith|1|1|1|-1|cell-tborder|0ln>|<cwith|1|1|1|-1|cell-bborder|0.5ln>|<cwith|2|2|1|-1|cell-tborder|0.5ln>|<cwith|1|1|1|1|cell-lborder|0ln>|<cwith|1|1|6|6|cell-rborder|0ln>|<table|<row|<\cell>
      <with|font-series|bold|test>
    </cell>|<\cell>
      <with|font-series|bold|s7>
    </cell>|<\cell>
      <with|font-series|bold|chibi 0.9.1>
    </cell>|<\cell>
      <with|font-series|bold|chez 9.5.1>
    </cell>|<\cell>
      <with|font-series|bold|guile 1.8.8>
    </cell>|<\cell>
      <with|font-series|bold|guile 3.0.4>
    </cell>>|<row|<\cell>
      browse:2000
    </cell>|<\cell>
      24.27
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      0.84
    </cell>|<\cell>
      76.63
    </cell>|<\cell>
      12.06
    </cell>>|<row|<\cell>
      deriv:10000000
    </cell>|<\cell>
      25.19
    </cell>|<\cell>
      97.11
    </cell>|<\cell>
      1.15
    </cell>|<\cell>
      67.27
    </cell>|<\cell>
      18.58
    </cell>>|<row|<\cell>
      destruc:600:50:4000
    </cell>|<\cell>
      52.08
    </cell>|<\cell>
      94.90
    </cell>|<\cell>
      2.21
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      7.14
    </cell>>|<row|<\cell>
      diviter:1000:1000000
    </cell>|<\cell>
      9.69
    </cell>|<\cell>
      55.88
    </cell>|<\cell>
      1.81
    </cell>|<\cell>
      82.75
    </cell>|<\cell>
      15.45
    </cell>>|<row|<\cell>
      divrec:1000:1000000
    </cell>|<\cell>
      11.80
    </cell>|<\cell>
      50.91
    </cell>|<\cell>
      2.19
    </cell>|<\cell>
      82.04
    </cell>|<\cell>
      17.41
    </cell>>|<row|<\cell>
      puzzle:1000
    </cell>|<\cell>
      27.72
    </cell>|<\cell>
      270.98
    </cell>|<\cell>
      1.66
    </cell>|<\cell>
      221.49
    </cell>|<\cell>
      18.09
    </cell>>|<row|<\cell>
      triangl:22:1:50
    </cell>|<\cell>
      33.93
    </cell>|<\cell>
      110.86
    </cell>|<\cell>
      1.91
    </cell>|<\cell>
      107.15
    </cell>|<\cell>
      8.52
    </cell>>|<row|<\cell>
      tak:40:20:11:1
    </cell>|<\cell>
      12.93
    </cell>|<\cell>
      55.19
    </cell>|<\cell>
      1.66
    </cell>|<\cell>
      134.21
    </cell>|<\cell>
      4.76
    </cell>>|<row|<\cell>
      takl:40:20:12:1
    </cell>|<\cell>
      20.97
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      3.71
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      9.46
    </cell>>|<row|<\cell>
      ntakl:40:20:12:1
    </cell>|<\cell>
      17.07
    </cell>|<\cell>
      95.98
    </cell>|<\cell>
      3.65
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      9.52
    </cell>>|<row|<\cell>
      cpstak:40:20:11:1
    </cell>|<\cell>
      103.36
    </cell>|<\cell>
      222.13
    </cell>|<\cell>
      4.21
    </cell>|<\cell>
      258.62
    </cell>|<\cell>
      59.44
    </cell>>|<row|<\cell>
      ctak:32:16:8:1
    </cell>|<\cell>
      44.14
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      0.96
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>>|<row|<\cell>
      fib:40:5
    </cell>|<\cell>
      10.22
    </cell>|<\cell>
      96.25
    </cell>|<\cell>
      3.63
    </cell>|<\cell>
      236.65
    </cell>|<\cell>
      12.09
    </cell>>|<row|<\cell>
      fibc:30:10
    </cell>|<\cell>
      25.80
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      0.71
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>>|<row|<\cell>
      fibfp:35.0:10
    </cell>|<\cell>
      1.89
    </cell>|<\cell>
      42.79
    </cell>|<\cell>
      3.18
    </cell>|<\cell>
      56.26
    </cell>|<\cell>
      22.00
    </cell>>|<row|<\cell>
      sum:10000:200000
    </cell>|<\cell>
      6.64
    </cell>|<\cell>
      99.79
    </cell>|<\cell>
      3.59
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      6.87
    </cell>>|<row|<\cell>
      sumfp:1000000.0:500
    </cell>|<\cell>
      2.50
    </cell>|<\cell>
      85.36
    </cell>|<\cell>
      4.25
    </cell>|<\cell>
      111.78
    </cell>|<\cell>
      42.06
    </cell>>|<row|<\cell>
      fft:65536:100
    </cell>|<\cell>
      32.20
    </cell>|<\cell>
      69.76
    </cell>|<\cell>
      3.32
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      7.69
    </cell>>|<row|<\cell>
      mbrot:75:1000
    </cell>|<\cell>
      24.40
    </cell>|<\cell>
      209.51
    </cell>|<\cell>
      5.39
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      50.09
    </cell>>|<row|<\cell>
      mbrotZ:75:1000
    </cell>|<\cell>
      18.56
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      9.26
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      67.01
    </cell>>|<row|<\cell>
      nucleic:50
    </cell>|<\cell>
      19.95
    </cell>|<\cell>
      79.05
    </cell>|<\cell>
      2.59
    </cell>|<\cell>
      69.32
    </cell>|<\cell>
      15.35
    </cell>>|<row|<\cell>
      pi
    </cell>|<\cell>
      \U
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      0.60
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      0.56
    </cell>>|<row|<\cell>
      pnpoly:1000000
    </cell>|<\cell>
      17.98
    </cell>|<\cell>
      253.84
    </cell>|<\cell>
      4.73
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      24.89
    </cell>>|<row|<\cell>
      ray:50
    </cell>|<\cell>
      20.46
    </cell>|<\cell>
      119.63
    </cell>|<\cell>
      2.83
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      18.51
    </cell>>|<row|<\cell>
      simplex:1000000
    </cell>|<\cell>
      46.34
    </cell>|<\cell>
      182.76
    </cell>|<\cell>
      2.34
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      13.90
    </cell>>|<row|<\cell>
      ack:3:12:2
    </cell>|<\cell>
      10.57
    </cell>|<\cell>
      74.51
    </cell>|<\cell>
      3.12
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      8.41
    </cell>>|<row|<\cell>
      array1:1000000:500
    </cell>|<\cell>
      11.48
    </cell>|<\cell>
      64.18
    </cell>|<\cell>
      8.16
    </cell>|<\cell>
      138.45
    </cell>|<\cell>
      9.24
    </cell>>|<row|<\cell>
      string:500000:100
    </cell>|<\cell>
      1.71
    </cell>|<\cell>
      6.34
    </cell>|<\cell>
      6.54
    </cell>|<\cell>
      1.81
    </cell>|<\cell>
      1.87
    </cell>>|<row|<\cell>
      sum1:25
    </cell>|<\cell>
      0.47
    </cell>|<\cell>
      121.78
    </cell>|<\cell>
      2.02
    </cell>|<\cell>
      1.71
    </cell>|<\cell>
      4.43
    </cell>>|<row|<\cell>
      cat:50
    </cell>|<\cell>
      1.19
    </cell>|<\cell>
      70.95
    </cell>|<\cell>
      2.69
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      28.40
    </cell>>|<row|<\cell>
      tail:50
    </cell>|<\cell>
      1.19
    </cell>|<\cell>
      11.21
    </cell>|<\cell>
      3.57
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      9.82
    </cell>>|<row|<\cell>
      wc:inputs/bib:50
    </cell>|<\cell>
      8.27
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      1.76
    </cell>|<\cell>
      73.34
    </cell>|<\cell>
      16.96
    </cell>>|<row|<\cell>
      read1:2500
    </cell>|<\cell>
      0.41
    </cell>|<\cell>
      281.23
    </cell>|<\cell>
      1.28
    </cell>|<\cell>
      2.69
    </cell>|<\cell>
      5.80
    </cell>>|<row|<\cell>
      compiler:2000
    </cell>|<\cell>
      41.16
    </cell>|<\cell>
      115.83
    </cell>|<\cell>
      2.99
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      5.15
    </cell>>|<row|<\cell>
      conform:500
    </cell>|<\cell>
      51.03
    </cell>|<\cell>
      199.42
    </cell>|<\cell>
      2.10
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      10.51
    </cell>>|<row|<\cell>
      dynamic:500
    </cell>|<\cell>
      22.74
    </cell>|<\cell>
      288.25
    </cell>|<\cell>
      4.01
    </cell>|<\cell>
      71.60
    </cell>|<\cell>
      7.37
    </cell>>|<row|<\cell>
      earley
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      5.03
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      9.49
    </cell>>|<row|<\cell>
      graphs:7:3
    </cell>|<\cell>
      127.61
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      2.27
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      23.03
    </cell>>|<row|<\cell>
      lattice:44:10
    </cell>|<\cell>
      139.28
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      3.91
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      15.94
    </cell>>|<row|<\cell>
      matrix:5:5:2500
    </cell>|<\cell>
      72.07
    </cell>|<\cell>
      214.16
    </cell>|<\cell>
      1.63
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      9.88
    </cell>>|<row|<\cell>
      maze:20:7:10000
    </cell>|<\cell>
      23.26
    </cell>|<\cell>
      84.15
    </cell>|<\cell>
      1.66
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      4.70
    </cell>>|<row|<\cell>
      mazefun:11:11:10000
    </cell>|<\cell>
      19.51
    </cell>|<\cell>
      122.02
    </cell>|<\cell>
      2.86
    </cell>|<\cell>
      128.66
    </cell>|<\cell>
      9.66
    </cell>>|<row|<\cell>
      nqueens:13:10
    </cell>|<\cell>
      55.11
    </cell>|<\cell>
      165.25
    </cell>|<\cell>
      4.99
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      19.37
    </cell>>|<row|<\cell>
      paraffins:23:10
    </cell>|<\cell>
      31.42
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      5.97
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      4.25
    </cell>>|<row|<\cell>
      parsing:2500
    </cell>|<\cell>
      39.44
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      3.35
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      10.69
    </cell>>|<row|<\cell>
      peval:2000
    </cell>|<\cell>
      29.68
    </cell>|<\cell>
      177.10
    </cell>|<\cell>
      2.05
    </cell>|<\cell>
      107.05
    </cell>|<\cell>
      15.64
    </cell>>|<row|<\cell>
      primes:1000:10000
    </cell>|<\cell>
      7.73
    </cell>|<\cell>
      21.08
    </cell>|<\cell>
      2.64
    </cell>|<\cell>
      43.73
    </cell>|<\cell>
      7.52
    </cell>>|<row|<\cell>
      quicksort:10000:2500
    </cell>|<\cell>
      94.00
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      3.90
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      13.25
    </cell>>|<row|<\cell>
      scheme:100000
    </cell>|<\cell>
      71.46
    </cell>|<\cell>
      154.36
    </cell>|<\cell>
      2.55
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      15.14
    </cell>>|<row|<\cell>
      slatex:500
    </cell>|<\cell>
      32.07
    </cell>|<\cell>
      173.60
    </cell>|<\cell>
      3.73
    </cell>|<\cell>
      43.82
    </cell>|<\cell>
      45.05
    </cell>>|<row|<\cell>
      chudnovsky
    </cell>|<\cell>
      \U
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      0.32
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      0.31
    </cell>>|<row|<\cell>
      nboyer:5:1
    </cell>|<\cell>
      39.27
    </cell>|<\cell>
      41.54
    </cell>|<\cell>
      3.95
    </cell>|<\cell>
      142.86
    </cell>|<\cell>
      5.10
    </cell>>|<row|<\cell>
      sboyer:5:1
    </cell>|<\cell>
      31.54
    </cell>|<\cell>
      39.14
    </cell>|<\cell>
      1.30
    </cell>|<\cell>
      155.49
    </cell>|<\cell>
      4.76
    </cell>>|<row|<\cell>
      gcbench:20:1
    </cell>|<\cell>
      20.54
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      1.87
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      3.51
    </cell>>|<row|<\cell>
      mperm:20:10:2:1
    </cell>|<\cell>
      173.33
    </cell>|<\cell>
      659.14
    </cell>|<\cell>
      13.33
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      10.65
    </cell>>|<row|<\cell>
      equal:100:8:1000:2000:5000
    </cell>|<\cell>
      0.78
    </cell>|<\cell>
      54.11
    </cell>|<\cell>
      0.99
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>>|<row|<\cell>
      bv2string:1000:1000:100
    </cell>|<\cell>
      10.78
    </cell>|<\cell>
      11.17
    </cell>|<\cell>
      2.47
    </cell>|<\cell>
      <math|\<varnothing\>>
    </cell>|<\cell>
      4.49
    </cell>>>>>>
  </with>

  \;

  <hrule>

  [8.1.2021]

  Some more benchmarks. Populating the autocompletion tree (i.e. pressing
  <key|tab> in a Scheme session within <TeXmacs>)

  <\with|par-mode|center>
    <small|<tabular|<tformat|<twith|table-hmode|min>|<twith|table-width|1par>|<cwith|1|-1|1|-1|cell-hyphen|t>|<cwith|1|5|1|1|cell-bsep|0.3em>|<cwith|1|5|1|1|cell-tsep|0.3em>|<cwith|1|-1|1|-1|cell-tborder|0.5ln>|<cwith|1|-1|1|-1|cell-bborder|0.5ln>|<cwith|1|-1|1|-1|cell-lborder|0ln>|<cwith|1|-1|1|-1|cell-rborder|0ln>|<cwith|1|1|1|-1|cell-tborder|0ln>|<cwith|1|1|1|-1|cell-bborder|0.5ln>|<cwith|1|1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|-1|cell-halign|c>|<table|<row|<\cell>
      \;
    </cell>|<\cell>
      <with|font-series|bold|symbols>
    </cell>|<\cell>
      <with|font-series|bold|time> (msec)
    </cell>>|<row|<\cell>
      guile 1.8.8<space|2em>
    </cell>|<\cell>
      8639
    </cell>|<\cell>
      686
    </cell>>|<row|<\cell>
      guile 3.0.5
    </cell>|<\cell>
      10300
    </cell>|<\cell>
      217
    </cell>>|<row|<\cell>
      S7
    </cell>|<\cell>
      7360
    </cell>|<\cell>
      255
    </cell>>>>>>
  </with>

  \;

  <hrule>

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
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-shape|<quote|small-caps>|Scheming>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <pageref|auto-1><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>