$helper:=cs:C1710.Helper_Invoices.new(Form:C1466.editEntity)
$name:=Select document:C905(System folder:C487(Desktop:K41:16)+"invoice.pdf"; ".PDF"; "Save PDF as"; File name entry:K24:17)
If (OK=1)
	$helper.createPDF(document)
End if 