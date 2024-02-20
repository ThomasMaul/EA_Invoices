// [CLIENTS].Output.bGraphsClients
//C_LONGINT($graphProcess)

C_LONGINT:C283($ref)

FORM SET INPUT:C55([CLIENTS:1]; "GraphForm")  // Set the Input form
$ref:=Open form window:C675([CLIENTS:1]; "GraphForm"; Plain form window:K39:10; 120; 140; *)
SET WINDOW TITLE:C213(Get localized string:C991("Graph"))
ADD RECORD:C56([CLIENTS:1]; *)
CLOSE WINDOW:C154($ref)
FORM SET INPUT:C55([CLIENTS:1]; "Input")  // Set the Input form