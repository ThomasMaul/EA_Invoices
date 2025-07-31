Class extends DataClass

exposed Function findByURL($location : Object)->$client : cs:C1710.CLIENTSEntity
	If (($location.urlPath#Null:C1517) && ($location.urlPath.client#Null:C1517))
		$client:=This:C1470.get(Num:C11($location.urlPath.client))
	Else 
		$client:=Null:C1517
	End if 
	