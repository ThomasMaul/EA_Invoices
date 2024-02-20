//%attributes = {"invisible":true}
// (P) Invoices_Delete

C_LONGINT:C283($highlightedInvoices; $i)

$highlightedInvoices:=Records in set:C195("$highlightedInvoices")
If ($highlightedInvoices>0)
	CONFIRM:C162("Do you really want to delete "+String:C10($highlightedInvoices)+" invoice(s)?"; "Yes"; "No")
	If (Ok=1)
		USE SET:C118("$highlightedInvoices")
		QUERY SELECTION:C341([INVOICES:2]; [INVOICES:2]ProForma:12=False:C215)
		If (Records in selection:C76([INVOICES:2])>0)
			CONFIRM:C162("Only the invoice(s) pro forma will be deleted. Continue?"; "Yes"; "No")
		Else 
			Ok:=1
		End if 
		If (Ok=1)
			USE SET:C118("$highlightedInvoices")
			FIRST RECORD:C50([INVOICES:2])
			For ($i; 1; Records in selection:C76([INVOICES:2]))
				If ([INVOICES:2]ProForma:12)
					RELATE MANY:C262([INVOICES:2]ID:1)
					DELETE SELECTION:C66([INVOICE_LINES:3])  // Delete the selected invoice lines
					DELETE RECORD:C58([INVOICES:2])  // Delete the selected invoice
				End if 
				NEXT RECORD:C51([INVOICES:2])
			End for 
			RELATE MANY:C262([CLIENTS:1])  // Create the list of the client invoices
			Invoices_Reorder  // Sort the current list of invoices
		End if 
	End if 
Else 
	ALERT:C41("No invoice(s) selected")
End if 
