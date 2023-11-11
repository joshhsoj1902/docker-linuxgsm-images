FROM joshhsoj1902/docker-linuxgsm-scripts:1.2.0 AS scripts
FROM gameservermanagers/gameserver:gmod@sha256:6c63badbf6387684ffa9f7918fa6b008acfab13a5f48c58e3417a2e7e5f40cfc

# Install envsubt
RUN apt-get update && apt-get install -y \
    gettext-base \
    && rm -rf /var/lib/apt/lists/*

# Override entrypoint-user to support hooks
COPY --from=scripts /entrypoint-user.sh /app/entrypoint-user.sh

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
