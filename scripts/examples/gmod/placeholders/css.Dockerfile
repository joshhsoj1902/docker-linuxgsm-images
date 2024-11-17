FROM joshhsoj1902/docker-linuxgsm-scripts:2.3.0@sha256:034468e8fd05ba77d5869275ce5204a3aab9b9c0dfa9f2663b6ddc2ea3b064d6 AS scripts
FROM gameservermanagers/gameserver:hl2dm

# Support running `auto-install` and exiting
COPY --from=scripts /entrypoint-user.sh /app/entrypoint-user.sh
COPY --from=scripts /entrypoint.sh /app/entrypoint.sh
