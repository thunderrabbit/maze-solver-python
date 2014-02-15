#!/bin/bash

# Produces animations (gif & avi) of the search process.
# Usage example: ./solve_maze.sh mazes/maze_000.jpg

TMP_DIR=tmp
MAZE=$1
MAZE_NAME=$(basename "$MAZE")
OUT_GIF=out/${MAZE_NAME%.*}.gif
OUT_VID=out/${MAZE_NAME%.*}.avi

# Clean up old output files.
{
	rm $TMP_DIR/* 
	rm $OUT_GIF
	rm $OUT_VID
} 2> /dev/null

# Solve.
python solve.py $MAZE

echo -n 'Generating AVI...'
avconv -r 10 -i $TMP_DIR/%5d.jpg $OUT_VID 2> /dev/null
echo -e "\t$OUT_VID"

echo -n 'Generating GIF...'
# Resize images.
(
    cd $TMP_DIR
    for img in `ls *.jpg`
    do
	    convert $img -resize 40% "tmp.jpg"
	    mv "tmp.jpg" $img
    done
)

convert -delay 10 -loop 0 -layers optimize $( ls $TMP_DIR/*.jpg | sort  ) $OUT_GIF
echo -e "\t$OUT_GIF"
