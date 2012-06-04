<?php
/**
	An object-oriented wrapper around just a few ldap_* php functions.
 */
class LDAP extends RTObject
{
	protected $_connection;
	protected $_lastResult;
	protected $_ldapURL;
	protected $_attribute;
	protected $_scope;
	protected $_filter;
	protected $_username;
	protected $_password;




	public function setURL(RTURL $aURL)
	{
		$this->_ldapURL = $aURL;
		if ($aURL->query() == NULL)
		{
			$queryArray = RTArray::anArray();
		}
		else
		{
			$queryArray = $aURL->query()->componentsSeparatedByString("?");
		}
		if ($queryArray->count() < 2)
		{
			throw new Exception(
				"LDAP connections require at least an attribute and scope argument.",
				MFAuthDriverError
			);
		}
		$this->_attribute = $queryArray->objectAtIndex(0);
		$this->_scope = $queryArray->objectAtIndex(1);
		$this->_filter = RTString::string();
		if ($queryArray->count() == 3)
		{
			$this->_filter = $queryArray->objectAtIndex(3);
		}
	}




	public function setUsername($aUsername)
	{
		$this->_username = RTString::stringWithString($aUsername);
	}




	public function username()
	{
		if ($this->_username == NULL)
		{
			return RTString::string();
		}
		return $this->_username;
	}




	public function setPassword($aPassword)
	{
		$this->_password = RTString::stringWithString($aPassword);
	}




	public function password()
	{
		if ($this->_password == NULL)
		{
			return RTString::string();
		}
		return $this->_password();
	}



	public function connect()
	{
		$this->_connection = @ldap_connect(
			$this->compiledHost(),
			$this->_ldapURL->port()
		);
		if ($this->_connection === NO)
		{
			throw new RuntimeException(
				"Unable to connect to LDAP server using URL '" . $this->_ldapURL . "'"
				. " LDAP said '" . @ldap_error() . "'",
				MFAuthDriverError
			);
		}
	}




	/**
		Performs an LDAP search and then returns an RTArray of the entries that were
		found. If no entries were found, or if there was an error during the search,
		and empty RTArray will be returned.
		\param $aUsername The username to seach for
		\returns RTDictionary
	 */
	public function search($aUsername)
	{
		if ($this->_connection == NULL)
		{
			$this->connect();
		}
		$this->_lastResult = @ldap_search(
			$this->_connection,
			$this->_scope,
			$this->compiledFilter()
		);
		if ($this->_lastResult === NO)
		{
			return RTArray::anArray();
		}

		$entries = ldap_get_entries($this->_connection, $this->_lastResult);
		if ($entries === NO)
		{
			$entries = RTArray::anArray();
		}
		else
		{
			$entries = $this->convertEntriesToArray($entries);
			$entries = RTDictionary::dictionaryWithPHPArray($entries);
		}
		return $entries;
	}




	/**
		Returns a BOOL value indicating that a bind worked (YES) or failed (NO).
	 */
	public function bind($dn, $password)
	{
		$result = @ldap_bind($this->_connection, $dn, $password);
		return $result !== NO;
	}




	/**
		Returns a string in the format of "protocol://hostname", which is intended
		for use attempting to connect to the LDAP server.
		\returns RTString
	 */
	protected function compiledHost()
	{
		$h = RTString::stringWithFormat(
			"%s://%s",
			$this->_ldapURL->scheme(),
			$this->_ldapURL->host()
		);
		return $h;
	}
	
	
	
	
	/**
		Returns the compiled filter string used for the LDAP lookup.
		This takes the attribute specified and combines it with the filter
		specified, if any. So if user 'joe' is attempting to authenticate and an
		LDAP url of ldap://example.com?cn?ou=users,o=example,c=US&gid=439 is
		provided, this method will return "(&(cn=joe)(gid=439)".
		If no filter is provided in the URL, this will simply return "(cn=joe)".
		\returns RTString
	 */
	protected function compiledFilter()
	{
		$filter = RTString::string();
		if ($this->_filter->length() == 0)
		{
			$filter = RTString::stringWithString(
				"(" . $this->_attribute . "=" . $this->username() . ")"
			);
		}
		else
		{
			$filter = RTString::stringWithString(
				"(&(" . $this->_attribute . "=" . $this->username() . ")"
			);
			if ($this->_filer->hasPrefix("("))
			{
				$filter = $filter->stringByAppendingString($this->_filter . ")");
			}
			else
			{
				$filter = $filter->stringByAppendingString(
					"(" . $this->_filter . "))"
				);
			}
		}
		return $filter;
	}




	/**
		Adapted from
		http://www.php.net/manual/en/function.ldap-get-entries.php#89508
	 */
	protected function convertEntriesToArray($entry)
	{
		$retEntry = array();
		for ( $i = 0; $i < $entry['count']; $i++ )
		{
			if (is_array($entry[$i]))
			{
				$subtree = $entry[$i];
				//This condition should be superfluous so just take the recursive call
				//adapted to your situation in order to increase perf.
				if ( ! empty($subtree['dn']) && ! isset($retEntry[$subtree['dn']]))
				{
					$retEntry[$subtree['dn']] = $this->convertEntriesToArray($subtree);
				}
				else
				{
					$retEntry[] = $this->convertEntriesToArray($subtree);
				}
			}
			else
			{
				$attribute = $entry[$i];
				if ( $entry[$attribute]['count'] == 1 )
				{
					$retEntry[$attribute] = $entry[$attribute][0];
				}
				else
				{
					for ( $j = 0; $j < $entry[$attribute]['count']; $j++ )
					{
						$retEntry[$attribute][] = $entry[$attribute][$j];
					}
				}
			}
		}
		return $retEntry;
	}
}
