#!/bin/bash

path="$1"
path="${path//\\//}"

if [[ $path =~ ^[A-Za-z]:/ ]]; then
    drive="${path:0:1}"
    drive="/mnt/${drive,,}"
    path="${path:2}"
    path="$drive$path"
elif [[ $path =~ ^[A-Za-z]: ]]; then
    drive="${path:0:1}"
    path="/mnt/${drive,,}"
fi

echo "$path"
