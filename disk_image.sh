#!/bin/bash

# Usage: disk_image.sh <warnUsage> <maxUsage>
# Example: disk_image.sh 2000000 4000000

echo '<?xml version="1.0" encoding="UTF-8" standalone="no"?><svg version="1.1" viewBox="0 0 32 32" xmlns="http://www.w3.org/2000/svg">';

IFS="
";
MAXDISK=3000000
WARNDISK=2000000

if -n "$2"; then
	WARNDISK=$1
	MAXDISK=$2
fi

MAXDISK10=$(( $MAXDISK/1000 ))
TMP="/tmp/disk_image.prev"
DATA=`cat /proc/diskstats`
if test -e $TMP; then
	OLDDATA=`cat $TMP`;
	OLDLINES=(${OLDDATA});
	LINES=0
	for line in $DATA; do
		LINES=$(($LINES+1))
	done

	YSTEP=$((32000/$LINES/1000))
	LINE=0
	Y=0
	for line in $DATA; do
		IFS=" " arrIN=(${line});
		OLDLINE=${OLDLINES[$LINE]}
		IFS=" " arrOld=(${OLDLINE});

		SECTORS=$(( ${arrIN[5]}+${arrIN[9]} ))
		SECTORS_OLD=$(( ${arrOld[5]}+${arrOld[9]} ))

		SECTORS_DIFF=$(( $SECTORS-$SECTORS_OLD ))

		WIDTH=$(($SECTORS_DIFF/$MAXDISK10*32/1000))
		if test $WIDTH -eq 0 -a $SECTORS_DIFF -gt 0; then
			WIDTH=1
		fi
		COLOR="rgb(0,255,0)";
		if test $SECTORS_DIFF -gt $WARNDISK; then
			COLOR="rgb(255,255,0)";
		fi
		if test $SECTORS_DIFF -gt $MAXDISK; then
			WIDTH=32
			COLOR="rgb(255,0,0)";
		fi

#		echo "<!-- $SECTORS_DIFF -->";
		echo '<rect y="'$Y'" width="'$WIDTH'" height="'$(($YSTEP-1))'" style="fill:'$COLOR';" />';
		Y=$((Y+$YSTEP))
		LINE=$(( $LINE+1 ))
	done
fi


echo "</svg>";

echo "$DATA" >$TMP

