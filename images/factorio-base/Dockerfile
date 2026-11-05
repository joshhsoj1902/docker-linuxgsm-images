FROM hairyhenderson/gomplate:v5.3.1@sha256:9c73c3cacc598cc9d926c67c5548901a4a4ee2223d29a2dacc910a68a5dfd684 AS gomplate

FROM gameservermanagers/gameserver:fctr@sha256:fa0d3110afef59e099982b4317348b4294643ac76afac71bf8343f8433222342
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

