#!/bin/bash 
for file in ~/\.*
do
    if [ -h $file ]; then
        if [ $(dirname $(readlink -f $file)) = $(pwd) ]; then
            rm $file;
        fi;
    fi
done
