Param(
    [Hashtable] $parameters
)

Invoke-ScriptInBcContainer -containerName $parameters.ContainerName -scriptblock { Param([string]$packagesFolder)
    if (!(Test-Path (Join-Path $packagesFolder "Microsoft_Application.app"))) {
        Write-Host "Copying apps to packages folder"
        Copy-Item -path "c:\run\my\Microsoft_*.app" -Destination "$packagesFolder\"
    }
} -argumentList (Get-BcContainerPath -ContainerName $parameters.ContainerName -path $Parameters.appSymbolsFolder) | Out-Null

Compile-AppInBcContainer @parameters

