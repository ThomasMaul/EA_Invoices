// [INVOICES].Output.bPrintInvoices

CREATE SET:C116(Current form table:C627->; "$tempoInvoices")
COPY SET:C600("$highlightedInvoices"; "$tempSet")  //Save the current highlighted clients
If (Records in set:C195("$highlightedInvoices")>0)
	CONFIRM:C162("Do you want to print all the invoices in list or only the highlighted ones?"; "Highlighted only"; "All invoices in list")
	If (Ok=1)
		USE SET:C118("$highlightedInvoices")
	End if 
End if 
FORM SET OUTPUT:C54(Current form table:C627->; "OutputPrint")
PRINT SELECTION:C60(Current form table:C627->)

COPY SET:C600("$tempSet"; "$highlightedInvoices")  //Restore the current highlighted invoices
USE SET:C118("$tempoInvoices")
Invoices_Reorder
