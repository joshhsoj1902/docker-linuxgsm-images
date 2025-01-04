FROM hairyhenderson/gomplate:v4.3.0@sha256:5e24d79d00b99d22ac248473ac09dc3a06f41024ca78d6905650057f296206cb AS gomplate

FROM gameservermanagers/gameserver:sf@sha256:ce1e1a49fe5ce87788f19d43e4e7720ba42d91f92c840888bf63416c22937347
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

