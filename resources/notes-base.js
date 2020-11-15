
/******************************************************************************
* MODULE     : notes-base.js
* DESCRIPTION: common scripts for TeXmacs blog/wiki pages
* COPYRIGHT  : (C) 2020  Massimiliano Gubinelli
*******************************************************************************
* This software falls under the GNU general public license version 3 or later.
* It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
* in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
******************************************************************************/


// syntax highlight for <pre> blocks

document.addEventListener('DOMContentLoaded',
  function(event) {
    document.querySelectorAll('pre').forEach(function(block){ 
          hljs.highlightBlock(block); }); });
          