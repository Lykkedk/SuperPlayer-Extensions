#!/bin/sh
# Script to start the CamillaDSP server  192.168.1.XX:5000 (with correct IP address)

su tc -c "/usr/local/bin/python3 /mnt/mmcblk0p2/tce/Camilla_Extensions/camillagui/main.py" &

exit
