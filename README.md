Ariadne Bootloader for Arduino
==========
Make a donation to the original Ariadne developer: [![PayPal donate button](http://img.shields.io/paypal/donate.png?color=yellow)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=6RBAQPJ77X9BG "Make a one-time donation to the original Ariadne bootloader developer using Paypal")

Ariadne Bootloader implements a TFTP server on the [Arduino](http://arduino.cc) board to allow uploading sketches to boards with a W5100 Ethernet controller attached using any TFTP client. This bootloader also supports the standard serial upload method.


## Downloading and Installing Files
There are two ways to install Ariadne:

#### Manual Installation
* Download the Ariadne files here: https://github.com/per1234/Ariadne-Bootloader/archive/ariadne.zip
* Extract the .zip file.
* Rename the extracted folder **ariadne**.
* Move the folder into the **hardware** folder in your sketchbook folder.
* If you are using Arduino IDE 1.0.x then move the folders under **[sketchbook]/hardware/ariadne/libraries** to your **[sketchbook]/libraries** folder
* If the Arduino IDE is running then restart it.

<a id="boardsmanager"></a>
#### Boards Manager Installation
This installation method requires Arduino IDE version 1.6.4 or greater.
* Open the Arduino IDE.
* Open the **File > Preferences** menu item.
* Enter the following URL in **Additional Boards Manager URLs**: https://per1234.github.io/Ariadne-Bootloader/package_codebendercc_ariadne-bootloader_index.json
* Open the **Tools > Board > Boards Manager...** menu item.
* Wait for the platform indexes to finish downloading.
* Scroll down until you see the **Ariadne Bootloader** entry and click on it.
  * **Note**: If you are using Arduino IDE 1.6.6 then you may need to close **Boards Manager** and then reopen it before the **Ariadne Bootloader** entry will appear.
* Click **Install**.
* After installation is complete close the **Boards Manager** window.


## Additional Boards
The file **more-boards.txt** contains alternate boards.txt entries for different configurations. To add any of these entries to your **Board** menu copy the entry to **boards.txt** and restart the Arduino IDE if it is running.

### 8MHz
Use these entries for boards without an external 16MHz crystal or to reduce power consumption.

### Other ATmega1284P pinouts
The default ATmega1284P Board uses the avr-developers.com pinout(ariadne/variants/avr_developers/pins_arduino.h) but there are entries for other ATmega1284P based boards including:
* [Mighty 1284P](https://maniacbug.wordpress.com/2011/11/27/arduino-on-atmega1284p-4)
* [Mighty Mini 1284P](https://github.com/JChristensen/mini1284)
* [Bobuino](http://crossroadsfencing.com/BobuinoRev17/index.html)
* [Skinny Bob](http://embeddedcoolness.com/shop/rfx-1284p-devdep-board-w-prototyping-area-nrf24l01-headers-kit)
* [Sleeping Beauty](http://www.firebirduino.com/sleeping_beauty)
* [Goldilocks](www.freetronics.com.au/products/goldilocks-arduino-compatible-with-atmega1284p-mcu)

These entries require the installation of the [Mighty 1284P core](https://github.com/JChristensen/mighty-1284p/tree/v1.6.3).

### Debug
The debug entries print bootloader information to the serial monitor at 115200 baud.


<a id="menus"></a>
## Using the Board Menu Entries
After installing Ariadne several new boards are added to the **Ariadne** section of the **Tools** > **Board** menu. Using Arduino IDE v1.5+ when any of these boards are selected additional menus will appear under the **Tools** menu which may include:

### Model Menu
Displays a list of board models for your **Board** menu selection.

### Clock Menu
The bootloader must be reburned whenever the clock setting is changed.
* **Low Power** - This is usually the best setting to use for commercially produced boards that run at 16MHz as it will decrease power usage compared to the **16MHz Full Swing** setting.
* **16MHz Full Swing** - This setting can be used for breadboard or homemade 16MHz boards where the **16MHz Low Power** setting causes unreliability due to electrical interference.
* **8MHz Internal** - For boards without an external 16MHz crystal or to reduce power consumption.

### Board Configuration Menu
* **Ethernet Shield** - If an Ethernet Shield is connected to your board Ariadne sets Arduino pin 4 HIGH to disable the SD card reader. If your board doesn't have SD card hardware installed then chose a **No Ethernet Shield** option.
* **Blink** - Blink the LED connected to Arduino pin 13(pin 9 on Arduino Ethernet) to indicate bootloader operation. Select a **No Blink** option if there is something else connected to the LED pin and you don't want Ariadne to change the pin state.


<a id="hardware"></a>
## Hardware
Once the Ariadne bootloader is burned to your Arduino the W5100 Ethernet controller must be attached for your Arduino to work, even when using serial upload.
Ariadne assumes:
* W5100 SS pin is connected to Arduino pin 10
* **Ethernet Shield** type **Board Configuration** menu entries: SD card SS is connected to pin 4
* **Blink** type **Board Configuration** menu entries: LED connected on pin 13(pin 9 on Arduino Ethernet).


<a id="burn"></a>
## Burning the Bootloader
To burn the bootloader, you will need an ISP(in-system programmer) such as:
* [USBasp](http://www.ebay.com/sch/i.html?_nkw=usbasp&_sop=15)
* [USBtinyISP](https://learn.adafruit.com/usbtinyisp)
* [Arduino as ISP](http://arduino.cc/en/Tutorial/ArduinoISP)
* [Atmega_Board_Programmer](http://www.gammon.com.au/forum/?id=11635)

After you have connected the Arduino board and the programmer to your computer launch the Arduino IDE. Navigate to the **Tools** > **Board** menu and select the Ariadne version of your board. Then go to **Tools** > **Programmer** and select the programmer you are using. In case you are using **Arduino as ISP**, make sure that the selected port in the **Tools** > **Serial Port** menu refers to the **Arduino as ISP** board and not the board that you want to burn the bootloader on. Now, just launch the **Tools** > **Burn Bootloader** command and wait for the operation to complete.

In the case of **Arduino Mega** not all ISPs will work. To install the bootloader in these boards you will need a compatible ISP such as the [USBasp](http://www.ebay.com/sch/i.html?_nkw=usbasp&_sop=15)(has a "verification error" in Arduino IDE 1.0.x but still works), [Olimex AVR-ISP-MK2](https://www.olimex.com/Products/AVR/Programmers/AVR-ISP-MK2), or [Atmel AVRISP mkII](http://www.digikey.com/product-detail/en/ATAVRISP2/ATAVRISP2-ND)(Mega compatible but [may not work with recent versions of the Arduino IDE](https://github.com/arduino/Arduino/issues/2986) but there is a [fix](https://github.com/per1234/Arduino-AVRISPmkII-fix)). Nick Gammon's excellent [Atmega_Board_Programmer](http://www.gammon.com.au/forum/?id=11635) has been reported to work for flashing **Ariadne** on **Arduino Mega**.


<a id="serial"></a>
## Serial Flashing
Ariadne bootloader supports flashing through serial like any other regular bootloader. Just plug in the USB cable and select the serial port and the appropriate board from the **Tools** > **Board** menu. Then click the upload button. If you are using an Ethernet Shield or module it must be connected to your Arduino to be able to upload a sketch even when using USB.

After a succesful flashing,

* **Arduino Duemilanove** will automatically start the program.
* **Arduino Uno** and **Mega** will do a reset cycle and start the program after the bootloader times out.

This happens because **Uno** and **Mega** have an autoreset feature that resets the board after a serial connection.

Due to the fact that "autoreset" for remote tftp programming is implemented using a watchdog timer timeout, the bootloader will do a full cycle after every reset, physical or software.


<a id="defaultnetworksettings"></a>
## Default Network Settings
The default network settings of the bootloader are listed below:
* IP Address: 192.168.1.128
* Subnet Mask: 255.255.255.0
* Gateway: 192.168.1.1
* MAC Address: 0xDE.0xAD.0xBE.0xEF.0xFE.0xED
* TFTP Negotiation Port: 69
* TFTP Data Port: 46969

**NOTE:** The Arduino Ethernet that were sent as Indiegogo Perks were flashed with different network settings. Their bootloader still defaults to the previous settings but the current values are on the accompaning leaflet.


<a id="networkconfig"></a>
## Configuring Network Settings
These can be changed using our **NetEEPROM** library. Navigate to **File** > **Examples** > **NetEEPROM** and select one of the examples. You can write the network settings with the **WriteNetworkSettings** sketch or print them to the serial monitor with **ReadNetworkSettings**. Follow the instructions in the comments of the sketches.

The network settings are saved to EEPROM so you need to make sure that you don't overwrite them in your program. Ariadne uses EEPROM addresses 0-26 for network settings and 27-63 for the password used in the **EthernetReset** library. If you're not using **EthernetReset** then you can use EEPROM addresses 27-63 for other purposes. The **NewEEPROM** library can be used instead of the EEPROM library to automatically avoid overwriting the Ariadne EEPROM section.


<a id="tftp"></a>
## TFTP Flashing
Now for the real reason we made this bootloader and why you should use it. You can watch **Ariadne** in action in this how-to video for remote flashing using TFTP [here](http://youtu.be/KCHqhV6xPMg). In the video you may notice that the board is being reset by hand but the **EthernetReset** library included with Ariadne provides an example of how you can do the reset remotely through a simple web server with some security measures.

### Converting your sketch to the right format
Unlike serial flashing that uses HEX files to flash the Arduino, the TFTP server implemented in the bootloader works with binary files. This means that you have to manually convert your programs to the right format. To do that, first set **File** > **Preferences** > **Show verbose output during compilation**(check) in the Arduino IDE and then click the **Verify** button. This will convert your sketch into a .hex file located in a temporary folder. The location of the temporary folder is printed in the last line of the compilation output.
For example:
```
C:\Program Files (x86)\Arduino\hardware\tools\avr/bin/avr-objcopy -O ihex -R .eeprom C:\Users\username\AppData\Local\Temp\build4255864821845399166.tmp/sketch/Blink.cpp.elf C:\Users\username\AppData\Local\Temp\build4255864821845399166.tmp/sketch/Blink.cpp.hex
```
Enter the directory and make sure that there is a `.elf` or a `.hex` file with the same name as your sketch. That is the file you need to convert. To achieve that you have to run the following command in a terminal:
```
avr-objcopy -I ihex [sketch].hex -O binary [sketch].bin`
```
In Windows and MacOS you can find the `avr-objcopy` program in your Arduino IDE installation folder under `hardware/tools/avr/bin/`.

Another option if you have scons installed, is to use the modified `SConstruct` script you can find at https://github.com/suapapa/arscons. This being based on the *arscons* script, it can be used in two ways:
- If you used the previous process to generate the HEX file you can just copy the `SConstruct` file inside the temporary *Arduino IDE* build directory (as mentioned above) and run `scons` in a terminal inside that directory.
- The other way to use it is to copy the `SConstruct` script inside the sketch's directory and, as above, run `scons` in a terminal inside that directory. This way you will build your project outside *Arduino IDE* creating the `.bin` file in the process. Note that this way the sketch's folder will be polluted with Arduino's build files, much like the temporary directory *Arduino IDE* uses.

For testing purposes you can find a **blink** sketch in binary form inside the `Ariadne-Bootloader/extras/blink` folder. The **fail** sketch in the `Ariadne-Bootloader/extras/fail` folder will give you a view of what a failed upload looks like. This sketch fails because it is written in plain **C** and not in **Arduino**. That way it lacks some "signatures" the bootloader uses to validate Arduino sketches.

### Using a tftp client to upload the sketch
Now that the binary is ready, you have to upload it. The upload procedure is as follows:
- Reset the Arduino board. This will activate the bootloader. If a valid program is already uploaded to the Arduino then there is only a **5 second** window that the upload can begin(indicated by the rapidly blinking LED. If the upload has not began withing 5 seconds of reset the previously installed program will run. If no valid program has previously been uploaded to the board it will stay in bootloader mode indefinitely.
- Start the upload using your TFTP client.
- If the upload is successful then the newly uploaded program will run. If the TFTP client fails to connect then the previously uploaded program will run. If the upload started but was not successfully completed the board will stay in bootloader mode waiting for a new upload.

#### TFTP client

All three major operating systems have their own clients that you can use through the command line.

##### Windows
The **TFTP client** may not be enabled in Windows by default. To enable it check **Control Panel > Programs and Features > Turn Windows features on or off > TFTP Client(check) > OK**.

`C:\>tftp -i 192.168.1.128 PUT sketch.bin`


##### Linux
On some **Linux** distributions, like **Fedora/RedHat**, before you use `tftp`, you should load the `ip_conntrack_tftp` module or the tftp client won't be able to acknowledge(**ACK**) the incoming packets. That is needed because TFTP is insecure and it is not enabled by default. Other distributions like **Arch**, don't need this step. To do that, open a terminal and run:
```
modprobe ip_conntrack_tftp
```
as **root** using `su` or `sudo`.

After that open a terminal as a regular user and type
```
tftp [ip] [port]
```

For the default bootloader settings that would be:
```
tftp 192.168.1.128 69
```
In this case it could just be `tftp 192.168.1.128` as **69** is the default tftp port and the client would automatically connect to it. For any other port you have to explicitly set it.

Now you should have been greeted by the
```
tftp>
```
prompt.

First you have to enter this command:
```
tftp> mode octet
```
This way you tell the **TFTP** client to send binary data. This is absolutely needed as if your client is in netascii mode, uploading will fail. After this, it is advised to use the two following commands to make the process more informative so you can have a better view of what is happening, but they are not needed.
```
tftp> trace
tftp> verbose
```
Now to actually upload the binary file all you have to do is **reset** the board and in the next **5
seconds** run the following command.
```
tftp> put [sketch].bin
```
Now you should see your tftp client sending packets and the indication LED blinking. A correct output sample of the TFTP client uploading the *blink* sketch is below:
```
tftp> mode octet
tftp> trace
Trace mode on.
tftp> verbose
Verbose mode on.
tftp> put blink.bin
sent WRQ <file: blink.bin, mode: octet <>>
received ACK <block: 0>
sent DATA <block: 1, size: 512>
received ACK <block: 1>
sent DATA <block: 2, size: 512>
received ACK <block: 2>
sent DATA <block: 3, size: 512>
received ACK <block: 3>
sent DATA <block: 4, size: 512>
received ACK <block: 4>
sent DATA <block: 5, size: 42>
received ACK <block: 5>
tftp>
```
In case that for some reason the upload fails, first of all stop your TFTP client from sending any more packets. After that you should wait for the upload process on the bootloader to timeout. That takes about **5 seconds** too. For this period you should witness the indication led doing some random blinking. After the timeout and since there is no valid program in the memory, the TFTP server should restart itself and wait for a new upload.


<a id="router"></a>
## Configuring your Router for Remote Flashing
If you are having trouble flashing your Arduino at home from the road, you probably need to enable [port forwarding](http://en.wikipedia.org/wiki/Port_forwarding). You need to forward ports **69** and **46969** to your Arduino in your router's configuration. In case you have changed the incoming data port from **46969** to another port i.e. **50232**, you have to forward **50232** port instead of **46969**. This is particularly useful when you have more than one Arduinos, that you want to flash, behind your router. In addition to this you are going to have to translate an external port of your choice on the router to the internal port and ip of the Arduino in the local network.

An example is that you have 2 devices, one at `192.168.1.128` and one at `192.168.1.129`. They both listen to port **69** for the initial connection. In this case you can translate external port **6969**(any random port will do) on your router to `192.168.1.128:69` and external port **6970** to `192.168.1.129:69` and specify these in the tftp client you are using.

Port Forward has [excellent guides](http://portforward.com/english/routers/port_forwarding) on how to enable port forwarding for a vast number of routers.


<a id="troubleshooting"></a>
## Troubleshooting
* Serial uploading doesn't work.
  * The W5100 must be connected even for serial uploading.
* TFTP times out when I try to upload a file larger than 32KB but smaller files upload fine.
  * Make sure the gateway value in your network settings is correct.
* The timing of things like delay() are wrong.
  * You must **Burn Bootloader** every time you change the **Clock** settings.


## Codebender
One of the best and easiest ways to use this bootloader is along with [codebender.cc](http://codebender.cc). Just register, enter your Arduino's IP(external IP for those in corporate or home networks behind NAT) and flash.


<a id="libraries"></a>
## Helper Libraries
* [NetEEPROM](https://github.com/per1234/Ariadne-Bootloader/tree/master/libraries/NetEEPROM) (Library to set or display the network settings of the bootloader)
* [NewEEPROM](https://github.com/per1234/Ariadne-Bootloader/tree/master/libraries/NewEEPROM) (Patched EEPROM library to protect the memory space used by the bootloader)
* [EthernetReset](https://github.com/per1234/Ariadne-Bootloader/tree/master/libraries/EthernetReset) (Library used to create an HTTP server on the Arduino to enable remote resetting of the microcontroller)


<a id="supported"></a>
## Supported Boards
Supported MCUs:
* **ATmega328P**
* **ATmega2560**
* **ATmega1284P**

Supported Ethernet controllers:
* **WIZnet W5100**

Tested Arduino Boards:
* [Arduino Ethernet](http://www.arduino.cc/en/Main/ArduinoBoardEthernet)
* [Arduino UNO](http://www.arduino.cc/en/Main/ArduinoBoardUno)
* [Arduino Duemilanove w/ ATmega328](http://www.arduino.cc/en/Main/ArduinoBoardDuemilanove)
* [Arduino Mega 2560](http://arduino.cc/en/Main/arduinoBoardMega2560)


## Other Tested Boards
These boards have been also tested and found to be working with Ariadne Bootloader. I don't have any of these so a big ***thank you*** goes to the people that took their time to test them. If you have successfully used Ariadne with a board not on the list please submit an issue or pull request and I'll add it.
* [ITead Studio IBoard](http://imall.iteadstudio.com/im120410001.html)
* [Sparkfun Ethernet Pro](https://www.sparkfun.com/products/10536)


## Donors [![PayPal donate button](http://img.shields.io/paypal/donate.png?color=yellow)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=6RBAQPJ77X9BG "Make a one-time donation to the original Ariadne bootloader developer using Paypal")
**Hachi Manzur** (AVRISP mkII programmer, testing)

If you feel that you should be in this list, please [contact me via email](https://github.com/codebendercc).


<a id="ackhowledgements"></a>
## Acknowledgements
**Ariadne** is built upon some great open source projects:
* [TFTP-Bootloader](https://github.com/arduino/TFTP-Bootloader) (The base of this project) - Unfinished attempt by an Arduino developer.
* [Optiboot](https://github.com/Optiboot/optiboot) (Serial flashing for **ATmega328**)
* [Arduino-stk500v2-bootloader](https://github.com/msproul/Arduino-stk500v2-bootloader) (Serial flashing for **ATmega2560**)
* [Mighty 1284P](https://github.com/JChristensen/mighty-1284p) (ATmega1284P pins_arduino.h written by [David A. Mellis](https://github.com/damellis))
* [SEM-bootloader](https://github.com/arjenhiemstra/SEM-Bootloader) (ATmega1284P support)

Credit should also go to [mharizanov](https://github.com/mharizanov) for commenting some of the initial *Arduino* code, making it easy for me to start and [follower](https://github.com/follower) whose sketches served as a starting point for the included **NetEEPROM** and **EthernetReset** libraries.


<a id="license"></a>
## License
This is free software and it is released under the [GPLv2, GNU General Public License](https://www.gnu.org/licenses/gpl-2.0.html)
