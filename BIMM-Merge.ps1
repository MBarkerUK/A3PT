$templatePath = "Arma 3 Preset Default.html"
$outputFilePath = "Arma 3 Preset Merged.html"
$modListStartTag = '<div class="mod-list">'
$modListEndTag = '</div>'

#Open file selection window to select preset
Add-Type -AssemblyName System.Windows.Forms
$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$OpenFileDialog.Title = "Please Select File"
$OpenFileDialog.InitialDirectory = $initialDirectory
$OpenFileDialog.filter = "Preset files (*.html)|*.html"
$OpenFileDialog.ShowDialog() | Out-Null

#Using selected file as input for the rest of the code
$Global:mod_list_1 = $OpenFileDialog.FileName

#Open file selection window to select preset
Add-Type -AssemblyName System.Windows.Forms
$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$OpenFileDialog.Title = "Please Select File"
$OpenFileDialog.InitialDirectory = $initialDirectory
$OpenFileDialog.filter = "Preset files (*.html)|*.html"
$OpenFileDialog.ShowDialog() | Out-Null

#Using selected file as input for the rest of the code
$Global:mod_list_2 = $OpenFileDialog.FileName

# Read template content
$templateContent = Get-Content -Path $templatePath -Raw

# Extract mod-list section from template
$modListStartIndex = $templateContent.IndexOf($modListStartTag)
$modListEndIndex = $templateContent.IndexOf($modListEndTag, $modListStartIndex) + $modListEndTag.Length
$modListSection = $templateContent.Substring($modListStartIndex, $modListEndIndex - $modListStartIndex)

# Read external mod list HTML files and append their table contents
$modListFiles = @("$mod_list_1", "$mod_list_2")  # Add more file paths if needed

foreach ($file in $modListFiles) {
    $modListContent = Get-Content -Path $file -Raw
    $tableStartTag = '<table>'
    $tableEndTag = '</table>'
    
    $tableStartIndex = $modListContent.IndexOf($tableStartTag)
    $tableEndIndex = $modListContent.IndexOf($tableEndTag, $tableStartIndex) + $tableEndTag.Length
    $tableContent = $modListContent.Substring($tableStartIndex, $tableEndIndex - $tableStartIndex)
    
    $modListSection += $tableContent
}

# Replace the mod-list section in the template with the merged content
$finalContent = $templateContent.Remove($modListStartIndex, $modListEndIndex - $modListStartIndex)
$finalContent = $finalContent.Insert($modListStartIndex, $modListSection)

# Write the final merged content to the output file
$finalContent | Set-Content -Path $outputFilePath
