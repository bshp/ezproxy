# Ocie Version, e.g 22.04 unquoted
ARG OCIE_VERSION
    
FROM bshp/ocie:${OCIE_VERSION}
    
# Ocie
ENV OCIE_CONFIG=/etc/ezproxy \
    APP_TYPE="ezproxy" \
    APP_DATA=/opt/ezproxy \
    APP_HOME=/usr/local/ezproxy \
    APP_VOLS="/opt/ezproxy" \
    WSKEY=""
    
RUN <<"EOD" bash
    set -eu;
    install -d -m 0755 -o root -g root ${APP_HOME};
    install -d -m 0755 -o root -g root ${APP_DATA}/config;
    install -d -m 0755 -o root -g root ${OCIE_CONFIG};
    wget --quiet --no-cookies https://help.oclc.org/@api/deki/files/9850/ezproxy-linux.bin;
    wget --quiet --no-cookies https://help.oclc.org/@api/deki/files/11977/ezproxy-linux-sha256.sum;
    OCLC_SIG=$(echo $(cat ezproxy-linux-sha256.sum | sed 's/\s.*$//') ezproxy-linux.bin | sha256sum -c | grep -o 'OK');
    if [[ -z "$OCLC_SIG" ]];then
        echo "Signature does not match";
        exit 1;
    fi;
    mv /ezproxy-linux.bin ${APP_HOME}/ezproxy;
    chown root:root ${APP_HOME}/ezproxy && chmod 0755 ${APP_HOME}/ezproxy;
    echo "EZProxy Version: $(${APP_HOME}/ezproxy -v | sed -n 's/^.*\s\(.*\) GA.*/\1/p')";
EOD

COPY --chown=root:root --chmod=0755 ./src/ ./
    
CMD ["/bin/bash"]
