#!/bin/bash
#supervisor -w /node/ /node/main.js
/usr/bin/nohup supervisor -w /node/ /node/main.js > /node/node.out 2>&1 & bash