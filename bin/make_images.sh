#!/usr/bin/env bash

# convert -layers flatten ./build/*.png out-layers.jpg

montage ./build/*.png \
  -background '#FFFFFF' \
  -resize 200x200 \
  -size 200x200 \
  -geometry +11+11 out-montage.jpg

