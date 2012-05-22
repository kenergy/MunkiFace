<?php

function glob_recursive($pattern, $flags = 0)
{
	$files = glob($pattern, $flags);
	foreach (glob(dirname($pattern).'/*', GLOB_ONLYDIR|GLOB_NOSORT) as $dir)
	{
		$files = array_merge($files, glob_recursive($dir.'/'.basename($pattern),
			$flags));
	}
	return $files;
}





class WatchPath
{
	protected $path;
	protected $pathInfo;
	protected $previousModificationDate;
	protected $changes;

	public function __construct($path, $previousModificationDate = 0)
	{
		$this->path = $path;
		$this->changes = array(
			"changed" => array(),
			"created" => array(),
			"removed" => array()
		);
		$this->previousModificationDate = $previousModificationDate;
		$this->pathInfo = array();
	}




	public function watch()
	{
		$isInitialRun = TRUE;
		$mostRecentModificationDate = -1;
		while (TRUE)
		{
			// examine the file system
			clearstatcache();
			$mostRecentPathInfo = array();
			foreach(glob_recursive($this->path, GLOB_MARK) as $file)
			{
				$m = filemtime($file);
				$mostRecentPathInfo[$file] = $m;
				if ($m > $mostRecentModificationDate)
				{
					$mostRecentModificationDate = $m;
				}
			}

			// setup initial variables if this is the first loop
			if ($isInitialRun && $this->previousModificationDate != 0)
			{
				$this->previousModificationDate = $mostRecentModificationDate;
				$this->pathInfo = $mostRecentPathInfo;
				$isInitialRun = FALSE;
			}

			$this->checkForNewOrMissingFiles($mostRecentPathInfo);
			
			// Determine if a file was modified, but only if the client is looking for
			// new items. If they aren't, there's no reason to send anything back in
			// 'changed' because everything will already be in 'created'.
			if ($this->previousModificationDate != 0
				&& $mostRecentModificationDate > $this->previousModificationDate)
			{
				$keys = array();
				$key = TRUE;
				while($key != FALSE)
				{
					$key = array_search($mostRecentModificationDate, $this->pathInfo);
					if ($key !== FALSE)
					{
						$keys[$key] = $key;
						unset($this->pathInfo[$key]);
					}
				}
				$this->filesWereChanged($keys);
			}

			if (count($this->changes["removed"]) > 0
				|| count($this->changes["created"]) > 0
				|| count($this->changes["changed"]) > 0)
			{
				return $this->changes;
			}
			usleep(200000);
		}
	}




	protected function checkForNewOrMissingFiles($aPathInfo)
	{
		// Determine if a file is missing or has been created
		$previousCount = count($this->pathInfo);
		$newCount = count($aPathInfo);
		if ($newCount < $previousCount)
		{
			// a file was removed
			$diffArray = array_diff($this->pathInfo, $aPathInfo);
			$this->filesWereRemoved($diffArray);
		}
		else if ($newCount > $previousCount)
		{
			// a file was created
			$diffArray = array_diff($aPathInfo, $this->pathInfo);
			$this->filesWereAdded($diffArray);
		}
		$this->pathInfo = $aPathInfo;
	}



	public function filesWereChanged($changes)
	{
		foreach($this->changes['created'] as $newFile => $val)
		{
			if (isset($changes[$newFile]))
			{
				unset($changes[$newFile]);
			}
		}
		$this->changes["changed"] = $changes;
	}



	public function filesWereRemoved($files)
	{
		$this->changes["removed"] = $files;
	}


	public function filesWereAdded($files)
	{
		$this->changes["created"] = $files;
	}
}
