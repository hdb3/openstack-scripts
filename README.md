openstack-scripts
=================

scripts used while installing OpenStack following the OS manuals

The OpenStack install manual contains snippets of code SQL and configuration and are spread accross many source files.
These scripts start with the html output of the documentation build process.  The source for that is on OpenStack git.
The main tools are:
- parse.py
-- this parses html, using the OS doc specific tags to distinguais 'code' and 'text'.
-- it dumps the code and optionally the text, text demarcated by a comment character
-- typically the output contains shell scripts, SQL commands and config file sections
-- the other tools work with the output of this one

- edit.py
-- this one is quite complex.  It uses a feature of parse.py, which writes filenames into the output when they are marked up as such
-- eidt use
- files.py and sql.py
-- simpler py scripts - these extract just the lines which look like configuration or SQL.  Files.py can act as an intermediate filter
-- between parse.py and edit.py
- filter.sh
-- very simple bash script, extracts only the line s which look like shell input,
-- and inserts 'sudo' for the lines which look like they would benefit from it.
s this syntax to run an update on the config files which are referred to and which have script like code
-- associated
