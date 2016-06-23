<#
.SYNOPSIS
A hacked-up way to deploy an ASP.NET Core webapp into Red Hat's Container Runtime Environment.

.DESCRIPTION
This script helps to set up a CRE container for remote debugging

.PARAMETER Configuration
The current build configuration (Debug or Release)

.INPUTS
None
#>

Param(
	[ValidateNotNullOrEmpty()]
	[String]$Configuration
)

$ContainerWorkingDirectory = "/app"
$ProjectName = $ProjectName -replace "[^a-zA-Z0-9]", ""
$ImageName = "${ProjectName}_musicstore"
$Framework = "netcoreapp1.0"
$ProjectFolder = (Split-Path -Path $MyInvocation.MyCommand.Definition)
$ProjectFolder = Resolve-Path $ProjectFolder
$CREBinFolder = Join-Path $ProjectFolder (Join-Path "bin" "CRE")
$buildContext = Join-Path $CREBinFolder $Configuration
$pubPath = Join-Path $buildContext "app"
dotnet publish -f $Framework -r "rhel.7.2-x64" -c $Configuration -o $pubPath $ProjectFolder
C:\cdk\docker-1.9.1.exe run -d -p 5000:80 -v "/c/Users/RedHatDevelopers/Documents/Repos/MusicStore/src/MusicStore/bin/CRE/Debug/app:/app" qodfathr/rhel-dotnet:1.0-debug