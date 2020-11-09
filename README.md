# notes
Notes about TeXmacs

This is an attempt to a blog/wiki about [TeXmacs](http://www.texmacs.org). It aims to be a container for articles, snippets, comments, developer docs, proposals, ... 

The site is served at https://texmacs.github.io/notes/ 

All the HTML code is automatically generated from the TeXmacs sources which are the primary source of content. Since TeXmacs itself takes care of the conversion there is essentially no need for an external software like `Jekyll` or `Hugo`.

The idea is that the site can be browsed both via a standard web browses on the Internet and via TeXmacs locally in the cloned repository. This setup allows an higher degree of interaction with the local copy. 

Contributions (also as pull requests) are welcome. 


Structure of the repository:

 * The `src/`directory hosts the TeXmacs sources for the website. 

 * The `docs/`directory hosts the HTML code for the website together with all the necessary resources which have to be served (fonts, css styles, etc...).

To automatically regenerate all the web pages  use `Tools->Web->Create/Update web site` within TeXmacs and choose `src/` as source and `docs/` as destination directories. 

Once the repository is pushed on github it becomes visible. 

**To contribute:** Fork the repository. Make your modifications (typically add new articles in the `src/`directory and modify accordingly `index.tm`). Make a pull request on github to ask the maintainers to integrated your changes into the public repository. Once the changes are pulled in they will become immediately publicly visible on the website.
A tutorial on how to work with git is at https://www.earthdatascience.org/workshops/intro-version-control-git/basic-git-commands/. It shows how to work with one's own repositories. Pull requests can be then sent through the "New pull request" button at https://github.com/texmacs/notes/pulls (the interface then help the user with the following steps).


Enjoy TeXmacs!

