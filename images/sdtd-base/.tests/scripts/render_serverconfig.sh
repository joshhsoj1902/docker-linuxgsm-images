# Download current LGSM serverconfig
wget -O rendered_serverconfig/lgsm-serverconfig.xml https://raw.githubusercontent.com/GameServerManagers/Game-Server-Configs/main/sdtd/serverconfig.xml

gomplate -f images/sdtd-base/layers/001-base/serverfiles/sdtdserver.xml.gomplate -o rendered_serverconfig/gomplate-serverconfig.xml

diff -w --color=always --unified=3 rendered_serverconfig/lgsm-serverconfig.xml rendered_serverconfig/gomplate-serverconfig.xml