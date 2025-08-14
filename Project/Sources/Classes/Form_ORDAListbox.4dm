property table : cs:C1710.DataClass
property tablename : Text
property _columnwidths : Collection
property Search : Text
property SearchCopy : Text
property listbox : cs:C1710.EntitySelection

property toolbar : cs:C1710.Toolbar
property preview : Object  // Subform - either class such as Form_CLIENTS or empty object
property SelectedElement : cs:C1710.Entity
property SelectedPosition : Integer


Class constructor
	
	
Function setTable($table : 4D:C1709.DataClass)
	This:C1470.table:=$table
	This:C1470.tablename:=This:C1470.table.getInfo().name
	This:C1470._columnwidths:=[]
	
	
Function load()
	Form:C1466.Search:=""
	Form:C1466.SearchCopy:=""
	
	Form:C1466.listbox:=This:C1470.useAll(This:C1470.table)
	SET WINDOW TITLE:C213(This:C1470.calcWindowTitle(Form:C1466.listbox); Current form window:C827)
	
	This:C1470._loadListboxColumns()
	
Function resize()
	ARRAY TEXT:C222($arrColNames; 0)
	ARRAY TEXT:C222($arrHeaderNames; 0)
	ARRAY POINTER:C280($arrColVars; 0)
	ARRAY POINTER:C280($arrHeaderVars; 0)
	ARRAY BOOLEAN:C223($arrColsVisible; 0)
	ARRAY POINTER:C280($arrStyles; 0)
	
	LISTBOX GET ARRAYS:C832(*; "Listbox"; $arrColNames; $arrHeaderNames; $arrColVars; $arrHeaderVars; $arrColsVisible; $arrStyles)
	If (Size of array:C274($arrColNames)>This:C1470._columnwidths.length)
		
	End if 
	
	var $width : Integer:=This:C1470._columnwidths.sum()
	
	var $left; $top; $right; $bottom; $view
	OBJECT GET COORDINATES:C663(*; "Listbox"; $left; $top; $right; $bottom)
	$view:=$right-$left-16
	If ($width#$view)
		var $ratio : Real:=$view/$width
		var $newwidth : Real
		var $i : Integer
		For ($i; 1; Size of array:C274($arrHeaderNames))
			$newwidth:=Int:C8(This:C1470._columnwidths[$i-1]*$ratio)
			LISTBOX SET COLUMN WIDTH:C833(*; $arrHeaderNames{$i}; $newwidth)
			This:C1470._columnwidths[$i-1]:=$newwidth
		End for 
	End if 
	
Function _loadListboxColumns()
	LISTBOX DELETE COLUMN:C830(*; "listbox"; 1; 100)
	
	var $nullpointer : Pointer
	var $counter : Integer:=0
	var $column : Object
	var $file : 4D:C1709.File:=File:C1566("/LOGS/Setup/Explorer/"+This:C1470.tablename+".myPrefs")
	If ($file.exists)
		var $object : Object:=JSON Parse:C1218($file.getText())
		This:C1470._columnwidths:=[]
		
		For each ($column; $object.columns)
			$counter+=1
			LISTBOX INSERT COLUMN FORMULA:C970(*; "Listbox"; $counter; $column.title; $column.formula; Is text:K8:3; $column.title; $nullpointer)
			OBJECT SET TITLE:C194(*; $column.title; $column.title)
			LISTBOX SET COLUMN WIDTH:C833(*; $column.title; $column.width)
			This:C1470._columnwidths.push($column.width)
		End for each 
		
		
	Else 
		// without defined content we use the first 10 attributes to display
		var $fieldname : Text
		For each ($fieldname; This:C1470.table) While ($counter<10)
			$column:=This:C1470.table[$fieldname]
			If ($column.kind="storage")
				If (($column.fieldType#Is BLOB:K8:12) & ($column.fieldType#Is object:K8:27))
					$counter:=$counter+1
				End if 
			End if 
		End for each 
		
		var $left; $top; $right; $bottom; $view
		OBJECT GET COORDINATES:C663(*; "Listbox"; $left; $top; $right; $bottom)
		$view:=$right-$left-16
		var $width : Integer:=Int:C8($view/$counter)
		$counter:=0
		For each ($fieldname; This:C1470.table) While ($counter<10)
			$column:=This:C1470.table[$fieldname]
			If ($column.kind="storage")
				If (($column.fieldType#Is BLOB:K8:12) & ($column.fieldType#Is object:K8:27))
					$counter:=$counter+1
					LISTBOX INSERT COLUMN FORMULA:C970(*; "Listbox"; $counter; $fieldname; "This."+$fieldname; $column.fieldType; $fieldname; $nullpointer)
					OBJECT SET TITLE:C194(*; $fieldname; $fieldname)
					LISTBOX SET COLUMN WIDTH:C833(*; $fieldname; $width)
					This:C1470._columnwidths.push($width)
				End if 
			End if 
		End for each 
	End if 
	
Function setInputForm()
	// load Preview Form
	// check if Form class exists. Name="Form_"+tablename
	var $name:="Form_"+This:C1470.tablename
	If (cs:C1710[$name]#Null:C1517)
		Form:C1466.preview:=cs:C1710[$name].new()
	Else 
		Form:C1466.preview:=New object:C1471
	End if 
	Form:C1466.preview.data:=Form:C1466.SelectedElement  // pass the selected element
	
	If (This:C1470._inputFormExists())
		var $tableptr : Pointer:=Formula from string:C1601("->["+This:C1470.tablename+"]").call()
		//var $form : 4D.File:=File("/PROJECT/Sources/TableForms/"+String(Table($tableptr))+"/Input_ORDA/form.4DForm")
		
		OBJECT SET SUBFORM:C1138(*; "Preview"; $tableptr->; "Input_ORDA")
	Else 
		var $result : Object:=This:C1470._getInputForm()
		OBJECT SET SUBFORM:C1138(*; "Preview"; $result)
	End if 
	
Function _inputFormExists() : Boolean
	var $tableptr : Pointer:=Formula from string:C1601("->["+This:C1470.tablename+"]").call()
	var $form : 4D:C1709.File:=File:C1566("/PROJECT/Sources/TableForms/"+String:C10(Table:C252($tableptr))+"/Input_ORDA/form.4DForm")
	return $form.exists
	
Function _getInputForm() : Object
	// create form with text + field in loop
	// use this form
	var $page : Object:=New object:C1471()
	
	var $top : Integer:=20
	var $fieldname : Text
	For each ($fieldname; This:C1470.table)
		var $text : Object:=New object:C1471("height"; 20; "width"; 130; "left"; 20; "top"; $top; "text"; $fieldname; "type"; "text")
		$page["text_"+String:C10($top)]:=$text
		var $field : Object:=New object:C1471("height"; 20; "width"; 300; "left"; 160; "top"; $top; "type"; "input"; "enterable"; False:C215; "dataSource"; "Form.data."+$fieldname)
		$page[$fieldname]:=$field
		$top:=$top+30
	End for each 
	return New object:C1471("pages"; New collection:C1472(Null:C1517; New object:C1471("objects"; $page)); "destination"; "detailScreen")
	
	
Function updateInputForm()
	// needs to call via Execute in Subform
	If (Form:C1466.preview.loadEvent=Null:C1517)
		// nothing do be done?
	Else 
		EXECUTE METHOD IN SUBFORM:C1085("preview"; Form:C1466.preview.loadEvent)
	End if 
	
Function useAll($class : 4D:C1709.DataClass)->$all : 4D:C1709.EntitySelection
	If ($class.useAll#Null:C1517)
		//%W-550.2
		$all:=$class.useAll()
		//%W+550.2
	Else 
		$all:=$class.all()
	End if 
	
Function calcWindowTitle($sel : 4D:C1709.EntitySelection)->$title : Text
	var $class : 4D:C1709.DataClass:=$sel.getDataClass()
	
	If ($class.calcWindowTitle#Null:C1517)
		//%W-550.2
		$title:=$class.calcWindowTitle($sel)
		//%W+550.2
	Else 
		$title:=This:C1470.tablename+"   -   "+String:C10($sel.length)+" of "+String:C10($class.all().length)
	End if 
	
	
Function handleButtonClick($button : Text; $event : Integer)
	// called via Call Form -> this is not useable, we need to use Form !!!
	var $this:=Form:C1466
	If ($event=On Clicked:K2:4)
		var $class : 4D:C1709.DataClass:=$this.table
		var $tablename : Text
		var $tableptr : Pointer
		var $context : Object
		
		Case of 
			: ($button="All")
				Form:C1466.listbox:=$this.useAll($class)
				SET WINDOW TITLE:C213($this.calcWindowTitle(Form:C1466.listbox); Current form window:C827)
				
			: ($button="None")
				Form:C1466.listbox:=$class.newSelection()
				SET WINDOW TITLE:C213($this.calcWindowTitle(Form:C1466.listbox); Current form window:C827)
				
			: ($button="Selected")
				Form:C1466.listbox:=Form:C1466.Selection
				SET WINDOW TITLE:C213($this.calcWindowTitle(Form:C1466.listbox); Current form window:C827)
				
			: ($button="Query")
				// open standard query editor from Classic
				// this shows how to use Classic editors for ORDA
				// alternative: use ORDA query, by example https://github.com/ThomasMaul/QueryEditor/tree/main
				$tableptr:=Formula from string:C1601("->["+$this.tablename+"]").call()
				QUERY:C277($tableptr->)
				$this.listbox:=Create entity selection:C1512($tableptr->)
				SET WINDOW TITLE:C213($this.calcWindowTitle($this.listbox); Current form window:C827)
				
			: ($button="Sort")
				$tableptr:=Formula from string:C1601("->["+$this.tablename+"]").call()
				USE ENTITY SELECTION:C1513($this)
				ORDER BY:C49($tableptr->)
				$this.listbox:=Create entity selection:C1512($tableptr->)
				
			: (($button="Print") | ($button="QuickReport"))
				$tableptr:=Formula from string:C1601("->["+$this.tablename+"]").call()
				USE ENTITY SELECTION:C1513($this.listbox)
				QR REPORT:C197($tableptr->; Char:C90(1))
				
			Else   // everything from your application to customize
				$this.handleCustomButtons($button; $event; $this)
		End case 
		
	Else   // alternative, open submenu
		var $submenu : Text:=Form:C1466.toolbar.buildSubPopup($button)
		var $ref : Text:=Dynamic pop up menu:C1006($submenu)
		RELEASE MENU:C978($submenu)
		$This.handleButtonClick($ref; On Clicked:K2:4)
	End if 
	
Function handleSearchbox()  // handle the searchbox
	// called via Call Form -> this is not useable, we need to use Form !!!
	var $this:=Form:C1466
	If ($this.table.quickSearch#Null:C1517)
		//%W-550.2
		Form:C1466.listbox:=$this.table.quickSearch(vSearch)
		//%W+550.2
		SET WINDOW TITLE:C213($this.calcWindowTitle($this.listbox); Current form window:C827)
	End if 
	
Function displaySearchbox()->$bool : Boolean  // display the searchbox
	$bool:=(This:C1470.table.quickSearch#Null:C1517)
	
	
Function Toolbar_Refresh()
	// called via Call Form from Toolbar_Setup - this form is supposed to have a toolbar, but checking just to be sure
	If ((Form:C1466.toolbar#Null:C1517) && (Form:C1466.toolbar.load#Null:C1517))
		Form:C1466.toolbar.load()
	End if 
	
Function doDoubleClick()
	// default version to handle double click, if we do not have an overwrite in the form class used for the preview subform
	var $name:="Form_"+This:C1470.tablename
	var $data : Object
	If (cs:C1710[$name]#Null:C1517)
		$data:=cs:C1710[$name].new()
	Else 
		$data:=New object:C1471
	End if 
	$data.data:=Form:C1466.SelectedElement  // pass the selected element
	
	// using case of, we could add different behavior depending of module
	// here we use the same concept for all 3 modules
	var $formdata:=cs:C1710.Form_Input_Main.new()
	$formdata.tablename:=This:C1470.tablename
	$formdata.SelectedElement:=This:C1470.SelectedElement
	var $win:=Open form window:C675("Input_Main")
	DIALOG:C40("Input_Main"; $formdata; *)
	
	
	// **************************************************
	//MARK: customize section
	// add here your own behavior
	
Function handleCustomButtons($button : Text; $event : Integer; $this : Object)
	// called via Call Form, so this is not available, use $this (or Form)
	Case of 
		: (($button="Clients") | ($button="Module") | ($button="Invoices") | ($button="Invoices"))
			If (($button="Clients") | ($button="Module"))
				Form:C1466.setTable(ds:C1482.CLIENTS)
			Else 
				Form:C1466.setTable(ds:C1482[Uppercase:C13($button)])
			End if 
			Form:C1466.load()
			Form:C1466.toolbar.load()  // this will recreate the toolbar, produce flicker. But allow to change buttons or show/hide searchbox
			Form:C1466.setInputForm()
			
		: ($button="Add")  // "New" button, different behavior depending of module
			// using case of, we could add different behavior depending of module
			// here we use the same concept for 2 modules, with exception for invoices
			If ($this.tablename="Invoices")
				ALERT:C41("Invoices can only be created through the Clients module")
			Else 
				var $formdata:=cs:C1710.Form_Input_Main.new()
				$formdata.tablename:=$this.tablename
				$formdata.SelectedElement:=ds:C1482[$this.tablename].new()
				var $win:=Open form window:C675("Input_Main")
				DIALOG:C40("Input_Main"; $formdata; *)
			End if 
			
			
		: ($button="Settings")
			Settings_Manage
			
		: ($button="4DViewPro")
			var $data : Object:=New object:C1471("table"; Form:C1466.tablename; "masterform"; Form:C1466)
			If (Form:C1466.Selection.length>0)  // if some records are selected, we use those, else all
				$data.data:=Form:C1466.Selection
			Else 
				$data.data:=Form:C1466.listbox
			End if 
			
			// special behavior for invoices
			If (Form:C1466.tablename="Invoices")
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
			
		: ($button="New Invoice as PDF")
			If (Form:C1466.SelectedElement=Null:C1517)
				ALERT:C41("Please select an invoice")
				return 
			End if 
			var $context:={invoice: Form:C1466.SelectedElement; seller: Storage:C1525.company}
			var $helper:=cs:C1710.Helper_Invoices.new($context)
			$helper.createPDF(System folder:C487(Desktop:K41:16)+"test.pdf")
			ALERT:C41("Stored as test.pdf on your desktop")
			
		: ($button="New Invoice Color Paper")
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
			
		: ($button="New Invoice BW Paper")
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
			If ($button#"")
				ALERT:C41("Not supported")
			End if 
	End case   // customButton