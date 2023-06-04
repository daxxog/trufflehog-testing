FROM trufflesecurity/trufflehog:latest as trufflehog
FROM alpine:latest
COPY --from=trufflehog /usr/bin/trufflehog /usr/bin/trufflehog
RUN apk add --no-cache git bash
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
ARG SCANNER_VERSION
ENV SCANNER_VERSION=${SCANNER_VERSION}
ARG SCANNER_ORIGIN
ENV SCANNER_ORIGIN=${SCANNER_ORIGIN}
