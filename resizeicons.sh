#!/bin/bash

# Constants
iosdir="Ballout/Assets/Assets.xcassets/AppIcon.appiconset/"
iossrc="Icon/AppIcon.png"

## IOS
#
# Convert all icons from the original 2048x2048 icon.
#		29x29
#		40x40
#		50x50
#		57x57
#		60x60
#		72x72
#		76x76
convert $iossrc -resize 20x20 -unsharp 0x0.75+0.75+0.008 ${iosdir}icon-20x20.png
convert $iossrc -resize 40x40 -unsharp 0x0.75+0.75+0.008 ${iosdir}icon-20x20@2x.png
convert $iossrc -resize 60x60 -unsharp 0x0.75+0.75+0.008 ${iosdir}icon-20x20@3x.png

convert $iossrc -resize 29x29 -unsharp 0x0.75+0.75+0.008 ${iosdir}icon-29x29.png
convert $iossrc -resize 58x58 -unsharp 0x0.75+0.75+0.008 ${iosdir}icon-29x29@2x.png
convert $iossrc -resize 87x87 -unsharp 0x0.75+0.75+0.008 ${iosdir}icon-29x29@3x.png

convert $iossrc -resize 40x40 -unsharp 0x0.75+0.75+0.008 ${iosdir}icon-40x40.png
convert $iossrc -resize 80x80 -unsharp 0x0.75+0.75+0.008 ${iosdir}icon-40x40@2x.png
convert $iossrc -resize 120x120 -unsharp 0x0.75+0.75+0.008 ${iosdir}icon-40x40@3x.png

convert $iossrc -resize 50x50 -unsharp 0x0.75+0.75+0.008 ${iosdir}icon-50x50.png
convert $iossrc -resize 100x100 -unsharp 0x0.75+0.75+0.008 ${iosdir}icon-50x50@2x.png

convert $iossrc -resize 57x57 -unsharp 0x0.75+0.75+0.008 ${iosdir}icon-57x57.png
convert $iossrc -resize 114x114 -unsharp 0x0.75+0.75+0.008 ${iosdir}icon-57x57@2x.png

convert $iossrc -resize 120x120 -unsharp 0x0.75+0.75+0.008 ${iosdir}icon-60x60@2x.png
convert $iossrc -resize 180x180 -unsharp 0x0.75+0.75+0.008 ${iosdir}icon-60x60@3x.png

convert $iossrc -resize 72x72 -unsharp 0x0.75+0.75+0.008 ${iosdir}icon-72x72.png
convert $iossrc -resize 144x144 -unsharp 0x0.75+0.75+0.008 ${iosdir}icon-72x72@2x.png

convert $iossrc -resize 76x76 -unsharp 0x0.75+0.75+0.008 ${iosdir}icon-76x76.png
convert $iossrc -resize 152x152 -unsharp 0x0.75+0.75+0.008 ${iosdir}icon-76x76@2x.png

convert $iossrc -resize 167x167 -unsharp 0x0.75+0.75+0.008 ${iosdir}icon-83.5x83.5@2x.png

convert $iossrc -resize 1024x1024 -unsharp 0x0.75+0.75+0.008 ${iosdir}icon-1024x1024.png
