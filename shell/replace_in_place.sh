#!/bin/bash

# Replace a string in a file "in place"

if [ ! -d '/tmp' ]; then
    echo "There should be a /tmp directory, please."
    exit -1
fi

if [ "$#" -ne 3 ]; then
    echo "Illegal number of parameters - give file, from string and to string (2 args)"
    exit -1
fi

filename=$1
from_string=$2
to_string=$3

TFILE="/tmp/repl-$$.tmp"
echo "Writing to ${TFILE}"

TMPERR=$(mktemp)
echo "if there are errors, they will be in ${TMPERR}"
sed "s/${from_string}/${to_string}/g" ${filename} > ${TFILE} 2>${TMPERR}

sed_exit=$?
if [ ${sed_exit} -eq 1 ]; then
    echo "Your sed patterns are too complex for this script, sorry. Your error is:"
    cat ${TMPERR}
    exit -1;
fi

echo "Sed exit with $?"
cp ${TFILE} ${filename}



