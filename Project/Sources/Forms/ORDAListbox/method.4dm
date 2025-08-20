var $sub : Object

Case of 
	: (Form event code:C388=On Close Box:K2:21)
		Form:C1466.closeWindow()
		
		
	: (Form event code:C388=On Load:K2:1)
		If (Is macOS:C1572)
			OBJECT SET VISIBLE:C603(*; "BtnWin@"; False:C215)
		Else 
			OBJECT SET VISIBLE:C603(*; "BtnMac@"; False:C215)
			OBJECT MOVE:C664(*; "buttonsubform"; -88; 0; 88; 0)
			HIDE MENU BAR:C432
		End if 
		
		Form:C1466.setTable(ds:C1482.CLIENTS)
		Form:C1466.load()
		Form:C1466.setInputForm()
		
		Form:C1466.toolbar:=cs:C1710.Toolbar.new()
		Form:C1466.toolbar.load()
		
	: (Form event code:C388=On Unload:K2:2)
		// nothing in this example
		
	: (Form event code:C388=On Resize:K2:27)
		Form:C1466.toolbar.resize()
		Form:C1466.resize()
		
End case 