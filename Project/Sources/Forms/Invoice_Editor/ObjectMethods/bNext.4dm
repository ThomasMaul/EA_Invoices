var $next : cs:C1710.INVOICESEntity
$next:=Form:C1466.Invoice.next()
If ($next=Null:C1517)
	$next:=ds:C1482.INVOICES.all().first()
End if 

Form:C1466.Invoice:=$next
Form:C1466.Number:=Form:C1466.Invoice.Invoice_Number
Form:C1466.helper.updateInvoice($Next)
