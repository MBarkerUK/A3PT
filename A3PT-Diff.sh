#!/bin/sh
# filepath: /ext/Development/A3PT/A3PT-Diff.sh

# Function to select an HTML file using Zenity
get_filename() {
    prompt_number="$1"
    zenity --file-selection \
        --title="Select Arma 3 Preset File $prompt_number" \
        --file-filter="Preset files (*.html)|*.html"
}

# Get the first mod list file
FILE1=$(get_filename 1)
if [ -z "$FILE1" ]; then
    echo "File 1 selection cancelled. Exiting."
    exit 1
fi

# Get the second mod list file
FILE2=$(get_filename 2)
if [ -z "$FILE2" ]; then
    echo "File 2 selection cancelled. Exiting."
    exit 1
fi

echo "--- Finding unique mods in '$FILE1' and '$FILE2' ---"
echo "--------------------------------------------------------"

# 1. Stitch together all lines belonging to a mod block, then find the unique blocks.
MOD_BLOCKS_RAW=$(cat "$FILE1" "$FILE2" | \
    awk '
        # Check for the start of a mod block
        /<tr data-type="ModContainer">/ { in_block=1; line=""; }
        # If inside a block, append the line content
        in_block { line = line $0; }
        # Check for the end of a mod block
        /<\/tr>/ { if (in_block) { print line; in_block=0; } }
    ' | sort | uniq -u)

# Check if any mod blocks were found
if [ -z "$MOD_BLOCKS_RAW" ]; then
    echo "No unique mod differences found between the selected presets."
    echo "--------------------------------------------------------"
    echo "Processing complete."
    exit 0
fi

# 2. Decode &amp;, and extract DisplayName, Mod ID, and Full Link.
PARSED_MODS=$(echo "$MOD_BLOCKS_RAW" | \
    # SED PRE-PASS: Decode the ampersand entity, e.g., 'O&amp;T' becomes 'O&T'.
    sed 's/&amp;/\&/g' | \
    
    # AWK PASS: Extract the required fields based on markers.
    awk '
    {
        # --- Extract Link and ID ---
        if (match($0, /href="(https:\/\/steamcommunity\.com\/sharedfiles\/filedetails\/\?id=[0-9]+)" data-type="Link"/)) {
            RSTART_LINK = RSTART + length("href=\"")
            RLENGTH_LINK = RLENGTH - length("href=\"") - length("\" data-type=\"Link\"")
            full_link = substr($0, RSTART_LINK, RLENGTH_LINK)
            
            if (match(full_link, /id=([0-9]+)/)) {
                mod_id = substr(full_link, RSTART + length("id="), RLENGTH - length("id="))
            } else {
                mod_id = "ID_NOT_FOUND"
            }
        }
        
        # --- Extract DisplayName ---
        if (match($0, /<td data-type="DisplayName">[^<]*<\/td>/)) {
            RSTART_NAME = RSTART + length("<td data-type=\"DisplayName\">")
            RLENGTH_NAME = RLENGTH - length("<td data-type=\"DisplayName\">") - length("</td>")
            
            name = substr($0, RSTART_NAME, RLENGTH_NAME)
        } else {
            name = "NAME_NOT_FOUND"
        }

        # Print Mod Name|Mod ID|Full Link
        print name "|" mod_id "|" full_link;
    }
')

# Use a subshell to generate the uncolored, aligned output using 'column'.
# Then, pipe the entire output into 'awk' to apply alternating colors.
(
    echo "Mod Name|Mod ID|Full Link"
    echo "--------|------|-----------"
    echo "$PARSED_MODS"
) | column -t -s '|' | awk '
    BEGIN {
        # ANSI Color Codes for alternating rows
        COLOR1="\033[48;5;236m\033[37m"; # Dark Gray background, White foreground
        COLOR2="\033[48;5;235m\033[37m"; # Darker Gray background, White foreground
        RESET="\033[0m";
        i = 0;
    }
    # Print the first two header/separator lines normally
    NR <= 2 { print; next }
    {
        # Alternate color for every data line
        i = !i;
        if (i) {
            printf "%s%s%s\n", COLOR1, $0, RESET;
        } else {
            printf "%s%s%s\n", COLOR2, $0, RESET;
        }
    }
'

echo "--------------------------------------------------------"
echo "Processing complete."