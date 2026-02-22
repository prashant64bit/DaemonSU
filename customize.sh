#!/system/bin/sh
MODPATH=${0%/*}
chmod 755 $MODPATH/service.sh
chmod 755 $MODPATH/plugins/*.sh 2>/dev/null || true