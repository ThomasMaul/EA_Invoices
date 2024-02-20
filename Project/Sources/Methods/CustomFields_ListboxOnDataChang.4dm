//%attributes = {}
// call from listbox in detail form, for On Data Change event
C_LONGINT:C283($tablenum; $i2; $index)
C_TEXT:C284($new; $fieldname; $name)
C_POINTER:C301($tableptr; $fieldptr; $ColPtr)
C_BOOLEAN:C305($hasfield)
C_VARIANT:C1683($value)

If (Form event code:C388=On Data Change:K2:15)
	
	$tableptr:=Current form table:C627
	$hasfield:=False:C215
	$tablenum:=Table:C252($tableptr)
	For ($i2; 1; Get last field number:C255($tableptr))
		If (Is field number valid:C1000($tablenum; $i2))
			$fieldname:=Field name:C257($tablenum; $i2)
			If ($fieldname="CustomFields")
				If (Type:C295(Field:C253($tablenum; $i2)->)=Is object:K8:27)
					$hasfield:=True:C214
					$fieldptr:=Field:C253($tablenum; $i2)
				End if 
			End if 
		End if 
	End for 
	If ($hasfield)
		// get field name and field value
		$index:=OBJECT Get pointer:C1124(Object named:K67:5; "customF_LB")->
		$ColPtr:=OBJECT Get pointer:C1124(Object named:K67:5; "CLB_Name")
		$name:=$ColPtr->{$index}
		$ColPtr:=OBJECT Get pointer:C1124(Object named:K67:5; "CLB_Value")
		$value:=$ColPtr->{$index}
		
		If ($value#"")
			OB SET:C1220($fieldptr->; $name; $value)
		Else 
			$new:=$fieldptr->
			OB REMOVE:C1226($new; $name)
			$fieldptr->:=$new
		End if 
	End if 
End if 