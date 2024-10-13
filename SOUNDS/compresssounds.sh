shopt -s globstar

for file in ./**/*.wav 
do
	ffmpeg -i "$file" -c:a libvorbis -ar 44100 -ac 1 "${file%.*}.ogg"
	rm "$file"
done
