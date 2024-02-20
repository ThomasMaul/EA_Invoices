//%attributes = {"invisible":true}
// (P) Invoices_ChangeColor

If (Not:C34([INVOICES:2]Paid:8))
	If (([INVOICES:2]Date:4+[INVOICES:2]PaymentDelay:13)<Current date:C33(*))
		$0:=0x00FF6060  //0x00FF0000
	End if 
Else 
	$0:=0x0025BD3C  //0x0027C940  //0x6400
End if 
