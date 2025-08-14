If (Form:C1466.data.isNew())
	Form:C1466.data.save()
End if 

var $formdata:=cs:C1710.Form_Input_Main.new()
$formdata.tablename:="INVOICES"
$formdata.SelectedElement:=ds:C1482.INVOICES.new()
$formdata.SelectedElement.ClientID:=Form:C1466.data.ID
$formdata.SelectedElement.Date:=Current date:C33
$formdata.SelectedElement.PaymentDelay:=30
$formdata.SelectedElement.ProForma:=True:C214
var $ProformaNumber:=ds:C1482.SETTINGS.getNextProFormaNumber()
$formdata.SelectedElement.ProformaNumber:="PRF"+String:C10($ProformaNumber; "00000")
var $win:=Open form window:C675("Input_Main")
DIALOG:C40("Input_Main"; $formdata; *)

