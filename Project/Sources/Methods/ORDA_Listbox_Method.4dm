//%attributes = {}
/* this method allows customization, it is used for 3 different purposes

- used as object method for Toolbar buttons (they must be a project mode). (from ORDA_listbox Toolbar)
   zero parameters given

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
					CALL FORM:C1391(Current form window:C827; Formula:C1597(Form:C1466.ORDA_listbox.handleButtonClick($buttonname; $event)))
				End if 
				
			: ($event=On Data Change:K2:15)
				If (String:C10(FORM Event:C1606.objectName)="search")
					CALL FORM:C1391(Current form window:C827; Formula:C1597(Form:C1466.ORDA_listbox.handleSearchbox()))
				End if 
		End case 
		
		//MARK: Preview - init your preview data
	: ($job="preview")
		// customize this for your tables
		// executed in context of the preview form
		If (Form:C1466.data#Null:C1517)
			$classname:=String:C10(Form:C1466.data.getDataClass().getInfo().name)
			
			Case of 
				: ($classname="CLIENTS")
					// load customfields done via computed attribute
					// sort invoices done via computed attribute as relation
					// for example purpose, we just hide/show listbox depending of computed content
					If ((Form:C1466.data.customFieldsLB#Null:C1517) && (Form:C1466.data.customFieldsLB.result.length>0))
						OBJECT SET VISIBLE:C603(*; "customF_LB"; True:C214)
					Else 
						OBJECT SET VISIBLE:C603(*; "customF_LB"; False:C215)
					End if 
					
				: ($classname="INVOICES")
					If (Form:C1466.data.ProForma)
						OBJECT SET VISIBLE:C603(*; "inv_@"; False:C215)
					Else 
						OBJECT SET ENTERABLE:C238(*; "invoiceDate"; False:C215)
						OBJECT SET ENTERABLE:C238(*; "invoiceDelay"; False:C215)
						OBJECT SET ENTERABLE:C238(*; "invoiceProforma"; False:C215)
						OBJECT SET VISIBLE:C603(*; "inv_@"; Bool:C1537(Form:C1466.data.Paid))
					End if 
					
					OBJECT SET FORMAT:C236(*; "@_cur"; Get localized string:C991("currency"))
			End case 
		End if 
		
		//MARK: Double click - handle detail form
	: ($job="doubleclick")
		$classname:=String:C10(Form:C1466.preview.data.getDataClass().getInfo().name)
		var $p : Integer:=New process:C317("ORDA_Listbox_Method"; 0; "ORDA_Listbox_Doubleclick"; "doubleclick_process"; $classname; Form:C1466.SelectedElement.getKey(dk key as string:K85:16))
		
		//MARK: Classic Mode - generic Double click 
	: ($job="doubleclick_process")
		// better to call above in double click directly your existing code to handle classic mode detail form
		// this generic method is just to help coding...
		// it requires that there is an input form named "Input" for each form, else it will do nothing
		
		// only if the form exist. Note that using that path checking works interpreted or compiled (checking inside 4DZ)
		var $tableptr : Pointer:=Formula from string:C1601("->["+$classname+"]").call()
		var $form : 4D:C1709.File:=File:C1566("/PROJECT/Sources/TableForms/"+String:C10(Table:C252($tableptr))+"/Input/form.4DForm")
		If ($form.exists)
			var $win : Integer:=Open form window:C675($tableptr->; "Input")
			FORM SET INPUT:C55($tableptr->; "Input")
			
			If ($pk="")  // new record
				ADD RECORD:C56($tableptr->; *)
			Else   // existing record
				var $entity : 4D:C1709.Entity:=ds:C1482[$classname].get($pk)
				var $sel : 4D:C1709.EntitySelection:=ds:C1482[$classname].newSelection()
				USE ENTITY SELECTION:C1513($sel.add($entity))
				
				READ WRITE:C146($tableptr->)
				LOAD RECORD:C52($tableptr->)
				
				If (Locked:C147($tableptr->))
					var $long : Integer
					var $user : Text
					var $machineuser : Text
					var $processname : Text
					var $message : Text
					LOCKED BY:C353($tableptr->; $long; $user; $machineuser; $processname)
					$user:=$user+"/"+$machineuser+" ("+$processname+")"
					$message:=Replace string:C233(Get localized string:C991("LockedClassic"); "xxx"; $user)
					ALERT:C41($message)
					DISPLAY SELECTION:C59($tableptr->)
				Else 
					MODIFY RECORD:C57($tableptr->; *)
				End if 
			End if 
			CLOSE WINDOW:C154($win)
		End if 
		
	: ($job="customButton")
		Case of 
			: ($classname="Clients")
				Form:C1466.ORDA_listbox.setTable(ds:C1482.CLIENTS)
				Form:C1466.ORDA_listbox.load()
				Form:C1466.ORDA_listbox.setInputForm()
			: ($classname="Invoices")
				Form:C1466.ORDA_listbox.setTable(ds:C1482.INVOICES)
				Form:C1466.ORDA_listbox.load()
				Form:C1466.ORDA_listbox.setInputForm()
			: ($classname="Products")
				Form:C1466.ORDA_listbox.setTable(ds:C1482.PRODUCTS)
				Form:C1466.ORDA_listbox.load()
				Form:C1466.ORDA_listbox.setInputForm()
				
			: ($classname="Add")  // "New" button, different behavior depending of module
				Case of 
					: ((Form:C1466.ORDA_listbox.tablename="CLIENTS") | (Form:C1466.ORDA_listbox.tablename="PRODUCTS"))
						// code similar to double click, but with new record
						$p:=New process:C317("ORDA_Listbox_Method"; 0; "ORDA_Listbox_Doubleclick"; "doubleclick_process"; Form:C1466.ORDA_listbox.tablename; "")
						
					: (Form:C1466.ORDA_listbox.tablename="INVOICES")
						ALERT:C41(Get localized string:C991("NoNewButtonForInvoices"))
						
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
					var $pop : Text:=Get localized string:C991("INVOICES")+";"+Get localized string:C991("INVOICE_LINES")
					var $popup : Integer:=Pop up menu:C542($pop)
					If ($popup=2)
						$data.table:="INVOICE_LINES"
						$data.data:=$data.data.invoice_lines
					End if 
				End if 
				
				$win:=Open form window:C675("ViewProReport")
				DIALOG:C40("ViewProReport"; $data; *)
				// end VPReport
				
			Else 
				If ($classname#"")
					ALERT:C41("Not supported")
				End if 
		End case   // customButton
End case   // job