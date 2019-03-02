#
# localdeploy.ps1
# script can be used for deployment from local pc to Azure
clear
#Clear-AzureRmContext -Scope Process

if ((Get-AzureRmContext).Subscription.Name -ne "Visual Studio Enterprise")
{
    Login-AzureRmAccount

    Set-AzureRmContext -Subscription Visual Studio Enterprise
}

$AadAdmin = "..."
$DockerPassword = ConvertTo-SecureString "..." -AsPlainText -Force
$ResourceGroupLocation = "northeurope"
$Environment = "dev"
$DockerRegistryUrl = "..."
$DockerUserName = "..."

.\deploy-dockerunittestspike.ps1 -DockerPassword $DockerPassword `
   -ResourceGroupLocation $ResourceGroupLocation `
   -DockerRegistryUrl $DockerRegistryUrl `
    -DockerUserName $DockerUserName `
   -environment $Environment