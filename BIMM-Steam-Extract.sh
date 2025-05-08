#!/bin/bash

# Use zenity to get the collection URL
collection_url=$(zenity --entry --title="Enter Steam Collection URL" --text="Please enter the URL of the Steam Workshop Collection:")

# Check if the user cancelled the input
if [ -z "$collection_url" ]; then
  echo "No collection URL provided. Exiting."
  exit 1
fi

# Use zenity to get the output file path and name
output_file=$(zenity --file-selection --save --confirm-overwrite --title="Save Modified Preset As" --filename="modified_preset.html")

# Check if the user cancelled the save dialog
if [ -z "$output_file" ]; then
  echo "No output file selected. Exiting."
  exit 1
fi

default_preset_file="Arma 3 Preset Default.html"

# Fetch the collection page
collection_html=$(curl -s "$collection_url")

# Extract mod names and links using awk and build mod_entries
mod_entries=$(awk '
  /workshopItemTitle/ {
    gsub(/<[^>]*>/, "", $0);
    sub(/^[[:space:]]*/, "", $0);
    titles[++title_count] = $0;
  }
  /<a href="https:\/\/steamcommunity\.com\/sharedfiles\/filedetails\/\?id=[0-9]+[^>]*>/ {
    match($0, /href="(https:\/\/steamcommunity\.com\/sharedfiles\/filedetails\/\?id=[0-9]+)"/);
    if (RSTART && RLENGTH > 0) {
      start = RSTART + length("href=\"");
      len = RLENGTH - length("href=\"") - length("\"");
      mod_link = substr($0, start, len);
      if (link_count > 0) {
        links[++link_count] = mod_link;
      } else {
        link_count = 1;
        # Intentionally skip storing the first link, so no corresponding title will be paired.
      }
    }
  }
  END {
    # Start the loop from the second title and the second link (if they exist)
    for (i = 2; i <= title_count && i <= link_count; i++) {
      printf "        <tr data-type=\"ModContainer\">\n";
      printf "          <td data-type=\"DisplayName\">%s</td>\n", titles[i];
      printf "          <td>\n            <span class=\"from-steam\">Steam</span>\n          </td>\n";
      printf "          <td>\n            <a href=\"%s\" data-type=\"Link\">%s</a>\n          </td>\n", links[i], links[i];
      printf "        </tr>\n";
    }
  }
' <<< "$collection_html")

# Construct the replacement for the entire mod-list div
mod_list_replacement="<div class=\"mod-list\">
      <table>
$mod_entries
      </table>
    </div>"

# Use awk to perform the replacement and directly output to the file
awk -v replacement="$mod_list_replacement" '
  {
    if ($0 ~ /<div class="mod-list">/) {
      replaced = 1
      print replacement
    } else if (replaced && $0 ~ /<\/div>/) {
      replaced = 0
    } else if (!replaced) {
      print
    }
  }
' "$default_preset_file" > "$output_file"

zenity --info --title="Success" --text="Successfully extracted mod list and saved to '$output_file'."

exit 0