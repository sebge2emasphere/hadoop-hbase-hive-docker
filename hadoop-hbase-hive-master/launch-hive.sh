#!/bin/bash

/root/start-hbase.sh

echo "Start derby..."
/usr/local/derby/bin/startNetworkServer >> /tmp/derby.log &

echo "Init DB schema..."
/usr/local/hive/bin/schematool -dbType derby -initSchema

echo "Start Hive..."
/usr/local/hive/bin/hiveserver2 --hiveconf hive.server2.enable.doAs=false -hiveconf hive.log.dir=/tmp/hive &

