var $last : cs:C1710.Entity:=Form:C1466.SelectedElement.last()
If ($last#Null:C1517)
	Form:C1466.SelectedElement:=$last
	Form:C1466.preview.data:=$last
End if 
Form:C1466.updateButtons()