# RTFoundation

RTFoundation is an incomplete implementation of [Apple's Foundation
framework](http://developer.apple.com/library/mac/#documentation/Cocoa/Reference/Foundation/ObjC_classic/_index.html#//apple_ref/doc/uid/20001091).
Why create a library that is a partial implementation at all? Well, I've found
myself wanting specific features (objects, methods, etc) that are available in
the Foundation framework while working on PHP projects. So, I've implemented
those that I've needed the most. I'll keep growing the project as my needs in
other projects grows, but others should feel free to implement/improve their
favorite components as well and then send me a pull request.


# Current Implementation

Here's a list of classes that are currently in the framework. For a list of
their methods, clone this project and use the Doxyfile to generate doxygen
documentation. You can download Doxygen from
[http://www.stack.nl/~dimitri/doxygen/](http://www.stack.nl/~dimitri/doxygen/)


* RTArray
* RTDictionary
* RTMutableArray
* RTMutableDictionary
* RTObject
* RTRange
* RTString
* RTURL


## Special Thanks

This project makes use of the exceptional work done by Christian Kruse and
Rodney Rehm on the [CFPropertyList
project](https://github.com/rodneyrehm/CFPropertyList). CFPropertyList is used
to read and write XML and binary plist files, which means every time a call is
made, such as

	$dict = RTDictionaty::dictionaryWithContentsOfFile("/tmp/file.plist");

... CFPropertyList is to thank for the work being done behind the scenes.
