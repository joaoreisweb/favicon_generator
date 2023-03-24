#!/bin/bash

##
#
# GENERATOR v.1
# Generate favicons from SVG image file
#
# Dependencies: 
# Inkscape (convert .svg to .png)
# imagemagick (create .ico file)
#
# 
# v.1 24.03.2023
#
# created by João Reis
# https://github.com/joaoreisweb
#
##

# Check if imagemagick and inkscape are installed
if ! command -v convert &> /dev/null || ! command -v inkscape &> /dev/null; then
    echo "Installing imagemagick and inkscape..."
    sudo apt-get update
    sudo apt-get install -y imagemagick inkscape
fi

# Check if input arguments are provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 logo.svg"
    exit 1
fi

# Assign input arguments to variables
INPUT_SVG_FILE="$1"
ICONS_FOLDER="images/favicon"
MANIFEST_FILE="$ICONS_FOLDER/app.manifest"
HTML_FILE="index.html"


# create images/favicon folder 
mkdir -p "$ICONS_FOLDER"
cp "$INPUT_SVG_FILE" "$ICONS_FOLDER/logo.svg"

# Use inkscape to convert .svg to .png image file
# Define the icon sizes to be generated
SIZES="180x180 192x192 256x256 512x512"

# Loop through the icon sizes and create the corresponding PNG files
for SIZE in $SIZES
do
    inkscape "$INPUT_SVG_FILE" \
      --export-png="$ICONS_FOLDER/logo_$SIZE.png" \
      --export-width=$SIZE \
      --export-height=$SIZE \
      --export-background-opacity=0
done

# Create favicon.ico file to put in App root folder
# https://imagemagick.org/script/convert.php
convert "$ICONS_FOLDER/logo_256x256.png" -define icon:auto-resize=64,48,32,16 "favicon.ico"
cp "favicon.ico" "$ICONS_FOLDER/favicon.ico"


# Create the app manifest
cat <<EOT > "$MANIFEST_FILE"
{
  "short_name": "My UNITY App",
  "name": "My UNITY Application ecosystem",
  "description": "",
  "start_url": ".",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#000000",
  "icons": [
    {
      "src": "$ICONS_FOLDER/logo.svg",
      "type": "image/svg+xml",
      "sizes": "512x512"
    },
    {
      "src": "$ICONS_FOLDER/logo_192x192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "$ICONS_FOLDER/logo_512x512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ]
}
EOT

# Create the HTML file
cat <<EOT > "$HTML_FILE"
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>My UNITY App</title>
  <link rel="icon" type="image/svg+xml" sizes="any" href="$ICONS_FOLDER/logo.svg">
  <link rel="icon" type="image/x-icon" sizes="16x16 32x32 48x48 64x64" href="/favicon.ico">
  <link rel="icon" type="image/png" sizes="32x32" href="$ICONS_FOLDER/logo_32x32.png">
  <link rel="icon" type="image/png" sizes="16x16" href="$ICONS_FOLDER/logo_16x16.png">
  <link rel="apple-touch-icon" sizes="180x180" href="$ICONS_FOLDER/logo_180x180.png">
  <link rel="manifest" href="$MANIFEST_FILE">
</head>
<body>
  <h1>Welcome to My Web App</h1>
</body>
</html>
EOT

echo "Favicon files, app manifest file, and HTML file created."

