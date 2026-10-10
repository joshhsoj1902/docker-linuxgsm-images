FROM hairyhenderson/gomplate:v4.3.3@sha256:55db623a1e3d620501fbf3ff01753cfde101d9b49fa5ff0132b4a8d0c246c16c AS gomplate

FROM gameservermanagers/gameserver:l4d2@sha256:241ab5d5d1536453ae000bcd00997f2dfe18fccc7d6bd5e688134d6ba8627519
ARG IMAGE_DIR

# Override entrypoint-user to support hooks
ADD scripts/entrypoints/entrypoint-user.sh /app/entrypoint-user.sh
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

ADD scripts/scripts/apply-overlay.sh /app/hooks/pre-install/50-apply-overlay.sh
ADD scripts/scripts/apply-overlay.sh /app/hooks/post-install/50-apply-overlay.sh
ADD scripts/scripts/resolve-templates.sh /app/hooks/pre-install/51-resolve-templates.sh
ADD scripts/scripts/resolve-templates.sh /app/hooks/post-install/51-resolve-templates.sh
ENV LGSM_HELPER_OVERLAY_SRC=/layers
ENV LGSM_HELPER_OVERLAY_DEST=/data
ENV LGSM_HELPER_TEMPLATE_EXTENSION=.overlay-template
ENV LGSM_HELPER_GOMPLATE_EXTENSION=.gomplate

