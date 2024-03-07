CONFIRM:C162(Get localized string:C991("Reset_Defaults"))
If (OK=1)
	var $file : 4D:C1709.File:=Folder:C1567(fk resources folder:K87:11).folder("Settings").folder("Toolbar").file("Default.json")
	If (Asserted:C1132($file.exists; "File /Settings/Toolbar/Buttons.json missing"))
		var $buttons : Collection:=JSON Parse:C1218($file.getText()).settings
		
		CLEAR LIST:C377(Form:C1466.userlist; *)
		var $newlist : Integer:=New list:C375
		SET LIST PROPERTIES:C387($newlist; 0; 0; 38)
		OBJECT Get pointer:C1124(Object named:K67:5; "Toolbar_User")->:=$newlist
		Form:C1466.userlist:=$newlist
		
		Form:C1466.mainlist.setUserSettings($buttons)
		Form:C1466.mainlist.isModified:=True:C214
	End if 
End if 