FROM hairyhenderson/gomplate:v4.3.3@sha256:55db623a1e3d620501fbf3ff01753cfde101d9b49fa5ff0132b4a8d0c246c16c AS gomplate

FROM gameservermanagers/gameserver:sf@sha256:273bdd4e7abd814ed293ecbaafc18d4c628d32249aa291573a54deca30ede9a5
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

