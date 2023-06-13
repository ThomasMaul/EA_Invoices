// insert all fields from top level

$vlNbItems:=Count list items:C380(*; "hlist_source")
For ($i; 1; $vlNbItems)
	GET LIST ITEM:C378(*; "hlist_source"; List item position:C629(*; "hlist_source"; $i); $itemRef; $itemText; $sublist; $expanded)
	If ($sublist=0)
		If (List item parent:C633(*; "hlist_source"; $itemRef)=0)
			var $icon : Text
			GET LIST ITEM PROPERTIES:C631(*; "hlist_source"; $itemRef; $enterable; $styles; $icon; $color)
			GET LIST ITEM PARAMETER:C985(*; "hlist_source"; $itemRef; "ref"; $para)
			DELETE FROM LIST:C624(*; "hlist_source"; $itemRef)
			APPEND TO LIST:C376(Form:C1466.target; $itemText; $itemRef)
			SET LIST ITEM PARAMETER:C986(Form:C1466.target; $itemRef; "ref"; $para)
			SET LIST ITEM PROPERTIES:C386(Form:C1466.target; $itemRef; $enterable; $styles; $icon; $color)
		End if 
	End if 
End for 
