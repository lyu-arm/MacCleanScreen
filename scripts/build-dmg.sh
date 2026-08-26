#!/bin/zsh

set -euo pipefail

project_root="${0:A:h:h}"
app_path="$project_root/dist/MacCleanScreen.app"
version="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$project_root/Resources/Info.plist")"
dmg_path="$project_root/dist/MacCleanScreen-$version-arm64.dmg"
checksum_path="$dmg_path.sha256"
staging_directory="$(mktemp -d)"

cleanup() {
    rm -rf "$staging_directory"
}
trap cleanup EXIT

"$project_root/scripts/build-app.sh"

ditto "$app_path" "$staging_directory/MacCleanScreen.app"
ln -s /Applications "$staging_directory/Applications"
cp "$project_root/Resources/ChatGPT源头批发网.txt" "$staging_directory/ChatGPT源头批发网.txt"
cp "$project_root/Resources/ChatGPT源头批发网.webloc" "$staging_directory/ChatGPT源头批发网.webloc"

rm -f "$dmg_path" "$checksum_path"
hdiutil create \
    -volname "MacCleanScreen" \
    -srcfolder "$staging_directory" \
    -format UDZO \
    -ov \
    "$dmg_path"

(
    cd "$project_root/dist"
    shasum -a 256 "${dmg_path:t}" > "${checksum_path:t}"
)

echo "$dmg_path"
echo "$checksum_path"
