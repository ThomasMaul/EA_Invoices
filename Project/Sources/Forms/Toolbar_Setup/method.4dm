var $event : Object:=FORM Event:C1606
Case of 
	: ($event.code=On Load:K2:1)
		var $list : cs:C1710.Toolbar_Setup:=cs:C1710.Toolbar_Setup.new(Get 4D folder:C485(Current resources folder:K5:16)+"Images"+Folder separator:K24:12+"Buttons_32"+Folder separator:K24:12)
		$list.buttonsInit()
		$list.assign("Toolbar_Store")
		
		var $newlist : Integer:=New list:C375
		SET LIST PROPERTIES:C387($newlist; 0; 0; 38)
		OBJECT Get pointer:C1124(Object named:K67:5; "Toolbar_User")->:=$newlist
		
		Form:C1466.mainlist:=$list
		Form:C1466.userlist:=$newlist
		
		var $buttons : Collection
		var $file : 4D:C1709.File
		$file:=Folder:C1567(fk logs folder:K87:17).folder("Settings").folder("Toolbar").file("User.json")
		If ($file.exists)
			$buttons:=JSON Parse:C1218($file.getText()).settings
		Else 
			$file:=Folder:C1567(fk resources folder:K87:11).folder("Settings").folder("Toolbar").file("Default.json")
			If ($file.exists)
				$buttons:=JSON Parse:C1218($file.getText()).settings
			End if 
		End if 
		
		If ($buttons#Null:C1517)
			Form:C1466.mainlist.setUserSettings($buttons)
		End if 
		
	: ($event.code=On Unload:K2:2)
		$list.clear()
		CLEAR LIST:C377(Form:C1466.userlist; *)
End case 