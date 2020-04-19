#!/bin/bash
downicon=
upicon=祝
speedtest --simple | grep -E "Download|Upload" | tr '\n' ' ' | sed -e "s/Download\:/$downicon/" | sed -e "s/Upload\:/$upicon/" | sed -e 's/Mbit\/s//g' | sed -e 's/^[[:space:]]*//'

