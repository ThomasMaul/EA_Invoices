Class extends DataStoreImplementation


local Function flattenCollection($col : Collection; $fullName : Boolean)
	$curName:=""
	For each ($ent; $col)
		
		For each ($ob; $ent)
			If (Value type:C1509($ent[$ob])=Is object:K8:27)
				This:C1470._flattenCollObject($ent; $ent[$ob]; $ob; $fullName)
				OB REMOVE:C1226($ent; $ob)
			Else 
				// all is fine already
			End if 
		End for each 
		
	End for each 
	
local Function _flattenCollObject($ent : Object; $subent : Object; $curName : Text; $fullName : Boolean)
	For each ($ob; $subent)
		If (Value type:C1509($subent[$ob])=Is object:K8:27)
			$name:=($curName="") ? $ob : $curName+"."+$ob
			This:C1470._flattenCollObject($ent; $subent[$ob]; $name; $fullName)
			OB REMOVE:C1226($subent; $ob)
		Else 
			If ($fullName)
				$name:=($curName="") ? $ob : $curName+"."+$ob
				$ent[$name]:=$subent[$ob]
			Else 
				$ent[$ob]:=$subent[$ob]
			End if 
		End if 
	End for each 
	