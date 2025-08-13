Case of 
	: (FORM Event:C1606.code=On Load:K2:1)
		If (Form:C1466.settings=Null:C1517)
			Form:C1466.settings:=ds:C1482.SETTINGS.all().first()
		End if 
End case 