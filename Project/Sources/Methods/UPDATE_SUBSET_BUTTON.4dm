//%attributes = {"invisible":true}
C_TEXT:C284($1; $2)
C_POINTER:C301($3)

C_LONGINT:C283($highlighted; $selection)
$highlighted:=Records in set:C195($2)
$selection:=Records in selection:C76($3->)

OBJECT SET ENABLED:C1123(*; $1; ($highlighted>0) & ($highlighted#$selection))