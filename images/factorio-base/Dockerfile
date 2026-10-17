FROM hairyhenderson/gomplate:v5.2.0@sha256:991ce1b8a1307fa32f9b8050a7b339697464664236cfddb1c4079df4aa5f1cd4 AS gomplate

FROM gameservermanagers/gameserver:fctr@sha256:ca95fd89892a7dcdfa881c4611817284a959fe03ae93a9c6c1d3add9d5eafe2f
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

