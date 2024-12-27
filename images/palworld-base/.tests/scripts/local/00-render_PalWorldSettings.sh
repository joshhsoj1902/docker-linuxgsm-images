SUDO=''
if [[ $EUID != 0 ]] && [[ "$USER" != "gha" ]]; then
    SUDO='sudo'
fi

echo "Validating gomplate produces default config"

echo "sleeping for 60 seconds to allow testing server to properly start"
sleep 60

./do dockerCopyFrom testing /data/serverfiles/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini /tmp/vanilla-palworld-worldsettings.ini
./do dockerCopyFrom linuxgsm /data/serverfiles/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini /tmp/gomplate-palworld-worldsettings.cfg
diff -w --color=always --unified=3 /tmp/vanilla-palworld-worldsettings.ini /tmp/gomplate-palworld-worldsettings.cfg

./do dockerCopyFrom testing /data/serverfiles/Pal/Saved/Config/LinuxServer/GameUserSettings.ini /tmp/vanilla-palworld-usersettings.ini
./do dockerCopyFrom linuxgsm /data/serverfiles/Pal/Saved/Config/LinuxServer/GameUserSettings.ini /tmp/gomplate-palworld-usersettings.cfg
$SUDO sed -i "s/DedicatedServerName=.*/DedicatedServerName=22AD4EA497F14EE4800AF1108166863B/g" /tmp/vanilla-palworld-usersettings.ini
diff -w --color=always --unified=3 /tmp/vanilla-palworld-usersettings.ini /tmp/gomplate-palworld-usersettings.cfg