#!/usr/bin/env bash

# convert -layers flatten ./build/*.png out-layers.jpg

# montage ./build/frame-*-360.png \
#   -background '#000000' \
#   -size 384x384 \
#   -resize 384x384 \
#   -geometry +0+0 \
#   -tile 5x2 \
#   out-montage.jpg

#   #-size 200x200 \
#   #-geometry 200x200 \
#   #-tile 4x4 \


for i in $(seq -f "%03g" 0 360); do
  echo "Building big frame: $i"

  montage "./build/frame-*-$i.png" \
    -background '#000000' \
    -size 384x384 \
    -resize 384x384 \
    -geometry +0+0 \
    -tile 5x2 \
    "./build/big-frame-$i.jpg"


  echo $i
done

