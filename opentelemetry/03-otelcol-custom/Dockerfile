FROM scratch
COPY ./zoneinfo.zip /
COPY ./otelcol-custom /
COPY ./config.yaml /etc/otel/config.yaml
EXPOSE 4317/tcp 55678/tcp 55679/tcp
ENV ZONEINFO=/zoneinfo.zip
ENV TZ=Asia/Shanghai
ENTRYPOINT [ "/otelcol-custom" ]
CMD [ "--config", "/etc/otel/config.yaml" ]
