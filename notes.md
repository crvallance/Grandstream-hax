# General notes

## Stuff Done

* Cracked open case with phillips head screw under warranty sticker on the back and then used spludger tool to open
* Removed solder from serial header
* Soldered pins to serial header
* Monitored serial port with 115200 baud using a TTL level USB serial adapt
* Tried to send commands to serial without any luck
* Interupted boot by bridging pins 5&6 on the flash chip and got request for xmodem upload
* Tried to upload dumped firmware with xmodem
* Interupted boot by bridging pins 5&6 on the flash chip during boot and was unable to get uboot shell
* Dumped flash with CH341A (`flashrom -p ch341a_spi -r firmware.bin`) after lifting pin 8 (vcc)
* Fixed endian-ness of flash dump with `objcopy -I binary -O binary --reverse-bytes=4 inputfile.bin outputfile.bin`
* Used `binwalk -Me` to extract filesystem
* Re-flashed original firmware after issues and using the `-f` force flag seems to push through problems