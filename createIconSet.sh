#!/bin/bash
function realpath { echo $(cd $(dirname $1); pwd)/$(basename $1); }
if [ ! -f $1 ]; then
  echo "cant find $1"
  exit 1
fi
command -v rsvg-convert >/dev/null 2>&1 || { echo >&2 "install rsvg-convert with brew install librsvg  Aborting."; exit 1; }
absPath=$(realpath $1)
file=$(basename $absPath)
basename=${file/.svg/}
mkdir $basename.iconset
cd $basename.iconset
for size in 16 32 128 256 512; do
  echo "icon_${size}x${size}.png"
  rsvg-convert -h $size $absPath > "icon_${size}x${size}.png"
  twox=$(( $size * 2 ))
  echo "icon_${size}x${size}@2x.png"
  rsvg-convert -h $twox $absPath > "icon_${size}x${size}@2x.png"
done
cd ..
echo "create icns $basename.icns"
iconutil -c icns $basename.iconset
#rm -r "$basename.iconset"
