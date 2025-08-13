Class extends DataClass

Function getNextInvoiceNumber() : Integer
	// increase Invoice Number counter and return
	var $settings:=ds:C1482.SETTINGS.all().first()
	var $status:=$settings.lock(dk reload if stamp changed:K85:15)
	var $startTime:=Milliseconds:C459
	
	While (($status.sucess=False:C215) && ($startTime+10000<Milliseconds:C459))
		DELAY PROCESS:C323(Current process:C322; 6)  // try 10 times per second
		$status:=$settings.lock(dk reload if stamp changed:K85:15)
	End while 
	
	If ($status.success)
		$settings.CrtInvoiceNumber+=1
		$settings.save()
		$settings.unlock()
		return $settings.CrtInvoiceNumber
	Else 
		return 0
	End if 