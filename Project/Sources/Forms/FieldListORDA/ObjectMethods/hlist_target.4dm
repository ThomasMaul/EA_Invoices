$event:=FORM Event:C1606.code
Case of 
	: ($event=On Begin Drag Over:K2:44)
		GET LIST ITEM:C378(*; "hlist_target"; *; $itemRef; $itemText; $sublist; $expanded)
		$ob:=New object:C1471("list"; "hlist_target"; "ref"; $itemRef; "text"; $itemText)
		VARIABLE TO BLOB:C532($ob; $blob)
		CLEAR PASTEBOARD:C402
		SET TEXT TO PASTEBOARD:C523($itemText)
		APPEND DATA TO PASTEBOARD:C403("com.4d.de.fieldlist"; $blob)
		
	: ($event=On Drop:K2:12)
		If (Pasteboard data size:C400("com.4d.de.fieldlist")>0)
			GET PASTEBOARD DATA:C401("com.4d.de.fieldlist"; $blob)
			BLOB TO VARIABLE:C533($blob; $ob)
			
			var $icon; $para : Text
			
			$pos:=Drop position:C608
			GET LIST ITEM:C378(*; "hlist_target"; $pos; $newitemRef; $itemText; $sublist; $expanded)
			
			GET LIST ITEM PROPERTIES:C631(*; $ob.list; $ob.ref; $enterable; $styles; $icon; $color)
			GET LIST ITEM PARAMETER:C985(*; $ob.list; $ob.ref; "ref"; $para)
			DELETE FROM LIST:C624(*; $ob.list; $ob.ref)
			
			INSERT IN LIST:C625(*; "hlist_target"; $newitemRef; $ob.text; $ob.ref)
			SET LIST ITEM PROPERTIES:C386(*; "hlist_target"; $ob.ref; $enterable; $styles; $icon; $color)
			SET LIST ITEM PARAMETER:C986(*; "hlist_target"; $ob.ref; "ref"; $para)
			
		End if 
End case 