FROM joshhsoj1902/docker-linuxgsm-scripts:testing AS scripts
FROM ubuntu:24.04@sha256:278628f08d4979fb9af9ead44277dbc9c92c2465922310916ad0c46ec9999295

COPY --from=scripts /scripts/apply-overlay.sh /apply-overlay.sh
ENV LGSM_HELPER_OVERLAY_SRC=/layers
ENV LGSM_HELPER_OVERLAY_DEST=/data
COPY layers /layers

RUN mkdir -p /data && echo "foo" >> /data/helloworld.txt
RUN ./apply-overlay.sh
RUN grep bar /data/helloworld.txt
