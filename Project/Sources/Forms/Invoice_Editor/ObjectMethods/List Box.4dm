If (FORM Event:C1606.code=On Begin Drag Over:K2:44)
	Form:C1466.drop:=OB Copy:C1225(Form:C1466.selectedField)
	If ((Form:C1466.drop.field="data@") | (Form:C1466.drop.field="item@"))
		Form:C1466.drop.field:="This."+Form:C1466.drop.field
	End if 
	
End if 


