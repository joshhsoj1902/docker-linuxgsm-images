FROM joshhsoj1902/docker-linuxgsm-scripts:1.1.0 AS scripts
FROM gameservermanagers/gameserver:pmc@sha256:74b423ea36ff2bea624f301604cffdcf1a1a22eb351b1a713827a530cf9e07d1

RUN apt-get update && apt-get install -y \
    gettext-base \
    && rm -rf /var/lib/apt/lists/*

# Override entrypoint-user to support hooks
COPY --from=scripts /entrypoint-user.sh /app/entrypoint-user.sh

# Setup Layers
COPY --from=scripts /scripts/apply-overlay.sh /app/hooks/pre-install/50-apply-overlay.sh
COPY --from=scripts /scripts/apply-overlay.sh /app/hooks/post-install/50-apply-overlay.sh
COPY --from=scripts /scripts/resolve-templates.sh /app/hooks/pre-install/51-resolve-templates.sh
COPY --from=scripts /scripts/resolve-templates.sh /app/hooks/post-install/51-resolve-templates.sh
ENV LGSM_HELPER_OVERLAY_SRC=/layers
ENV LGSM_HELPER_OVERLAY_DEST=/data
ENV LGSM_HELPER_TEMPLATE_EXTENSION=.overlay-template

# Download Plugins
COPY --from=scripts /scripts/minecraft-install-plugins.sh /app/hooks/post-install/52-install-plugins.sh
## Set versions
ENV LGSM_MINECRAFT_PLUGIN_DYNMAP_VERSION_ID=UXqPUg7D
ENV LGSM_MINECRAFT_PLUGIN_DYNMAP_VERSION=Dynmap-3.7-beta-2-spigot.jar
ENV LGSM_MINECRAFT_PLUGIN_ESSENTIALS_VERSION=2.20.1
ENV LGSM_MINECRAFT_PLUGIN_UNIFIED_METRICS_VERSION=0.3.8
