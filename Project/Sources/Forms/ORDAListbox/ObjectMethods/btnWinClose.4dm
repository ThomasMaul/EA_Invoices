Case of 
	: (Form event code:C388=On Clicked:K2:4)
		
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
		
End case 
