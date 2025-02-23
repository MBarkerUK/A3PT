#!/bin/bash

#Open file selection window to select preset
filename="$(zenity --file-selection --file-filter='HTML files (html) | *.html' --title"Select your mod preset")"

#Take selected file and cut away everything apart from the mod names
grep -a '"DisplayName"' $filename | cut -d ">" -f2 | cut -d "<" -f1 | sed 's/^/@/' | tr '\n' ';' > ModList.txt
printf "Your File Is Now Ready To Be Copy And Pasted Into A Config\n"
printf "Default File Name: ModList.txt"
