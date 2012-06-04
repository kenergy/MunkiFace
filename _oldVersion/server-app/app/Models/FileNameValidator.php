<?php
/**
	A utility class that will check a file name against the values in
	Settings.plist.
	A file is considered valid if it doesn't start with a ".", doesn't end with
	one of the values in exclude_extensions, and does end with a value in
	plist_extensions.

	When plist_extensions is empty, a file is considered valid if it doesn't start
	with a "." and doesn't end with one of the values in exclude_extensions.

	When exclude_extensions is empty, a file is considered valid if it doesn't
	start with a "." but does end with one of the values in plist_extensions.

	When both plist_extensions and exclude_extensions are empty, a file is
	considered valid is it doesn't start with a ".".
 */
class FileNameValidator extends RTObject
{
	protected static $_plistExtensions;
	protected static $_excludeExtensions;
	protected static $_plistExtensionsAreEmpty;
	protected static $_excludeExtensionsAreEmpty;




	public function isValidFileName($aFile)
	{
		$name = RTString::stringWithString($aFile);
		$val = YES;
		if ($name->hasPrefix("."))
		{
			$val = NO;
		}

		else if ($this->plistExtensionsAreEmpty() && $this->excludeExtensionsAreEmpty())
		{
			$val = YES;
		}

		else if ($this->plistExtensionsAreEmpty())
		{
			$val = $this->matchesExcludeList($name) == NO;
		}

		else if ($this->excludeExtensionsAreEmpty())
		{
			$val = $this->matchesPlistList($name) == YES;
		}
		else
		{
			$val = $this->matchesExcludeList($name) == NO
				&& $this->matchesPlistList($name) == YES;
		}

		return $val;
	}




	public function plistExtensionsAreEmpty()
	{
		if (self::$_plistExtensionsAreEmpty == null)
		{
			self::$_plistExtensionsAreEmpty = $this->plistExtensions()->count() === 0;
		}
		return self::$_plistExtensionsAreEmpty;
	}




	public function excludeExtensionsAreEmpty()
	{
		if (self::$_excludeExtensionsAreEmpty == null)
		{
			self::$_excludeExtensionsAreEmpty = $this->excludeExtensions()->count() === 0;
		}
		return self::$_excludeExtensionsAreEmpty;
	}
	
	
	
	
	/**
		Returns the file extension for valid plists that are to be included when
		scanning a directory.
		\returns RTString
	 */
	public function plistExtensions()
	{
		if (self::$_plistExtensions == null)
		{
			self::$_plistExtensions =
			Settings::sharedSettings()->objectForKey("plist_extensions");
		}
		return self::$_plistExtensions;
	}




	/**
		Returns the array of file extensions that are to be ignored during a
		directory scan.
		\returns RTArray
	 */
	public function excludeExtensions()
	{
		if (self::$_excludeExtensions == null)
		{
			self::$_excludeExtensions =
				Settings::sharedSettings()->objectForKey("exclude_extensions");
		}
		return self::$_excludeExtensions;
	}




	public function matchesExcludeList($aFile)
	{
		if ($this->excludeExtensionsAreEmpty() == YES)
		{
			return NO;
		}
		
		$fileName = RTString::stringWithString($aFile);
		for($i = 0; $i < $this->excludeExtensions()->count(); $i++)
		{
			$ext = $this->excludeExtensions()->objectAtIndex($i);
			if (YES == $fileName->hasSuffix($ext))
			{
				return YES;
			}
		}
		return NO;
	}




	public function matchesPlistList($aFile)
	{
		if ($this->plistExtensionsAreEmpty() == YES)
		{
			return YES;
		}
		
		$fileName = RTString::stringWithString($aFile);
		for($i = 0; $i < $this->plistExtensions()->count(); $i++)
		{
			$ext = $this->plistExtensions()->objectAtIndex($i);
			if (YES == $fileName->hasSuffix($ext))
			{
				return YES;
			}
		}

		return NO;
	}
}
