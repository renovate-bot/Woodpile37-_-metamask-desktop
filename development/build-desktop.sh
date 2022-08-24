#!/bin/sh

OUTPUT_DIR="dist_desktop"

echo "Rebuilding leveldown for Electron to support 3box"
yarn electron-rebuild -o leveldown

echo "Removing existing build files"
rm -rf $OUTPUT_DIR

echo "Creating directories"
mkdir $OUTPUT_DIR
mkdir $OUTPUT_DIR/app

echo "Copying HTML"
cp -r app/desktop.html $OUTPUT_DIR/app/desktop.html

echo "Copying locales"
cp -r app/_locales $OUTPUT_DIR/app

# Export all shell variables
set -a

# Set desktop specific variables
DESKTOP=APP

# Add variables from .metamaskrc
export $(cat .metamaskrc | grep -v ";" | xargs)

echo "Transpiling JavaScript"
babel --plugins transform-inline-environment-variables \
    . \
    -d ./$OUTPUT_DIR \
    --watch \
    --ignore dist \
    --ignore dist_desktop \
    --ignore builds_desktop \
    --ignore development \
    --ignore node_modules \
    --ignore test \
    --ignore .storybook
