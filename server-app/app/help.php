<!doctype html>
<html>
<head>
	<title>MunkiFace Server Help</title>
	<?php include dirname(__FILE__) . "/Resources/style.php";?>
</head>
<body>
<div id="body">
	<h1>MunkiFace Server Help</h1>
	<p>
		Before you get started, you should first visit <a
		href="installCheck.php">installCheck.php</a> to make sure you've got
		MunkiFace Server configured properly.
	</p>

	<h1>Arguments</h1>
	<p>
		Arguments are broken up into two main components; <code>target</code> and
		<code>action</code>. A target is a relative path (relative to the base of
		the munki repo on the local filesystem) to a specific file or a directory of
		files. Actions are a little more abstract, and are currently defined as one
		of <code>read</code>, <code>readHeaders</code>, or the combination
		<code>setObject</code><code>forKey</code>.
	</p>
	<p>
		Here's an example of each supported argument list.
	</p>
	<ul>
		<li>?target=manifests&amp;readHeaders</li>
		<li>?target=manifests/<code>a-specific-manifest</code>&amp;read</li>
		<li>?target=manifests/<code>a-specific-manifest</code>&amp;setObject=<code>some-json-data</code>&amp;forKey=<code>some-key</code></li>
		<li>?target=pkgsinfo&amp;readHeaders</li>
		<li>?target=pkgsinfo/<code>a-specific-pkgsinfo-file</code>&amp;read</li>
		<li>?target=pkgsinfo/<code>a-specific-pkgsinfo-file</code>&amp;setObject=<code>some-json-data</code>&amp;forKey=<code>some-key</code></li>
	</ul>

	<h2>More on <code>target</code>s</h2>
	<p>
		Targets specify either a file or directory.
	</p>
	<p>
		What you specify in the <code>target</code> argument depends upon what
		action you want to use. The <code>readHeaders</code> action will expect
		<code>target</code> to be a directory containing either manifests or
		pkgsinfo files. The other two actions expect a specific file to be named.
	</p>
	<p>
		The value of <code>target</code> is parsed based on the '/' separator. The
		first component tells the server-app what model logic to use. Supported
		values are currently <code>manifests</code> and <code>pkgsinfo</code>, though
		support for all four munki repo directories will probably be added for the
		sake of completeness.
	</p>

	<h2>More on <code>action</code>s</h2>
	<p>
		Actions specify what should be done with a file or directory.
	</p>
	<h3>readHeaders</h3>
	<p>
		Recursively scans the directory specified by <code>target</code> and returns
		a json data structure representing the files and directories it found.
		This can be very useful for discovering a directory's contents without the
		overhead of reading every file.
	</p>
	<p>
		For an example of what the output looks like, try <a
		href="?target=manifests&amp;readHeaders">?target=manifests&amp;readHeaders</a>
	</p>

	<h3>read</h3>
	<p>
		Parses the plist file specified by <code>target</code> and returns its
		value structure in JSON format.
	</p>

	<h3>setObject...forKey</h3>
	<p>
		Like the other actions, this combination will work on a spcific file
		specified by <code>target</code>. If <code>target</code> file doesn't exist,
		it will be created with the single value specified. These two arguments
		must be present at the same time. The notion is very similar to the
		setObject:forKey: method found in <a
		href="http://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSMutableDictionary_Class/Reference/Reference.html#//apple_ref/doc/uid/20000141-BABBDAFD"
		target="_blank">NSMutableDictionary</a>.
	</p>
	<p>
		Say for example you want to change the <code>display_name</code> in the
		pkgsinfo file located at the path <code>pkgsinfo/chrome</code> to the value
		"Google Chrome". The argument should look like this:
	</p>
	<p>
		<code>?target=pkgsinfo/chrome&amp;setObject:"Google Chrome"&amp;forKey:display_name</code>
	</p>
	<p>
		<code>forKey</code> also supports key paths so you can access nested
		data. Let's say you want to change the <code>attribute_setting</code> of the
		first <code>installer_choices_xml</code> item from <code>false</code> to
		<code>true</code>. You could do provide a key that looks something like
		<code>installer_choices_xml.0.attribute_setting</code>. Note that true key
		paths don't support array indexes, but MunkiFace Server does!
	</p>

</div>
</body>
</html>
