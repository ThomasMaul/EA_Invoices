
var $file : 4D:C1709.File:=Folder:C1567(fk logs folder:K87:17).folder("Settings").folder("Toolbar").file("User.json")
$file.setText(JSON Stringify:C1217(New object:C1471("settings"; Form:C1466.mainlist.storeSettings())))
