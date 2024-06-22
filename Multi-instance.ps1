# Define parameters for the script
param(
    [switch]$install,
    [switch]$uninstall
)

# Name that will be used everywhere
$name = (Get-Item $MyInvocation.MyCommand.Path).BaseName

# Name of main folder
$mainFolderName = "Bloxstrap"

if ($install -or $uninstall) {
    $currentFileName = $MyInvocation.MyCommand.Name

    # Define the main folder path
    $mainFolderPath = Join-Path $env:LOCALAPPDATA $mainFolderName

    # Define the settings file name and path
    $settingsFileName = "Settings.json"
    $settingsFilePath = Join-Path $mainFolderPath $settingsFileName

    # Define the integrations folder name and path
    $integrationsFolderName = "Integrations"
    $integrationsFolderPath = Join-Path $mainFolderPath $integrationsFolderName
    $integrationsFolderExists = Test-Path $integrationsFolderPath

    $containerFolderPath = Join-Path $integrationsFolderPath $name
    $fileCopyPath = Join-Path $containerFolderPath $currentFileName

    $customIntegrationsName = "CustomIntegrations"

    # File content and existence check
    $settingsFileContent = Get-Content $settingsFilePath -Raw | ConvertFrom-Json
    $customIntegrationExists = $settingsFileContent.$customIntegrationsName | Where-Object { $_.Name -eq $name }

    # Installation section
    if ($install) {
        Write-Host "Installing..." -ForegroundColor Blue

        try {
            # Check if the necessary folders and files exist
            if (-not (Test-Path $mainFolderPath) -or -not (Test-Path $settingsFilePath)) {
                Write-Host "Installation failed. $mainFolderName folder or $settingsFileName not found." -ForegroundColor Red
                return
            }

            # Create the integrations folder if it doesn't exist
            if (-not (Test-Path $integrationsFolderPath)) {
                New-Item -ItemType Directory -Path $integrationsFolderPath | Out-Null
                Write-Host "Created $integrationsFolderName folder in $mainFolderPath." -ForegroundColor Green
            }
            else {
                Write-Host "$integrationsFolderName folder already exists." -ForegroundColor Yellow
            }

            # Create the name folder if it doesn't exist
            if (-not (Test-Path $containerFolderPath)) {
                New-Item -ItemType Directory -Path $containerFolderPath | Out-Null
                Write-Host "Created $name folder in $integrationsFolderPath." -ForegroundColor Green
            }
            else {
                Write-Host "$name folder already exists." -ForegroundColor Yellow
            }

            # Copy the file to the name folder
            Copy-Item $PSCommandPath $fileCopyPath -Force
            Write-Host "Force copied $currentFileName to $name folder." -ForegroundColor Green

            # Add the custom integration to the settings file
            if ($settingsFileContent.psobject.Properties.Name -contains $customIntegrationsName) {
                if ($customIntegrationExists) {
                    Write-Host "Custom integration with name $name already exists in $settingsFileName." -ForegroundColor Yellow
                } else {
                    $settingsFileContent.$customIntegrationsName += [ordered]@{
                        "Name" = $name
                        "Location" = "powershell.exe"
                        "LaunchArgs" = "-ExecutionPolicy Bypass $fileCopyPath"
                        "AutoClose" = $true
                    }

                    $settingsFileContent | ConvertTo-Json | Set-Content $settingsFilePath
                    Write-Host "Custom integration added to $settingsFileName." -ForegroundColor Green
                }
            } else {
                Write-Host "Installation failed. $customIntegrationsName object not found in $settingsFileName." -ForegroundColor Red
                return
            }

        } catch {
            Write-Host "An error occurred during installation: $_" -ForegroundColor Red
        }
    }
    # Uninstallation section
    elseif ($uninstall) {
        Write-Host "Uninstalling..." -ForegroundColor Blue

        try {
            # Check if the necessary folders and files exist
            if (-not (Test-Path $mainFolderPath) -or -not (Test-Path $settingsFilePath)) {
                Write-Host "Uninstallation failed. $mainFolderName folder or $settingsFileName not found." -ForegroundColor Red
                return
            }

            # Remove the name folder if it exists
            if (Test-Path $containerFolderPath) {
                Remove-Item $containerFolderPath -Force -Recurse
                Write-Host "Removed $name folder from $integrationsFolderPath." -ForegroundColor Green
            } else {
                Write-Host "$name folder not found." -ForegroundColor Yellow
            }

            # Check if the integrations folder is empty, and remove if it is
            $isIntegrationsFolderEmpty = !(Test-Path "$integrationsFolderPath\*")
            if ($isIntegrationsFolderEmpty -and $integrationsFolderExists) {
                try {
                    Remove-Item -Path $integrationsFolderPath -Force -Recurse
                    Write-Host "Removed $integrationsFolderName folder from $mainFolderPath because it was empty." -ForegroundColor Green
                } catch {
                    Write-Host "An error occurred while removing empty $integrationsFolderName folder: $_" -ForegroundColor Red
                }
            }

            # Remove the custom integration from the settings file
            if ($settingsFileContent.psobject.Properties.Name -contains $customIntegrationsName) {
                if ($customIntegrationExists) {
                    $settingsFileContent.$customIntegrationsName = @($settingsFileContent.$customIntegrationsName | Where-Object { $_.Name -ne $name })
                    if (!$settingsFileContent.$customIntegrationsName) {
                        $settingsFileContent.$customIntegrationsName = @()
                    }
                    $settingsFileContent | ConvertTo-Json | Set-Content $settingsFilePath
                    Write-Host "Custom integration removed from $settingsFileName." -ForegroundColor Green
                } else {
                    Write-Host "Custom integration with name $name not found in $settingsFileName." -ForegroundColor Yellow
                }
            } else {
                Write-Host "Uninstallation failed. $customIntegrationsName object not found in $settingsFileName." -ForegroundColor Red
                return
            }

        } catch {
            Write-Host "An error occurred during uninstallation: $_" -ForegroundColor Red
        }
    }
}
# Main functionality section
else {
    # Define the mutex name and check if it exists
    $mutexName = "ROBLOX_singletonEvent"
    $exists = [System.Threading.Mutex]::TryOpenExisting($mutexName, [ref]$null)

    if (-not $exists) {
        $mutex = New-Object System.Threading.Mutex($true, $mutexName)
        Write-Host "$mainFolderName $name integration activated. Do not close this window." -ForegroundColor Green

        # Infinite loop
        while ($true) {
            Start-Sleep -Seconds 1
        }
    }
}
