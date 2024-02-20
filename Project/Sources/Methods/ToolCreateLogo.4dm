//%attributes = {"invisible":true}

C_TEXT:C284($1)
C_TEXT:C284($type)
C_TEXT:C284($path)
C_LONGINT:C283($Width; $height)
C_PICTURE:C286($Logo)

If (Count parameters:C259=1)
	$type:=$1
Else 
	$type:="logo"
End if 

C_PICTURE:C286(<>DefaultLogoPict)
C_PICTURE:C286(<>DefaultProductPict)

If (Picture size:C356(<>DefaultLogoPict)=0)
	$path:=Get 4D folder:C485(Current resources folder:K5:16)+"Images"+Folder separator:K24:12+"Logo.jpg"
	READ PICTURE FILE:C678($path; <>DefaultLogoPict)
End if 

If (Picture size:C356(<>DefaultProductPict)=0)
	$path:=Get 4D folder:C485(Current resources folder:K5:16)+"Images"+Folder separator:K24:12+"Product.jpg"
	READ PICTURE FILE:C678($path; <>DefaultProductPict)
End if 


If ($type="logo")
	PICTURE PROPERTIES:C457(<>DefaultLogoPict; $width; $height)
	
	$Logo:=<>DefaultLogoPict
	TRANSFORM PICTURE:C988($Logo; Crop:K61:7; Random:C100%($width-256); Random:C100%($height-256); 256; 256)
	CONVERT PICTURE:C1002($Logo; ".jpg"; 0.5)
	
Else 
	PICTURE PROPERTIES:C457(<>DefaultProductPict; $width; $height)
	
	$Logo:=<>DefaultProductPict
	TRANSFORM PICTURE:C988($Logo; Crop:K61:7; Random:C100%($width-256); Random:C100%($height-256); 256; 256)
	CONVERT PICTURE:C1002($Logo; ".jpg"; 0.5)
	
End if 

$0:=$Logo

