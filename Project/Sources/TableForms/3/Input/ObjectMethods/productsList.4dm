// Object Method [INVOICE_LINES]Input.productList

USE SET:C118("$highlightedProducts")
[INVOICE_LINES:3]Product_ID:3:=[PRODUCTS:4]ID:1
productChoice:=[PRODUCTS:4]Reference:2
[INVOICE_LINES:3]ProductReference:4:=[PRODUCTS:4]Reference:2
[INVOICE_LINES:3]ProductName:5:=[PRODUCTS:4]Name:3
[INVOICE_LINES:3]ProductUnitPrice:7:=[PRODUCTS:4]UnitPrice:5
[INVOICE_LINES:3]ProductTaxRate:9:=[PRODUCTS:4]TaxRate:6
Invoices_CalculateLineTotals
GOTO OBJECT:C206(*; "invl_Quantity")
