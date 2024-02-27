If (Not:C34(Form:C1466.data.Paid))
	ALERT:C41(Get localized string:C991("You can not unpaid an invoice!"))
	Form:C1466.data.Paid:=True:C214
Else 
	CONFIRM:C162("You will not be able to undo this operation. Continue?"; "Yes"; "No")
	If (Ok=1)
		Form:C1466.data.PaymentDate:=Current date:C33(*)
		OBJECT SET VISIBLE:C603(*; "inv_@"; True:C214)
		OBJECT SET VISIBLE:C603(*; "inv_@"; True:C214)
	Else 
		Form:C1466.data.Paid:=False:C215
	End if 
End if 
