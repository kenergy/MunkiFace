# What's MunkiFace? #
At the moment, it's a work in progress. What it will eventually become is a web application front end for [Munki][5]. _I can't stress enough that this is a **work in progress**_, so while feedback is certainly appreciated, please don't attempt to install the app and expect miricales…yet ;-)


## Pages Of Interest

* [Installation][1]
* [Software Requirements][2]

## Get Involved
If you'd like to help me test this application as it is developed, or if you'd like to help out with development and need a place to ask questions, please join the [MunkiFace mailing list][6]. Is this the first time you're hearing of [Munki][5]? [Join the Munki community][7] and learn the tricks of the trade!



## Goals
[Munki][5] is a fantastic tool for managing OS X client computers within an organization or enterprise, but it can be intimidating for those not comfortable with the commandline. Even for those who are very comfortable in a commandline environment, administering [Munki][5] can still be very cumbersome and even error prone. MunkiFace intends to do for [Munki][5] admins what [Munki][5] did for OS X administration; be a helper monkey.

## Features
Because MunkiFace is still in development, this is far from a complete list and will continue to grow as the project matures.

* **Built on [Cappuccino][4]** - Yes, I'm addicted to caffeine, but that's the wrong cappuccino. Cappuccino is a web framework that is to JavaScript what Objective-C is to C. They've even done a fantastic job of modeling the framework after Apple's Objective-C language, which means the application not only looks and feels more like a native OS X app than most other web apps out there, it also means that it's possible to build web applications very easily if you're coming from an Objective-C background. While you never mess with JavaScript, HTML or CSS, Cappuccino apps compile to these three components, which has the added benefit of requiring zero browser plugins to function.
* **Realtime Data** - MunkiFace employs the [Comet][3] programing model to make sure the data that you see is the data that's on the server, at all times, no matter how it gets modified. This means importing a new installer item with munkiimport will cause MunkiFace to display the new installer item in near real-time.
* **Searchable** - Sure you can grep through your slew of plist files, but you can't search for values in specific keys without some creative scripting. MunkiFace uses predicate searches to give you the same searching power that you've grown to depend on in modern applications such as Apple's Mail, Finder or iTunes. _work is being done to implement a predicate editor, but the search bar is currently serving as proof of this concept_
* **Saved Searches** - What's the use in being able to create incredibly detailed searches if you can't go back and execute them again at the click of a button?
* **Support for Manifests, Catalogs, and PkgsInfo files** - MunkiFace will currently show you the contents of each file within each of the respective directories. It will eventually allow you to perform operations on pkgsinfo files such as drag and drop, renaming, and importing new installer items.

[1]:https://github.com/buffalo/MunkiFace/wiki/Installation
[2]:https://github.com/buffalo/MunkiFace/wiki/Software Requirements
[3]:http://en.wikipedia.org/wiki/Comet_(programming)
[4]:http://cappuccino.org
[5]:http://code.google.com/p/munki
[6]:http://groups.google.com/group/munkiface
[7]:http://groups.google.com/group/munkidev