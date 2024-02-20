If (Not:C34([INVOICES:2]Paid:8))
	ALERT:C41(Get localized string:C991("You can not unpaid an invoice!"))
	[INVOICES:2]Paid:8:=True:C214
Else 
	CONFIRM:C162("You will not be able to undo this operation. Continue?"; "Yes"; "No")
	If (Ok=1)
		[INVOICES:2]PaymentDate:9:=Current date:C33(*)
		OBJECT SET VISIBLE:C603(*; "inv_@"; True:C214)
		OBJECT SET VISIBLE:C603(*; "inv_@"; True:C214)
	Else 
		[INVOICES:2]Paid:8:=False:C215
	End if 
End if 
