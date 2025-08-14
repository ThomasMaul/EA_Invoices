var $next : cs:C1710.Entity:=Form:C1466.SelectedElement.next()
If ($next#Null:C1517)
	Form:C1466.SelectedElement:=$next
	Form:C1466.preview.data:=$next
End if 
Form:C1466.updateButtons()