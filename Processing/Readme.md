# Processing

## Install
curl https://processing.org/download/install-arm.sh | sudo sh
--> not working

Alternative

wget https://github.com/processing/processing/releases/download/processing-0269-3.5.3/processing-3.5.3-linux-armv6hf.tgz -P /home/pi/

mkdir /home/pi/processing

tar -xzvf /home/pi/processing-3.5.3-linux-armv6hf.tgz -C /home/pi/processing

# Usage

>cd processing

>cd processing-3.5.3/

>./processing

## CLI

### RPi (Mac?)

>DISPLAY=:0 ./processing-java --sketch=/home/pi/HelloWorld --present

>DISPLAY=:0 /home/pi/processing/processing-3.5.3/processing-java --sketch=/home/pi/eeg/BrainGrapher --present

> DISPLAY=:0 /home/pi/processing/processing-3.5.3/processing-java --sketch=/home/pi/eeg/Interfaces --present

### Windows
>C:\Users\Stan\Downloads\processing-4.0b1-windows64\processing-4.0b1\processing-java --sketch=C:\Users\Stan\Projects\eeg\Interfaces --run