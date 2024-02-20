// (*) Form Method [PRODUCTS]Input.bDelete
Case of 
	: (Form event code:C388=On Load:K2:1)
		RELATE MANY:C262([PRODUCTS:4])
		If (Records in selection:C76([INVOICE_LINES:3])>0)
			_O_DISABLE BUTTON:C193(*; "bDeleteProduct")
			//OBJECT SET ENABLED(*;"bDeleteProduct";False)
		Else 
			_O_ENABLE BUTTON:C192(*; "bDeleteProduct")
			//OBJECT SET ENABLED(*;"bDeleteProduct";True)
		End if 
		OBJECT SET FORMAT:C236(*; "@_cur"; Get localized string:C991("currency"))
		
		
		//If ((Picture size([PRODUCTS]Picture)=0) & Shift down)
		//[PRODUCTS]Picture:=ToolCreateLogo ("Product")
		//End if 
		
End case 
