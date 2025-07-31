shared singleton Class constructor()
	
Function useOpenStreetMap($countrycode : Text; $state : Text; $zip : Text; $city : Text; $address : Text)->$result : Object
	
	var $url; $urlstart : Text
	
	$urlstart:="https://nominatim.openstreetmap.org/search?format=json&addressdetails=1"
	
	If ($countrycode#"")
		$countrycode:=This:C1470._checkCountryCode($countrycode)
		$urlstart+=("&country="+This:C1470._URLEncoder($countrycode; "UTF-8"))
	End if 
	If ($state#"")
		$urlstart+=("&state="+This:C1470._URLEncoder($state; "UTF-8"))
	End if 
	If ($zip#"")
		$urlstart+=("&postalcode="+This:C1470._URLEncoder($zip; "UTF-8"))
	End if 
	If ($city#"")
		$urlstart+=("&city="+This:C1470._URLEncoder($city; "UTF-8"))
	End if 
	
	$address:=Replace string:C233($address; "straße"; "str")
	$url:=$urlstart+("&street="+This:C1470._URLEncoder($address; "UTF-8"))
	
	// first try with full street name and house number
	$result:=This:C1470._callOSM($url)
	
	If (OB Is empty:C1297($result))
		// remove house number for Germany/Austria, sometimes result is available for street name only
		
		var $viDirSymbol:=32  // space
		var $viLen:=Length:C16($address)
		var $viPos:=0
		var $viChar : Integer
		For ($viChar; $viLen; 1; -1)
			If (Character code:C91($address[[$viChar]])=$viDirSymbol)
				$viPos:=$viChar
				$viChar:=0
			End if 
		End for 
		If (($viPos>0) & ((Length:C16($address)-$viPos)<5))
			$address:=Substring:C12($address; 1; $viPos-1)
		End if 
		$url:=$urlstart+("&street="+This:C1470._URLEncoder($address; "UTF-8"))
		DELAY PROCESS:C323(Current process:C322; 60)  // don't do too many calls to free API
		$result:=This:C1470._callOSM($url)
	End if 
	
	If (OB Is empty:C1297($result))
		// finally try without street name
		$url:=$urlstart
		DELAY PROCESS:C323(Current process:C322; 60)  // don't do too many calls to free API
		$result:=This:C1470._callOSM($url)
	End if 
	// if still nothing is found, result is {}
	
	
Function _callOSM($url)->$object : Object
	$object:={}
	var $request : 4D:C1709.HTTPRequest
	$request:=4D:C1709.HTTPRequest.new($url; {timeout: 5})
	$request.wait(5)
	If ($request.response.status=200)
		Case of 
			: (Value type:C1509($request.response.body)=Is object:K8:27)
				$object:=$request.response.body
			: (Value type:C1509($request.response.body)=Is collection:K8:32)
				If ($request.response.body.length>0)
					$object:=$request.response.body[0]
				End if 
		End case 
	End if 
	
Function _URLEncoder($url : Text; $encoding : Text)->$result : Text
	//  useful if you need to encode your URL
	// example:  "www.test.com/my method"  contains a blank, so needs to be converted to "www.test.com/my%20method"
	// $format could be UTF-8 or ISO-8859-1
	// characters > 127 will be encoded using this format. 
	//  encodes umlauts, blanks and other special chars in an URL
	
	var $format; $WSPI_MyChar; $out : Text
	var $blob : Blob
	var $WSPI_parser; $charIn; $WSPI_ascii; $i; $WSPI_n : Integer
	
	$result:=""
	If (Count parameters:C259>1)
		$format:=$encoding
	Else 
		$format:="ISO-8859-1"
	End if 
	
	// If the charset is different than Latin-1 please add your translation below
	// Parse the string and translate the special characters
	For ($WSPI_parser; 1; Length:C16($url))
		$WSPI_MyChar:=Substring:C12($url; $WSPI_parser; 1)
		$WSPI_ascii:=Character code:C91($WSPI_MyChar)
		If ((($WSPI_ascii>=Character code:C91("a'")) & ($WSPI_ascii<=Character code:C91("z'"))) | (($WSPI_ascii>=Character code:C91("A")) & ($WSPI_ascii<=Character code:C91("Z"))) | (($WSPI_ascii>=Character code:C91("0")) & ($WSPI_ascii<=Character code:C91("9"))) | ($WSPI_MyChar="*") | ($WSPI_MyChar="-") | ($WSPI_MyChar=".") | ($WSPI_MyChar="_") | ($WSPI_MyChar="/"))
			$result:=$result+$WSPI_MyChar
		Else 
			SET BLOB SIZE:C606($blob; 0)
			CONVERT FROM TEXT:C1011($WSPI_MyChar; $format; $blob)
			For ($i; 1; BLOB size:C605($blob))
				$charIn:=$blob{$i-1}
				$out:="%"
				$WSPI_n:=$charIn\16
				If ($WSPI_n<10)
					$out:=$out+String:C10($WSPI_n)
				Else 
					$out:=$out+Char:C90(Character code:C91("A")+$WSPI_n-10)
				End if 
				$WSPI_n:=$charIn%16
				If ($WSPI_n<10)
					$out:=$out+String:C10($WSPI_n)
				Else 
					$out:=$out+Char:C90(Character code:C91("A")+$WSPI_n-10)
				End if 
				$result:=$result+$out
			End for 
		End if 
	End for 
	
	// converts european postal codes to ISO (2 digit) country codes
Function _checkCountryCode($country : Text)->$code : Text
	Case of 
		: ($country="D")
			$code:="DE"
		: ($country="A")
			$code:="AT"
		: ($country="L")
			$code:="LU"
		: ($country="F")
			$code:="FR"
		: ($country="USA")
			$code:="US"
			// enhance this list to cover used missing countries
		Else 
			$code:=$country
	End case 