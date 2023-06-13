$name:=Request:C163("Name")
If (OK=1)
	$ent:=ds:C1482.Document_Templates.new()
	$ent.Name:=$name
	$ent.save()
	
	Form:C1466.list:=ds:C1482.Document_Templates.all().orderBy("Name")
	WPArea:=WP New:C1317()
	
End if 