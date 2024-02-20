//%attributes = {"invisible":true}
// (P) Invoices_CalculateLineTotals
// This method is applied to each invoice line

// Calculate the total price per line item

If ([INVOICE_LINES:3]DiscountRate:8#0)
	[INVOICE_LINES:3]Total:10:=[INVOICE_LINES:3]ProductUnitPrice:7*[INVOICE_LINES:3]Quantity:6*(1-([INVOICE_LINES:3]DiscountRate:8/100))
Else 
	[INVOICE_LINES:3]Total:10:=[INVOICE_LINES:3]ProductUnitPrice:7*[INVOICE_LINES:3]Quantity:6
End if 

// Calculate the total tax per line item
[INVOICE_LINES:3]TotalTax:11:=[INVOICE_LINES:3]Total:10*([INVOICE_LINES:3]ProductTaxRate:9/100)

