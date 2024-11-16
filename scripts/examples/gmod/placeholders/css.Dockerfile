FROM joshhsoj1902/docker-linuxgsm-scripts:1.5.0@sha256:f6f6b93c810fbea409fc8a7e7eb2b4a93ff20e7cf89ab8f7e0a8e291914b6b43 AS scripts
FROM gameservermanagers/gameserver:hl2dm

# Support running `auto-install` and exiting
COPY --from=scripts /entrypoint-user.sh /app/entrypoint-user.sh
COPY --from=scripts /entrypoint.sh /app/entrypoint.sh
