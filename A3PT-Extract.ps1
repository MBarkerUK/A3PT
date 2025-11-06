# Function to write information messages
function Write-InformationMessage {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    # Using Write-Information, which can be suppressed or redirected.
    Write-Information -MessageData $Message -InformationAction Continue
}

# Define a function for the file dialog to make it reusable and avoid global variables
function Get-PresetFilePath {
    param(
        [string]$InitialDirectory = (Get-Location).Path # Default to current location
    )
    Add-Type -AssemblyName System.Windows.Forms

    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.Title = "Please Select Preset File"
    $OpenFileDialog.InitialDirectory = $InitialDirectory
    $OpenFileDialog.Filter = "Preset files (*.html)|*.html"
    $OpenFileDialog.ShowDialog() | Out-Null # Suppress the dialog result output

    # Return the selected file name directly
    return $OpenFileDialog.FileName
}

# --- Main Script Logic ---

# Get the path to the selected preset file
$selectedFilePath = Get-PresetFilePath

# Check if a file was selected
if ([string]::IsNullOrEmpty($selectedFilePath)) {
    Write-InformationMessage "No file selected. Exiting."
    exit 1
}

# Define the output file name
$outputModListFile = "ModList.txt"

try {
    # Take selected file and extract mod names
    # Using Select-String for more robust XML/HTML parsing than findstr/split
    # Get-Content -Raw reads the entire file as a single string,
    # then [regex]::Matches finds all occurrences, then loop through them.
    $modNames = [regex]::Matches(
        (Get-Content -Path $selectedFilePath -Raw),
        '<td data-type="DisplayName">(?<modname>.*?)</td>'
    ) | ForEach-Object {
        $_.Groups["modname"].Value.Trim()
    }

    if ($modNames.Count -gt 0) {
        # Connect mod names with ;@ in between, formatting them as required by BI
        $modNames -join ";@" | Set-Content -Path $outputModListFile -Encoding UTF8

        Write-InformationMessage "Successfully extracted mod list and saved to '$outputModListFile'."
        Write-InformationMessage "Your File Is Now Ready To Be Copy And Pasted Into A Config"
        Write-InformationMessage "Default File Name: $outputModListFile"
    } else {
        Write-Warning "No mod display names found in the selected preset file."
        Set-Content -Path $outputModListFile -Value "" -Encoding UTF8 # Create empty file
    }
}
catch {
    Write-Error "An error occurred during file processing: $($_.Exception.Message)"
    exit 1
}

exit 0