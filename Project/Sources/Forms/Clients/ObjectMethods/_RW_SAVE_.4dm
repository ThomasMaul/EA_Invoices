If ((Form:C1466.editEntity._Geo=Null:C1517) || (OB Is empty:C1297(Form:C1466.editEntity._Geo)))
	Form:C1466.editEntity._Geo:=cs:C1710.Geocoding.me.useOpenStreetMap(Form:C1466.editEntity.Country; Form:C1466.editEntity.State; Form:C1466.editEntity.Zip_Code; Form:C1466.editEntity.City; Form:C1466.editEntity.Address)
	If (OB Is empty:C1297(Form:C1466.editEntity._Geo))
		Form:C1466.editEntity._Geo:=New object:C1471("error"; String:C10(Current date:C33))
	End if 
Else 
	var $touched : Collection:=Form:C1466.editEntity.touchedAttributes()
	var $checkAttr:=["Country"; "State"; "Zip_Code"; "City"; "Address"]  // if any of those are modified, call geocoding
	var $attr : Text
	For each ($attr; $checkAttr)
		If ($touched.includes($attr))
			Form:C1466.editEntity._Geo:=cs:C1710.Geocoding.me.useOpenStreetMap(Form:C1466.editEntity.Country; Form:C1466.editEntity.State; Form:C1466.editEntity.Zip_Code; Form:C1466.editEntity.City; Form:C1466.editEntity.Address)
			If (OB Is empty:C1297(Form:C1466.editEntity._Geo))
				Form:C1466.editEntity._Geo:=New object:C1471("error"; String:C10(Current date:C33))
			End if 
			break
		End if 
	End for each 
End if 

action_Save
