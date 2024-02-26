// (*) Form Method [PRODUCTS]Input.bDelete
Case of 
	: (Form event code:C388=On Load:K2:1)
		RELATE MANY:C262([PRODUCTS:4])
		If (Records in selection:C76([INVOICE_LINES:3])>0)
			OBJECT SET ENABLED:C1123(*; "bDeleteProduct"; False:C215)
		Else 
			OBJECT SET ENABLED:C1123(*; "bDeleteProduct"; True:C214)
		End if 
		OBJECT SET FORMAT:C236(*; "@_cur"; Get localized string:C991("currency"))
		
		
		//If ((Picture size([PRODUCTS]Picture)=0) & Shift down)
		//[PRODUCTS]Picture:=ToolCreateLogo ("Product")
		//End if 
		
End case 
