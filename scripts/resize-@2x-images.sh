#!/bin/bash

base="$( dirname "$( dirname "$0" )" )"
cd "$base"

process() {
	f=$1
	if [ -f $f -a "$(echo $f | grep '@2x.')" ]; then
		resizeFile $f
	elif [ -d $f ]; then
		for f in $(find $f -name '*@2x.*' -type f); do
			resizeFile $f
		done
	fi
}
resizeFile() {
	f="$1"
	ext="$(basename $f | sed -Ee 's/.*\.([a-z]+)/\1/')" \
		&& outFile="$(dirname $f)/$(basename -s "@2x.$ext" $f).$ext" \
		&& echo "Converting $f" \
		&& convert "$f" -resize '50%' $outFile
}

if [ "$1" ]; then
	for f in $@; do
		process $f
	done
else
	while read f; do
		process $f
	done
fi