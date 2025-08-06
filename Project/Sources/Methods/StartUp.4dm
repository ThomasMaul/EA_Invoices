//%attributes = {}



// Check minimal version of 4D for compatibility
C_TEXT:C284(compatibility_version_check)
C_BOOLEAN:C305($fl_Select)
$compatibility_version_check:=Application version:C493
If ($compatibility_version_check<"20A0")
	// (Content of this message should be included as an xliff resource):
	
	CONFIRM:C162(Util_Get_LocalizedMessage("VersionCheck"))
	If (OK=1)
		QUIT 4D:C291
	End if 
End if 
If (Not:C34(Version type:C495 ?? 64 bit version:K5:25))
	ALERT:C41(Util_Get_LocalizedMessage("Use64bitVersion"))  // to avoid an empty Admin dashboard.
End if 

New process:C317("Clients_UpdateGeocoding"; 0; "Clients_UpdateGeocoding")  // in case an older data file is used without geocoding data

UNREGISTER CLIENT:C649
REGISTER CLIENT:C648(ds:C1482.getClientSessionID())

If ((Application type:C494=4D Local mode:K5:1) | (Application type:C494=4D Remote mode:K5:5))
	CALL WORKER:C1389("Generic"; "W_Generic"; "StartupScreen"; $fl_Select)
End if 

If ((Application type:C494=4D Local mode:K5:1) | (Application type:C494=4D Server:K5:6))
	WEB SET ROOT FOLDER:C634(Get 4D folder:C485(Database folder:K5:14)+"Web")
	WEB START SERVER:C617
End if 

