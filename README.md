# What's MunkiFace? #
At the moment, it's a work in progress. What it will eventually become is a web
application front end for [Munki](http://code.google.com/p/munki/).

Greg Neagle, the creator of Munki and various other tools, just emailed a few
links to me for reference. I'll clean this up a little later, but wanted to get
them posted for reference.

* munkiserver: https://github.com/jnraine/munkiserver
* MunkiReport: http://code.google.com/p/munkireport/
* MunkiReport-php: http://code.google.com/p/munkireport-php/
* [Pushing Packages with Munki](http://documentation.macsysadmin.se/2011/computer/Pushing_Packages_with_Munki.m4v)

## Basic Roadmap ##

### Read Only ###
The biggest problems with Munki have absolutely nothing to do with it's
abilities and reliability, but rather Munki simply isn't very good at
communicating with humans (pun intended). Therefore, the first goal of MunkiFace
is to create a clean read-only interface that allows the administrator to view
the repository for verification and reporting purposes. For example, if a
manager asks what applications are being pushed to a particular lab, you'd be
able to send them out to to MunkiFace and select the catalog associated with the
lab in question. Until this first goal is met, you'll still need to parse the
plists manually and send the filtered data on, which is just no fun.


### Read / Write ###
After the read-only functionality is pretty solid, I'll start working on some
very basic read/write stuff. Basic as in, providing a mechanism for editing the
description of the installer and hopefully adding drag-n-drop functionality such
that catalogs can be created and modified by simply dragging packages from one
list into another.


### Full C.R.U.D ###
Finally, there should be some way to import new packages and automatically run
the various munki tools that keep the repositories/catalogs all clean and in
sync. Lots to do, so off we go...
