Class constructor($invoice : cs:C1710.INVOICESEntity; $Write : Object)
	If (Count parameters:C259<2)
		var $templates : cs:C1710.Document_TemplatesSelection:=ds:C1482.Document_Templates.query("Name='Invoice'")
		If ($templates.length=0)
			//ALERT("Template Invoice is missing")
			// start with an empty one
			This:C1470.WP:=WP New:C1317()
		Else 
			var $template : cs:C1710.Document_Templates
			$template:=$templates.first()
			This:C1470.WP:=$template.WPro
		End if 
	Else 
		This:C1470.WP:=$write
	End if 
	This:C1470.invoice:=$invoice
	This:C1470.setContext()
	
Function updateTemplate($templatename : Text)
	var $templates : cs:C1710.Document_TemplatesSelection:=ds:C1482.Document_Templates.query("Name=:1"; $templatename)
	If ($templates.length=0)
		Form:C1466.WP:=WP New:C1317()
	Else 
		var $template : cs:C1710.Document_Templates
		$template:=$templates.first()
		This:C1470.WP:=$template.WPro
	End if 
	This:C1470.setContext()
	WPArea:=This:C1470.WP
	
Function updateInvoice($invoice : cs:C1710.INVOICESEntity)
	This:C1470.invoice:=$invoice
	This:C1470.setContext()
	
Function setContext($wp : Object)
	If (Count parameters:C259=0)
		$wp:=This:C1470.WP
	End if 
	var $context : Object:=This:C1470.invoice  // just use the full invoice. We could add more data 
	WP SET DATA CONTEXT:C1786($wp; $context)
	WP COMPUTE FORMULAS:C1707($wp)
	
Function update()
	This:C1470.setContext()
	
Function getPageImages()->$pages : Collection
	var $wp : Object:=This:C1470.WP
	var $pageCount : Integer:=WP Get page count:C1412($wp)
	$pages:=New collection:C1472
	var $options : Object:=New object:C1471
	$options[wk max picture DPI:K81:316]:=300
	var $text : Text
	WP EXPORT VARIABLE:C1319($wp; $text; wk svg:K81:356; $options)
	var $svgRoot : Text:=DOM Parse XML variable:C720($text; False:C215)
	var $preview : Picture
	SVG EXPORT TO PICTURE:C1017($svgRoot; $preview; Own XML data source:K45:18)
	var $i : Integer
	For ($i; 1; $pageCount)
		$options[wk page index:K81:357]:=$i
		WP EXPORT VARIABLE:C1319($wp; $text; wk svg:K81:356; $options)
		$svgRoot:=DOM Parse XML variable:C720($text; False:C215)
		SVG EXPORT TO PICTURE:C1017($svgRoot; $preview; Own XML data source:K45:18)
		$pages.push(New object:C1471("page"; $i; "svg"; $preview))
	End for 
	
Function createPDF_noConditions($pfad : Text)
	var $wp : Object:=WP New:C1317(This:C1470.WP)
	WP EXPORT DOCUMENT:C1337($wp; $pfad; wk pdf:K81:315)
	
Function createPDF($pfad : Text)
	var $wp : Object:=WP New:C1317()
	var $col : Collection:=This:C1470.getPageImages()
	var $conditions : Picture
	var $conditionsentity : cs:C1710.Document_TemplatesSelection:=ds:C1482.Document_Templates.query("Name='conditions'")
	
	var $page : Object
	For each ($page; $col)
		var $pic : Object:=WP Add picture:C1536($wp; $page.svg)
		WP SET ATTRIBUTES:C1342($pic; wk anchor page:K81:231; $page.page)
		WP INSERT BREAK:C1413($wp; wk page break:K81:188; wk append:K81:179)
	End for each 
	If ($conditionsentity.length>0)
		$conditions:=$conditionsentity.first().image
		If (Picture size:C356($conditions)>0)
			$pic:=WP Add picture:C1536($wp; $conditions)
			WP SET ATTRIBUTES:C1342($pic; wk anchor page:K81:231; $col.length+1)
		End if 
	End if 
	WP EXPORT DOCUMENT:C1337($wp; $pfad; wk pdf:K81:315)
	
	
Function print_white()
	// remove background, then print. Create a copy to do so
	var $wp : Object:=WP New:C1317(This:C1470.WP)
	This:C1470.setContext($wp)
	var $obj : Object:=WP Get element by ID:C1549($wp; "LogoBackground")
	WP DELETE PICTURE:C1701($obj)
	
	SET PRINT OPTION:C733(Spooler document name option:K47:10; "Invoice "+This:C1470.invoice.InvoiceNumber)
	WP PRINT:C1343($wp)
	
Function print_color()
	var $wp : Object:=WP New:C1317()
	var $col : Collection:=This:C1470.getPageImages()
	var $conditions : Picture
	var $conditionsentity : cs:C1710.Document_TemplatesSelection:=ds:C1482.Document_Templates.query("Name='conditions'")
	If ($conditionsentity.length>0)
		$conditions:=$conditionsentity.first().image
	End if 
	
	var $pagecounter : Integer:=1
	var $page : Object
	var $pic : Object
	For each ($page; $col)
		$pic:=WP Add picture:C1536($wp; $page.svg)
		WP SET ATTRIBUTES:C1342($pic; wk anchor page:K81:231; $pagecounter)
		$pagecounter+=1
		Case of 
			: ($pagecounter=2)  // first page...
				If (Picture size:C356($conditions)>0)
					WP INSERT BREAK:C1413($wp; wk page break:K81:188; wk append:K81:179)
					$pic:=WP Add picture:C1536($wp; $conditions)
					WP SET ATTRIBUTES:C1342($pic; wk anchor page:K81:231; $pagecounter)
				End if 
				$pagecounter+=1
				If ($page.page<$col.length)
					WP INSERT BREAK:C1413($wp; wk page break:K81:188; wk append:K81:179)
				End if 
			: ($page.page<$col.length)
				WP INSERT BREAK:C1413($wp; wk page break:K81:188; wk append:K81:179)  // empty page
				$pagecounter+=1
				WP INSERT BREAK:C1413($wp; wk page break:K81:188; wk append:K81:179)
		End case 
	End for each 
	
	SET PRINT OPTION:C733(Spooler document name option:K47:10; "Invoice "+This:C1470.invoice.InvoiceNumber)
	WP PRINT:C1343($wp)