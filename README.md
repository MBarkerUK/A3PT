<div align="center">

## Bohemia Interactive Mod Manager (B.I.M.M)

<<<<<<< HEAD
[![Shell Script Security](https://github.com/MBarkerUK/B.I.M.M/actions/workflows/CScan.yml/badge.svg?branch=main)](https://github.com/MBarkerUK/B.I.M.M/actions/workflows/CScan.yml)
=======
[![Code Scan](https://github.com/MBarkerUK/B.I.M.M/actions/workflows/CScan.yml/badge.svg?branch=main)](https://github.com/MBarkerUK/B.I.M.M/actions/workflows/CScan.yml)
[![Security Scan](https://img.shields.io/badge/Security-Scanned-brightgreen)](https://github.com/MBarkerUK/B.I.M.M/security)
>>>>>>> c0a7ffaa0c1f93bd745962d71269a79b92743766
[![Last Commit](https://img.shields.io/github/last-commit/MBarkerUK/B.I.M.M)](https://github.com/MBarkerUK/B.I.M.M/commits/main)
[![Codacy Security Scan](https://github.com/MBarkerUK/B.I.M.M/actions/workflows/codacy.yml/badge.svg?branch=main)](https://github.com/MBarkerUK/B.I.M.M/actions/workflows/codacy.yml)

<small>This repository is regularly scanned for security vulnerabilities using GitHub Actions, ensuring code quality and safety. The build status indicates the current state of the automated tests, and the last update badge shows recent development activity.</small>

### B.I.M.M (Bohemia Interactive Mod Manager) is a command-line utility designed to streamline the management of Arma 3 mod presets. It provides functionality to extract mod lists from preset files and merge multiple presets into a single, unified file

</div>

## Features

* **Mod List Extraction:** Quickly generate a list of mods from an Arma 3 preset HTML file, facilitating easy inspection and configuration.
* **Preset Merging:** Combine multiple Arma 3 preset files into a consolidated file, simplifying the management of complex mod configurations.

## Usage

### Mod List Extraction

#### Linux/macOS

```bash
./BIMM-Extract.sh
```

#### Windows

```powershell
.\BIMM-Extract.ps1
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
./BIMM-Merge.sh
```

#### Windows

```powershell
.\BIMM-Merge.ps1
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

## Installation

**Download:** Download the B.I.M.M scripts from [here](https://github.com/MBarkerUK/B.I.M.M/releases).
**Make Executable (Linux/macOS):** For the Bash scripts, execute the following command:

```bash
chmod +x BIMM-Extract.sh BIMM-Merge.sh
```

## Dependencies

* **Linux/macOS:**  `zenity`, `grep`, `cut`, `sed`, `tr`, `cat` (Typically pre-installed on most distributions.)
* **Windows:** PowerShell (Pre-installed on Windows).

## Releases

* **v1.5.0 (23-02-2025):** [Release Notes](https://github.com/MBarkerUK/B.I.M.M/releases/tag/1.5.0)
* **v1.4.0 (11-08-2023):** [Release Notes](https://github.com/MBarkerUK/B.I.M.M/releases/tag/1.4.0)
* **v1.3.1 (20-11-2021):** [Release Notes](https://github.com/MBarkerUK/B.I.M.M/releases/tag/1.3.1)
* **v1.3.0 (18-11-2021):** [Release Notes](https://github.com/MBarkerUK/B.I.M.M/releases/tag/1.3.0)

## Contributing

Contributions are welcome! Please submit [pull requests](https://github.com/MBarkerUK/B.I.M.M/pulls) or [open issues](https://github.com/MBarkerUK/B.I.M.M/issues).

## License

This project is licensed under the [GNU General Public License v3.0](LICENSE).
