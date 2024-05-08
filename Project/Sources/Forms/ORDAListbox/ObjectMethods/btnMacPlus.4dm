Case of 
	: (Form event code:C388=On Clicked:K2:4)
		If (Is window maximized:C1830(Current form window:C827))
			MINIMIZE WINDOW:C454(Current form window:C827)
		Else 
			MAXIMIZE WINDOW:C453(Current form window:C827)
		End if 
		
	: (Form event code:C388=On Mouse Enter:K2:33)
		OBJECT SET FORMAT:C236(*; "btnClose"; ";path:/RESOURCES/images/mac/close2.png")
		OBJECT SET FORMAT:C236(*; "btnMinus"; ";path:/RESOURCES/images/mac/minus2.png")
		OBJECT SET FORMAT:C236(*; "btnPlus"; ";path:/RESOURCES/images/mac/plus2.png")
		
	: (Form event code:C388=On Mouse Leave:K2:34)
		OBJECT SET FORMAT:C236(*; "btnClose"; ";path:/RESOURCES/images/mac/close.png")
		OBJECT SET FORMAT:C236(*; "btnMinus"; ";path:/RESOURCES/images/mac/minus.png")
		OBJECT SET FORMAT:C236(*; "btnPlus"; ";path:/RESOURCES/images/mac/plus.png")
End case 
