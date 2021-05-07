Import-Module "C:\Users\sragala\Desktop\ADOScannerCurrentSprint\ApprovedException\ADOScanner\src\AzSK.ADO\AzSKStaging.ADO.psd1"

Gads -OrganizationName "Safetitestvso" -ProjectNames "AzSDKDemoRepo" -ResourceType Build `
            -BuildNames "AzSDKDemoApp_BuildDef,AzSDKDemoRepo-Azure Web App-CI" `
                     -ControlIds "ADO_Build_DP_Review_Inactive_Build" `
                            -ControlsToAttest All