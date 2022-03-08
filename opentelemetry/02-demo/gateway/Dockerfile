FROM scratch
COPY ./otelcol-custom /
EXPOSE 4317/tcp 55678/tcp 55679/tcp
ENTRYPOINT [ "/otelcol-custom" ]
CMD [ "--config", "/etc/otel/config.yaml" ]
