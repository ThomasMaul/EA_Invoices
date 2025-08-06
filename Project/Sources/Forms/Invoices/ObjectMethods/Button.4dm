FORM GOTO PAGE:C247(3)

var $id:=ds:C1482.getClientSessionID()
var $host:=ds:C1482.getWebServerAddress()
WA OPEN URL:C1020(*; "Web Area"; $host+"/$lib/renderer/?w=Calendar&session="+$id)
