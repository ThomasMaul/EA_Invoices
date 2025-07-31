action_Move("LAST")
var $id:=ds:C1482.getClientSessionID()
var $host:=ds:C1482.getWebServerAddress()
WA OPEN URL:C1020(*; "Web Area"; $host+"/$lib/renderer/?w=ClientMap4D&session="+$id+"&client="+String:C10(Form:C1466.editEntity.ID))