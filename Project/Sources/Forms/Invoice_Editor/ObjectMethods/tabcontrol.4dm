If (FORM Event:C1606.code=On Clicked:K2:4)
	Case of 
		: (Form:C1466.oTab.index=1)  // business paper
			var $templates : cs:C1710.Document_TemplatesSelection:=ds:C1482.Document_Templates.query("Name='BusinessPaper'")
			If ($templates.length=0)
				//ALERT("Template Invoice is missing")
				// start with an empty one
				WParea1:=WP New:C1317()
			Else 
				var $template : cs:C1710.Document_Templates
				$template:=$templates.first()
				WParea1:=$template.WPro
			End if 
			
		: (Form:C1466.oTab.index=2)  // conditions
			$templates:=ds:C1482.Document_Templates.query("Name='Conditions'")
			If ($templates.length=0)
				//ALERT("Template Invoice is missing")
				// start with an empty one
				WParea2:=WP New:C1317()
			Else 
				$template:=$templates.first()
				WParea2:=$template.WPro
			End if 
	End case 
End if 
