cp images/sdtd-a19/.tests/serverconfig.a19.xml rendered_serverconfig/lgsm-serverconfig.xml

gomplate -f images/sdtd-a19/layers/001-base/serverfiles/sdtdserver.xml.gomplate -o rendered_serverconfig/gomplate-serverconfig.xml

diff -w --color=always --unified=3 rendered_serverconfig/lgsm-serverconfig.xml rendered_serverconfig/gomplate-serverconfig.xml
