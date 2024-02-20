Case of 
	: (Form event code:C388=On Load:K2:1)
		Form:C1466.ORDA_listbox:=cs:C1710.ORDA_Listbox.new(ds:C1482.CLIENTS)
		Form:C1466.ORDA_listbox.load()
		
		Form:C1466.toolbar:=cs:C1710.Toolbar.new()  // clear and build new
		
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
		
		
		$allbuttons:=cs:C1710.Toolbar_Setup.new(Get 4D folder:C485(Current resources folder:K5:16)+"Images"+Folder separator:K24:12+"Buttons_32"+Folder separator:K24:12)
		$allbuttons.buttonsInit()
		
		$groupcounter:=1
		For each ($button; $buttons)
			If ($button.name="Divider")
				$groupcounter:=$groupcounter+1
			Else 
				Form:C1466.toolbar.add(OrdaListbox_Toolbar2(""; String:C10($groupcounter); 0; False:C215; ""; $button; $allbuttons))
			End if 
		End for each 
		
		
		// #### Search Picker
		$searchbox:=cs:C1710.Toolbar_Button.new(New object:C1471("name"; "search"; "group"; "300"; "mytype"; 1; "prio"; 1000))
		$searchbox.width:=205
		$searchbox.height:=36
		$searchbox.method:="OrdaListbox_Button_Call"
		$searchbox.subform:="SearchPicker"
		C_TEXT:C284(vSearch)
		$searchbox.dataSource:="vSearch"  // needs to be a process text variable, Form.xx will not work
		$searchbox.dataSourceTypeHint:="text"  // needs to b 
		vSearch:=""  // default text empty
		Form:C1466.toolbar.add($searchbox)
		
		C_OBJECT:C1216($sub)
		$sub:=Form:C1466.toolbar.getSubform("buttonsubform")
		OBJECT SET SUBFORM:C1138(*; "buttonsubform"; $sub)
		
		
	: (Form event code:C388=On Unload:K2:2)
		// nothing in this example
		
	: (Form event code:C388=On Resize:K2:27)
		//Form.toolbar.resize()
		Form:C1466.ORDA_listbox.resize()
		
End case 