#!/bin/zsh

set -euo pipefail

project_root="${0:A:h:h}"
configuration="release"
output_directory="$project_root/dist"
app_directory="$output_directory/MacCleanScreen.app"

cd "$project_root"
swift build -c "$configuration"

binary_path="$(swift build -c "$configuration" --show-bin-path)/MacCleanScreen"
rm -rf "$app_directory"
mkdir -p "$app_directory/Contents/MacOS" "$app_directory/Contents/Resources"
cp "$binary_path" "$app_directory/Contents/MacOS/MacCleanScreen"
cp "$project_root/Resources/Info.plist" "$app_directory/Contents/Info.plist"
codesign --force --deep --sign - "$app_directory"

echo "$app_directory"
