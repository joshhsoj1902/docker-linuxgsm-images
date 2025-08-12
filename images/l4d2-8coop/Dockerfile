FROM hairyhenderson/gomplate:v4.3.0@sha256:5e24d79d00b99d22ac248473ac09dc3a06f41024ca78d6905650057f296206cb AS gomplate

# https://forums.alliedmods.net/showthread.php?t=39439
FROM ubuntu@sha256:7c06e91f61fa88c08cc74f7e1b7c69ae24910d745357e0dfe1d2c0322aaf20f9 AS stripper
ADD http://www.bailopan.net/stripper/snapshots/1.2/stripper-1.2.2-git141-linux.tar.gz stripper.tar.gz
RUN tar -zxvf stripper.tar.gz

# https://github.com/fbef0102/l4dtoolz/releases
FROM kubeless/unzip:latest@sha256:e867f9b366ffb1a25f14baf83438db426ced4f7add56137b7300d32507229b5a AS l4dtoolz
# renovate: datasource=github-tags depName=fbef0102/l4dtoolz versioning=semver-coerced
# ENV L4DTOOLZ_VERSION=1.0.0.2
# ADD https://github.com/fbef0102/l4dtoolz/releases/download/$L4DTOOLZ_VERSION/l4dtoolz-l4d2-linux.zip l4dtoolz.zip
# RUN unzip l4dtoolz.zip

# The github downloading worked fine, until the maintainer deleted the previous tag. I can't easily figure out what changed and
# I don't have time right now to test the new release. so for now I'm using a copy of the previous tag I had downloaded.
ARG IMAGE_DIR
ADD images/$IMAGE_DIR/l4dtools /

# https://github.com/SilvDev/Left4DHooks
FROM bitnami/git@sha256:cad8593b904daf66e2d83454440be2052bcb6f19d2ce87d2db5a0b1beef63331 AS left4dhooks
RUN git clone https://github.com/SilvDev/Left4DHooks.git

# https://github.com/fbef0102/L4D1_2-Plugins/tree/master
FROM bitnami/git@sha256:cad8593b904daf66e2d83454440be2052bcb6f19d2ce87d2db5a0b1beef63331 AS l4dplugins
RUN git clone https://github.com/fbef0102/L4D1_2-Plugins.git

# https://github.com/fbef0102/L4D2-Plugins/tree/master
FROM bitnami/git@sha256:cad8593b904daf66e2d83454440be2052bcb6f19d2ce87d2db5a0b1beef63331 AS l4d2plugins
RUN git clone https://github.com/fbef0102/L4D2-Plugins.git

# https://github.com/LuxLuma/Left-4-fix
FROM bitnami/git@sha256:cad8593b904daf66e2d83454440be2052bcb6f19d2ce87d2db5a0b1beef63331 AS left4fix
RUN git clone https://github.com/LuxLuma/Left-4-fix.git

# https://github.com/Target5150/MoYu_Server_Stupid_Plugins
FROM bitnami/git@sha256:cad8593b904daf66e2d83454440be2052bcb6f19d2ce87d2db5a0b1beef63331 AS moyo
RUN git clone https://github.com/Target5150/MoYu_Server_Stupid_Plugins.git

# https://github.com/fbef0102/L4D1_2-Plugins/releases/tag/Multi-Colors
FROM kubeless/unzip:latest@sha256:e867f9b366ffb1a25f14baf83438db426ced4f7add56137b7300d32507229b5a AS multicolors
ADD https://github.com/fbef0102/L4D1_2-Plugins/releases/download/Multi-Colors/multicolors.zip multicolors.zip
RUN unzip multicolors.zip

# https://github.com/nosoop/SMExt-SourceScramble
FROM ubuntu@sha256:7c06e91f61fa88c08cc74f7e1b7c69ae24910d745357e0dfe1d2c0322aaf20f9 AS sourcescramble
# renovate: datasource=github-tags depName=fbef0102/l4dtoolz versioning=semver-coerced
ENV SOURCESCRAMBLE_VERSION=0.7.1.4
ADD https://github.com/nosoop/SMExt-SourceScramble/releases/download/$SOURCESCRAMBLE_VERSION/package.tar.gz package.tar.gz
RUN tar -zxvf package.tar.gz

# Discord logger
FROM bitnami/git@sha256:cad8593b904daf66e2d83454440be2052bcb6f19d2ce87d2db5a0b1beef63331 AS discord
RUN git clone https://github.com/Mbk10201/Discord_loggerv2.git

FROM gameservermanagers/gameserver:l4d2@sha256:c0879f0c343eb0e75215e8f0bf0225aba23df31ffaddd7b4affc29e9653f27ca
ARG IMAGE_DIR

# Override entrypoint-user to support hooks
COPY scripts/entrypoints/entrypoint-user.sh /app/entrypoint-user.sh
COPY --from=gomplate /gomplate /bin/gomplate

# Install envsubt
RUN apt-get update && apt-get install -y \
    gettext-base \
    && rm -rf /var/lib/apt/lists/*

COPY --from=stripper /addons /layers/stripper/serverfiles/left4dead2/addons
COPY --from=l4dtoolz /addons /layers/l4dtoolz/serverfiles/left4dead2/addons
COPY --from=left4dhooks /Left4DHooks/sourcemod /layers/l4dtoolz/serverfiles/left4dead2/addons/sourcemod

COPY --from=multicolors /scripting /layers/multicolors/serverfiles/left4dead2/addons/sourcemod/scripting

COPY --from=sourcescramble addons /layers/multicolors/serverfiles/left4dead2/addons

COPY --from=l4dplugins /L4D1_2-Plugins/l4dmultislots /layers/l4dtoolz/serverfiles/left4dead2/addons/sourcemod
COPY --from=l4dplugins /L4D1_2-Plugins/l4dafkfix_deadbot /layers/l4dtoolz/serverfiles/left4dead2/addons/sourcemod

COPY --from=l4d2plugins /L4D2-Plugins/lfd_both_fixUpgradePack /layers/l4dtoolz/serverfiles/left4dead2/addons/sourcemod

COPY --from=discord /Discord_loggerv2/ /layers/discordlogger/serverfiles/left4dead2/addons/sourcemod

COPY --from=left4fix ["/Left-4-fix/left 4 fix/Defib_Fix", "/layers/l4dtoolz/serverfiles/left4dead2/addons/sourcemod"]
COPY --from=left4fix ["/Left-4-fix/left 4 fix/survivors/survivor_afk_fix", "/layers/l4dtoolz/serverfiles/left4dead2/addons/sourcemod"]
COPY --from=left4fix ["/Left-4-fix/left 4 fix/charger/Charger_Collision_patch", "/layers/l4dtoolz/serverfiles/left4dead2/addons/sourcemod"]
COPY --from=left4fix ["/Left-4-fix/left 4 fix/witch/witch_target_patch", "/layers/l4dtoolz/serverfiles/left4dead2/addons/sourcemod"]

COPY --from=moyo ["/MoYu_Server_Stupid_Plugins/The Last Stand/l4d2_fix_changelevel/l4d2_fix_changelevel.smx", "/layers/l4dtoolz/serverfiles/left4dead2/addons/sourcemod/plugins"]
COPY --from=moyo ["/MoYu_Server_Stupid_Plugins/The Last Stand/l4d2_fix_changelevel/l4d2_fix_changelevel.txt", "/layers/l4dtoolz/serverfiles/left4dead2/addons/sourcemod/gamedata"]


# COPY --from=unrar /addons /layers/8coop/serverfiles/left4dead2/addons
# COPY --from=unrar /cfg /layers/8coop/serverfiles/left4dead2/cfg

# RUN rm -rf /layers/8coop/serverfiles/left4dead2/addons/metamod_x64.vdf
# RUN rm -rf /layers/8coop/serverfiles/left4dead2/addons/metamod/bin/win64
# RUN sed 's/win64/linux/' /layers/8coop/serverfiles/left4dead2/addons/metamod_x64/bin/win64

# COPY --from=unrar /addons/stripper /data/serverfiles/left4dead2/addons/stipper
# COPY --from=unrar /cfg /data/serverfiles/left4dead2/cfg

# COPY --from=unrar /addons/metamod/l4dtoolz.vdf /data/serverfiles/left4dead2/addons/metamod/l4dtoolz.vdf
# COPY --from=unrar /addons/metamod/stripper.vdf /data/serverfiles/left4dead2/addons/metamod/stripper.vdf


# Setup FastDL
# COPY --from=scripts /scripts/auto-fastdl.sh /app/hooks/post-install/80-auto-fastdl.sh

# Setup metamod & sourcemod
ADD scripts/scripts/mod-install.sh /app/hooks/post-install/10-mod-install.sh
ENV LGSM_HELPER_MODS=metamodsource,sourcemod

# Setup Layers
ADD images/$IMAGE_DIR/layers /layers
ADD common/common.cfg.gomplate /layers/001-base/config-lgsm/l4d2server/

ADD scripts/scripts/apply-overlay.sh /app/hooks/pre-install/50-apply-overlay.sh
ADD scripts/scripts/apply-overlay.sh /app/hooks/post-install/50-apply-overlay.sh
ADD scripts/scripts/resolve-templates.sh /app/hooks/pre-install/51-resolve-templates.sh
ADD scripts/scripts/resolve-templates.sh /app/hooks/post-install/51-resolve-templates.sh
ENV LGSM_HELPER_OVERLAY_SRC=/layers
ENV LGSM_HELPER_OVERLAY_DEST=/data
ENV LGSM_HELPER_TEMPLATE_EXTENSION=.overlay-template
ENV LGSM_HELPER_GOMPLATE_EXTENSION=.gomplate

