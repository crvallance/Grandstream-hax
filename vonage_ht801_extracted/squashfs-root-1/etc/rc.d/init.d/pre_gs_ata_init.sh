#!/bin/sh

echo "Start PRE gs_ata Init scripts"

#
# If busybox/uclibc/kernel supports readahead we can try to cache in background 
#
READAHEAD_BIN=/usr/bin/readahead
if [ -f ${READAHEAD_BIN} ]; then
    echo "Start pre-caching files (readahead)"
    ${READAHEAD_BIN} /app/lib/firmware/css-loader
    ${READAHEAD_BIN} /app/lib/drv_silabs.ko
    ${READAHEAD_BIN} /app/lib/drv_tapi.ko
fi

/etc/rc.d/init.d/load_modules.sh
