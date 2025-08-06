Class extends Entity

exposed Function SelectDate()
	If (This:C1470#Null:C1517)
		// find the Desktop Session ID
		var $sessionID : Text:=Session:C1714.storage.client4D.sessionID
		
		If (Application type:C494=4D Remote mode:K5:5)
			EXECUTE ON CLIENT:C651($sessionID; "SelectInvoice_ExecuteClient"; This:C1470.ID)
		Else 
			//CALL WORKER("RemoteWorker"; "SelectInvoice_ExecuteClient"; This.ID)  // still runs in wrong session?
			New process:C317("SelectInvoice_ExecuteClient"; 0; "SelectInvoice_ExecuteClient"; This:C1470.ID)  //  this seems to work in desktop session
		End if 
	End if 
	