FROM hairyhenderson/gomplate:v5.3.1@sha256:9c73c3cacc598cc9d926c67c5548901a4a4ee2223d29a2dacc910a68a5dfd684 AS gomplate

FROM gameservermanagers/gameserver:sdtd@sha256:50bf1041f54547c8c483e348b19c137af9077b915956aa1a7592ddea3410cc92
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
# V1 track: last published V1 branch on the dedicated server app.
# https://steamdb.info/app/294420/depots/
ENV LGSM_SERVER_BRANCH=v1.4