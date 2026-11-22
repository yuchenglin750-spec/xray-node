# Fetch the xray binary (multi-stage build)
FROM alpine:latest AS fetch
RUN apk add --no-cache curl unzip
RUN TAG=$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases/latest | grep '"tag_name":' | cut -d'"' -f4) \
    && echo "xray version: ${TAG}" \
    && curl -L -o /tmp/xray.zip "https://github.com/XTLS/Xray-core/releases/download/${TAG}/Xray-linux-64.zip" \
    && unzip /tmp/xray.zip -d /tmp/xray \
    && chmod +x /tmp/xray/xray

# Runtime image
FROM alpine:latest
RUN apk add --no-cache ca-certificates
COPY --from=fetch /tmp/xray/xray /usr/local/bin/xray
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
