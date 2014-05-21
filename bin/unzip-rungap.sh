#!/usr/bin/env bash

echo "UnZIP RunGap ZIPs"

echo "Input: \"$INPUT_FOLDER\""
echo "Output: \"$OUTPUT_FOLDER\""

export INPUT_GLOB="$INPUT_FOLDER/*.zip"

for f in $INPUT_GLOB; do unzip -o -f -q $f '*.tcx' -d $OUTPUT_FOLDER; done

echo "Done."
