#!/bin/bash

# Default database file
db_file="$HOME/.protecao"
if [ ! -f $db_file ]; then
touch $HOME/.protecao
fi

db_file="$HOME/.protecao"

# Function to display usage
usage() {https://videoconf-colibri.zoom.us/my/joaquimferreira
echo "Usage: $0 [-p directory1 [directory2 ...]] [-v] [-f database_file]"
echo "Options:"
echo " -p : Protect specified directories"
echo " -v : Verify if changes have been made since last protection"
echo " -f : Specify database file (default: $HOME/.protecao)"
exit 1
}
# Function to protect directories
protect_directories() {
# Check if directories are specified
if [ $# -eq 0 ]; then
    echo "Error: No directories specified for protection."
    usage
fi

# Create database file
#
echo "# Protected Directories:" > "$db_file"
# Loop through directories and store file information
for dir in "$@"; do
echo "# $dir" >> "$db_file"



find "$dir" -type f -exec stat --format="%n %u %g %s %A %y" {} + >> "$db_file"
done

echo "Protection completed."
}

# Function to verify changes
verify_changes() {
# Check if database file exists
if [ ! -f "$db_file" ]; then
echo "Error: Database file no
# Parse command-line optionst found. Please run in protection mode first."
usage
fi

# Loop through protected directories on $HOME/.protecao file 
while read -r line; do
if [[ $line == "# "* ]]; then
dir="${line:2}"
echo "Checking directory: $dir"
else
file_info=($line)
file="${file_info[0]}"
if [ ! -f "$file" ]; then
echo "File removed: $file"
else
# Check if file has been modified
current_info=$(stat --format="%n %u %g %s %A %y" "$file")
if [ "$line" != "$current_info" ]; then
echo "Changes detected in file: $file"
echo "Previous info: $line"
echo "Current info: $current_info"
fi
fi
fi
done < "$db_file"
}

# Parse command-line options
while getopts ":p:vf:" opt; do
case $opt in
p)
protect_directories "${OPTARG[@]}"
;;
v)
verify_changes
;;
f)
db_file="$OPTARG"
;;
\?)
echo "Error: Invalid option -$OPTARG"
usage
;;
esac
done

# If no options are provided, default to verification mode
if [ $OPTIND -eq 1 ]; then
verify_changes
fi
