raspbian-wizard
===================
Simple bash script to automatically create fresh Raspbian Lite device (USB, memory card, etc.) for Raspberry Pi.

Created to enhance Your experience with Your brand new Raspberry Pi (and because i'm lazy and i've destroyed
few instances of my OS with my experiments and i had to recreate it from scratch many times).

Usage
-----

Script will download recent version of Raspbian Jessie Lite (or use cache) from [raspberrypi.org](https://www.raspberrypi.org/downloads/raspbian/),
check checksum and guide You step by step.


```
$ ./raspbian-wizard.sh
Raspbian Wizard - Raspberry PI node creator, version 0.0.1
Copyright (C) 2011-2016 Gabor Wnuk
License: MIT

[   >>    ]: Downloading Raspbian Jessie Lite ...
[   OK    ]: b78bb50bdac5ec8c108f34104f788e214ac23635 checksum match https://www.raspberrypi.org/downloads/raspbian/ .
[   >>    ]: Inflate /tmp/rjl.zip file ...
[   OK    ]: Inflated Raspbian image to /tmp/2016-03-18-raspbian-jessie-lite.img.

[   >>    ]: We will list all devices You can use. NOTHING TO WORRY FOR NOW.
[   >>    ]: Insert device You want install Raspbian on and press ENTER to continue, or CTRL+C to abort.

[   >>    ]: Available devices:
/dev/disk1     233Gi  143Gi   89Gi    62% 37642372 23342970   62%   /
[   >>    ]: Device to use [i.e. /dev/disk4, NOT /dev/disk4s1]: /dev/bleble

[ WARNING ]: Device /dev/bleble will be used. ALL DATA ON THIS DEVICE WILL BE LOST.
[ WARNING ]: From now on process will be mostly automated.
[ WARNING ]: Press ENTER to continue, or CTRL+C to abort.

Password:
[ WARNING ]: Writing system image to /dev/bleble - this will take few (10-15) minutes (CTRL+T for progress).
```

Contribution
-----

Feel free to fork and create merge requests. This script was created on OSX, should work on any UNIX,
however i could't be bothered to check. If You want to fix anything - be my guest!
