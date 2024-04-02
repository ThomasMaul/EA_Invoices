If (Form event code:C388=On Load:K2:1)
	
	// Tab Control
	var $items : Collection:=Split string:C1554(Get localized string:C991("IE_TabControl"); ";")
	
	Form:C1466.oTab:=New object:C1471
	Form:C1466.oTab.values:=$items
	Form:C1466.oTab.index:=0  // select the first Tab
	
	
	
	Form:C1466.Invoice:=ds:C1482.INVOICES.all().first()
	Form:C1466.Number:=Form:C1466.Invoice.InvoiceNumber
	Form:C1466.drop:=Null:C1517
	var $context : Object:={invoice: Form:C1466.Invoice; seller: Storage:C1525.company}
	Form:C1466.helper:=cs:C1710.Helper_Invoices.new($context)
	WPArea:=Form:C1466.helper.WP
	
	var $col : Collection:=New collection:C1472
	var $file : 4D:C1709.File
	$file:=Folder:C1567(fk resources folder:K87:11).folder("EditorTemplates").file("Invoice_Fieldlist.txt")
	If ($file.exists)
		var $liste : Text:=$file.getText("UTF-8"; Document with LF:K24:22)
		var $listecol : Collection:=Split string:C1554($liste; Char:C90(10))
		var $line : Text
		For each ($line; $listecol)
			var $cells : Collection:=Split string:C1554($line; Char:C90(9))
			If ($cells.length>=2)
				$col.push(New object:C1471("field"; $cells[0]; "name"; $cells[1]))
			End if 
		End for each 
	End if 
	Form:C1466.fieldlist:=$col
	
	
End if 
