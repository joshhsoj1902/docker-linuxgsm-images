FROM hairyhenderson/gomplate:v4.2.0@sha256:20af20cf82a5b8c14572f756af1ab89d25a42da33823b8eddbe058d60398927f AS gomplate

FROM gameservermanagers/gameserver:sdtd@sha256:7ca052f50d65db8ea665f19109cee70a90d91e4f2990227b57a16c3f8a840adf
ARG IMAGE_DIR

# Override entrypoint-user to support hooks
ADD scripts/entrypoints/entrypoint-user.sh /app/entrypoint-user.sh
COPY --from=gomplate /gomplate /bin/gomplate

# Install envsubt
RUN apt-get update && apt-get install -y \
    gettext-base \
    && rm -rf /var/lib/apt/lists/*

# Setup Layers
ADD images/$IMAGE_DIR/layers /layers
ADD common/common.cfg.gomplate /layers/001-base/config-lgsm/sdtdserver/

ADD scripts/scripts/apply-overlay.sh /app/hooks/pre-install/50-apply-overlay.sh
ADD scripts/scripts/apply-overlay.sh /app/hooks/post-install/50-apply-overlay.sh
ADD scripts/scripts/resolve-templates.sh /app/hooks/pre-install/51-resolve-templates.sh
ADD scripts/scripts/resolve-templates.sh /app/hooks/post-install/51-resolve-templates.sh
ENV LGSM_HELPER_GOMPLATE_EXTENSION=.gomplate
ENV LGSM_HELPER_OVERLAY_SRC=/layers
ENV LGSM_HELPER_OVERLAY_DEST=/data
ENV LGSM_HELPER_TEMPLATE_EXTENSION=.overlay-template


# ENV LGSM_GAME_WORLD=RNG
# ENV LGSM_GAME_NAME="My Game"
# https://steamdb.info/app/251570/depots/
ENV LGSM_SERVER_BRANCH=alpha19.6