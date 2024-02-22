//%attributes = {}
// called from ORDA_listbox Toolbar (buttons on top)
// those buttons automatically call a method using the method property, so it needs to be a project method

var $event : Integer:=FORM Event:C1606.code

Case of 
	: (($event=On Clicked:K2:4) | ($event=On Alternative Click:K2:36))
		If (Form:C1466.buttons#Null:C1517)  // to be sure we are in the right form...
			var $buttonname : Text:=FORM Event:C1606.objectName
			CALL FORM:C1391(Current form window:C827; Formula:C1597(Form:C1466.ORDA_listbox.handleButtonClick($buttonname; FORM Event:C1606.code)))
		End if 
		
	: ($event=On Data Change:K2:15)
		If (String:C10(FORM Event:C1606.objectName)="search")
			CALL FORM:C1391(Current form window:C827; Formula:C1597(Form:C1466.ORDA_listbox.handleSearchbox()))
		End if 
End case 