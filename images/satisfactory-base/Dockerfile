FROM hairyhenderson/gomplate:v4.2.0@sha256:20af20cf82a5b8c14572f756af1ab89d25a42da33823b8eddbe058d60398927f AS gomplate

FROM gameservermanagers/gameserver:sf@sha256:83a4f8fd92f7e91c49c5d60e0c01fab7df46165884bf1ba37a56878327735170
ARG IMAGE_DIR

# Override entrypoint-user to support hooks
ADD scripts/entrypoints/entrypoint-user.sh /app/entrypoint-user.sh
COPY --from=gomplate /gomplate /bin/gomplate

# Install envsubt
RUN apt-get update && apt-get install -y \
    gettext-base \
    && rm -rf /var/lib/apt/lists/*

# Setup Layers
ADD common/common.cfg.gomplate /layers/001-base/config-lgsm/sfserver/

ENV LGSM_HELPER_OVERLAY_SRC=/layers
ENV LGSM_HELPER_OVERLAY_DEST=/data
ENV LGSM_HELPER_TEMPLATE_EXTENSION=.overlay-template
ENV LGSM_HELPER_GOMPLATE_EXTENSION=.gomplate

