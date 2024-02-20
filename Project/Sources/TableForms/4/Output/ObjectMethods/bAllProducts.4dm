// [PRODUCTS].Output.bAllProducts
COPY SET:C600("$highlightedProducts"; "$tempoProducts")  // Save the current selected products
ALL RECORDS:C47(Current form table:C627->)
Products_Reorder
COPY SET:C600("$tempoProducts"; "$highlightedProducts")
