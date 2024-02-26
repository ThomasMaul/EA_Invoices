//// Form method [INVOICES]Input
//Case of 

//: (Form event code=On Load)

//FormSetInterface

//C_LONGINT($ProformaNumber)
//invoicesSubtotalLabel:=Get localized string("Subtotal")

//If (Is new record([INVOICES]))
//[INVOICES]Client_ID:=[CLIENTS]ID
//[INVOICES]Date:=Current date
//[INVOICES]PaymentDelay:=30
//[INVOICES]ProForma:=True
//$ProformaNumber:=Invoices_GetNumberPrf
//[INVOICES]ProformaNumber:="PRF"+String($ProformaNumber; "00000")
//End if 

//If ([INVOICES]ProForma)

//OBJECT SET VISIBLE(*; "inv_@"; False)

//Else 

////OBJECT SET ENTERABLE([INVOICES]ProformaNumber;False)
////OBJECT SET ENTERABLE([INVOICES]InvoiceNumber;False)
//OBJECT SET ENTERABLE([INVOICES]Date; False)
//OBJECT SET ENTERABLE([INVOICES]PaymentDelay; False)
//OBJECT SET ENTERABLE([INVOICES]ProForma; False)
//OBJECT SET VISIBLE(*; "inv_@"; [INVOICES]Paid)
//OBJECT SET VISIBLE([INVOICES]Paid; True)
//OBJECT SET VISIBLE(*; "inv_LabelPaid"; True)
////OBJECT SET VISIBLE(*;"bDeleteInvoice";False)
////OBJECT SET VISIBLE(*;"bAddInvoiceLine";False)
////OBJECT SET VISIBLE(*;"bDeleteInvoiceLine";False)

//End if 

//OBJECT SET ENABLED(*; "bDeleteInvoice"; (Records in selection([INVOICE_LINES])=0))
//OBJECT SET ENABLED(*; "bDeleteInvoiceLine"; False)
//OBJECT SET FORMAT(*; "@_cur"; Get localized string("currency"))
//OBJECT SET HELP TIP([CLIENTS]Email; [CLIENTS]Email)

//LISTBOX_ADJUST_WIDTH("List Box")

//CustomFields_OnLoadMethod
//End case 


