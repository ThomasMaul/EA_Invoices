//%attributes = {}
C_LONGINT:C283($ref)
FORM SET INPUT:C55([SETTINGS:5]; "CustomFields")
$ref:=Open form window:C675([SETTINGS:5]; "CustomFields"; Plain form window:K39:10; 120; 140)
SET WINDOW TITLE:C213("SETTINGS")
ALL RECORDS:C47([SETTINGS:5])
MODIFY RECORD:C57([SETTINGS:5]; *)
CLOSE WINDOW:C154($ref)
