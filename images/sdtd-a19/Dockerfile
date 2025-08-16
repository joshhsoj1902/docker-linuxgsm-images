FROM hairyhenderson/gomplate:v4.3.0@sha256:5e24d79d00b99d22ac248473ac09dc3a06f41024ca78d6905650057f296206cb AS gomplate

FROM gameservermanagers/gameserver:sdtd@sha256:6138cf9b27b2fe5d35c3a95adcd8df5e672ec38097fe6976d24dee2a91dba165
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