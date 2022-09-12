#!/bin/sh
notefile="$HOME/.note"

function highlight() {
	declare -A fg_color_map
	fg_color_map[black]=30
	fg_color_map[red]=31
	fg_color_map[green]=32
	fg_color_map[yellow]=33
	fg_color_map[blue]=34
	fg_color_map[magenta]=35
	fg_color_map[cyan]=36
	 
	fg_c=$(echo -e "\e[1;${fg_color_map[$1]}m")
	c_rs=$'\e[0m'
	sed -u s"/$2/$fg_c\0$c_rs/g"
}

print_help() {
	echo "-h help
-e edit file
-n new note
-t list of tags
-c cat all notes or search if \$@ exist"
}

case "$1" in
	-h|--help|-help)
		print_help ;
		exit
		;;
	-e|--edit|-edit)
		$EDITOR $notefile;
		exit
		;;
	-n|--new|-new)
		shift ;
		echo "$@" >> $notefile ;
		;;
	-t|--tag|-tag)
		grep -o "[#:][[:alnum:]]\+" $notefile |
		sort -u | sed 's/^[#:]//' ;
		;;
	-c|--cat|-cat)
		shift ; 
		if [ -z "$@" ] ; then	
			nl -w1 "$notefile" | highlight green "[#:][[:alnum:]]\+"  | highlight red "http[^ <]*"
		else
			grep_list=$(echo "$@" | sed 's/ / | grep -i /g;s/^/grep -i /;s/[#:]/[#:]/g')
			hl_list=$(echo "$@" | sed 's/ / | highlight yellow /g;s/^/highlight yellow /;s/[#:]/[#:]/g')
			nl -w1 "$notefile" | eval "$grep_list"  | highlight green "[#:][[:alnum:]]\+"  | highlight red "http[^ <]*" | eval "$hl_list"
		fi
		;;
esac


