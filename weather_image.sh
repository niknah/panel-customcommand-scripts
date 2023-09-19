#!/bin/bash

#echo '<?xml version="1.0" encoding="UTF-8" standalone="no"?><svg version="1.1" viewBox="0 0 128 128" xmlns="http://www.w3.org/2000/svg">';
SVGDIR="$0-svg"


LOCATION=`curl -s http://ip-api.com/json/`
LAT=`echo "$LOCATION" | jq -r .lat`
LNG=`echo "$LOCATION" | jq -r .lon`
TIMEZONE=`echo "$LOCATION" | jq -r .timezone`

DAYS=1
DAY_NTH=0

if test `date +%H` -gt 18; then
	DAYS=2
	DAY_NTH=1
fi

FORECAST=`curl -s "https://api.open-meteo.com/v1/forecast?latitude=$LAT&longitude=$LNG&daily=temperature_2m_min,temperature_2m_max,rain_sum,showers_sum&forecast_days=$DAYS&timezone=$TIMEZONE"`;

RAIN=`echo "$FORECAST" | jq -r .daily.rain_sum[$DAY_NTH]`
SHOWERS=`echo "$FORECAST" | jq -r .daily.showers_sum[$DAY_NTH]`
RAIN=${RAIN/\./}
SHOWERS=${SHOWERS/\./}


if test $RAIN -gt 0; then
	cat "$SVGDIR/sun.svg";
elif test $SHOWERS -gt 0; then
	cat "$SVGDIR/showers.svg";
else
	cat "$SVGDIR/sun.svg";
fi


#echo "</svg>";

