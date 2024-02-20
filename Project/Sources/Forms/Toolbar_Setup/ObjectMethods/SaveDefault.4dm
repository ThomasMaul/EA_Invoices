If (Application type:C494#4D Local mode:K5:1)
	ALERT:C41("Only in local mode possible, please contact admin")
Else 
	CONFIRM:C162(Get localized string:C991("Overwrite_user_settings"))
	If (OK=1)
		var $file : 4D:C1709.File:=Folder:C1567(fk resources folder:K87:11).folder("Settings").folder("Toolbar").file("Default.json")
		$file.setText(JSON Stringify:C1217(New object:C1471("settings"; Form:C1466.mainlist.storeSettings())))
	End if 
End if 
