#!/bin/bash

echo '<?xml version="1.0" encoding="UTF-8" standalone="no"?><svg version="1.1" viewBox="0 0 32 32" xmlns="http://www.w3.org/2000/svg">';
TEMPS=`cat \`find /sys/devices/ -iname 'temp1_input'\``;
MAXTEMP=60000
WARNTEMP=50000
MAXTEMP10=$(($MAXTEMP/1000))
TEMPSCOUNT=0
for TEMP in $TEMPS; do
	TEMPSCOUNT=$(($TEMPSCOUNT+1))
done
YSTEP=$((32000/$TEMPSCOUNT/1000))
Y=0
for TEMP in $TEMPS; do
	WIDTH=$(($TEMP/$MAXTEMP10*32/1000))
	COLOR="rgb(0,255,0)";
	if test $TEMP -gt $WARNTEMP; then
		COLOR="rgb(255,255,0)";
	fi
	if test $TEMP -gt $MAXTEMP; then
		WIDTH=32
		COLOR="rgb(255,0,0)";
	fi

	echo '<rect y="'$Y'" width="'$WIDTH'" height="'$(($YSTEP-1))'" style="fill:'$COLOR';" />';
	Y=$((Y+$YSTEP))
done

echo "</svg>";


