//%attributes = {}
// to create dynamic objects, we are required to assign methods (not class functions)
// this method is only to route button events
// sorry, yes, we need a project method for this...

var $event : Integer:=FORM Event:C1606.code
var $button : Text:=FORM Event:C1606.objectName

Case of 
	: (($event=On Clicked:K2:4) | ($event=On Alternative Click:K2:36))
		If (Form:C1466.buttons#Null:C1517)  // to be sure we are in the right form...
			CALL FORM:C1391(Form:C1466.parentWindow; Form:C1466.parentForm.handleButtonClick; $button; $event)
		End if 
		
	: ($event=On Data Change:K2:15)
		If (String:C10(FORM Event:C1606.objectName)="search")
			CALL FORM:C1391(Form:C1466.parentWindow; Form:C1466.parentForm.handleSearchbox)
		End if 
End case 
