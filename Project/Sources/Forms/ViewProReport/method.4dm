Case of 
	: (FORM Event:C1606.code=On Load:K2:1)
		// debug, just for testing in stand alone, should be set from calling code
		
		If (Form:C1466.table=Null:C1517)
			Form:C1466.table:="INVOICES"
		End if 
		If (Form:C1466.data=Null:C1517)
			Form:C1466.data:=ds:C1482[Form:C1466.table].all()
		End if 
		
		
End case 