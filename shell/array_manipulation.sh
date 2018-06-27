#!/bin/bash

currdirectory="$(ls -d */ | sed 's/.$//')" #getting all the folders' names in a string without the '/' at the end

numberLines="$(ls -d */ | sed 's/.$//' | wc -l)" #count the number of output lines

FOLDER_NAMES=() #create the array

for (( i=1; i<=$numberLines; i++ ))

do
    echo ${i}
    echo $currdirectory | sed -n ${i}p
line="$(echo $currdirectory | sed -n ${i}p)" #adding the output of a current i line to the variable line

FOLDER_NAMES+=($line) #adding the element itself to the array

done

echo "FOLDER_NAMES: ${FOLDER_NAMES[*]}" #show array values
