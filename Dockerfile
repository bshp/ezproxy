# Ocie Version, e.g 22.04 unquoted
ARG OCIE_VERSION
    
FROM bshp/ocie:${OCIE_VERSION}
    
# Ocie
ENV OCIE_CONFIG=/etc/ezproxy \
    APP_TYPE="ezproxy" \
    APP_HOME=/usr/local/ezproxy \
    WSKEY=""
    
RUN <<"EOD" bash
    set -eu;
    install -d -m 0755 -o root -g root ${APP_HOME}/config;
    install -d -m 0755 -o root -g root ${OCIE_CONFIG};
    wget --quiet --no-cookies https://help.oclc.org/@api/deki/files/9850/ezproxy-linux.bin;
    wget --quiet --no-cookies https://help.oclc.org/@api/deki/files/11977/ezproxy-linux-sha256.sum;
    OCLC_SIG=$(echo $(cat ezproxy-linux-sha256.sum | sed 's/\s.*$//') ezproxy-linux.bin | sha256sum -c | grep -o 'OK');
    if [[ -z "$OCLC_SIG" ]];then
        echo "Signature does not match";
        exit 1;
    fi;
    mv /ezproxy-linux.bin ${APP_HOME}/ezproxy;
EOD

COPY --chown=root:root --chmod=0755 ./src/ ./etc/ezproxy/
    
CMD ["/bin/bash"]
