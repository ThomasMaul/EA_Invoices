var $vlItemPos : Integer

Case of 
	: (FORM Event:C1606.code=On Drop:K2:12)
		$0:=Form:C1466.mainlist.acceptDrop()
		
	: (FORM Event:C1606.code=On Begin Drag Over:K2:44)
		ARRAY LONGINT:C221($arrPos; 0)
		$vlItemPos:=Selected list items:C379(Form:C1466.userlist; $arrPos)
		If (Size of array:C274($arrPos)=1)
			GET LIST ITEM:C378(Form:C1466.userlist; *; $ref; $text; $sublist; $xpand)
			var $value : Text:=JSON Stringify:C1217(New object:C1471("id"; $ref; "origin"; "user"))
		Else 
			var $sel : Collection:=New collection:C1472
			var $i : Integer
			For ($i; 1; Size of array:C274($arrPos))
				GET LIST ITEM:C378(Form:C1466.userlist; $arrPos{$i}; $ref; $text; $sublist; $xpand)
				$sel.push($ref)
			End for 
			$value:=JSON Stringify:C1217(New object:C1471("ids"; $sel; "origin"; "user"))
		End if 
		SET TEXT TO PASTEBOARD:C523($value)  // dragboard
		
	: (FORM Event:C1606.code=On Clicked:K2:4)
		If (Contextual click:C713)
			ARRAY LONGINT:C221($arrPos; 0)
			$vlItemPos:=Selected list items:C379(Form:C1466.userlist; $arrPos)
			If (Size of array:C274($arrPos)=1)
				GET LIST ITEM:C378(Form:C1466.userlist; *; $ref; $text; $sublist; $xpand)
				
				var $pop : Integer:=Pop up menu:C542(Get localized string:C991("Popup_Delete"))
				Case of 
					: ($pop=1)
						DELETE FROM LIST:C624(Form:C1466.userlist; $ref; *)
						Form:C1466.mainlist.isModified:=True:C214
					: ($pop=2)
						CONFIRM:C162(Get localized string:C991("Delete_all_buttons"))
						If (OK=1)
							CLEAR LIST:C377(Form:C1466.userlist; *)
							var $newlist : Integer:=New list:C375
							SET LIST PROPERTIES:C387($newlist; 0; 0; 38)
							OBJECT Get pointer:C1124(Object named:K67:5; "Toolbar_User")->:=$newlist
							Form:C1466.userlist:=$newlist
							Form:C1466.mainlist.isModified:=True:C214
						End if 
				End case 
			End if 
		End if 
End case 