var $first : cs:C1710.Entity:=Form:C1466.SelectedElement.first()
If ($first#Null:C1517)
	Form:C1466.SelectedElement:=$first
	Form:C1466.preview.data:=$first
End if 
Form:C1466.updateButtons()