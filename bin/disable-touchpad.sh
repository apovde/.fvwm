#!/bin/bash

id=$(xinput list | grep -i touchpad | sed -e 's/^.*id=//;s/\t.*$//')

xinput set-prop $id "Device Enabled" 0
