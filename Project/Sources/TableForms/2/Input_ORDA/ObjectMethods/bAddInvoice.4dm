If (Form:C1466.data.isNew())
	Form:C1466.data.save()
End if 

var $newLine:=ds:C1482.INVOICE_LINES.new()
$newLine.Invoice_ID:=Form:C1466.data.ID
$newLine.save()
Form:C1466.itemList:=Form:C1466.itemList.add($newLine)
// selected is ordered, so new one is the last

