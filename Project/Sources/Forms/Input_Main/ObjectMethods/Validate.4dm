var $status : Object:=Form:C1466.preview.data.save(dk auto merge:K85:24)
If ($status.success)
	ds:C1482.validateTransaction()
	CANCEL:C270
Else 
	ALERT:C41("Error on saving: "+$status.statusText)
End if 