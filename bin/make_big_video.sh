#!/usr/bin/env bash

ffmpeg -pattern_type glob -i './build/big-frame-*.jpg' -c:v libx264 -pix_fmt yuv420p out.mp4 -y
