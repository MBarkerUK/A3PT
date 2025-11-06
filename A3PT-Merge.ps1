# A3PT-Merge.ps1
# This script merges mod lists from two Arma 3 HTML preset files into a template.

# Function to write information messages to the console (and potentially logs)
function Write-InformationMessage {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    Write-Information -MessageData $Message -InformationAction Continue
}

# Function to write warning messages to the console (and potentially logs)
function Write-WarningMessage {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    Write-Warning -Message $Message
}

# Function to display an Open File Dialog and return the selected file path
function Get-PresetFilePath {
    param(
        [string]$Title = "Please Select Preset File",
        [string]$InitialDirectory = (Get-Location).Path # Default to current location
    )
    # Ensure the System.Windows.Forms assembly is loaded for GUI elements
    try {
        Add-Type -AssemblyName System.Windows.Forms -ErrorAction Stop
    }
    catch {
        Write-Error "Could not load System.Windows.Forms assembly. This script requires a GUI environment."
        exit 1
    }

    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.Title = $Title
    $OpenFileDialog.InitialDirectory = $InitialDirectory
    $OpenFileDialog.Filter = "Preset files (*.html)|*.html"
    $OpenFileDialog.ShowDialog() | Out-Null # Suppress the dialog result output

    # Return the selected file name. Returns an empty string if no file is selected.
    return $OpenFileDialog.FileName
}

# Function to extract the inner content of the first <table> tag from an HTML string
# It prioritizes XML parsing but includes a regex fallback for less-than-perfect HTML.
function Get-HtmlTableContent {
    param(
        [Parameter(Mandatory=$true)]
        [string]$HtmlContent
    )
    try {
        # Attempt to parse HTML as XML for robust element selection
        $htmlDoc = New-Object System.Xml.XmlDocument
        # Suppress errors from LoadXml if it fails due to malformed HTML, we'll use regex fallback
        $htmlDoc.LoadXml($HtmlContent) # This will throw an error if HTML is not strictly XML

        # Find the first <table> element using XPath
        $tableNode = $htmlDoc.SelectSingleNode("//table")

        if ($tableNode) {
            # Return the InnerXml of the table (its content, i.e., the <tr> elements, etc.)
            return $tableNode.InnerXml
        } else {
            Write-WarningMessage "No <table> tag found via XML parsing in the provided HTML content. Attempting regex fallback."
            # Fall through to regex fallback
        }
    }
    catch {
        Write-WarningMessage "XML parsing of HTML content failed: $($_.Exception.Message). Attempting regex fallback for table extraction."
        # Fall through to regex fallback
    }

    # Fallback to regex if XML parsing fails or finds no table
    $tableMatch = [regex]::Match($HtmlContent, '(?s)<table>(.*?)</table>')
    if ($tableMatch.Success) {
        # Capture group 1 contains the content *inside* the table tags
        return $tableMatch.Groups[1].Value
    } else {
        Write-WarningMessage "Regex fallback also failed: No <table> tag found in the provided HTML content."
        return $null # Return $null if no table content could be extracted
    }
}


# --- Main Script Logic ---

# Define standard file paths for the template and output
$templatePath = "Arma 3 Preset Default.html"
$outputFilePath = "Arma 3 Preset Merged.html"

# Define the HTML tags for the mod list division
$modListDivStartTag = '<div class="mod-list">'
$modListDivEndTag = '</div>'

# Get the path for the first mod list HTML file from the user
$modListFile1 = Get-PresetFilePath -Title "Please Select First Mod List File"
if ([string]::IsNullOrEmpty($modListFile1)) {
    Write-InformationMessage "No first mod list file selected. Exiting."
    exit 1
}

# Get the path for the second mod list HTML file from the user
$modListFile2 = Get-PresetFilePath -Title "Please Select Second Mod List File"
if ([string]::IsNullOrEmpty($modListFile2)) {
    Write-InformationMessage "No second mod list file selected. Exiting."
    exit 1
}

# Read the content of the template HTML file
try {
    $templateContent = Get-Content -Path $templatePath -Raw -ErrorAction Stop
}
catch {
    Write-Error "Error reading the template file ('$templatePath'): $($_.Exception.Message)"
    exit 1
}

# Define a regex pattern to find the exact placeholder structure in the template HTML
# This pattern looks for a 'div' with class 'mod-list' containing an empty 'table' tag
$placeholderModListPattern = '(?s)(<div class="mod-list">\s*<table[^>]*>\s*</table>\s*</div>)'
$templateModListMatch = [regex]::Match($templateContent, $placeholderModListPattern)

# Check if the expected placeholder was found in the template
if (-not $templateModListMatch.Success) {
    Write-Error "Error: Could not find the empty mod list placeholder in '$templatePath'."
    Write-Error "Expected pattern: <div class='mod-list'><table /></div> (or similar empty table within the div)."
    exit 1
}

# Capture the exact text of the matched placeholder for replacement
$targetPlaceholderText = $templateModListMatch.Groups[1].Value

# Initialize a StringBuilder for efficient concatenation of mod list HTML fragments
$mergedTableContent = [System.Text.StringBuilder]::new()

# Define the list of mod list files to be merged
$modListFilesToMerge = @($modListFile1, $modListFile2)

# Process each mod list file
foreach ($file in $modListFilesToMerge) {
    try {
        $fileContent = Get-Content -Path $file -Raw -ErrorAction Stop
        # Extract the inner HTML content of the <table> tag from the current file
        $tableInnerHtml = Get-HtmlTableContent -HtmlContent $fileContent

        # If table content was successfully extracted, append it to the StringBuilder
        if ($null -ne $tableInnerHtml) {
            [void]$mergedTableContent.AppendLine($tableInnerHtml)
        } else {
            Write-WarningMessage "Could not extract table content from '$file'. Skipping this file."
        }
    }
    catch {
        Write-Error "An error occurred while reading or processing '$file': $($_.Exception.Message)"
        # Do not exit here; attempt to process other files in the list
    }
}

# Construct the complete new mod-list section, including the div and table tags
# The content from mergedTableContent is placed inside the <table> tags
$newModListSection = @"
$modListDivStartTag
      <table>
$($mergedTableContent.ToString().Trim()) # Trim to remove any trailing newlines from AppendLine
      </table>
$modListDivEndTag
"@

# Replace the identified placeholder in the template content with the new merged section
# [regex]::Escape is used to ensure the exact matched placeholder text is treated literally in the replacement
$finalContent = $templateContent -replace [regex]::Escape($targetPlaceholderText), $newModListSection

# Write the final merged content to the specified output file
try {
    $finalContent | Set-Content -Path $outputFilePath -Encoding UTF8 -ErrorAction Stop
    Write-InformationMessage "Successfully merged mod lists and saved to '$outputFilePath'."
}
catch {
    Write-Error "Error writing the final merged content to '$outputFilePath': $($_.Exception.Message)"
    exit 1
}

# Exit with success code
exit 0