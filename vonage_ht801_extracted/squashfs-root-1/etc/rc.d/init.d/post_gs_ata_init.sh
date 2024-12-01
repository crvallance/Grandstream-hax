#!/bin/sh

# Wait for the application to fully boot before starting these non esential services
STAGE_1_CNT=0
STAGE_1_MAX_DELAY=15
app_stage_1_started=`nvram get :slic_inited`
while [ "${STAGE_1_CNT}" -le ${STAGE_1_MAX_DELAY} -a "${app_stage_1_started}" != 1 ]
do
    sleep 1	
    STAGE_1_CNT=$(($STAGE_1_CNT+1))
    app_stage_1_started=`nvram get :slic_inited`
done


CSS_LOAD_CNT=0
while [ "$CSS_LOAD_CNT" -le 10 -a "`cat /sys/bus/platform/devices/8200000.css/state`" != "loaded" ]
do
        sleep 1
        CSS_LOAD_CNT=$(($CSS_LOAD_CNT+1))
done


#
# Start Reset Button polling
#
nvram set :reset_lock=0
reset_poll &

#
# Start urandom
#
/etc/rc.d/init.d/urandom start

#
# Start cron daemon
#
/etc/rc.d/init.d/cron 

#
# Start event notifier
#
msg_server &
msg_monitor_cc &

#
# Start telnet server
#
if [ "`nvram get 276`" = "0" -o "x${FACTORYMODE}" == "x1" ]; then
    /etc/rc.d/init.d/telnet
fi

#setup http/https/ftp proxy for GUI
if [ ! -z "`nvram get http_proxy`" ]; then
    export http_proxy="`nvram get http_proxy`"
    if [ "`nvram get proxy_apply_all`" = "1" ]; then
        export https_proxy=${http_proxy}
        export ftp_proxy=${http_proxy}
    else
        if [ ! -z "`nvram get https_proxy`" ]; then
            export https_proxy="`nvram get https_proxy`"
        fi
        if [ ! -z "`nvram get ftp_proxy`" ]; then
            export ftp_proxy="`nvram get ftp_proxy`"
        fi
    fi
else
    if [ ! -z "`nvram get https_proxy`" ]; then
        export https_proxy="`nvram get https_proxy`"
    fi
    if [ ! -z "`nvram get ftp_proxy`" ]; then
        export ftp_proxy="`nvram get ftp_proxy`"
    fi
fi
if [ ! -z "`nvram get no_proxy`" ]; then
    export no_proxy="`nvram get no_proxy`"
fi


#
# Start web server
#
if [ -f /usr/sbin/httpd -a -r /etc/hosts ]; then
    /app/bin/lang
    echo "Starting HTTP Server ...."
    /etc/rc.d/init.d/http start
fi

#
# Start TR069
#
if [ -f /app/bin/tr_069_start.sh ]; then
    /app/bin/tr_069_start.sh
fi

#
# Product specific
#
if [ -f /app/bin/ht_prod.sh ]; then
    echo "Starting Product Specific Support..."
    . /app/bin/ht_prod.sh
fi

#
# Start provisioning after application has performend the initial registration 
#
STAGE_2_CNT=0
STAGE_2_MAX_DELAY=10
app_stage_2_started=`nvram get :gs_ata_inited`
while [ "${STAGE_2_CNT}" -le ${STAGE_2_MAX_DELAY} -a "${app_stage_2_started}" != 1 ]
do
    sleep 1	
    STAGE_2_CNT=$(($STAGE_2_CNT+1))
    app_stage_2_started=`nvram get :gs_ata_inited`
done

initial_provision &
