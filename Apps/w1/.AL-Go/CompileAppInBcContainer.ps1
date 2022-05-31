Param(
    [Hashtable] $parameters
)

Invoke-ScriptInBcContainer -containerName $parameters.ContainerName -scriptblock { Param([string]$packagesFolder)
    if (!(Test-Path (Join-Path $packagesFolder "Microsoft_Application.app"))) {
        if (!(Test-Path -Path $packagesFolder -PathType Container)) {
            New-Item -Path $packagesFolder -ItemType Directory | Out-Null
        }
        Write-Host "Copying apps to packages folder"
        Copy-Item -path "c:\run\my\Microsoft_*.app" -Destination $packagesFolder
    }
} -argumentList (Get-BcContainerPath -ContainerName $parameters.ContainerName -path $Parameters.appSymbolsFolder) | Out-Null

Get-ChildItem $parameters.appSymbolsFolder -recurse | Out-Host

Write-Host "App symbols before:"
Get-BcContainerAppInfo -ContainerName $parameters.ContainerName -updatesymbols | Out-Host

Compile-AppInBcContainer @parameters

Write-Host "App Symbols after:"
Get-ChildItem $parameters.appSymbolsFolder -recurse | Out-Host
