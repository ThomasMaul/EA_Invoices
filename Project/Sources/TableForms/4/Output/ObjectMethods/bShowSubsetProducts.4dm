// [PRODUCTS].Output.bSubsetProducts

COPY SET:C600("$highlightedProducts"; "$tempoProducts")  // Save the current selected products
USE SET:C118("$highlightedProducts")
Products_Reorder
COPY SET:C600("$tempoProducts"; "$highlightedProducts")
