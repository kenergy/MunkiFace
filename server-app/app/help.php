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
		of <code>read</code>, <code>readHeaders</code>, or <code>set</code>.
	</p>
	<p>
		Here's an example of each supported argument list.
	</p>
	<ul>
		<li>?target=manifests&amp;readHeaders</li>
		<li>?target=catalogs/all&amp;read</li>
		<li>?target=pkgsinfo/<code>a-specific-pkgsinfo-file</code>&amp;set=<code>some-json-data</code></li>
	</ul>

	<h2>More on <code>target</code>s</h2>
	<p>
		Normal targets specify either a file or directory. An <code>MFTarget</code>
		is a MunkiFace-specific meta location. Currently, the only supported
		<code>MFTarget</code> value is 'settings' and the only supported action for
		that value is <code>read</code>.
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
	<p>
		<code>MFTarget</code> can currently be used to retrieve the settings that
		are in use by server-app. The argument list to gain that data should look
		exactly like this:
		<ul>
			<li><a href="?MFTarget=settings&read">?MFTarget=settings&amp;read</a></li>
		</ul>
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

	<h3>set</h3>
	<p>
		Like the other actions, this will work on a specific file identified in
		<code>target</code>. If <code>target</code> file doesn't exist, it will be
		created and populated with the specified value. <b>To be clear: this will
		<i>replace</i> the contents of <code>target</code></b>. Therefore, you must
		<i>always</i> provide the complete structure of the file exactly (in JSON
		notation) as you want it to be stored.
	</p>
</div>
</body>
</html>
