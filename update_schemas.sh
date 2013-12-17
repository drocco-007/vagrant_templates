#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PYTHON="/home/vagrant/amft/bin/python"

SCHEMAS=""
if [ "$1" == "-m" ]; then
    for i in blcore blauthentication blconfig blerrorhandling bllang blnotification blexcel blrules blfilter bllocking blscripts blcrypto blintegration blmonitor bltemplates ; do
        thing="$i:$DIR/../modules-git/$i/schema/ "
        SCHEMAS+=$thing
    done
fi

$PYTHON /home/vagrant/amft/bin/update_schemas.py $DIR/dev.cfg brighttrac:$DIR/../brighttrac/schema/ amftrb_brighttrac:$DIR/schema/ $SCHEMAS
