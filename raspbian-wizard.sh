#!/bin/bash
#
# Raspbian Wizard - Raspberry PI node creator
#
# Copyright (c) 2016 Gabor Wnuk
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

BASE_DIRECTORY="${PWD}"
TMP_DIRECTORY=`mktemp -d -t wrk`
VERSION="0.0.1"

#
# Helpers
#
print_info() {
    echo -e "[   >>    ]: ${1}"
}

print_read() {
    echo -n "[   >>    ]: ${1}"
}

print_ok() {
    echo -e "[ \033[32m  OK   \033[0m ]: ${1}"
}

print_error() {
    echo -e "[ \033[31m ERROR \033[0m ]: ${1}"
}

print_warning() {
    echo -e "[ \033[33mWARNING\033[0m ]: ${1}"
}

show_info() {
    echo "Raspbian Wizard - Raspberry PI node creator, version ${VERSION}"
    echo "Copyright (C) 2011-"`date +%Y`" Gabor Wnuk"
    echo "License: MIT"
    echo
}

show_info

print_info "Downloading Raspbian Jessie Lite ..."
RASPBIAN_FILE=/tmp/rjl.zip

if [ ! -f ${RASPBIAN_FILE} ]; then
    curl -L --url https://downloads.raspberrypi.org/raspbian_lite_latest --output ${RASPBIAN_FILE}
fi

RASPBIAN_FILE_SHA=`shasum -a 256 ${RASPBIAN_FILE} | cut -d" " -f1`
RASPBIAN_FILE_SHA_VALIDATION=`curl -s https://www.raspberrypi.org/downloads/raspbian/ 2>/dev/null | grep -o "<strong>${RASPBIAN_FILE_SHA}</strong>"`

if [ -z ${RASPBIAN_FILE_SHA_VALIDATION} ]; then
    print_error "${RASPBIAN_FILE_SHA} checksum doesn't match https://www.raspberrypi.org/downloads/raspbian/ ."
    print_error "Remove ${RASPBIAN_FILE} file and try again."
    exit 2
else
    print_ok "${RASPBIAN_FILE_SHA} checksum match https://www.raspberrypi.org/downloads/raspbian/ ."
fi

print_info "Inflate ${RASPBIAN_FILE} file ..."
RASPBIAN_IMG_FILE=`unzip -o ${RASPBIAN_FILE} -d /tmp/ | grep inflating | cut -d":" -f2`
RASPBIAN_IMG_FILE=`echo ${RASPBIAN_IMG_FILE} | xargs`

print_ok "Inflated Raspbian image to ${RASPBIAN_IMG_FILE}."
echo
print_info "We will list all devices You can use. NOTHING TO WORRY FOR NOW."
print_info "Insert device You want install Raspbian on and press ENTER to continue, or CTRL+C to abort."
read -p ""

print_info "Available devices:"
df -h | grep /dev/

while true;
do
	print_read "Device to use [i.e. /dev/disk4, NOT /dev/disk4s1]: "
	read DEVICE

	if [ ! -z "${DEVICE}" ]; then
		break
	fi

	print_error "Device name cannot be empty."
done

echo
print_warning "Device ${DEVICE} will be used. ALL DATA ON THIS DEVICE WILL BE LOST."
print_warning "From now on process will be mostly automated."
print_warning "Press ENTER to continue, or CTRL+C to abort."
read -p ""

for n in ${DEVICE}* ; do sudo umount -f $n 2>/dev/null ; done

print_warning "Writing system image to ${DEVICE} - this will take few (10-15) minutes (CTRL+T for progress)."
sudo dd bs=4m if=${RASPBIAN_IMG_FILE} of=${DEVICE}
if [ $? -eq 0 ]; then
    print_ok "${RASPBIAN_IMG_FILE} image successfully written."
else
    print_error "Failed to write ${RASPBIAN_IMG_FILE} image to ${DEVICE} device."
    print_error "If this message appeared immediately, check, if device isn't write"
    print_error "protected."
    exit 2
fi

