Class extends DataClass

Function readData($name : Text)->$object : Object
	var $ents : cs:C1710.Document_TemplatesSelection:=This:C1470.query("Name=:1"; $name)
	If ($ents.length>0)
		var $ent : cs:C1710.Document_TemplatesEntity:=$ents.first()
		If ($ent.data#Null:C1517)
			return $ent.data
		End if 
	End if 
	return {}
	
Function writeData($name : Text; $object : Object)
	var $ents : cs:C1710.Document_TemplatesSelection:=This:C1470.query("Name=:1"; $name)
	If ($ents.length>0)
		var $ent : cs:C1710.Document_TemplatesEntity:=$ents.first()
	Else 
		$ent:=cs:C1710.Document_Templates.new()
		$ent.Name:=$name
	End if 
	$ent.data:=$object
	$ent.save()
	