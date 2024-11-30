echo "Validating gomplate produces default config"

echo "sleeping for 60 seconds to allow testing server to properly start"
sleep 60

./do dockerCopyFrom testing /data/serverfiles/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini /tmp/vanilla-palworld.ini
./do dockerCopyFrom linuxgsm /data/serverfiles/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini /tmp/gomplate-palworld.cfg

diff -w --color=always --unified=3 /tmp/vanilla-palworld.ini /tmp/gomplate-palworld.cfg
