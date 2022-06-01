Param(
    [Hashtable]$parameters
)

$parameters.appfile | Out-Host

$systemAppFile = $parameters.appfile | Where-Object { [System.IO.Path]::GetFileName($_) -like "Microsoft_System Application_*.*.*.*.app" }
$ModulesTestApps = $parameters.appfile | Where-Object { [System.IO.Path]::GetFileName($_) -like "Modules-main-TestApps-*.*.*.*.zip" }
if ($systemAppFile) {
    $includeOnlyAppIds = $parameters.includeOnlyAppIds
    $remainingAppFiles = $parameters.appfile | Where-Object { $_ -ne $systemAppFile }
    $parameters.AppFile = $systemAppFile
    $parameters.includeOnlyAppIds = @()

    Publish-BcContainerApp @parameters

    Copy-Item -Path $systemAppFile -Destination (Join-Path $bcContainerHelperConfig.hostHelperFolder "Extensions\$($parameters.ContainerName)\my")

    # Copy necessary apps to my folder
    Invoke-ScriptInBcContainer -containerName $parameters.ContainerName -scriptblock {
        $baseApp = "C:\Applications.*\Microsoft_Base Application_*.*.*.*.app"
        if (-not (Test-Path $baseApp)) {
            $baseApp = "C:\Applications\BaseApp\Source\Microsoft_Base Application.app"
        }
        Write-Host "Copying Base Application to my path"
        Copy-Item -Path (Get-Item $baseApp).FullName -Destination "c:\run\my\Microsoft_Base Application.app"

        $application = "C:\Applications.*\Microsoft_Application_*.*.*.*.app"
        if (-not (Test-Path $application)) {
            $application = "C:\Applications\Application\Source\Microsoft_Application.app"
        }
        Write-Host "Copying Application to my path"
        Copy-Item -Path (Get-Item $application).FullName -Destination "c:\run\my\Microsoft_Application.app"

        $testLibrariesApp = "C:\Applications.*\Microsoft_Tests-TestLibraries_*.*.*.*.app"
        if (-not (Test-Path $testLibrariesApp)) {
            $testLibrariesApp = "C:\Applications\BaseApp\Test\Microsoft_Tests-TestLibraries.app"
        }
        Write-Host "Copying Tests-TestLibraries to my path"
        Copy-Item -Path (Get-Item $testLibrariesApp).FullName -Destination "c:\run\my\Microsoft_Tests-TestLibraries.app"
    }

    Write-Host "Publishing Base Application"
    $parameters.appFile = Join-Path $bcContainerHelperConfig.hostHelperFolder "Extensions\$($parameters.ContainerName)\my\Microsoft_Base Application.app"
    Publish-BcContainerApp @parameters

    Write-Host "Publishing Application"
    $parameters.appFile = Join-Path $bcContainerHelperConfig.hostHelperFolder "Extensions\$($parameters.ContainerName)\my\Microsoft_Application.app"
    Publish-BcContainerApp @parameters

    if ($remainingAppFiles) {
        $parameters.AppFile = $remainingAppFiles
        $parameters.includeOnlyAppIds = $includeOnlyAppIds
        Publish-BcContainerApp @parameters
    }
}
elseif ($ModulesTestApps) {
    $includeOnlyAppIds = $parameters.includeOnlyAppIds
    $parameters.includeOnlyAppIds = @()
    Publish-BcContainerApp @parameters

    Write-Host "Publishing Tests-TestLibraries"
    $parameters.includeOnlyAppIds = $includeOnlyAppIds
    $parameters.appFile = Join-Path $bcContainerHelperConfig.hostHelperFolder "Extensions\$($parameters.ContainerName)\my\Microsoft_Tests-TestLibraries.app"
    Publish-BcContainerApp @parameters
}
else {
    Publish-BcContainerApp @parameters
}
