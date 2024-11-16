FROM joshhsoj1902/docker-linuxgsm-scripts:testing AS scripts
FROM ubuntu:24.04@sha256:278628f08d4979fb9af9ead44277dbc9c92c2465922310916ad0c46ec9999295

# Install envsubt
RUN apt-get update && apt-get install --no-install-recommends -y \
    gettext-base \
    && rm -rf /var/lib/apt/lists/*

COPY --from=scripts /scripts/resolve-templates.sh /resolve-templates.sh
ENV LGSM_HELPER_OVERLAY_DEST=/data
ENV LGSM_HELPER_TEMPLATE_EXTENSION=.tmpl

RUN mkdir -p /data/serverfiles && echo "Hello \$NAME" >> /data/serverfiles/helloworld.txt.tmpl
RUN mkdir -p /data/config-lgsm && echo "Hello \$NAME" >> /data/config-lgsm/helloworld.txt.tmpl
ENV NAME=LinuxGSM
RUN ./resolve-templates.sh
RUN grep "Hello LinuxGSM" /data/serverfiles/helloworld.txt
RUN grep "Hello LinuxGSM" /data/config-lgsm/helloworld.txt
