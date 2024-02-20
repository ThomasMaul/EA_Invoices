// Form method [INVOICES]Input
Case of 
		
	: (Form event code:C388=On Load:K2:1)
		
		FormSetInterface
		
		C_LONGINT:C283($ProformaNumber)
		invoicesSubtotalLabel:=Get localized string:C991("Subtotal")
		
		If (Is new record:C668([INVOICES:2]))
			[INVOICES:2]Client_ID:3:=[CLIENTS:1]ID:1
			[INVOICES:2]Date:4:=Current date:C33
			[INVOICES:2]PaymentDelay:13:=30
			[INVOICES:2]ProForma:12:=True:C214
			$ProformaNumber:=Invoices_GetNumberPrf
			[INVOICES:2]ProformaNumber:14:="PRF"+String:C10($ProformaNumber; "00000")
		End if 
		
		If ([INVOICES:2]ProForma:12)
			
			OBJECT SET VISIBLE:C603(*; "inv_@"; False:C215)
			
		Else 
			
			//OBJECT SET ENTERABLE([INVOICES]ProformaNumber;False)
			//OBJECT SET ENTERABLE([INVOICES]InvoiceNumber;False)
			OBJECT SET ENTERABLE:C238([INVOICES:2]Date:4; False:C215)
			OBJECT SET ENTERABLE:C238([INVOICES:2]PaymentDelay:13; False:C215)
			OBJECT SET ENTERABLE:C238([INVOICES:2]ProForma:12; False:C215)
			OBJECT SET VISIBLE:C603(*; "inv_@"; [INVOICES:2]Paid:8)
			OBJECT SET VISIBLE:C603([INVOICES:2]Paid:8; True:C214)
			OBJECT SET VISIBLE:C603(*; "inv_LabelPaid"; True:C214)
			//OBJECT SET VISIBLE(*;"bDeleteInvoice";False)
			//OBJECT SET VISIBLE(*;"bAddInvoiceLine";False)
			//OBJECT SET VISIBLE(*;"bDeleteInvoiceLine";False)
			
		End if 
		
		OBJECT SET ENABLED:C1123(*; "bDeleteInvoice"; (Records in selection:C76([INVOICE_LINES:3])=0))
		OBJECT SET ENABLED:C1123(*; "bDeleteInvoiceLine"; False:C215)
		OBJECT SET FORMAT:C236(*; "@_cur"; Get localized string:C991("currency"))
		OBJECT SET HELP TIP:C1181([CLIENTS:1]Email:11; [CLIENTS:1]Email:11)
		
		LISTBOX_ADJUST_WIDTH("List Box")
		
		CustomFields_OnLoadMethod
End case 


