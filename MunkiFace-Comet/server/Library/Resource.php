<?php
/**
	Handles operations on filesystem resources such as creating directories or
	renaming or deleting directories or files.
 */
class Resource
{
	protected $munkiRepoPath;




	public function __construct()
	{
		$settings = Settings::sharedSettings();
		$this->munkiRepoPath = $settings->objectForKey("munki_repo");
		if (substr($this->munkiRepoPath, -1) != "/")
		{
			$this->munkiRepoPath .= "/";
		}
	}




	protected function targetIsPkgsInfo($aTarget)
	{
		return strpos("/pkgsinfo", $aTarget) === 0 || strpos("pkgsinfo", $aTarget) === 0;
	}




	protected function fullTargetPath($aTarget)
	{
		if (strpos($aTarget, "/") === 0)
		{
			return $this->munkiRepoPath . substr($aTarget, 1);
		}
		return $this->munkiRepoPath . $aTarget;
	}
	
	
	
	
	public function createDirectory($aPath)
	{
		$fullPath = $this->fullTargetPath($aPath);
		return mkdir($fullPath, 0777, TRUE);
	}




	public function deleteResource($aPath)
	{
		$fullPath = $this->fullTargetPath($aPath);
		if (is_dir($fullPath))
		{
			return rmdir($fullPath);
		}
		else if (is_file($fullPath))
		{
			return unlink($fullPath);
		}
		else return FALSE;
	}




	public function movePath_toPath($from, $to)
	{
		$fullFromPath = $this->fullTargetPath($from);
		$fullToPath = $this->fullTargetPath($to);
		return rename($fullFromPath, $fullToPath);
	}
}
