#!/bin/bash
speedtest --simple | grep -E "Download|Upload" | tr '\n' ' ' | sed -e 's/Download://' | sed -e 's/Upload://' | sed -e 's/Mbit\/s//g'

