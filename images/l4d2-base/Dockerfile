FROM hairyhenderson/gomplate:v5.3.1@sha256:9c73c3cacc598cc9d926c67c5548901a4a4ee2223d29a2dacc910a68a5dfd684 AS gomplate

FROM gameservermanagers/gameserver:l4d2@sha256:82e2f5a8462fca4c17a5f03b383800adfeeea4ed42a85fd41d56a67c7072f733
ARG IMAGE_DIR

# Insert pre/post install hook calls into the base image entrypoint.
COPY scripts/inject-entrypoint-hooks.sh /tmp/inject-entrypoint-hooks.sh
RUN bash /tmp/inject-entrypoint-hooks.sh && rm /tmp/inject-entrypoint-hooks.sh
COPY --from=gomplate /gomplate /bin/gomplate

# Install envsubt
RUN apt-get update && apt-get install -y \
    gettext-base \
    && rm -rf /var/lib/apt/lists/*

# Setup FastDL
# ADD scripts/scripts/auto-fastdl.sh /app/hooks/post-install/80-auto-fastdl.sh

# # Setup ulib
# ADD scripts/scripts/mod-install.sh /app/hooks/post-install/10-mod-install.sh
# ENV LGSM_HELPER_MODS=ulib,ulx

# Anonymous app_update of 222860 fails with "Invalid platform" until the
# Windows depot has been fetched once. See scripts/scripts/l4d2-anonymous-install.sh.
ADD scripts/scripts/l4d2-anonymous-install.sh /app/hooks/pre-install/40-l4d2-anonymous-install.sh

# Setup Layers
ADD common/common.cfg.gomplate /layers/001-base/config-lgsm/l4d2server/
# Loaded after _default.cfg. Overrides querytype=protocol-valve, which gamedig 5.3 cannot query.
ADD images/l4d2-base/layers/001-base/config-lgsm/l4d2server/l4d2server.cfg.gomplate /layers/001-base/config-lgsm/l4d2server/l4d2server.cfg.gomplate

ADD scripts/scripts/apply-overlay.sh /app/hooks/pre-install/50-apply-overlay.sh
ADD scripts/scripts/apply-overlay.sh /app/hooks/post-install/50-apply-overlay.sh
ADD scripts/scripts/resolve-templates.sh /app/hooks/pre-install/51-resolve-templates.sh
ADD scripts/scripts/resolve-templates.sh /app/hooks/post-install/51-resolve-templates.sh
ENV LGSM_HELPER_OVERLAY_SRC=/layers
ENV LGSM_HELPER_OVERLAY_DEST=/data
ENV LGSM_HELPER_TEMPLATE_EXTENSION=.overlay-template
ENV LGSM_HELPER_GOMPLATE_EXTENSION=.gomplate

