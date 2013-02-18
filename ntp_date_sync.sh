#!/bin/sh

# UA
# 0.ua.pool.ntp.org
NTP_SERVER="0.ua.pool.ntp.org"


/usr/sbin/ntpdate $NTP_SERVER
