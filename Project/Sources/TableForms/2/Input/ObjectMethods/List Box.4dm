// [INVOICES].Input.List Box

Case of 
	: (Form event code:C388=On Selection Change:K2:29)
		
		UPDATE_DELETE_BUTTON("bDeleteInvoiceLine"; "$highlightedInvoiceLines")
		
	: (Form event code:C388=On Double Clicked:K2:5)
		
		MODIFY RECORD:C57([INVOICE_LINES:3]; *)  // Modify the current selected invoice line
		RELATE MANY:C262([INVOICES:2])
		Invoices_CalculateTotals
		InvoiceLines_Reorder
		
End case 