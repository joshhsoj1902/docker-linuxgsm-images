FROM joshhsoj1902/docker-linuxgsm-scripts:1.3.0 AS scripts
FROM hairyhenderson/gomplate:v3.11.6 AS gomplate

FROM gameservermanagers/gameserver:gmod@sha256:17847b6a832a6b46a5884b734a71250fcb6a135207a8e914c3843a5f60af48b8

# Override entrypoint-user to support hooks
COPY --from=scripts /entrypoint-user.sh /app/entrypoint-user.sh
COPY --from=gomplate /gomplate /bin/gomplate

# Install envsubt
RUN apt-get update && apt-get install -y \
    gettext-base \
    && rm -rf /var/lib/apt/lists/*

# Setup FastDL
COPY --from=scripts /scripts/auto-fastdl.sh /app/hooks/post-install/80-auto-fastdl.sh

# Setup ulib
COPY --from=scripts /scripts/mod-install.sh /app/hooks/post-install/10-mod-install.sh
ENV LGSM_HELPER_MODS=ulib,ulx

# Setup Layers
COPY --from=scripts /scripts/apply-overlay.sh /app/hooks/pre-install/50-apply-overlay.sh
COPY --from=scripts /scripts/apply-overlay.sh /app/hooks/post-install/50-apply-overlay.sh
COPY --from=scripts /scripts/resolve-templates.sh /app/hooks/pre-install/51-resolve-templates.sh
COPY --from=scripts /scripts/resolve-templates.sh /app/hooks/post-install/51-resolve-templates.sh
ENV LGSM_HELPER_OVERLAY_SRC=/layers
ENV LGSM_HELPER_OVERLAY_DEST=/data
ENV LGSM_HELPER_TEMPLATE_EXTENSION=.overlay-template
ENV LGSM_HELPER_GOMPLATE_EXTENSION=.gomplate

