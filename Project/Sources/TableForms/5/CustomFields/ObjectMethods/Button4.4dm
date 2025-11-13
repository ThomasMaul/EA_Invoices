C_POINTER:C301($ColPtr)
C_LONGINT:C283($selected)

If (Form event code:C388=On Clicked:K2:4)
	$ColPtr:=OBJECT Get pointer:C1124(Object named:K67:5; "LBcustomFields")
	$selected:=$ColPtr->
	If ($selected>0)
		$selected:=$selected+1
		$ColPtr:=OBJECT Get pointer:C1124(Object named:K67:5; "Tablename")
		INSERT IN ARRAY:C227($ColPtr->; $selected)
		$ColPtr->{$selected}:=$ColPtr->{$selected-1}
		
		$ColPtr:=OBJECT Get pointer:C1124(Object named:K67:5; "Fieldname")
		INSERT IN ARRAY:C227($ColPtr->; $selected)
		$ColPtr->{$selected}:=""
		EDIT ITEM:C870($ColPtr->; $selected)
		
	End if 
End if 