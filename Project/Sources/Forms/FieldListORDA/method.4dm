Case of 
	: (FORM Event:C1606.code=On Load:K2:1)
		
		Form:C1466.source:=New list:C375
		Form:C1466.target:=New list:C375
		If (Form:C1466.selectedFields=Null:C1517)
			Form:C1466.selectedFields:=New collection:C1472
		End if 
		$class:=cs:C1710.FieldListEditor.new(Form:C1466.table; Form:C1466.source)
		
		If (Form:C1466.selectedFields.length>0)
			For each ($el; Form:C1466.selectedFields)
				// $el could be relation.fieldname. If not, we can use Find in list.
				If (Position:C15("."; $el; *)<1)
					$vlItemPos:=Find in list:C952(Form:C1466.source; $el; 0; *)
					If ($vlItemPos>0)
						GET LIST ITEM:C378(*; "hlist_source"; List item position:C629(*; "hlist_source"; $vlItemPos); $itemRef; $itemText; $sublist; $expanded)
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
					End if 
					
				Else 
					$max:=Count list items:C380(*; "hlist_source"; *)
					For ($i; 1; $max)
						GET LIST ITEM:C378(*; "hlist_source"; $i; $itemRef; $itemText; $sublist; $expanded)
						GET LIST ITEM PARAMETER:C985(*; "hlist_source"; $itemRef; "ref"; $para)
						If ($para=$el)
							GET LIST ITEM PROPERTIES:C631(*; "hlist_source"; $itemRef; $enterable; $styles; $icon; $color)
							DELETE FROM LIST:C624(*; "hlist_source"; $itemRef)
							APPEND TO LIST:C376(Form:C1466.target; $itemText; $itemRef)
							SET LIST ITEM PARAMETER:C986(Form:C1466.target; $itemRef; "ref"; $para)
							SET LIST ITEM PROPERTIES:C386(Form:C1466.target; $itemRef; $enterable; $styles; $icon; $color)
							break
						End if 
					End for 
					
				End if 
				
				
			End for each 
		End if 
		
		
	: (FORM Event:C1606.code=On Unload:K2:2)
		CLEAR LIST:C377(Form:C1466.source; *)
		CLEAR LIST:C377(Form:C1466.target)
		
End case 