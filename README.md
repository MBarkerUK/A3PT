<div align="center">

## Arma 3 Preset Toolkit (A3PT)

[![Shell Script Security](https://github.com/MBarkerUK/A3PT/actions/workflows/CScan.yml/badge.svg?branch=main)](https://github.com/MBarkerUK/A3PT/actions/workflows/CScan.yml)
[![Last Commit](https://img.shields.io/github/last-commit/MBarkerUK/A3PT)](https://github.com/MBarkerUK/A3PT/commits/main)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/ff18ca2d321c4fe09a81a6679d153c24)](https://app.codacy.com/gh/MBarkerUK/A3PT/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)

<small>This repository is regularly scanned for security vulnerabilities using GitHub Actions, ensuring code quality and safety. The build status indicates the current state of the automated tests, and the last update badge shows recent development activity.</small>

### A3PT (Arma 3 Preset Toolkit) is a command-line utility designed to streamline the management of Arma 3 mod presets. It provides functionality to extract mod lists from preset files and merge multiple presets into a single, unified file

</div>

## Features

* **Mod List Extraction:** Quickly generate a list of mods from an Arma 3 preset HTML file, facilitating easy inspection and configuration.
* **Preset Merging:** Combine multiple Arma 3 preset files into a consolidated file, simplifying the management of complex mod configurations.
* **Steam Collection Extraction:** Extract mods from Steam Workshop Collections and build a mod preset out of them for easy setup.

## Usage

### Mod List Extraction

#### Linux/macOS

```bash
./A3PT-Extract.sh
```

#### Windows

```powershell
.\A3PT-Extract.ps1
```

<details>
<summary>Detailed Explanation</summary>

This command extracts mod names from a given Arma 3 preset HTML file.

1. **File Selection:** A file selection dialog will appear, prompting you to choose the desired preset HTML file.

2. **Mod Name Extraction:** The script parses the HTML file, identifying and extracting the mod names.

3. **Output:** The extracted mod list is saved to `ModList.txt` in the current working directory. The file contains a single line with mod names delimited by `;@`, suitable for direct use in configuration files.

</details>

### Preset Merging

#### Linux/macOS

```bash
./A3PT-Merge.sh
```

#### Windows

```powershell
.\A3PT-Merge.ps1
```

<details>
<summary>Detailed Explanation</summary>

This command merges two Arma 3 preset HTML files.

1. **File Selection:** You will be prompted to select two preset HTML files.

2. **Template Utilization:** The script uses a template file (`Arma 3 Preset Default.html`) to ensure proper formatting of the merged output.

3. **Mod List Extraction & Combination:** The script extracts the mod lists from the selected files and combines them.

4. **Template Population:** The combined mod list is inserted into the designated section of the template.

5. **Output:** The merged preset is saved as `Arma 3 Preset Merged.html` in the current working directory.

</details>

### Steam Collection Extraction

#### Linux/macOS
```bash
./A3PT-Steam-Extract.sh
```

#### Windows
```powershell
.\A3PT-Steam-Extract.ps1
```

<details>
<summary>Detailed Explanation</summary>

This command extracts a mod list from a Steam Workshop Collection URL and merges it into an Arma 3 preset file.

1. **Collection URL Input:** A dialog will appear, prompting you to enter the URL of the Steam Workshop Collection.

2. **Output File Selection:** You will be prompted to choose where to save the generated Arma 3 preset HTML file.

3. **Template Utilization:** The script uses a template file (Arma 3 Preset Default.html) to ensure proper formatting of the output preset.

4. **Mod List Extraction & Combination:** The script parses the HTML from the Steam Workshop Collection URL, extracts the mod names and their Steam Workshop IDs, and combines them into a format suitable for the Arma 3 preset file.

5. **Template Population:** The extracted and formatted mod list is inserted into the designated mod list section of the template.

6. **Output:** The new preset containing the mods from the Steam Workshop Collection is saved to the location you specified.

</details>

### Mod List Difference

#### Linux/macOS
```bash
./A3PT-Diff.sh
```

<details>
<summary>Detailed Explanation</summary>

This command compares two Arma 3 preset HTML files and identifies mods that are unique to either file.

1. **File Selection:** You will be prompted to select two preset HTML files.

2. **Mod List Comparison:** The script extracts all mod entries from both selected files and then identifies which mod entries are present in one file but not the other.

3. **Output:** The unique mod entries are displayed in the terminal, formatted with their Display Name, Mod ID, and Full Steam Workshop Link. The output is colorized for better readability, with alternating colors for each unique mod.

</details>

## Installation

* **Download:** Download the A3PT scripts from [here](https://github.com/MBarkerUK/A3PT/releases).
* **Make Executable (Linux/macOS):** For the Bash scripts, execute the following command:

```bash
chmod +x A3PT-Extract.sh A3PT-Merge.sh A3PT-Steam-Extract.sh
```

* **Make Executable (Windows):** For the PowerShell scripts, ensure you have the necessary permissions to execute scripts. You may need to set the execution policy:

```powershell
Set-ExecutionPolicy Unrestricted
```

## Dependencies

* **Linux/macOS:**  `zenity`, `grep`, `cut`, `sed`, `tr`, `cat` (Typically pre-installed on most distributions.)
* **Windows:** PowerShell (Pre-installed on Windows).

## Releases

* **v1.6.1 (11-05-2025):** [Release Notes](https://github.com/MBarkerUK/A3PT/releases/tag/1.6.1)
* **v1.6.0 (08-05-2025):** [Release Notes](https://github.com/MBarkerUK/A3PT/releases/tag/1.6.0)
* **v1.5.0 (23-02-2025):** [Release Notes](https://github.com/MBarkerUK/A3PT/releases/tag/1.5.0)
* **v1.4.0 (11-08-2023):** [Release Notes](https://github.com/MBarkerUK/A3PT/releases/tag/1.4.0)
* **v1.3.1 (20-11-2021):** [Release Notes](https://github.com/MBarkerUK/A3PT/releases/tag/1.3.1)
* **v1.3.0 (18-11-2021):** [Release Notes](https://github.com/MBarkerUK/A3PT/releases/tag/1.3.0)

## Contributing

Contributions are welcome! Please submit [pull requests](https://github.com/MBarkerUK/A3PT/pulls) or [open issues](https://github.com/MBarkerUK/A3PT/issues).

## License

This project is licensed under the [GNU General Public License v3.0](LICENSE).
