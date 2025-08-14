var $prev : cs:C1710.Entity:=Form:C1466.SelectedElement.previous()
If ($prev#Null:C1517)
	Form:C1466.SelectedElement:=$prev
	Form:C1466.preview.data:=$prev
End if 
Form:C1466.updateButtons()