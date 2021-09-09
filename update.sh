#!/bin/bash


echo ""
echo "Mise a jour"
cd "/home/pi/eeg"
git pull
cp "/home/pi/eeg/update.sh" "/home/pi/Desktop/update.sh"
cd "/home/pi/Desktop/"
chmod +x "/home/pi/Desktop/update.sh"

#Test maj 2