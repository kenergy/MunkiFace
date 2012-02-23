<?php
class Server extends RTObject
{
	protected $_plist;
	protected $_dict;

	public function init()
	{
		$this->_plist = SERVER_APP_DIR . "/Settings.plist";
		$this->reloadPlist();
		return $this;
	}




	public function detectRepoPathFromMunki()
	{
		$munkiPrefs = RTDictionary::dictionaryWithContentsOfFile(
			RTString::stringWithString(
				"/Users/" . get_current_user()
				. "/Library/Preferences/com.googlecode.munki.munkiimport.plist")
		);
		return $munkiPrefs->objectForKey("repo_path");
	}




	public function reloadPlist()
	{
		$this->_dict = RTMutableDictionary::dictionaryWithContentsOfFile(
			RTString::stringWithString($this->_plist));
	}




	public function readRepoPath()
	{
		$this->reloadPlist();
		return $this->_dict->objectForKey("munki-repo");
	}




	public function setRepoPath($aPath)
	{
		$this->reloadPlist();
		$this->_dict->setObject_forKey($aPath, "munki-repo");
		$this->_dict->writeToFile($this->_plist);
	}
}
