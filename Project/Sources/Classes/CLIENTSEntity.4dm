Class extends Entity


Function get invoices_sort->$sel : cs:C1710.INVOICESSelection
	$sel:=This:C1470.invoices.orderBy("Date desc")
	
local Function get customFieldsLB->$cb : Object  // the data is already on the client, no need to ask the server
	return cs:C1710.CustomFields.me.buildContent("CLIENTS"; This:C1470.CustomFields)
	
local Function set customFieldsLB($cb : Object)
	This:C1470.CustomFields:=cs:C1710.CustomFields.me.setContent("CLIENTS"; $cb)
	
Function get TotalSales->$total : Real
	$total:=This:C1470.invoices.sum("Total")
	
local Function get fullAddress->$address : Text
	$address:=This:C1470.Name+Char:C90(13)
	$address+=(This:C1470.Address1+Char:C90(13))
	If (This:C1470.Country="Germany")  // In Germany first Zip, then city
		$address+=(This:C1470.ZipCode+" "+This:C1470.City+Char:C90(13))
	Else   // to keep the code simple, for anything else US format, City, State Zip. Adapt for your country format...
		$address+=(This:C1470.City+", "+This:C1470.State+" "+This:C1470.ZipCode+Char:C90(13))
	End if 
	$address+=This:C1470.Country
	