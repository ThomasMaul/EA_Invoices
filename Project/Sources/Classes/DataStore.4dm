Class extends DataStoreImplementation

Function getClientSessionID : Text
	// the Session ID of a Client is only available on the server. So we need to call the server to get the id
	return Session:C1714.id
	
Function getWebServerAddress->$url : Text
	// allows to get the IP address where the web server is hosted, to use it in the URL of the web area
	var $webobject:=WEB Get server info:C1531
	$url:=""
	var $ip_Address_collection : Collection:=$webobject.options.webIPAddressToListen
	If ($ip_Address_collection.length>0)
		$url:=$ip_Address_collection[0]+":"+String:C10($webobject.options.webPortID)
	End if 
	
exposed Function authentify($username : Text; $pass : Text; $query : Object)->$out : Text
	// this method is called to authenticate an user in a Qodly web application
	// for full web applications, you have a login page to identify the user, calling this function to
	// set permissions, user rights, etc
	// but called from a 4D form/web area, the user is already authenticated in 4D itself, so you just
	// want to share this info
	// we handle here only the part "called from 4D", and use the Current User as identification.
	// to make sure it is really called from 4D, we use the 4D session ID (a 16 byte token) to verify.
	
	// debug only - allow everyone
	var $info:=New object:C1471("userName"; Current user:C182; "roles"; "user"; "privileges"; "user")
	$status:=Session:C1714.setPrivileges($info)
	return String:C10($status)
	
	
	//var $sessionID : Text:=String($query.urlPath.session)
	//If ($sessionID#"")
	//var $storage:=Session storage($sessionID)
	//If ($storage#Null)
	//var $info:=New object("userName"; Current user; "roles"; "user"; "privileges"; "user")
	//Session.setPrivileges($info)
	//End if 
	//End if 
	//return ""