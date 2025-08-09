FROM hairyhenderson/gomplate:v4.3.3@sha256:55db623a1e3d620501fbf3ff01753cfde101d9b49fa5ff0132b4a8d0c246c16c AS gomplate

FROM gameservermanagers/gameserver:pmc@sha256:31a6976de4637a20bb0156a071139c3d595c6686a167f0f7d0c685419a67b89a
ARG IMAGE_DIR

# Upgrade java version (remove this if the base image is updated)
RUN apt-get update && sudo apt install openjdk-21-jdk -y \
    && rm -rf /var/lib/apt/lists/*

# Override entrypoint-user to support hooks
ADD scripts/entrypoints/entrypoint-user.sh /app/entrypoint-user.sh
COPY --from=gomplate /gomplate /bin/gomplate

RUN apt-get update && apt-get install -y \
    gettext-base \
    && rm -rf /var/lib/apt/lists/*

# Setup Layers
ADD common/common.cfg.gomplate /layers/001-base/config-lgsm/pmcserver/

ADD scripts/scripts/apply-overlay.sh /app/hooks/pre-install/50-apply-overlay.sh
ADD scripts/scripts/apply-overlay.sh /app/hooks/post-install/50-apply-overlay.sh
ADD scripts/scripts/resolve-templates.sh /app/hooks/pre-install/51-resolve-templates.sh
ADD scripts/scripts/resolve-templates.sh /app/hooks/post-install/51-resolve-templates.sh
ENV LGSM_HELPER_OVERLAY_SRC=/layers
ENV LGSM_HELPER_OVERLAY_DEST=/data
ENV LGSM_HELPER_TEMPLATE_EXTENSION=.overlay-template
ENV LGSM_HELPER_GOMPLATE_EXTENSION=.gomplate


# Download Plugins
ADD scripts/scripts/minecraft-install-plugins.sh /app/hooks/post-install/52-install-plugins.sh
## Set versions
ENV LGSM_MINECRAFT_PLUGIN_DYNMAP_VERSION_ID=ImNNT17B
ENV LGSM_MINECRAFT_PLUGIN_DYNMAP_VERSION=Dynmap-3.7-beta-8-spigot.jar
ENV LGSM_MINECRAFT_PLUGIN_ESSENTIALS_VERSION=2.20.1
ENV LGSM_MINECRAFT_PLUGIN_UNIFIED_METRICS_VERSION=0.3.8

# Disable auto update checks (For PaperMC the update fails resulting in the server not coming back up after the attempted update)
ENV UPDATE_CHECK=90000000
