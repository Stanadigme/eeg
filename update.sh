#!/bin/bash


echo ""
echo "Mise a jour"
cd "/home/pi/eeg"
git pull
cp ./update.sh ~/Desktop/update.sh
cd ~/Desktop/
chmod +x ./update.sh

#Test maj