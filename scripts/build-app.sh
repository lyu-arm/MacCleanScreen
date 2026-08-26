#!/bin/zsh

set -euo pipefail

project_root="${0:A:h:h}"
configuration="release"
output_directory="$project_root/dist"
app_directory="$output_directory/MacCleanScreen.app"
target_architecture="arm64"

cd "$project_root"
"$project_root/scripts/build-icon.sh"
swift build -c "$configuration" --arch "$target_architecture"

binary_path="$(swift build -c "$configuration" --arch "$target_architecture" --show-bin-path)/MacCleanScreen"
rm -rf "$app_directory"
mkdir -p "$app_directory/Contents/MacOS" "$app_directory/Contents/Resources"
cp "$binary_path" "$app_directory/Contents/MacOS/MacCleanScreen"
cp "$project_root/Resources/Info.plist" "$app_directory/Contents/Info.plist"
cp "$project_root/Resources/AppIcon.icns" "$app_directory/Contents/Resources/AppIcon.icns"
codesign --force --deep --sign - "$app_directory"

actual_architecture="$(lipo -archs "$app_directory/Contents/MacOS/MacCleanScreen")"
if [[ "$actual_architecture" != "$target_architecture" ]]; then
    echo "Unexpected application architecture: $actual_architecture" >&2
    exit 1
fi

echo "$app_directory"
