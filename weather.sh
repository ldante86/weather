#!/bin/bash -
#
# SCRIPT: weather.sh
# AUTHOR: Luciano D. Cecere
########################################################################
#
# weather.sh - Get temperature for location from wttr.in
# Copyright (C) 2016 Luciano D. Cecere <ldante86@aol.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
########################################################################

PROGRAM="${0##*/}"

LOCATION="$1"
FLAG="$2"
WEATHER="wttr.in/${LOCATION}"
LYNX="lynx"

HELP="\
  Usage: $PROGRAM location [OPTION]
  Report temperature for location

	-f	show forcast
	-t	show temperature
	-h	show this help and exit

  A location can be a zip code or a name.
  If is name is multiple words, link them with
  underscores.
"

case $LOCATION in
	-h|--help)
		echo "$HELP"
		exit 0
		;;
	'')
		printf "\n%s\n\n" " ----No location specified."
		echo "$HELP"
		exit 1
		;;
esac

if [ $(which $LYNX) >/dev/null ]; then
	LYNX="lynx -source"
else
	echo $LYNX is not installed
	exit 1
fi

_get_current_weather()
{
	echo "$PAGE_DATA" | grep -A 6 'Weather for' | sed 's/<\/\?[^>]\+>//g'
}

_get_current_temperature()
{
	_get_current_weather | grep 'F' | tr -d 'a-zA-Z-&_\/;\(\),.° '
}

_get_forcast()
{
	echo "$PAGE_DATA" | grep -A 9 '  ┌─────────────┐  ' | sed 's/<\/\?[^>]\+>//g'
}

PAGE_DATA=$($LYNX $WEATHER)

case $FLAG in
	-f)	_get_forcast ;;
	-t)	_get_current_temperature ;;
	 *)	_get_current_weather ;;
esac
