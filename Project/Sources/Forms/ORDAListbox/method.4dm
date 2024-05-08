var $sub : Object

Case of 
	: (Form event code:C388=On Close Box:K2:21)
		// code also in red/close button, as we handle this with new window type ourself
		ARRAY LONGINT:C221($windows; 0)
		WINDOW LIST:C442($windows)
		If (Size of array:C274($Windows)=1)  // if not already in design mode or other windows open, quit...
			If (Is compiled mode:C492)
				QUIT 4D:C291
			Else 
				CONFIRM:C162("Quit or open design mode?"; "Quit"; "Design")
				If (OK=1)
					QUIT 4D:C291
				Else 
					SHOW MENU BAR:C431
					INVOKE ACTION:C1439(ak return to design mode:K76:62)
				End if 
			End if 
		Else 
			CANCEL:C270  // close only this window, don't ask/quit
		End if 
		
	: (Form event code:C388=On Load:K2:1)
		If (Is macOS:C1572)
			OBJECT SET VISIBLE:C603(*; "BtnWin@"; False:C215)
		Else 
			OBJECT SET VISIBLE:C603(*; "BtnMac@"; False:C215)
			OBJECT MOVE:C664(*; "buttonsubform"; -88; 0; 88; 0)
			HIDE MENU BAR:C432
		End if 
		
		Form:C1466.ORDA_listbox:=cs:C1710.ORDA_Listbox.new(ds:C1482.CLIENTS)
		Form:C1466.ORDA_listbox.load()
		Form:C1466.ORDA_listbox.setInputForm()
		
		Form:C1466.toolbar:=cs:C1710.Toolbar.new()
		Form:C1466.toolbar.load()
		
	: (Form event code:C388=On Unload:K2:2)
		// nothing in this example
		
	: (Form event code:C388=On Resize:K2:27)
		Form:C1466.toolbar.resize()
		Form:C1466.ORDA_listbox.resize()
		
End case 