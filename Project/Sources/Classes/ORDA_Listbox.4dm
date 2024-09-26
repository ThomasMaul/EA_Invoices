Class constructor($table : 4D:C1709.DataClass)
	This:C1470.table:=$table
	This:C1470.tablename:=This:C1470.table.getInfo().name
	This:C1470._columnwidths:=[]
	
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
	//  load Preview Form
	Form:C1466.preview:=New object:C1471
	Form:C1466.preview.data:=Form:C1466.SelectedElement  // pass the selected element
	
	var $tableptr : Pointer:=Formula from string:C1601("->["+This:C1470.tablename+"]").call()
	var $form : 4D:C1709.File:=File:C1566("/PROJECT/Sources/TableForms/"+String:C10(Table:C252($tableptr))+"/Input_ORDA/form.4DForm")
	If ($form.exists)
		OBJECT SET SUBFORM:C1138(*; "Preview"; $tableptr->; "Input_ORDA")
	Else 
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
		
		var $sub : Object:=New object:C1471("pages"; New collection:C1472(Null:C1517; New object:C1471("objects"; $page)); "destination"; "detailScreen")
		OBJECT SET SUBFORM:C1138(*; "Preview"; $sub)
		
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
	If ($event=On Clicked:K2:4)
		var $class : 4D:C1709.DataClass:=This:C1470.table
		var $tablename : Text
		var $tableptr : Pointer
		var $context : Object
		var $helper : cs:C1710.Helper_Invoices
		
		Case of 
			: ($button="All")
				Form:C1466.listbox:=This:C1470.useAll($class)
				SET WINDOW TITLE:C213(This:C1470.calcWindowTitle(Form:C1466.listbox); Current form window:C827)
				
			: ($button="None")
				Form:C1466.listbox:=$class.newSelection()
				SET WINDOW TITLE:C213(This:C1470.calcWindowTitle(Form:C1466.listbox); Current form window:C827)
				
			: ($button="Selected")
				Form:C1466.listbox:=Form:C1466.Selection
				SET WINDOW TITLE:C213(This:C1470.calcWindowTitle(Form:C1466.listbox); Current form window:C827)
				
			: ($button="Query")
				// open standard query editor from Classic
				// this shows how to use Classic editors for ORDA
				// alternative: use ORDA query, by example https://github.com/ThomasMaul/QueryEditor/tree/main
				$tableptr:=Formula from string:C1601("->["+This:C1470.tablename+"]").call()
				QUERY:C277($tableptr->)
				Form:C1466.listbox:=Create entity selection:C1512($tableptr->)
				SET WINDOW TITLE:C213(This:C1470.calcWindowTitle(Form:C1466.listbox); Current form window:C827)
				
			: ($button="Sort")
				$tableptr:=Formula from string:C1601("->["+This:C1470.tablename+"]").call()
				USE ENTITY SELECTION:C1513(Form:C1466.listbox)
				ORDER BY:C49($tableptr->)
				Form:C1466.listbox:=Create entity selection:C1512($tableptr->)
				
			: (($button="Print") | ($button="QuickReport"))
				$tableptr:=Formula from string:C1601("->["+This:C1470.tablename+"]").call()
				USE ENTITY SELECTION:C1513(Form:C1466.listbox)
				QR REPORT:C197($tableptr->; Char:C90(1))
				
			Else   // everything from your application to customize
				ORDA_Listbox_Method("customButton"; $button)
		End case 
		
	Else   // alternative, open submenu
		var $submenu : Text:=Form:C1466.toolbar.buildSubPopup($button)
		var $ref : Text:=Dynamic pop up menu:C1006($submenu)
		RELEASE MENU:C978($submenu)
		This:C1470.handleButtonClick($ref; On Clicked:K2:4)
	End if 
	
Function handleSearchbox()  // handle the searchbox
	If (This:C1470.table.quickSearch#Null:C1517)
		//%W-550.2
		Form:C1466.listbox:=This:C1470.table.quickSearch(vSearch)
		//%W+550.2
		SET WINDOW TITLE:C213(This:C1470.calcWindowTitle(Form:C1466.listbox); Current form window:C827)
	End if 
	
Function displaySearchbox()->$bool : Boolean  // display the searchbox
	$bool:=(This:C1470.table.quickSearch#Null:C1517)
	
	
	