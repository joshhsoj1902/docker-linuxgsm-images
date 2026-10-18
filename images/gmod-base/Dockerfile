FROM hairyhenderson/gomplate:v5.3.0@sha256:40307f53fa8d6133c5bac8264b5cb4f6ceb3ce02e1d57c33e100959967f6fd18 AS gomplate

FROM gameservermanagers/gameserver:gmod@sha256:f0fb3ff7924205822b459f908a449df53d2cfaf9381f23fd40093a138986d6f9
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
ADD scripts/scripts/auto-fastdl.sh /app/hooks/post-install/80-auto-fastdl.sh

# Setup ulib
ADD scripts/scripts/mod-install.sh /app/hooks/post-install/10-mod-install.sh
ENV LGSM_HELPER_MODS=ulib,ulx

# Setup Layers
ADD common/common.cfg.gomplate /layers/001-base/config-lgsm/gmodserver/
ADD scripts/scripts/apply-overlay.sh /app/hooks/pre-install/50-apply-overlay.sh
ADD scripts/scripts/apply-overlay.sh /app/hooks/post-install/50-apply-overlay.sh
ADD scripts/scripts/resolve-templates.sh /app/hooks/pre-install/51-resolve-templates.sh
ADD scripts/scripts/resolve-templates.sh /app/hooks/post-install/51-resolve-templates.sh
ENV LGSM_HELPER_OVERLAY_SRC=/layers
ENV LGSM_HELPER_OVERLAY_DEST=/data
ENV LGSM_HELPER_TEMPLATE_EXTENSION=.overlay-template
ENV LGSM_HELPER_GOMPLATE_EXTENSION=.gomplate
