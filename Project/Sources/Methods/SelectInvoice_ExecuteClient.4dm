//%attributes = {}
// called via Execute on Client from ORDA class, which is executed on the server through Qodly

#DECLARE($invoiceID : Integer)

If ($invoiceID#0)
	CALL FORM:C1391(Frontmost window:C447; cs:C1710.Form_Code.me.selectInvoice; $invoiceID)  // using entity is received as NULL - because different session?
End if 