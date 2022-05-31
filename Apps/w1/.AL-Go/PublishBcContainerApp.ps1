Param(
    [Hashtable]$parameters
)

Publish-BcContainerApp @parameters

$filename = [System.IO.Path]::GetFileName($parameters.appFile)

if ($filename -like "Microsoft_System Application_*.*.*.*.app") {

    Copy-Item -Path $parameters.appFile -Destination (Join-Path $bcContainerHelperConfig.hostHelperFolder "Extensions\$($parameters.ContainerName)\my")

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
    $parameters.includeOnlyAppIds = @()
    Publish-BcContainerApp @parameters
}
elseif ($filename -like "Microsoft_System Application Test Library_*.*.*.*.app" -or $filename -like "Modules-main-TestApps-*.*.*.*.zip") {
    Write-Host "Publishing Tests-TestLibraries"
    $parameters.appFile = Join-Path $bcContainerHelperConfig.hostHelperFolder "Extensions\$($parameters.ContainerName)\my\Microsoft_Tests-TestLibraries.app"
    Publish-BcContainerApp @parameters
}
