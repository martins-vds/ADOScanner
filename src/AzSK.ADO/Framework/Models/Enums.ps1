Set-StrictMode -Version Latest
enum VerificationResult
{
	Passed 
    Failed
    Verify
    Manual
	RiskAck
	Error
	Disabled
	Exception
	Remediate
	Skipped
	NotScanned
	Fixed
}

enum AttestationStatus
{
	None
    NotAnIssue
	NotFixed
	WillNotFix
	WillFixLater
	ApprovedException
	NotApplicable
	StateConfirmed
}

enum AttestControls 
{
	None
	All
	AlreadyAttested
	NotAttested
}

enum MessageType
{
    Critical
    Error
    Warning
    Info
    Update
    Deprecated
	Default
}

enum ControlSeverity
{
	Critical
	High
	Medium
	Low
}


enum ScanSource
{
    SpotCheck
    VSO
    Runbook
}

enum FeatureGroup
{
	Unknown
    Organization
    Service
}

enum ServiceScanKind
{
    Partial
    ResourceGroup
    Organization
}

enum OrganizationScanKind
{
    Partial
    Complete
}

enum MonitoringSolutionInstallationOption
{
	All
	Queries
	Alerts
	SampleView
	GenericView
}

enum GeneratePDF
{
	None
	Landscape
	Portrait
}

enum CAReportsLocation
{
	CentralSub
	IndividualSubs	
}

enum InfoType
{
	OrganizationInfo
	ControlInfo
	HostInfo
	AttestationInfo
	ComplianceInfo
}

enum AutoUpdate
{
	On
	Off
	NotSet
}

enum StorageContainerType
{
	AttestationDataContainer
	CAMultiSubScanConfigContainer
	ScanProgressSnapshotsContainer
	CAScanOutputLogsContainer
}

enum TertiaryBool
{	
	False
	True
	NotSet
}

enum ComparisionType
{
	NumLesserOrEqual
}

enum OverrideConfigurationType
{
	Installer
	CARunbooks
	AzSKRootConfig
	MonitoringDashboard
	OrgAzSKVersion
	All
	None
}

enum RemoveConfiguredCASetting
{
	LAWSSettings
	AltLAWSSettings
	WebhookSettings
}

enum DashboardType
{
	View
	Workbook
}

enum AIOrgTelemetryStatus
{
	Undefined
	Enabled
	Disabled
}

enum BugLogForControls 
{
	All
	BaselineControls
	PreviewBaselineControls
	Custom
}

enum SecuritySeverity 
{
	Critical
	High
	Important
	Moderate
	Medium
	Low
}

enum FeedPermissions {
	Reader = 2
	Contributor = 3
	administrator = 4 
	collaborator = 5
}