// (*) Object method [INVOICES]Input.bAddInvoiceLine

SAVE RECORD:C53([INVOICES:2])
ADD RECORD:C56([INVOICE_LINES:3]; *)
If (Ok=1)
	_O_DISABLE BUTTON:C193(*; "bCancelInvoice")
	//OBJECT SET VISIBLE(*;"bCancelInvoice";False)
End if 
RELATE MANY:C262([INVOICES:2])
Invoices_CalculateTotals
InvoiceLines_Reorder