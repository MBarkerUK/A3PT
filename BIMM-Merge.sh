#!/bin/bash

templatePath="Arma 3 Preset Default.html"
outputFilePath="Arma 3 Preset Merged.html"
modListStartTag='<div class="mod-list">'
modListEndTag='</div>'

# Function to get filename using zenity
get_filename() {
    zenity --file-selection --file-filter='Preset files (*.html)|*.html' --title="Select your mod preset"
}

# Get the first mod list file
mod_list_1=$(get_filename)
if [ -z "$mod_list_1" ]; then
    echo "No file selected for mod list 1. Exiting."
    exit 1
fi

# Get the second mod list file
mod_list_2=$(get_filename)
if [ -z "$mod_list_2" ]; then
    echo "No file selected for mod list 2. Exiting."
    exit 1
fi

# Read template content
templateContent=$(cat "$templatePath")

# Extract mod-list section from template (retain the full div and table structure)
modListStartIndex=$(echo "$templateContent" | grep -ob "$modListStartTag" | cut -d: -f1 | tr -d '\n')
modListEndIndex=$(($(echo "$templateContent" | grep -ob "$modListEndTag" | cut -d: -f1 | tr -d '\n') + ${#modListEndTag}))

# Check for valid indices
if [ "$modListStartIndex" -ge "$modListEndIndex" ]; then
    echo "Invalid indices: modListStartIndex >= modListEndIndex. Exiting."
    exit 1
fi

# Initialize variable to hold the merged table contents
mergedModList=""

# Read external mod list HTML files and append their table contents
modListFiles=("$mod_list_1" "$mod_list_2")

for file in "${modListFiles[@]}"; do
    modListContent=$(cat "$file")
    tableStartTag='<table>'
    tableEndTag='</table>'

    # Extract the table content from the mod list file
    tableStartIndex=$(echo "$modListContent" | grep -ob "$tableStartTag" | cut -d: -f1 | tr -d '\n')
    tableEndIndex=$(($(echo "$modListContent" | grep -ob "$tableEndTag" | cut -d: -f1 | tr -d '\n') + ${#tableEndTag}))

    # Check for valid table indices
    if [ "$tableStartIndex" -ge "$tableEndIndex" ]; then
        echo "Invalid indices: tableStartIndex >= tableEndIndex for $file. Skipping."
        continue
    fi

    # Extract the table content (excluding any malformed characters before or after)
    tableContent="${modListContent:$tableStartIndex:$((tableEndIndex - tableStartIndex))}"

    # Clean up the extracted table content to ensure there are no stray or malformed characters
    cleanTableContent=$(echo "$tableContent" | sed 's/<table>//g' | sed 's/<\/table>//g' | sed 's/able>//g')

    # Append the cleaned-up table content to the merged mod list
    mergedModList+="$cleanTableContent"
done

# Ensure the merged table content is wrapped in a <table> tag
finalTableContent="<table>$mergedModList</table>"

# Replace the mod-list section in the template with the new merged table content, keeping the div structure intact
finalContent="${templateContent:0:$modListStartIndex}$modListStartTag$finalTableContent$modListEndTag${templateContent:$modListEndIndex}"

# Append the footer, dlc-list, and other sections back at the end if missing
finalContent="${finalContent}"$'\n'"    <div class=\"dlc-list\">"$'\n'"        <table />"$'\n'"    </div>"$'\n'"    <div class=\"footer\">"$'\n'"        <span>Created by Arma 3 Launcher by Bohemia Interactive.</span>"$'\n'"    </div>"$'\n'"  </body>"$'\n'"</html>"

# Write the final merged content to the output file
echo "$finalContent" > "$outputFilePath"

echo "Files merged successfully. Output file: $outputFilePath"
