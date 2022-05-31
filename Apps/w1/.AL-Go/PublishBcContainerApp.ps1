Param(
    [Hashtable]$parameters
)

Publish-BcContainerApp @parameters

$filename = [System.IO.Path]::GetFileName($parameters.appFile)
if ($filename -like "Microsoft_System Application_*.*.*.*.app") {
    Write-Host "Publishing Base Application"
    $parameters.appFile = Join-Path $bcContainerHelperConfig.hostHelperFolder "Extensions\$($parameters.ContainerName)\my\Microsoft_Base Application.app"
    Publish-BcContainerApp @parameters

    Write-Host "Publishing Application"
    $parameters.appFile = Join-Path $bcContainerHelperConfig.hostHelperFolder "Extensions\$($parameters.ContainerName)\my\Microsoft_Application.app"
    Publish-BcContainerApp @parameters
}
elseif ($filename -like "Microsoft_System Application Test_*.*.*.*.app") {
    Write-Host "Publishing Tests-TestLibraries"
    $parameters.appFile = Join-Path $bcContainerHelperConfig.hostHelperFolder "Extensions\$($parameters.ContainerName)\my\Microsoft_Tests-TestLibraries.app"
    Publish-BcContainerApp @parameters
}
