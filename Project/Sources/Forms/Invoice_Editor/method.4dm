If (Form event code:C388=On Load:K2:1)
	
	Form:C1466.Invoice:=ds:C1482.INVOICES.all().first()
	Form:C1466.Number:=Form:C1466.Invoice.Invoice_Number
	Form:C1466.drop:=Null:C1517
	Form:C1466.helper:=cs:C1710.Helper_Invoices.new(Form:C1466.Invoice)
	WPArea:=Form:C1466.helper.WP
	
	$templates:=ds:C1482.Document_Templates.query("Name='Invoice@'")
	$templatenames:=$templates.Name
	Form:C1466.templates:=New object:C1471
	Form:C1466.templates.values:=$templatenames
	Form:C1466.templates.index:=$templatenames.indexOf("Invoice")
	
	$col:=New collection:C1472
	var $file : 4D:C1709.File
	$file:=Folder:C1567(fk resources folder:K87:11).folder("EditorTemplates").file("Invoice_Fieldlist.txt")
	If ($file.exists)
		$liste:=$file.getText("UTF-8"; Document with LF:K24:22)
		$listecol:=Split string:C1554($liste; Char:C90(10))
		For each ($line; $listecol)
			$cells:=Split string:C1554($line; Char:C90(9))
			If ($cells.length>=2)
				$col.push(New object:C1471("field"; $cells[0]; "name"; $cells[1]))
			End if 
		End for each 
	End if 
	Form:C1466.fieldlist:=$col
	
End if 
