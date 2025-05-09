#Open file selection window to select preset
Add-Type -AssemblyName System.Windows.Forms
$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$OpenFileDialog.Title = "Please Select File"
$OpenFileDialog.InitialDirectory = $initialDirectory
$OpenFileDialog.filter = "Preset files (*.html)|*.html"
$OpenFileDialog.ShowDialog() | Out-Null
#Using selected file as input for the rest of the code
$Global:SelectedFile = $OpenFileDialog.FileName

#Take selected file and cut away everything apart from the mod names
Get-Content "$SelectedFile" | findstr "DisplayName" | ForEach-Object { ([string]$_).Split(">")[1] } | ForEach-Object { ([string]$_).Split("<")[0] } > ModList.txt
#Connect mod names with ;@ in between, formatting them as required by BI
(Get-Content -Path ModList.txt) -join ";@" | Set-Content -Path ModList.txt
Write-Host "Your File Is Now Ready To Be Copy And Pasted Into A Config"
Write-Host "Default File Name: ModList.txt"
