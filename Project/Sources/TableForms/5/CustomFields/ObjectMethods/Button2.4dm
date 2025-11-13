C_TEXT:C284($tablename)
C_POINTER:C301($ColPtr)
C_LONGINT:C283($selected)

If (Form event code:C388=On Clicked:K2:4)
	$ColPtr:=OBJECT Get pointer:C1124(Object named:K67:5; "LBcustomFields")
	$selected:=$ColPtr->
	If ($selected>0)
		$ColPtr:=OBJECT Get pointer:C1124(Object named:K67:5; "Tablename")
		$tablename:=$ColPtr->{$selected}
		If (Count in array:C907($ColPtr->; $tablename)>1)
			DELETE FROM ARRAY:C228($ColPtr->; $selected)
			$ColPtr:=OBJECT Get pointer:C1124(Object named:K67:5; "Fieldname")
			DELETE FROM ARRAY:C228($ColPtr->; $selected)
		Else 
			// last entry for that table
			$ColPtr:=OBJECT Get pointer:C1124(Object named:K67:5; "Fieldname")
			$ColPtr->{$selected}:=""
		End if 
	End if 
End if 