#!/bin/bash
# Insert pre-install and post-install hook calls into the entrypoint-user.sh
# shipped by gameservermanagers/gameserver. The rest of that script stays upstream.

set -eu -o pipefail

target="${1:-/app/entrypoint-user.sh}"

if [ ! -f "${target}" ]; then
	echo "entrypoint not found: ${target}" >&2
	exit 1
fi

if grep -q 'execute_hook_directory' "${target}"; then
	echo "Hook calls already present in ${target}"
	exit 0
fi

pre_marker='# Install game server'
post_marker='echo -e "Starting ${GAMESERVER}"'

if ! grep -qxF "${pre_marker}" "${target}"; then
	echo "missing anchor: ${pre_marker}" >&2
	exit 1
fi
if ! grep -qxF "${post_marker}" "${target}"; then
	echo "missing anchor: ${post_marker}" >&2
	exit 1
fi

blockdir="$(mktemp -d)"
trap 'rm -rf "${blockdir}"' EXIT

cat > "${blockdir}/function" << 'EOF'
execute_hook_directory() {
	# shellcheck disable=SC2086
	for f in $1; do
		if ! bash "$f"
		then
			echo "Failed running hook \"$f\""
			exit 1
		fi
	done
}

EOF

cat > "${blockdir}/pre" << 'EOF'
# Run pre-install scripts
if [ -d "/app/hooks/pre-install" ]; then
	echo -e ""
	echo -e "Executing pre-install hooks"
	echo -e "================================="
	execute_hook_directory "/app/hooks/pre-install/*.sh"
fi

EOF

cat > "${blockdir}/post" << 'EOF'
# Run post-install scripts
if [ -d "/app/hooks/post-install" ]; then
	echo -e ""
	echo -e "Executing post-install hooks"
	echo -e "================================="
	execute_hook_directory "/app/hooks/post-install/*.sh"
fi

EOF

tmp="$(mktemp)"
awk \
	-v pre="${pre_marker}" \
	-v post="${post_marker}" \
	-v fnfile="${blockdir}/function" \
	-v prefile="${blockdir}/pre" \
	-v postfile="${blockdir}/post" \
	'
function emit(file,    line) {
	while ((getline line < file) > 0) {
		print line
	}
	close(file)
}
NR == 1 {
	print
	print ""
	emit(fnfile)
	next
}
$0 == pre && !didpre {
	emit(prefile)
	didpre = 1
}
$0 == post && !didpost {
	emit(postfile)
	didpost = 1
}
{ print }
END {
	if (!didpre || !didpost) {
		exit 2
	}
}
' "${target}" > "${tmp}"
cat "${tmp}" > "${target}"
rm -f "${tmp}"
chmod +x "${target}"
