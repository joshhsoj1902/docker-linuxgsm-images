FROM joshhsoj1902/docker-linuxgsm-scripts:1.5.0 AS scripts
FROM hairyhenderson/gomplate:v3.11.7 AS gomplate

FROM gameservermanagers/gameserver:pmc@sha256:c644a23bf1a2a01825a78723f26e8fcacdbf2510a0d18efa5dbb94bf6deeb898

# Upgrade java version (remove this if the base image is updated)
RUN apt-get update && sudo apt install openjdk-21-jdk -y \
    && rm -rf /var/lib/apt/lists/*

# Override entrypoint-user to support hooks
COPY --from=scripts /entrypoint-user.sh /app/entrypoint-user.sh
COPY --from=gomplate /gomplate /bin/gomplate

RUN apt-get update && apt-get install -y \
    gettext-base \
    && rm -rf /var/lib/apt/lists/*

# Setup Layers
COPY --from=scripts /scripts/apply-overlay.sh /app/hooks/pre-install/50-apply-overlay.sh
COPY --from=scripts /scripts/apply-overlay.sh /app/hooks/post-install/50-apply-overlay.sh
COPY --from=scripts /scripts/resolve-templates.sh /app/hooks/pre-install/51-resolve-templates.sh
COPY --from=scripts /scripts/resolve-templates.sh /app/hooks/post-install/51-resolve-templates.sh
ENV LGSM_HELPER_OVERLAY_SRC=/layers
ENV LGSM_HELPER_OVERLAY_DEST=/data
ENV LGSM_HELPER_TEMPLATE_EXTENSION=.overlay-template
ENV LGSM_HELPER_GOMPLATE_EXTENSION=.gomplate


# Download Plugins
COPY --from=scripts /scripts/minecraft-install-plugins.sh /app/hooks/post-install/52-install-plugins.sh
## Set versions
ENV LGSM_MINECRAFT_PLUGIN_DYNMAP_VERSION_ID=UXqPUg7D
ENV LGSM_MINECRAFT_PLUGIN_DYNMAP_VERSION=Dynmap-3.7-beta-2-spigot.jar
ENV LGSM_MINECRAFT_PLUGIN_ESSENTIALS_VERSION=2.20.1
ENV LGSM_MINECRAFT_PLUGIN_UNIFIED_METRICS_VERSION=0.3.8

# Disable auto update checks (For PaperMC the update fails resulting in the server not coming back up after the attempted update)
ENV UPDATE_CHECK=90000000
