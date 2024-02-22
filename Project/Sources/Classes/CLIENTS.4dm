Class extends DataClass

Function useAll()->$all : cs:C1710.CLIENTSSelection
	$all:=ds:C1482.CLIENTS.all().orderBy("Name asc")
	
Function quickSearch($value : Text)->$all : cs:C1710.CLIENTSSelection
	If (Length:C16($value)<3)
		$all:=This:C1470.useAll()
	Else 
		$all:=This:C1470.query("Name=:1 or Email=:2 or City=:1 order by Name asc"; $value+"@"; "@"+$value+"@")
	End if 
	
Function calcWindowTitle($sel : cs:C1710.CLIENTSSelection)->$title : Text
	var $sub : Text:=String:C10($sel.length)
	var $all : Text:=String:C10(This:C1470.all().length)
	var $text : Text:=Get localized string:C991(" clients out of ")
	$title:=$sub+$text+$all