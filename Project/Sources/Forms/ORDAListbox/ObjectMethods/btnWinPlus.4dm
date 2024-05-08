Case of 
	: (Form event code:C388=On Clicked:K2:4)
		
		
		If (Is window maximized:C1830(Current form window:C827))
			MINIMIZE WINDOW:C454(Current form window:C827)
			OBJECT SET FORMAT:C236(*; "btnPlus"; ";path:/RESOURCES/images/win/maximize.png")
		Else 
			MAXIMIZE WINDOW:C453(Current form window:C827)
			OBJECT SET FORMAT:C236(*; "btnPlus"; ";path:/RESOURCES/images/win/restore.png")
		End if 
		
End case 
