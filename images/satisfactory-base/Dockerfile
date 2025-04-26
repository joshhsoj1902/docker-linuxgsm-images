FROM hairyhenderson/gomplate:v4.3.2@sha256:c46e772f2577a63b39a05ed1c3a8bb0c03986ea1a37a105349b4093e76decb90 AS gomplate

FROM gameservermanagers/gameserver:sf@sha256:94b5eb9c35c402cef4e819901af8e86dee705207c402e97bd9f2114d24365581
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

