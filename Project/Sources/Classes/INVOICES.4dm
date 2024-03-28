Class extends DataClass

// overwrite the popup toolbar for Printing
Function OverWriteButtonPopup($title : Text; $menu : Text)
	// we add 4 items.
	//Printing classic forms
	//Printing using 4D Write Pro templates: PDF
	//Printing using 4D Write Pro templates: paper, duplex (conditions on background first page), color
	//Printing using 4D Write Pro templates: paper, BW
	
	APPEND MENU ITEM:C411($menu; "Classic Invoice")
	SET MENU ITEM PARAMETER:C1004($menu; -1; "Classic Invoice")
	APPEND MENU ITEM:C411($menu; "New Invoice as PDF")
	SET MENU ITEM PARAMETER:C1004($menu; -1; "New Invoice as PDF")
	APPEND MENU ITEM:C411($menu; "New Invoice Color Paper")
	SET MENU ITEM PARAMETER:C1004($menu; -1; "New Invoice Color Paper")
	APPEND MENU ITEM:C411($menu; "New Invoice BW Paper")
	SET MENU ITEM PARAMETER:C1004($menu; -1; "New Invoice BW Paper")