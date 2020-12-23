#!/bin/sh

#
# 23 december 2020
#
# Automatic install script ::
# Installs Camilladsp & GUI on piCore / piCorePlayer v6.10 / etc...
#
# Files installed ::
#
# - camilladsp v0.5.0-beta2      https://github.com/Lykkedk/SuperPlayer_Camilladsp/archive/v0.5.0-beta-2.zip
# - pycamilladsp v0.5.0          https://github.com/HEnquist/pycamilladsp/archive/v0.5.0.zip
# - pycamilladsp-plot v0.4.3     https://github.com/HEnquist/pycamilladsp-plot/archive/v0.4.3.zip
# - camillagui-backend v0.6.0    https://github.com/HEnquist/camillagui-backend/releases/download/v0.6.0/camillagui.zip
# - Websocket & Six              https://github.com/Lykkedk/SuperPlayer_Websocket/archive/v1.0.zip
# - StartServer.sh               https://github.com/Lykkedk/SuperPlayer-Extensions/archive/CamillaGUI-start-v1.0.zip

RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m'

# Download locations for the packages ::
get_camilladsp="https://github.com/Lykkedk/SuperPlayer_Camilladsp/archive/v0.5.0-beta-2.zip"
get_pycamilladsp="https://github.com/HEnquist/pycamilladsp/archive/v0.5.0.zip"
get_pycamilladsp_plot="https://github.com/HEnquist/pycamilladsp-plot/archive/v0.4.3.zip"
get_camillagui="https://github.com/HEnquist/camillagui-backend/releases/download/v0.6.0/camillagui.zip"
get_websocket="https://github.com/Lykkedk/SuperPlayer_Websocket/archive/v1.0.zip"
get_startscript="https://github.com/Lykkedk/SuperPlayer-Extensions/archive/CamillaGUI-start-v1.0.zip"

# .Zip name / version
zip_camilladsp=v0.5.0-beta-2.zip
zip_pycamilladsp=v0.5.0.zip
zip_pycamilladsp_plot=v0.4.3.zip
zip_camillagui=camillagui.zip
zip_websocket=v1.0.zip
zip_startscript=CamillaGUI-start-v1.0.zip

# Directory name when unzipped
zipdir_camilladsp=SuperPlayer_Camilladsp-0.5.0-beta-2
zipdir_websocket=SuperPlayer_Websocket-1.0
zipdir_pycamilladsp=pycamilladsp-0.5.0
zipdir_pycamilladsp_plot=pycamilladsp-plot-0.4.3
zipdir_startscript=SuperPlayer-Extensions-CamillaGUI-start-v1.0
zipdir_camillagui=none # Camillagui is not extracted into directory

extensions=/mnt/mmcblk0p2/tce/Camilla_Extensions
camilladsp=$extensions/camilladsp
websocket=$extensions/websocket
pycamilladsp=$extensions/pycamilladsp
pycamilladsp_plot=$extensions/pycamilladsp_plot
camillagui=$extensions/camillagui
startscript=$extensions/startscript

# Remove old extensions
echo
if [ -d "$extensions" ]; then
  rm -fr $extensions
  echo -e "${GREEN}Old extensions... found & removed... ${NC}Continue..."
else
  echo -e "${GREEN}None old extensions found... ${NC}Continue..."
fi
sleep 2

# Create needed directories
su tc -c "mkdir -p $camilladsp"
su tc -c "mkdir -p $websocket"
su tc -c "mkdir -p $pycamilladsp"
su tc -c "mkdir -p $pycamilladsp_plot"
su tc -c "mkdir -p $camillagui"
su tc -c "mkdir -p $startscript"

# Must be run as SuperUser (Root)
if [[ "$USER" != 'root' && "$1" != "status" ]] ; then
echo
echo -e "${RED}This script must be run as root, or with sudo.${NC}"
echo
exit
fi

echo
echo -e "${GREEN}Start installation...${NC}"
echo
sleep 2

# Load needed tools
su tc -c "tce-load -wo compiletc.tcz"
su tc -c "tce-load -wo python3.6-dev"
su tc -c "tce-load -i compiletc.tcz"
su tc -c "tce-load -i python3.6-dev"

echo
echo -e "${GREEN}--- Install python libraries${NC}"
sudo -H pip3 install setuptools
sudo -H pip3 install aiohttp
sleep 2

echo
echo -e "${GREEN}--- Download camilladsp${NC}"
cd $camilladsp
su tc -c "wget $get_camilladsp"
echo -e "${GREEN}--- Uncompress camilladsp-$zip_camilladsp${NC}"
su tc -c "unzip $zip_camilladsp"
su tc -c "cp -f $camilladsp/$zipdir_camilladsp/camilladsp.tcz /mnt/mmcblk0p2/tce/optional"
sleep 2

echo
echo -e "${GREEN}--- Download Websocket & Six Python${NC}"
cd $websocket
su tc -c "wget $get_websocket"
echo -e "${GREEN}--- Uncompress Websocket & Six Python .tcz's${NC}"
su tc -c "unzip $zip_websocket"
su tc -c "cp -f $websocket/$zipdir_websocket/py_websocket.tcz /mnt/mmcblk0p2/tce/optional"
su tc -c "cp -f $websocket/$zipdir_websocket/py_six.tcz /mnt/mmcblk0p2/tce/optional"
su tc -c "cp -f $websocket/$zipdir_websocket/py_websocket.tcz.dep /mnt/mmcblk0p2/tce/optional"

echo
echo -e "${GREEN}--- Download pycamilladsp${NC}"
cd $pycamilladsp
su tc -c "wget $get_pycamilladsp"
echo -e "${GREEN}--- Uncompress pycamilladsp${NC}"
su tc -c "unzip $zip_pycamilladsp"
cd $pycamilladsp/$zipdir_pycamilladsp
echo -e "${GREEN}--- Install pycamilladsp${NC}"
sudo -H pip3 install .

echo
echo -e "${GREEN}--- Download pycamilladsp-plot${NC}"
cd $pycamilladsp_plot
su tc -c "wget $get_pycamilladsp_plot"
echo -e "${GREEN}--- Uncompress pycamilladsp-plot${NC}"
su tc -c "unzip $zip_pycamilladsp_plot"
cd $pycamilladsp_plot/$zipdir_pycamilladsp_plot
echo -e "${GREEN}--- Install pycamilladsp-plot${NC}"
sudo -H pip3 install .

echo
echo -e "${GREEN}--- Download Camillagui${NC}"
cd $camillagui
su tc -c "wget $get_camillagui"
echo -e "${GREEN}--- Uncompress Camillagui${NC}"
su tc -c "unzip $zip_camillagui"

echo
echo -e "${GREEN}--- Download SuperPlayer extensions v1.0${NC}"
cd $startscript
su tc -c "wget $get_startscript"
su tc -c "unzip $zip_startscript"
cd $startscript/$zipdir_startscript
chmod +x $startscript/$zipdir_startscript/StartServer.sh
chown tc:staff $startscript/$zipdir_startscript/StartServer.sh
su tc -c "cp -f $startscript/$zipdir_startscript/StartServer.sh /home/tc"

echo
echo -e "${GREEN}--- IMPORTANT! ${NC}py_websocket.tcz ${GREEN}& ${NC}camilladsp.tcz ${GREEN}must be included in /mnt/mmcblk0p2/tce/onboot.lst :${NC}"
echo -e "${GREEN}--- File${NC} /mnt/mmcblk0p2/tce/onboot.lst :"
cat /mnt/mmcblk0p2/tce/onboot.lst
echo -e "${GREEN}-------------------------------------------------------------------------------------------${NC}"
echo
read -r -s -p $'Press enter to continue...\n'

echo
echo -e "${GREEN}--- IMPORTANT! ${NC}usr/local/lib/python3.6/site-packages ${GREEN}must be included in /opt/.filetool.lst${NC}"
echo -e "${GREEN}--- File /opt/.filetool.lst ::${NC}"
cat /opt/.filetool.lst
echo -e "${GREEN}-------------------------------------------------------------------------------------------${NC}"
echo

read -r -s -p $'Press enter to continue...\n'

echo -e "${GREEN}For automatic start the GUI backend, place this line in ${NC}/opt/bootlocal.sh ${GREEN}::${NC}"
echo
echo -e "${NC}/home/tc/StartServer.sh${NC}"
echo
echo -e "${GREEN}Remember to execute ${NC}sudo filetool.sh -b ${GREEN}for saving the changes${NC}"
echo -e "${GREEN}-------------------------------------------------------------------------------------------${NC}"
sleep 2
echo
echo -e "${NC}Install done!${NC}"
echo
exit








