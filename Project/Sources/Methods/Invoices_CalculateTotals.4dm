//%attributes = {"invisible":true}
// (P) Invoices_CalculateTotals
// This method is applied to each invoice

// Calculate the invoice totals
[INVOICES:2]Subtotal:5:=Sum:C1([INVOICE_LINES:3]Total:10)
[INVOICES:2]Tax:6:=Sum:C1([INVOICE_LINES:3]TotalTax:11)
[INVOICES:2]Total:7:=[INVOICES:2]Subtotal:5+[INVOICES:2]Tax:6
