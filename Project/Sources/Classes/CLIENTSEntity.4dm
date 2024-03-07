Class extends Entity


Function get invoices_sort->$sel : cs:C1710.INVOICESSelection
	$sel:=This:C1470.invoices.orderBy("Date desc")
	
Function get customFieldsLB->$cb : Object
/* return custom fields as collection directly to display in input form
custom fields were stored for this demo in 2014 as:
{
"Twitter": "@abc",
"Customer Group": "Special"
}
	
we need to rearrange as
[{"name": "Twitter", "value": "@abc"},
{"name": "Customer Group", "value": "Special"}
]
*/
	
	var $col : Collection:=[]
	var $property : Text
	If (This:C1470.CustomFields#Null:C1517)
		For each ($property; This:C1470.CustomFields)
			$col.push(New object:C1471("name"; $property; "value"; This:C1470.CustomFields[$property]))
		End for each 
		$cb:=New object:C1471("result"; $col)
	End if 
	
	
Function get TotalSales->$total : Real
	$total:=This:C1470.invoices.sum("Total")
	
Function get fullAddress->$address : Text
	$address:=This:C1470.Name+Char:C90(13)
	$address+=(This:C1470.Address1+Char:C90(13))
	If (This:C1470.Country="Germany")  // In Germany first Zip, then city
		$address+=(This:C1470.ZipCode+" "+This:C1470.City+Char:C90(13))
	Else   // to keep the code simple, for anything else US format, City, State Zip. Adapt for your country format...
		$address+=(This:C1470.City+", "+This:C1470.State+" "+This:C1470.ZipCode+Char:C90(13))
	End if 
	$address+=This:C1470.Country
	