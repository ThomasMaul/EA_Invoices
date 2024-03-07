var $event : Integer:=FORM Event:C1606.code
Case of 
	: ($event=On Double Clicked:K2:5)
		var $vlItemPos : Integer:=Selected list items:C379(*; "hlist_source"; *)
		If ($vlItemPos>0)
			GET LIST ITEM:C378(*; "hlist_source"; List item position:C629(*; "hlist_source"; $vlItemPos); $itemRef; $itemText; $sublist; $expanded)
			var $sublist : Integer
			If ($sublist=0)
				var $icon; $para : Text
				var $enterable : Boolean
				var $styles; $color : Integer
				GET LIST ITEM PROPERTIES:C631(*; "hlist_source"; $itemRef; $enterable; $styles; $icon; $color)
				GET LIST ITEM PARAMETER:C985(*; "hlist_source"; $itemRef; "ref"; $para)
				DELETE FROM LIST:C624(*; "hlist_source"; $itemRef)
				APPEND TO LIST:C376(Form:C1466.target; $itemText; $itemRef)
				SET LIST ITEM PARAMETER:C986(Form:C1466.target; $itemRef; "ref"; $para)
				SET LIST ITEM PROPERTIES:C386(Form:C1466.target; $itemRef; $enterable; $styles; $icon; $color)
				
			End if 
		End if 
		
		
	: ($event=On Begin Drag Over:K2:44)
		GET LIST ITEM:C378(*; "hlist_source"; *; $itemRef; $itemText; $sublist; $expanded)
		var $ob : Object:=New object:C1471("list"; "hlist_source"; "ref"; $itemRef; "text"; $itemText)
		var $blob : 4D:C1709.Blob
		VARIABLE TO BLOB:C532($ob; $blob)
		CLEAR PASTEBOARD:C402
		SET TEXT TO PASTEBOARD:C523($itemText)
		APPEND DATA TO PASTEBOARD:C403("com.4d.de.fieldlist"; $blob)
		
End case 