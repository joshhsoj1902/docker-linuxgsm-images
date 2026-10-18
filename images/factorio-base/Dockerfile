FROM hairyhenderson/gomplate:v5.3.0@sha256:40307f53fa8d6133c5bac8264b5cb4f6ceb3ce02e1d57c33e100959967f6fd18 AS gomplate

FROM gameservermanagers/gameserver:fctr@sha256:997070b64bb315f4a3477cd4c5777a7ac1d1b536449d15240a37bbc390747ff3
ARG IMAGE_DIR

# Insert pre/post install hook calls into the base image entrypoint.
COPY scripts/inject-entrypoint-hooks.sh /tmp/inject-entrypoint-hooks.sh
RUN bash /tmp/inject-entrypoint-hooks.sh && rm /tmp/inject-entrypoint-hooks.sh
COPY --from=gomplate /gomplate /bin/gomplate

# Install envsubt
RUN apt-get update && apt-get install -y \
    gettext-base \
    && rm -rf /var/lib/apt/lists/*

# Setup Layers
ADD common/common.cfg.gomplate /layers/001-base/config-lgsm/fctrserver/

ENV LGSM_HELPER_OVERLAY_SRC=/layers
ENV LGSM_HELPER_OVERLAY_DEST=/data
ENV LGSM_HELPER_TEMPLATE_EXTENSION=.overlay-template
ENV LGSM_HELPER_GOMPLATE_EXTENSION=.gomplate

