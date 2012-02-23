<?php
class Client extends RTObject
{
	protected $_plist;
	protected $_dict;
	protected $_MSUKey = "Munki Server URI";
	protected $_MFSUKey = "MunkiFace Server URI";

	public function init()
	{
		$this->_plist = CLIENT_APP_DIR . "/Info.plist";
		return $this;
	}




	public function reloadPlist()
	{
		$this->_dict = RTMutableDictionary::dictionaryWithContentsOfFile(
			RTString::stringWithString($this->_plist));
	}




	public function readMunkiURI()
	{
		$this->reloadPlist();
		return $this->_dict->objectForKey($this->_MSUKey);
	}
	
	
	
	
	public function setMunkiURI($aUri)
	{
		$this->reloadPlist();
		$this->_dict->setObject_forKey($aUri, $this->_MSUKey);
		$this->_dict->writeToFile($this->_plist);
	}




	public function readMunkiFaceURI()
	{
		$this->reloadPlist();
		return $this->_dict->objectForKey($this->_MFSUKey);
	}
	
	
	
	
	public function setMunkiFaceURI($aUri)
	{
		$this->reloadPlist();
		$this->_dict->setObject_forKey($aUri, $this->_MFSUKey);
		$this->_dict->writeToFile($this->_plist);
	}




	public function URIIsReachable($aURI)
	{
		$url = parse_url($aURI);
		if (!isset($url['scheme']))
		{
			return FALSE;
		}
		$fp = fopen($aURI, "r");
		return is_resource($fp);
	}
}
