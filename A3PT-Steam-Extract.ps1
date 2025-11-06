function Save-FileDialog {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Title,
        [string]$InitialFileName,
        [string]$Filter
    )
    Add-Type -AssemblyName System.Windows.Forms
    $SaveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $SaveFileDialog.Title = $Title
    $SaveFileDialog.FileName = $InitialFileName
    $SaveFileDialog.Filter = $Filter
    $SaveFileDialog.OverwritePrompt = $true
    if ($SaveFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        return $SaveFileDialog.FileName
    }
    return ""
}

# --- Main Script Logic ---

# Function to write information messages (replaces Write-Host for non-critical info)
function Write-InformationMessage {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    # Using Write-Information, which can be suppressed or redirected.
    Write-Information -MessageData $Message -InformationAction Continue
}

# Function to write warning messages
function Write-WarningMessage {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    Write-Warning -Message $Message
}

# Prompt the user for the Steam Collection URL
$collectionUrl = Read-Host -Prompt "Enter Steam Workshop Collection URL"

# Check if the user provided a URL
if ([string]::IsNullOrEmpty($collectionUrl)) {
    Write-InformationMessage "No collection URL provided. Exiting." # Replaced Write-Host
    exit 1
}

# Prompt the user for the output file path and name
$outputFile = Save-FileDialog -Title "Save Modified Preset As" -InitialFileName "modified_preset.html" -Filter "HTML files (*.html)|*.html"

# Check if the user selected a file
if ([string]::IsNullOrEmpty($outputFile)) {
    Write-InformationMessage "No output file selected. Exiting." # Replaced Write-Host
    exit 1
}

$defaultPresetFile = "Arma 3 Preset Default.html"

# Fetch the collection page
try {
    # Add a timeout and error action
    $collectionHtml = Invoke-WebRequest -Uri $collectionUrl -UseBasicParsing -TimeoutSec 30 -ErrorAction Stop | Select-Object -ExpandProperty Content
}
catch [System.Net.WebException] {
    Write-Error "A network error occurred: $($_.Exception.Message)"
    exit 1
}
catch {
    Write-Error "Failed to fetch the collection page: $($_.Exception.Message)"
    exit 1
}

# Extract mod names and links using regular expressions
$modEntries = ""
# Renamed $matches to $regexMatches to avoid conflict with automatic variable $matches
$regexMatches = [regex]::Matches($collectionHtml, '(?s)<a href="(?<link>https:\/\/steamcommunity\.com\/sharedfiles\/filedetails\/\?id=\d+)"><div class="workshopItemTitle">(?<title>.*?)<\/div><\/a>')

if ($regexMatches.Count -gt 0) { # Use .Count for checking if matches exist
    foreach ($match in $regexMatches) { # Iterate through $regexMatches
        $title = $match.Groups["title"].Value.Trim()
        $link = $match.Groups["link"].Value.Trim()
        if ($title -and $link) {
            $modEntries += @"
        <tr data-type=`"ModContainer`">
          <td data-type=`"DisplayName`">$title</td>
          <td>
            <span class=`"from-steam`">Steam</span>
          </td>
          <td>
            <a href=`"$link`" data-type=`"Link`">$link</a>
          </td>
        </tr>
"@
        }
    }
    $modEntries = @"
      <table>
$modEntries
      </table>
"@
} else {
    Write-WarningMessage "No mods found in the Steam Workshop Collection." # Replaced Write-Warning
}

# Construct the replacement for the entire mod-list div
$modListReplacement = @"
<div class="mod-list">
        $modEntries
"@

# Read the default preset file content
try {
    $defaultPresetContent = Get-Content -Path $defaultPresetFile -Raw
}
catch {
    Write-Error "Error reading the default preset file: $($_.Exception.Message)"
    exit 1
}

# Perform the replacement
$newContent = $defaultPresetContent -replace '(<div class="mod-list">
      <table />)', $modListReplacement

# Write the modified content to the output file
try {
    $newContent | Out-File -FilePath $outputFile -Encoding UTF8
    Write-InformationMessage "Successfully extracted mod list and saved to '$outputFile'." # Replaced Write-Host
}
catch {
    Write-Error "Error writing to the output file: $($_.Exception.Message)"
    exit 1
}

exit 0