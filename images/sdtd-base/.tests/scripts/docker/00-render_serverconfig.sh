mkdir -p /tmp/gomplate/

export LGSM_SERVER_NAME="My Game Host"

gomplate -f /layers/001-base/serverfiles/sdtdserver.xml.gomplate -o /tmp/gomplate/gomplate-serverconfig.xml

diff -w --color=always --unified=3 /data/serverfiles/serverconfig.xml /tmp/gomplate//gomplate-serverconfig.xml

echo "hello world"