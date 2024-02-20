// [PRODUCTS].Output.bExportProducts

CREATE SET:C116(Current form table:C627->; "$tempoProducts")
COPY SET:C600("$highlightedProducts"; "$tempSet")  //Save the current highlighted products
If (Records in set:C195("$highlightedProducts")>0)
	CONFIRM:C162("Do you want to export all the products in list or only the highlighted ones?"; "Highlighted only"; "All products in list")
	If (Ok=1)
		USE SET:C118("$highlightedProducts")
	End if 
End if 
FORM SET OUTPUT:C54(Current form table:C627->; "OutputExport")
EXPORT TEXT:C167(Current form table:C627->; "ExportProducts_"+String:C10(Year of:C25(Current date:C33))+"-"+String:C10(Month of:C24(Current date:C33))+"-"+String:C10(Day of:C23(Current date:C33))+"_"+Replace string:C233(String:C10(Current time:C178); ":"; "")+".txt")

COPY SET:C600("$tempSet"; "$highlightedProducts")  //Restore the current highlighted products
USE SET:C118("$tempoProducts")
Products_Reorder
