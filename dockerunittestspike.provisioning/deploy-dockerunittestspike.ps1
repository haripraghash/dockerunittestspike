Param (
	[Parameter(Mandatory=$true)]
	[string]$DockerRegistryUrl,

	[Parameter(Mandatory=$true)]
	[string]$DockerUserName,

	[Parameter(Mandatory=$true)]
	[securestring]$DockerPassword,

	[Parameter(Mandatory=$true)]
	[string]$DockerImageName,

	# Resource group
	[Parameter(Mandatory=$true)]
	[string] $ResourceGroupLocation,

    [string] $ResourceGroupName = 'dockerunittestspike-eun-dev-resgrp',

    [string] $TemplateFile = 'azuredeploy.json',

	# General
	[Parameter(Mandatory=$true)]
	[string] $Environment = 'dev'
)

$ErrorActionPreference = 'Stop'

Set-Location $PSScriptRoot

$AadTenantId = (Get-AzureRmContext).Tenant.Id
$ArtifactsStorageAccountName = $ResourceNamePrefix + $Environment + 'artifacts'
$ArtifactsStorageContainerName = 'artifacts'
$ArtifactsStagingDirectory = '.'


function CreateResourceGroup() {
	$parameters = New-Object -TypeName Hashtable

	# general
	$parameters['environment'] = $Environment
	$parameters['dockerRegistryUrl'] = $DockerRegistryUrl
	$parameters['dockerUserName'] = $DockerUserName
	$parameters['dockerPassword'] = $DockerPassword
	$parameters['dockerImageName'] = $DockerImageName

	 Write-Host ($parameters | Out-String)
	.\Deploy-AzureResourcegroup.ps1 `
	    -resourcegrouplocation $ResourceGroupLocation `
		-resourcegroupname $ResourceGroupName `
		-uploadartifacts `
		-storageaccountname $ArtifactsStorageAccountName `
		-storagecontainername $ArtifactsStorageContainerName `
		-artifactstagingdirectory $ArtifactsStagingDirectory `
		-templatefile $TemplateFile `
		-templateparameters $parameters
}

function Main() {
	$deployment = CreateResourceGroup
	$deployment

	if ($deployment.ProvisioningState -eq 'Failed'){
		throw "Deployment was unsuccessful"
	}
	
	$webApiName = $deployment.outputs.webApiName.Value
	#$appInsightsName = $deployment.outputs.appInsightsName.Value
	$appInsightsInstrumentationKey = $deployment.outputs.appInsightsInstrumentationKey.Value
	$apiWebAppUrl = $deployment.outputs.webApiUrl.Value

	
	# set application settings for web api
	$apiAppSettings = @{
		'ApplicationInsights:InstrumentationKey' = $appInsightsInstrumentationKey;
		'ASPNETCORE_ENVIRONMENT' = 'Development';
	}

	#if ($IsDevelopment)
	#{
	#	$apiAppSettings = $apiAppSettings + @{'ASPNETCORE_ENVIRONMENT' = 'Development'}
	#}

	.\Configure-AppSettings.ps1 `
	-ResourceGroupName $ResourceGroupName `
	-WebAppName $webApiName `
	-AppSettings $apiAppSettings
	
	Write-Host "##vso[task.setvariable variable=WebApiAppServiceName;]$webApiName"
	Write-Host "##vso[task.setvariable variable=ResourceGroupName;]$ResourceGroupName"
	Write-Host "##vso[task.setvariable variable=ApiWebAppUrl;]$apiWebAppUrl"
}

Main