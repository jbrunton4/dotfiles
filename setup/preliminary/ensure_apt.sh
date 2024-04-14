#!/bin/bash

if command -v apt-get &>/dev/null
then
    : # pass
else
    echo "The installation process requires apt. Please run in an environment where apt is available."
    exit 1
fi