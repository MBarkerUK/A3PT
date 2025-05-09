#region Helper Functions
# Function to display a cross-platform file selection dialog
function Select-File {
    param(
        [string]$Title = "Please Select File",
        [string]$InitialDirectory = $PWD,
        [string]$Filter = "Preset files (*.html)|*.html"
    )

    # Check if we are on Windows
    if ($PSPlatform -eq "Win32") {
        # Use the Windows Forms OpenFileDialog
        Add-Type -AssemblyName System.Windows.Forms
        $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
        $OpenFileDialog.Title = $Title
        $OpenFileDialog.InitialDirectory = $InitialDirectory
        $OpenFileDialog.filter = $Filter
        $OpenFileDialog.ShowDialog() | Out-Null
        return $OpenFileDialog.FileName
    }
    elseif ($PSPlatform -eq "Linux") {
        # Use zenity for Linux
        $zenityPath = (Get-Command zenity -ErrorAction SilentlyContinue).path
        if ($zenityPath) {
            $selectedFile = try {
                # Construct the command, ensuring proper quoting and using the full path
                $command = "$zenityPath --file-selection --title='$Title' --filename='$InitialDirectory' --file-filter'$filter'"
                Write-Host "Executing zenity: $command"
                $selectedFile = Invoke-Expression $command
                 # Output the selected file path
                Write-Host "Selected file: $selectedFile"
            } catch {
                Write-Error "Error executing zenity: $($_.Exception.Message)"
                return ""
            }
            return $selectedFile
        }
        else {
            Write-Error "Zenity is not available on this Linux system."
            return ""
        }
    }
    else {
        # Use a simpler, console-based approach for other platforms
        Write-Host "$Title"
        Write-Host "Please enter the file path (or drag and drop the file and press Enter):"
        # Read the file path from the console
        $filePath = Read-Host
        #Basic validation
        if (-Not (Test-Path $filePath))
        {
            Write-Error "Invalid file path"
            return ""
        }
        return $filePath
    }
}

# Function to extract mod names from the file content
function Extract-ModNames {
    param(
        [string]$FilePath
    )
    try {
        # Read the file content
        $content = Get-Content -Path $FilePath -Encoding UTF8
        # Use a more robust regex pattern
        [string[]]$modNames = $content | Select-String -Pattern 'DisplayName&gt;([^&lt;]+)&lt;' -AllMatches |
                                  ForEach-Object { $_.Matches.Value } |
                                  ForEach-Object { $_ -replace 'DisplayName&gt;', '' -replace '&lt;', '' }
        return $modNames
    }
    catch {
        Write-Error "Error reading or processing file: $($_.Exception.Message)"
        return @()
    }
}

# Function to format the mod names as required
function Format-ModNames {
    param(
        [string[]]$ModNames
    )
    return ($ModNames -join ";@")
}

# Function to write content to a file
function Write-ToFile {
    param(
        [string]$FilePath,
        [string]$Content
    )
    try {
        $Content | Out-File -FilePath $FilePath -Encoding UTF8
        Write-Host "File successfully written to: $FilePath" -ForegroundColor Green
    }
    catch {
        Write-Error "Error writing to file: $($_.Exception.Message)"
        return @()
    }
}
#endregion

# Main Script Logic
$initialDirectory = Get-Location
$fileFilter = "Preset files (*.html)|*.html"

# Select the file
$selectedFile = Select-File -Title "Please Select File" -InitialDirectory $initialDirectory -Filter $fileFilter

# Check if a file was selected
if (-not $selectedFile) {
    Write-Warning "No file selected. Exiting."
    exit
}

$Global:SelectedFile = $selectedFile #make available in global scope.

# Extract and format the mod names
$modNames = Extract-ModNames -FilePath $selectedFile
$formattedModNames = Format-ModNames -ModNames $modNames

# Write the formatted mod names to a file
$outputFilePath = Join-Path -Path (Get-Location) -ChildPath "ModList.txt"
Write-ToFile -FilePath $outputFilePath -Content $formattedModNames

Write-Host "Your File Is Now Ready To Be Copy And Pasted Into A Config" -ForegroundColor Green
Write-Host "Default File Name: $outputFilePath" -ForegroundColor Yellow
