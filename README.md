`liftweb-vim`
=============

A plugin for vim to ease navigation for projects that use the Lift Scala web framework.

Currently provides a few commands:
* :Lmodel, Lsnippet, Lactor, Lcomet -- all take a class name and take you to
  the appropriate associated file
* :Lview -- takes a class name and takes you to the appropriate view file
* :Lspec or :Ltest -- when called from a class (e.g., GroupSnip), takes you to
  the associated test file (GroupSnipTest)
* :Lclass -- the opposite of Lspec, takes you to the class for the current test

Currently there are some inconsistencies. Lmodel and family take a class name
only -- so you would say :Lmodel Group, not :Lmodel Group.scala. Lview, however,
takes an actual filename -- so you would say :Lview index.html, not :Lview
index. Hopefully that will change in the near future so that both take either
form.

The semantics for Lview are also different than the other commands. Lview will
recursively search for a file with the given name, while Lmodel and family will
only look in the immediate package (model/ for Lmodel, snippet/ for Lsnippet,
etc).

Note that the plugin assumes a standard directory layout of:

    src/
      main/
        webapp/
          <view files>
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

This plugin is copyright mew, Antonio Salazar Cardozo, and licensed under the
same terms as Vim proper. No warranties are made, express or implied.

I’m currently working on OpenStudy, a product designed to help students help
each other in their studying.

I have a rather sporadically updated blog at http://shadowfiend.posterous.com/
