Class extends Entity

Alias CustomerName client.Name

local Function get customFieldsLB->$cb : Object  // the data is already on the client, no need to ask the server
	return cs:C1710.CustomFields.me.buildContent("INVOICES"; This:C1470.CustomFields)
	
local Function updateTotals()
	// calculates Subtotal, Tax and Total
	// cannot be run in event, as there might be no change in invoice, only invoice item
	// local, as we need the results on the client, without reloading the invoice
	var $items:=ds:C1482.INVOICE_LINES.query("Invoice_ID=:1"; This:C1470.ID)
	// we cannot use the relation, as there might be just new created ones
	This:C1470.Subtotal:=$items.sum("Total")
	This:C1470.Tax:=$items.sum("TotalTax")
	This:C1470.Total:=This:C1470.Subtotal+This:C1470.Tax
	