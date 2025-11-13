If (FORM Event:C1606.code=On Load:K2:1)
	var $settings:=ds:C1482.SETTINGS.all().first().CustomFields_
	If ($settings#Null:C1517)
		var $settingsTables : Collection:=$settings.Tables
		var $tablecol : Collection
		
		var $tablename : Text
		For each ($tablename; ds:C1482)
			If (ds:C1482[$tablename].CustomFields#Null:C1517)  // there is a field CustomFields existing
				var $hits:=$settingsTables.query("name=:1"; $tablename)
				If ($hits.length=0)
					// there is table with a CustomFields field - but not in settings template!
					$settingsTables.push(New object:C1471("name"; $tablename))
				End if 
			End if 
		End for each 
		
		
		
		
		
	End if 
End if 