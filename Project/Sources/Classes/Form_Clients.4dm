property data : cs:C1710.CLIENTSEntity
property Position : Integer

Function loadEvent()
	// nothing
	
Function Invoices_ChangeColor($this : Object) : Integer
	If (Not:C34($this.Paid))
		If (($this.Date+$this.PaymentDelay)<Current date:C33)
			return 0x00FF6060  //0x00FF0000
		End if 
	Else 
		return 0x0025BD3C  //0x0027C940  //0x6400
	End if 
	return 0x0000