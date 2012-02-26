<?php



class ManifestsModel extends AbstractModel
{
	private $_manifestDir;


	public function manifests()
	{
		$this->_manifestDir = $this->munkiDir() . "/manifests/";
		return $this->recursivelyScanDirectory_relativePaths($this->_manifestDir,
		YES);
	}




	public function manifestDirectory()
	{
		return $this->_manifestDir;
	}
}
