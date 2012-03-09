# Basic Installation Notes #


## Manual Installation

Download and unzip the latest version of MunkiFace from
https://github.com/buffalo/MunkiFace/zipball/master (zip).


Move the `server-app` and `client-app` directories into your webserver's
document root. On OS X client, this would be `/Library/WebServer/Documents`.


Edit `client-app/Info.plist`'s `MunkiFace Server URI` key such that it contains
the full URI to `server-app`. For example: `http://munki.example.com/server-app`

Edit `server-app/Settings.plist` and set `munki-repo` to the local filesystem
path that contains your munki files; `/Users/Shared/munki_repo` for example.
Next set the `SoftwareRepoURL` to essentially the same value that you would use
in ManagedInstalls.plist; `http://munki.example.com/munki_repo` for example.


Point your browser to `http://munki.example.com/client-app` and test.


For the sake of human readability, you might consider renaming the client-app
directory to `munkiface` or something similar.


## Requirements
In order to properly run the server components, you'll need to have the
following:

* a web server (MunkiFace is developed using an Apache 2 environment)
* PHP v5.3.x or higher built as a module for your web server
* munki

MunkiFace is pure Javascript, which means it really only requires a modern
browser with a stanards-compliant Javascript engine. MunkiFace is written in
Objective-J/Cappuccino, and according to
[Cappuccino](http://cappuccino.org/learn/)'s documentation, the client-app
requirements should be one of the following browsers:

* Internet Explorer 7+
* Firefox 2+
* Safari 3+
* Google Chrome
* Opera 9+

...though it should be noted that development is largely done in Safari and
Google Chrome at the moment with Chrome out performing Safari. The Cappuccino
group has a few bugs filed with Apple that will hopefully be addressed in
Mountain Lion. The Safari bugs are largely related to resizing the browser
window while a Cappuccino app is loaded and visible.


# What's MunkiFace? #
At the moment, it's a work in progress. What it will eventually become is a web
application front end for [Munki](http://code.google.com/p/munki/).


Here are a few links to some other projects that provide features similar to
what MunkiFace has in mind. The last link is an excellent video of a
presentation on Munki given by its creator, Greg Neagle.

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
that manifests can be created and modified by simply dragging packages from one
list into another.


### Full C.R.U.D ###
Finally, there should be some way to import new packages and automatically run
the various munki tools that keep the repositories/catalogs all clean and in
sync. Lots to do, so off we go...
