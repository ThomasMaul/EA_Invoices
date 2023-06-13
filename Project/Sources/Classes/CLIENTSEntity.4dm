Class extends Entity

Function get fullAddress->$address : Text
	$address:=This:C1470.Name+Char:C90(13)
	$address+=(This:C1470.Address+Char:C90(13))
	If (This:C1470.Country="Germany")
		$address+=(This:C1470.Zip_Code+" "+This:C1470.City+Char:C90(13))
	Else 
		$address+=(This:C1470.City+", "+This:C1470.State+" "+This:C1470.Zip_Code+Char:C90(13))
	End if 
	$address+=This:C1470.Country
	
	