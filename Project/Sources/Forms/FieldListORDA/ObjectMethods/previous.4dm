ARRAY LONGINT:C221($selected; 0)
var $vlItemPos : Integer:=Selected list items:C379(*; "hlist_target"; $selected; *)
If ($vlItemPos>0)
	var $i : Integer
	For ($i; Size of array:C274($selected); 1; -1)
		var $itemRef; $findRef : Integer
		GET LIST ITEM:C378(*; "hlist_target"; List item position:C629(*; "hlist_target"; $selected{$i}); $itemRef; $itemText; $sublist; $expanded)
		
		If ($sublist=0)
			var $icon; $para; $para2 : Text
			var $enterable : Boolean
			var $styles; $color : Integer
			GET LIST ITEM PROPERTIES:C631(*; "hlist_target"; $itemRef; $enterable; $styles; $icon; $color)
			GET LIST ITEM PARAMETER:C985(*; "hlist_target"; $itemRef; "ref"; $para)
			DELETE FROM LIST:C624(*; "hlist_target"; $itemRef)
			var $total : Integer:=Count list items:C380(*; "hlist_source")
			If ($total=0)
				APPEND TO LIST:C376(Form:C1466.source; $itemText; $itemRef)
			Else 
				// find correct slot
				$findRef:=$itemRef
				$para2:=""
				While (($findRef>0) && ($para2=""))
					GET LIST ITEM PARAMETER:C985(*; "hlist_source"; $findRef; "ref"; $para2)
					If ($para2="")
						$findRef:=$findRef-1
					Else 
						INSERT IN LIST:C625(Form:C1466.source; $findRef; $itemText; $itemRef)
					End if 
				End while 
				If ($findRef=0)
					APPEND TO LIST:C376(Form:C1466.source; $itemText; $itemRef)
				End if 
			End if 
			SET LIST ITEM PARAMETER:C986(Form:C1466.source; $itemRef; "ref"; $para)
			SET LIST ITEM PROPERTIES:C386(Form:C1466.source; $itemRef; $enterable; $styles; $icon; $color)
			
		End if 
	End for 
End if 