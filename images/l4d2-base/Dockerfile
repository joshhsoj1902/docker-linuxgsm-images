FROM hairyhenderson/gomplate:v4.2.0@sha256:20af20cf82a5b8c14572f756af1ab89d25a42da33823b8eddbe058d60398927f AS gomplate

FROM gameservermanagers/gameserver:l4d2@sha256:8900a6952c1f2294b1316a7c3a9a70e33cb2ff93c78537ea1bbedf7deae2bef3
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

