// [INVOICES].Output.bSubsetInvoices

COPY SET:C600("$highlightedInvoices"; "$tempoInvoices")  // Save the current selected invoices
USE SET:C118("$highlightedInvoices")
Invoices_Reorder
COPY SET:C600("$tempoInvoices"; "$highlightedInvoices")
