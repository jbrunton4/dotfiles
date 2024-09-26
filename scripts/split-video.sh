#!/bin/bash
# Short script to split videos by filesize using ffmpeg by LukeLR
# (Modified)

if [ $# -lt 1 ] || [[ "$1" =~ ^-(-)?h(elp)?$ ]]; then
	echo 'Usage:'
	echo "$1 FILE_PATH [SIZE_LIMIT_BYES] [FFMPEG_ARGS]"
	echo
	echo 'Parameters:'
	echo '    - FILE:        Name of the video file to split'
	echo '    - SIZELIMIT:   [Optional] Maximum file size of each part (in bytes). Default is 500_000_000 (~500MB)'
	echo '    - FFMPEG_ARGS: [Optional] Additional arguments to pass to each ffmpeg-call. Default: "-c:v libx264 -crf 23 -c:a copy -vf scale=960:-1"'
	echo '                   (video format and quality options etc.)'
	exit 1
fi

FILE="$1"
SIZELIMIT="$2"
FFMPEG_ARGS="$3"

if [ -z "$SIZELIMIT" ]; then
	SIZELIMIT="500000000"
fi

if [ -z "$FFMPEG_ARGS" ]; then
	FFMPEG_ARGS="-c:v libx264 -crf 23 -c:a copy -vf scale=960:-1"
fi

# Duration of the source video
DURATION=$(ffprobe -i "$FILE" -show_entries format=duration -v quiet -of default=noprint_wrappers=1:nokey=1 | cut -d. -f1)

# Duration that has been encoded so far
CUR_DURATION=0

# Filename of the source video (without extension)
BASENAME="${FILE%.*}"

# Extension for the video parts
EXTENSION="$(echo $FILE | awk -F '.' '{print $NF}')"

# Number of the current video part
i=1

# Filename of the next video part
NEXTFILENAME="$BASENAME-$i.$EXTENSION"

echo "Duration of source video: $DURATION"

# Until the duration of all partial videos has reached the duration of the source video
while [[ $CUR_DURATION -lt $DURATION ]]; do
	# Encode next part
	echo ffmpeg -i "$FILE" -ss "$CUR_DURATION" -fs "$SIZELIMIT" $FFMPEG_ARGS "$NEXTFILENAME"
	ffmpeg -ss "$CUR_DURATION" -i "$FILE" -fs "$SIZELIMIT" $FFMPEG_ARGS "$NEXTFILENAME"

	# Duration of the new part
	NEW_DURATION=$(ffprobe -i "$NEXTFILENAME" -show_entries format=duration -v quiet -of default=noprint_wrappers=1:nokey=1 | cut -d. -f1)

	# Total duration encoded so far
	CUR_DURATION=$((CUR_DURATION + NEW_DURATION))

	i=$((i + 1))

	echo "Duration of $NEXTFILENAME: $NEW_DURATION"
	echo "Part No. $i starts at $CUR_DURATION"

	NEXTFILENAME="$BASENAME-$i.$EXTENSION"
done
