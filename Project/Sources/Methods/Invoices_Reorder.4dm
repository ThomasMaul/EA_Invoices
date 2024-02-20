//%attributes = {"invisible":true}
// (P) Invoices_Reorder
ORDER BY:C49([INVOICES:2]; [INVOICES:2]Date:4; <)

If (Length:C16(Get localized string:C991("reorder_label_reverse"))=0)
	infoInvoices:=String:C10(Records in selection:C76([INVOICES:2]))+Get localized string:C991(" invoices out of ")+String:C10(Records in table:C83([INVOICES:2]))
Else 
	infoInvoices:=String:C10(Records in table:C83([INVOICES:2]))+Get localized string:C991(" invoices out of ")+String:C10(Records in selection:C76([INVOICES:2]))
End if 

UPDATE_ALL_BUTTON("bAllInvoices"; Current form table:C627)

UPDATE_SUBSET_BUTTON("bShowSubsetInvoices"; "$highlightedInvoices"; Current form table:C627)