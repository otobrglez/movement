#!/usr/bin/env bash

ffmpeg -pattern_type glob -i './build/frame-0-*.png' -c:v libx264 -pix_fmt yuv420p out-0.mp4 -y
