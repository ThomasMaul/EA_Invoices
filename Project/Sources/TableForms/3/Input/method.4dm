Case of 
	: (Form event code:C388=On Load:K2:1)
		productChoice:=[INVOICE_LINES:3]ProductReference:4
		If (Is new record:C668([INVOICE_LINES:3]))
			[INVOICE_LINES:3]Invoice_ID:2:=[INVOICES:2]ID:1
			[INVOICE_LINES:3]Quantity:6:=1
			[INVOICE_LINES:3]DiscountRate:8:=[CLIENTS:1]DiscountRate:18
			GOTO OBJECT:C206(*; "productChoice")
		Else 
			GOTO OBJECT:C206([INVOICE_LINES:3]Quantity:6)
		End if 
		If (Not:C34([INVOICES:2]ProForma:12))
			OBJECT SET ENTERABLE:C238(*; "productChoice"; False:C215)
			OBJECT SET ENTERABLE:C238(*; "invl_ProductReference"; False:C215)
			OBJECT SET ENTERABLE:C238(*; "invl_ProductName"; False:C215)
			OBJECT SET ENTERABLE:C238(*; "invl_Quantity"; False:C215)
			OBJECT SET ENTERABLE:C238(*; "invl_UnitPrice"; False:C215)
			OBJECT SET ENTERABLE:C238(*; "invl_DiscountRate"; False:C215)
			OBJECT SET ENTERABLE:C238(*; "invl_TaxRate"; False:C215)
			_O_DISABLE BUTTON:C193(*; "bDeleteInvoiceLine")
			//OBJECT SET VISIBLE(*;"bDeleteInvoiceLine";False)
		End if 
		OBJECT SET FORMAT:C236(*; "@_cur"; Get localized string:C991("currency"))
End case 
