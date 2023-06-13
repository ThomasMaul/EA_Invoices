If (FORM Event:C1606.code=On Load:K2:1)
	WPArea:=WP New:C1317()
	Form:C1466.list:=ds:C1482.Document_Templates.all().orderBy("Name")
End if 
