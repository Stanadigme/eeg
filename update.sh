#!/bin/bash


echo ""
echo "Mise a jour"
cd "/home/pi/eeg"
git pull
cp "/home/pi/eeg/update.sh" "/home/pi/Desktop/update.sh"
cp "/home/pi/eeg/launch.sh" "/home/pi/Desktop/launch.sh"

cd "/home/pi/Desktop/"
chmod +x "/home/pi/Desktop/update.sh"
chmod +x "/home/pi/Desktop/launch.sh"

