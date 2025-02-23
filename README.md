# Bohemia Interactive Mod Manager (B.I.M.M)

B.I.M.M (Bohemia Interactive Mod Manager) is a command-line utility designed to streamline the management of Arma 3 mod presets.  It provides functionality to extract mod lists from preset files and merge multiple presets into a single, unified file.

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

1. **Download:** Download the B.I.M.M scripts from [here](https://github.com/MBarkerUK/B.I.M.M/releases).
2. **Make Executable (Linux/macOS):** For the Bash scripts, execute the following command:

```bash
chmod +x BIMM-Extract.sh BIMM-Merge.sh
```

## Dependencies

* **Linux/macOS:**  `zenity`, `grep`, `cut`, `sed`, `tr`, `cat` (Typically pre-installed on most distributions.)
* **Windows:** PowerShell (Pre-installed on Windows).

## Contributing

Contributions are welcome! Please submit [pull requests](https://github.com/MBarkerUK/B.I.M.M/pulls) or [open issues](https://github.com/MBarkerUK/B.I.M.M/issues).

## License

This project is licensed under the [GNU General Public License v3.0](LICENSE).
