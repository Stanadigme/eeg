# Arduino IDE

## Install

curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh

Déjà installé 

### Test

arduino-cli

### PATH

nano ~/.bashrc

append to end of file : export PATH=$PATH:/home/pi/bin

sudo reboot

### Install core

>arduino-cli core install arduino:avr


## CLI
Arduino Command Line Interface (arduino-cli).

Usage:
  arduino-cli [command]

Examples:
  arduino-cli <command> [flags...]

Available Commands:

  board           Arduino board commands.

  burn-bootloader Upload the bootloader.

  cache           Arduino cache commands.

  compile         Compiles Arduino sketches.

  completion      Generates completion scripts

  config          Arduino configuration commands.

  core            Arduino core operations.

  daemon          Run as a daemon on port 50051

  debug           Debug Arduino sketches.

  help            Help about any command

  lib             Arduino commands about libraries.

  outdated        Lists cores and libraries that can be upgraded

  sketch          Arduino CLI sketch commands.

  update          Updates the index of cores and libraries

  upgrade         Upgrades installed cores and libraries.

  upload          Upload Arduino sketches.

  version         Shows version number of Arduino CLI.

Flags:
      --additional-urls strings   Comma-separated list of additional URLs for the Boards Manager.
      --config-file string        The custom config file (if not specified the default will be used).
      --format string             The output format, can be {text|json}. (default "text")
  -h, --help                      help for arduino-cli
      --log-file string           Path to the file where logs will be written.
      --log-format string         The output format for the logs, can be {text|json}.
      --log-level string          Messages with this level and above will be logged. Valid levels are: trace, debug, info, warn, error, fatal, panic
  -v, --verbose                   Print the logs on the standard output.

Use "arduino-cli [command] --help" for more information about a command.


## Connecting the board

### Update the available platforms and libraries

> arduino-cli core update-index

### Search for the board

> arduino-cli board list

## Librairies

### Config

### enable_unsafe_install

set to true to enable the use of the --git-url and --zip-file flags with arduino-cli lib install. These are considered "unsafe" installation methods because they allow installing files that have not passed through the Library Manager submission process.

nano ~/.arduino15/arduino-cli.yaml 

### Install

>arduino-cli lib install <library>

>arduino-cli lib install --git-url https://github.com/arduino-libraries/WiFi101.git https://github.com/arduino-libraries/ArduinoBLE.git


>arduino-cli lib install --zip-path /path/to/WiFi101.zip /path/to/ArduinoBLE.zip

_>arduino-cli lib install --zip-path ~/eeg/Brain/kitschpatrol-Brain-v1.0-6-gefc9b2b.zip_

>arduino-cli lib install --git-url https://github.com/Stanadigme/Brain.git

## Uploading

### Compile

>arduino-cli compile -b 'fbqn' {sketch}

>arduino-cli compile -b arduino:avr:uno /home/pi/eeg/Brain/examples/BrainSerialTest/BrainSerialTest.ino

### Upload
>arduino-cli upload -p /dev/ttyACM0 --fqbn arduino:samd:mkr1000 MyFirstSketch

>arduino-cli upload -p /dev/ttyACM0 --fqbn arduino:avr:uno /home/pi/eeg/Brain/examples/BrainSerialTest/BrainSerialTest.ino