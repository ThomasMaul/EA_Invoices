var $status : Object:=Form:C1466.settings.save(dk auto merge:K85:24)
If ($status.success=False:C215)
	ALERT:C41("Error saving settings: "+$status.statusText)
Else 
	CANCEL:C270  // close the window
End if 