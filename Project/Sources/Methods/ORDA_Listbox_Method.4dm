//%attributes = {}
/* this method allows customization, it is used for 3 different purposes

- used as object method for Toolbar buttons. (from ORDA_listbox Toolbar)
   zero parameters given
   use the button name to identify - and then do whatever special action you need

- prepare preview form, init your data here depending of your tables
   parameter "preview"

- handle double click, either open classic process or open form as ORDA form in current process
  parameter "doubleclick" 

- double click - new process, opens input form in classic mode
  this is a placeholder, most of you have code for that already
  instead of using this placeholder, call your existing code
  the placeholder uses as job "doubleclick_process", with additional parameters
  tablename and primary key

*/

#DECLARE($job : Text; $classname : Text; $pk : Text)

Case of 
		//MARK: button - called from object method
	: ($job="")
		var $event : Integer:=FORM Event:C1606.code
		
		Case of 
			: (($event=On Clicked:K2:4) | ($event=On Alternative Click:K2:36))
				If (Form:C1466.buttons#Null:C1517)  // to be sure we are in the right form...
					var $buttonname : Text:=FORM Event:C1606.objectName
					CALL FORM:C1391(Current form window:C827; Formula:C1597(Form:C1466.handleButtonClick($buttonname; $event)))
				End if 
				
			: ($event=On Data Change:K2:15)
				If (String:C10(FORM Event:C1606.objectName)="search")
					CALL FORM:C1391(Current form window:C827; Formula:C1597(Form:C1466.handleSearchbox()))
				End if 
		End case 
		
		
		
	: ($job="customButton")
		Case of 
			: (($classname="Clients") | ($classname="Module"))
				Form:C1466.setTable(ds:C1482.CLIENTS)
				Form:C1466.load()
				Form:C1466.toolbar.load()  // this will recreate the toolbar, produce flicker. But allow to change buttons or show/hide searchbox
				Form:C1466.setInputForm()
			: ($classname="Invoices")
				Form:C1466.setTable(ds:C1482.INVOICES)
				Form:C1466.load()
				Form:C1466.toolbar.load()
				Form:C1466.setInputForm()
			: ($classname="Products")
				Form:C1466.setTable(ds:C1482.PRODUCTS)
				Form:C1466.load()
				Form:C1466.toolbar.load()
				Form:C1466.setInputForm()
				
			: ($classname="Add")  // "New" button, different behavior depending of module
				Case of 
					: ((Form:C1466.ORDA_listbox.tablename="CLIENTS") | (Form:C1466.ORDA_listbox.tablename="PRODUCTS"))
						// code similar to double click, but with new record
						$p:=New process:C317("ORDA_Listbox_Method"; 0; "ORDA_Listbox_Doubleclick"; "doubleclick_process"; Form:C1466.ORDA_listbox.tablename; "")
						
					: (Form:C1466.ORDA_listbox.tablename="INVOICES")
						ALERT:C41(Localized string:C991("NoNewButtonForInvoices"))
						
					Else 
						ALERT:C41("Not supported")
				End case   // button New
				
			: ($classname="Settings")
				Settings_Manage
				
			: ($classname="4DViewPro")
				var $data : Object:=New object:C1471("table"; Form:C1466.ORDA_listbox.tablename; "masterform"; Form:C1466)
				If (Form:C1466.Selection.length>0)  // if some records are selected, we use those, else all
					$data.data:=Form:C1466.Selection
				Else 
					$data.data:=Form:C1466.listbox
				End if 
				
				// special behavior for invoices
				If (Form:C1466.ORDA_listbox.tablename="Invoices")
					var $pop : Text:=Localized string:C991("Invoices")+";"+Localized string:C991("Invoice_Lines")
					var $popup : Integer:=Pop up menu:C542($pop)
					If ($popup=2)
						$data.table:="INVOICE_LINES"
						$data.data:=$data.data.invoice_lines
					End if 
				End if 
				
				$win:=Open form window:C675("ViewProReport")
				DIALOG:C40("ViewProReport"; $data; *)
				// end VPReport
				
			: ($classname="Classic Invoice")
				$tableptr:=Formula from string:C1601("->["+This:C1470.tablename+"]").call()
				USE ENTITY SELECTION:C1513(Form:C1466.Selection)
				FIRST RECORD:C50($tableptr->)
				FORM SET OUTPUT:C54($tableptr->; "OutputPrint")
				PRINT RECORD:C71($tableptr->)
				
			: ($classname="New Invoice as PDF")
				If (Form:C1466.SelectedElement=Null:C1517)
					ALERT:C41("Please select an invoice")
					return 
				End if 
				var $context:={invoice: Form:C1466.SelectedElement; seller: Storage:C1525.company}
				var $helper:=cs:C1710.Helper_Invoices.new($context)
				$helper.createPDF(System folder:C487(Desktop:K41:16)+"test.pdf")
				ALERT:C41("Stored as test.pdf on your desktop")
				
			: ($classname="New Invoice Color Paper")
				If (Form:C1466.SelectedElement=Null:C1517)
					ALERT:C41("Please select an invoice")
					return 
				End if 
				$context:={invoice: Form:C1466.SelectedElement; seller: Storage:C1525.company}
				$helper:=cs:C1710.Helper_Invoices.new($context)
				ALERT:C41("Set the printer to duplex and color. For production, change the code to make this automatically")
				PRINT SETTINGS:C106  // better than to ask the user how to setup the printer would be to do that automatically
				// in settings dialog, allow the end user to store the settings using Print settings to BLOB   
				// this includes which printer to use, what paper tray, color/duplex/stapling, etc.
				// then just load this settings and pass them to the printer via BLOB to print settings   
				$helper.print_color()
				
			: ($classname="New Invoice BW Paper")
				If (Form:C1466.SelectedElement=Null:C1517)
					ALERT:C41("Please select an invoice")
					return 
				End if 
				$context:={invoice: Form:C1466.SelectedElement; seller: Storage:C1525.company}
				$helper:=cs:C1710.Helper_Invoices.new($context)
				ALERT:C41("Set the printer to single page and black&white. For production, change the code to make this automatically")
				PRINT SETTINGS:C106  // better than to ask the user how to setup the printer would be to do that automatically
				// in settings dialog, allow the end user to store the settings using Print settings to BLOB   
				// this includes which printer to use, what paper tray, color/duplex/stapling, etc.
				// then just load this settings and pass them to the printer via BLOB to print settings   
				$helper.print_white()
				
			Else 
				If ($classname#"")
					ALERT:C41("Not supported")
				End if 
		End case   // customButton
End case   // job