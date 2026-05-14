#!/bin/bash

clear

stty -echo -icanon time 0 min 0

snake=("3;5" "3;6" "3;7")
dx=0
dy=0

while true; do
	dx=0
	dy=0
	clear
	
	#for a in "${snake[@]}"; do
	#	echo ${a//;/ }
	#done
	#read -n 1 -s
	#break;

	for i in {1..50}; do
		for j in {1..50}; do

			is_snake=0
			for pos in "${snake[@]}"; do
				# Split the coordinates
				IFS=';' read -r snake_x snake_y <<< "$pos"
				
				if [[ $i -eq $snake_x && $j -eq $snake_y ]]; then
					echo -n "O"
					is_snake=1
					break
				fi
			done

			if [[ $i -eq 1 || $i -eq 50 || $j -eq 1 || $j -eq 50 ]]; then
				echo -n "#"
			else
				echo -n " "
			fi
		done
		echo
	done
	read -n 1 input
	case "$input" in
		w) dy=-1 ;;
		s) dy=1 ;;
		a) dx=-1 ;;
		d) dx=1;;
	esac
	# Get head position
	IFS=';' read -r x y <<< "${snake[0]}"
	new_head="$((x+dx));$((y+dy))"
	unset 'snake[-1]'           # Remove tail
	snake=("$new_head" "${snake[@]}")
done


