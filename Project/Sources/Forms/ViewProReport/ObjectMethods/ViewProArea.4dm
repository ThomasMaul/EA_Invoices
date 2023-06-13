Case of 
	: (FORM Event:C1606.code=On VP Ready:K2:59)
		$datasheet:=-1
		$sheetcount:=VP Get sheet count("ViewProArea")
		For ($i; 0; $sheetcount)
			$name:=VP Get sheet name("ViewProArea"; $i)
			If ($name="data")
				$datasheet:=$i
				break
			End if 
		End for 
		If ($datasheet<0)
			VP ADD SHEET("ViewProArea"; 0; "data")
			$datasheet:=$0
		End if 
End case 