#!/bin/bash
# Anonymous Linux installs of L4D2 app 222860 fail with "Invalid platform".
# Download the Windows depot first, then validate the Linux depot.
# https://github.com/ValveSoftware/steam-for-linux/issues/11522
# A cold SteamCMD also returns "Missing configuration" unless app info is
# printed in the same command. Skip when the dedicated server is already installed.

set -u

serverfiles="${LGSM_SERVERFILES:-/data/serverfiles}"

if [ -f "${serverfiles}/srcds_linux" ]; then
	echo "L4D2 srcds_linux already present, skipping anonymous bootstrap"
	exit 0
fi

echo "Bootstrapping L4D2 dedicated server into ${serverfiles}"
mkdir -p "${serverfiles}"

steamcmd_update() {
	platform="$1"
	validate="$2"
	# shellcheck disable=SC2086
	steamcmd \
		+@sSteamCmdForcePlatformType "${platform}" \
		+force_install_dir "${serverfiles}" \
		+login anonymous \
		+app_info_print 222860 \
		+app_update 222860 ${validate} \
		+quit || true
}

steamcmd_update windows ""
if [ ! -d "${serverfiles}/steamapps" ]; then
	echo "Windows depot did not start, retrying once"
	steamcmd_update windows ""
fi

steamcmd_update linux validate

if [ ! -f "${serverfiles}/srcds_linux" ]; then
	echo "L4D2 bootstrap did not produce srcds_linux"
	exit 1
fi

exit 0
