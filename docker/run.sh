#!/bin/bash

SLPROPZ_RETRY_COUNT="${SLPROPZ_RETRY_COUNT:-5}"
SLPROPZ_RETRY_TIME="${SLPROPZ_RETRY_TIME:-10}"

mkdir -p /opt/snaplogic/etc
if [[ ! -z "$SNAPLOGIC_CONFIG_LINK" ]]; then
    USER=$(if [ ! -z "$SNAPLOGIC_USERNAME" ]; then echo "-u $SNAPLOGIC_USERNAME:$SNAPLOGIC_PASSWORD"; else echo ""; fi)

    n=0
    success=false
    until [ "$n" -ge "$SLPROPZ_RETRY_COUNT" ]
    do
        echo $USER | curl --fail -o /opt/snaplogic/etc/snaplogic.slpropz $SNAPLOGIC_CONFIG_LINK -K-
        if [ 0 = $? ]; then
            success=true
            break;
        fi
        n=$((n+1))
        echo "Unable to download .slpropz file on attempt $n"
        sleep $SLPROPZ_RETRY_TIME
    done

    if [ "$success" = false ]; then
        echo "Failed to download .slpropz"
        exit 1
    fi

fi

unset SNAPLOGIC_USERNAME
unset SNAPLOGIC_PASSWORD

# remove changing ownership of the /opt/snaplogic/etc directory
# you can not do this in OpenShift as the container runs as a random user
# chown -R snapuser:snapuser /opt/snaplogic/etc
/opt/snaplogic/bin/jcc.sh start
tail -f /opt/snaplogic/run/log/monitor.log