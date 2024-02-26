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