Case of 
	: (Form event code:C388=On Load:K2:1)
		
		FormSetInterface
		
		OBJECT SET ENABLED:C1123(*; "bShowSubsetInvoices"; False:C215)
		OBJECT SET ENABLED:C1123(*; "bDeleteInvoices"; False:C215)
		invoicesSubtotalLabel:=Get localized string:C991("Total")
		Invoices_Reorder
		LISTBOX_ADJUST_WIDTH("ListBoxInvoices")
		
End case 