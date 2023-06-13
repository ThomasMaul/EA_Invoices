$templatename:="Stationary"
$templates:=ds:C1482.Document_Templates.query("Name=:1"; $templatename)

var $template : cs:C1710.Document_TemplatesEntity

If ($templates.length=0)
	$template:=ds:C1482.Document_Templates.new()
	$template.Name:=$templatename
Else 
	$template:=$templates.first()
End if 

$image:=$template.image

$obj:=WP Get element by ID:C1549(WPArea; "LogoBackground")
If ($obj#Null:C1517)
	WP DELETE PICTURE:C1701($obj)
End if 

WP GET ATTRIBUTES:C1345(WPArea; wk page width:K81:262; $width)

$obImage:=WP Add picture:C1536(WPArea; $image)
$obImage.id:="LogoBackground"
WP SET ATTRIBUTES:C1342($obImage; wk anchor horizontal align:K81:237; wk left:K81:95; \
wk anchor layout:K81:227; wk behind text:K81:240; wk anchor origin:K81:235; wk paper box:K81:215; \
wk anchor page:K81:231; wk anchor all:K81:229; wk width:K81:45; $width)
