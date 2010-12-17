`liftweb-vim`
=============

Installation
------------

To install liftweb-vim:

* Copy `liftweb.vim` from `autoload/` to `~/.vim/autoload/`.
* Copy `liftweb.vim` from `plugin/` to `~/.vim/plugin/`.
* Copy `liftweb.txt` from `doc/` to `~/.vim/doc/`.
* Open vim and then run `:helptags ~/.vim/doc`

Then, once you've opened a scala file, liftweb.vim will be loaded for the
session.  The commands will only work if you are in a file that has been
detected to be in a Lift project.

Alternatively, use Tim Pope's pathogen.vim and put this plugin's files in
~/.vim/bundle/liftweb-vim/ (or extract the tarball directly there).

Usage
-----

A plugin for vim to ease navigation for projects that use the Lift Scala web
framework. Heavily inspired by the awesome that is Tim Pope's rails.vim (at
http://rails.vim.tpope.net/) .

Currently provides a few commands:

* :Lmodel, Lsnippet, Lactor, Lcomet, Llib -- all take a class name and take you
  to the appropriate associated file
* :Lview -- takes a filename and takes you to the appropriate view file
* :Lspec or :Ltest -- when called from a class (e.g., GroupSnip), takes you to
  the associated test file (GroupSnipTest)
* :Lclass -- the opposite of Lspec, takes you to the class for the current test
* :Lboot -- takes you directly to Boot.scala
* :Lcss, Ljavascript, Lsass -- takes a filename and takes you to the
  appropriate file

Lmodel and family can take a class name (without .scala) or file name (with
.scala). Lview can likewise take a view name with or without .html. All of
these functions have proper completion built-in, including alternatives (e.g.,
if there is a view index.html and a static/index.html, Lview will complete on
both and lets you switch between them using <Tab>).

Lmodel and family, when completing, take into account potential suffixes. For
example, when completing on Group, Lmodel looks for Group.scala or
GroupModel.scala; Lcomet looks for Group.scala or GroupComet.scala; Lactor looks
for Group.scala or GroupActor.scala; and Lsnippet looks for Group.scala,
GroupSnip.scala, or GroupSnippet.scala.

The semantics for Lview are also different than the other commands. Lview will
recursively search for a file with the given name, while Lmodel and family will
only look in the immediate package (model/ for Lmodel, snippet/ for Lsnippet,
etc). Note that the *completion* for Lmodel and family will search recursively,
but the command itself will not. So running Lmodel Group will only open
Group.scala, but running Lmodel Group<Tab> will complete Group.scala,
GroupModel.scala, subpackage/Group.scala, subpackage/GroupModel.scala, and so
on.

The same semantics are applied to Ljavascript, Lcss, or Lsass. These are
assumed to be in src/main/webapp in javascripts, stylesheets, and sass-hidden
directories, respectively.

Possibly forthcoming will be a broad recursive search for any
appropriately-named file if you pass an argument to Lclass, Lspec, or Ltest.

Note that the plugin assumes a standard directory layout of:

    src/
      main/
        webapp/
          <view files>
          javascripts/
          sass-hidden/
          stylesheets/
        scala/
          package/for/project/
            model/
            actor/
            snippet/
            comet/
      test/
        scala/
          package/for/project/
            model/
            actor/
            snippet/
            comet/

The project package is generally autodetected from the project root as well as
from src/ and any subdirectory of test/ and main/ . Better package detection code is
on the to-do list.

Author
------

This plugin is copyright me, Antonio Salazar Cardozo, and licensed under the
same terms as Vim proper. No warranties are made, express or implied.

I’m currently working on OpenStudy, a product designed to help students help
each other in their studying.

I have a rather sporadically updated blog at http://shadowfiend.posterous.com/
