If (FORM Event:C1606.code=On Double Clicked:K2:5)
	$vlItemPos:=Selected list items:C379(*; "hlist_source"; *)
	If ($vlItemPos>0)
		GET LIST ITEM:C378(*; "hlist_source"; List item position:C629(*; "hlist_source"; $vlItemPos); $itemRef; $itemText; $sublist; $expanded)
		If ($sublist=0)
			var $icon : Text
			GET LIST ITEM PROPERTIES:C631(*; "hlist_source"; $itemRef; $enterable; $styles; $icon; $color)
			GET LIST ITEM PARAMETER:C985(*; "hlist_source"; $itemRef; "ref"; $para)
			DELETE FROM LIST:C624(*; "hlist_source"; $itemRef)
			APPEND TO LIST:C376(Form:C1466.target; $itemText; $itemRef)
			SET LIST ITEM PARAMETER:C986(Form:C1466.target; $itemRef; "ref"; $para)
			SET LIST ITEM PROPERTIES:C386(Form:C1466.target; $itemRef; $enterable; $styles; $icon; $color)
			
		End if 
	End if 
End if 