FROM adaptris/interlok-base:latest-zulu-alpine

EXPOSE 8080 5555

ARG java_tool_opts
ENV JAVA_TOOL_OPTIONS=$java_tool_opts

COPY builder /root/builder

WORKDIR /opt/interlok

RUN cd /root/builder && \
    chmod +x /root/builder/gradlew && \
    rm -rf /opt/interlok/docs && \
    ./gradlew --no-daemon installDist && \
    chmod +x /docker-entrypoint.sh && \
    rm -rf /root/.gradle && \
    rm -rf /root/builder

# Since config is a volume; gradlew installDist changes to the
# config directory will be discarded; so let's add it
# via docker
# COPY  builder/src/main/interlok/config /opt/interlok/config

ENV JAVA_TOOL_OPTIONS=""

