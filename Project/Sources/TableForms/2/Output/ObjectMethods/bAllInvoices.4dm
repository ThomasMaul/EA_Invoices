// [INVOICES].Output.bAllInvoices
COPY SET:C600("$highlightedInvoices"; "$tempoInvoices")  // Save the current selected invoices
ALL RECORDS:C47(Current form table:C627->)
Invoices_Reorder
COPY SET:C600("$tempoInvoices"; "$highlightedInvoices")
