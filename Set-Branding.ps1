[CmdletBinding()]
param (
	#! If no other param specified, then will not show in windows 11
	[Parameter(Mandatory = $true)]
	[String]
	$CompanyName,

	[Parameter(Mandatory = $false)]
	[String]
	$HomeScreen,

	[Parameter(Mandatory = $false)]
	[String]
	$LockScreen,

	[Parameter(Mandatory = $false)]
	[String]
	$LoginBackground,

	#! Does not work with Windows 11
	[Parameter(Mandatory = $false)]
	[String]
	$Logo,

	[Parameter(Mandatory = $false)]
	[String]
	$SupportURL,

	[Parameter(Mandatory = $false)]
	[String]
	$SupportPhone,

	[Parameter(Mandatory = $false)]
	[String]
	$UserImage

)

# make required registry changes
$hklmSoft = "HKLM:\Software"
$hklmCurrentVer = "$($hklmSoft)\Microsoft\Windows\CurrentVersion"
$oemInfoPath = "$($hklmCurrentVer)\OEMInformation"

Set-ItemProperty -Path $oemInfoPath -Name Manufacturer -Value $CompanyName
# Set-ItemProperty -Path $oemInfoPath -Name SupportHours -Value "7:00am to 7:00pm"

# Create directory structure for custom OOBE
If (!(Test-Path "$($env:windir)\system32\oobe\info\backgrounds")) {
	New-Item "$($env:windir)\system32\oobe\info\backgrounds" -type directory 
}

# Set HomeScreen Image
if ($HomeScreen) {
	$strPath4 = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
	Copy-Item $HomeScreen "$($env:windir)\Web\Wallpaper\Windows" -PassThru -OutVariable HomeScreen
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies -Name System -Force
	Set-ItemProperty -Path $strPath4 -Name Wallpaper -Value ($HomeScreen).FullName
	Set-ItemProperty -Path $strPath4 -Name WallpaperStyle -Value 2

}

# Set LockScreen Image
if ($LockScreen) {
	$strPath3 = "$($hklmSoft)\Policies\Microsoft\Windows\Personalization"
	Copy-Item $LockScreen "$($env:windir)\Web\Screen" -PassThru -OutVariable LockScreen
	New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows" -Name Personalization -Force
	Set-ItemProperty -Path $strPath3 -Name LockScreenImage -Value ($LockScreen).FullName

}

# Set Login Background
if ($LoginBackground) {
	$strPath2 = "$($hklmCurrentVer)\Authentication\LogonUI\Background"
	Copy-Item $LoginBackground "$($env:windir)\system32\oobe\info\backgrounds"
	Set-ItemProperty -Path $strPath2 -Name OEMBackground -Value 1
}

# Set Logo
if ($Logo) {
	Copy-Item $Logo "$($env:windir)\system32"
	Copy-Item $Logo "$($env:windir)\system32\oobe\info" -PassThru -OutVariable Logo
	Set-ItemProperty -Path $strPath -Name Logo -Value ($Logo).FullName
}

# Set support URL
if ($SupportPhone) {
	Set-ItemProperty -Path $oemInfoPath -Name SupportURL -Value $SupportURL
}

# Set support phone number
if ($SupportPhone) {
	Set-ItemProperty -Path $oemInfoPath -Name SupportPhone -Value $SupportPhone
}

# Set user image
if ($UserImage) {
	Copy-Item $UserImage "$($env:ProgramData)\Microsoft\User Account Pictures"
}
