If (Form:C1466.Selected#Null:C1517)
	If (Form:C1466.Selected.ProForma)
		Form:C1466.Selected.drop()
	Else 
		ALERT:C41("You can only delete ProForma invoices")
	End if 
End if 