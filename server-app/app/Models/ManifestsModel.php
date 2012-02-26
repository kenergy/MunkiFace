<?php



class ManifestsModel extends AbstractModel
{
	private $_manifestDir;


	public function manifests()
	{
		$this->_manifestDir = $this->munkiDir() . "/manifests/";
		return $this->recursivelyScanDirectory($this->_manifestDir);
	}




	public function manifestDirectory()
	{
		return $this->_manifestDir;
	}
}
