//%attributes = {}
// checks for all CLIENTS if geocoding information exists, update if missing

var $clients:=ds:C1482.CLIENTS.query("_Geo = null")
var $client : cs:C1710.CLIENTSEntity

For each ($client; $clients)
	$client._Geo:=cs:C1710.Geocoding.me.useOpenStreetMap($client.Country; $client.State; $client.Zip_Code; $client.City; $client.Address)
	If (OB Is empty:C1297($client._Geo))
		$client._Geo:=New object:C1471("error"; String:C10(Current date:C33))
	End if 
	$client.save()
	DELAY PROCESS:C323(Current process:C322; 120)  // slow down, to avoid too high traffic on free API service
End for each 