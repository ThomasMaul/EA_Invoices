var $version:=Application version:C493
If ($version<"20A0")
	ALERT:C41("This Demo requires 4D 20 R10 or newer.")
End if 

// Storage for Company Informations
// as inhouse developer, just enter your data here
// as software reseller, usually you store that in a table and allow the end user to modify it
var $company:=New shared object:C1526("company"; "ACE company"; "ID"; Null:C1517; "zip"; "12345"; "city"; "Himmelstadt"; "street"; "Himmelsleiter 42"; "country"; "DE"; "vat"; "DE12345678"; \
"iban"; "DE844456258123"; "VAT_Rate"; 19)
Use (Storage:C1525)
	Storage:C1525.company:=$company
End use 

If (ds:C1482.CLIENTS.getCount()=0)  // Test if the database is empty
	CONFIRM:C162("Your database is empty."+Char:C90(Carriage return:K15:38)+"Do you want to import some sample data?"; "Yes, please!"; "No, thanks")
	If (Ok=1)
		var $fill:=cs:C1710.Helper_Demo.new().buildDemoData()
		If ($fill#"")
			ALERT:C41($fill)
		End if 
	End if 
End if 

// now we can finally start...
If (Is Windows:C1573)
	HIDE MENU BAR:C432
End if 
SET MENU BAR:C67("empty")
var $win : Integer:=Open form window:C675("ORDAListbox"; Plain form window no title:K39:19)
DIALOG:C40("ORDAListbox"; *)

