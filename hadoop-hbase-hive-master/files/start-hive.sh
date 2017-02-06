/root/start-hbase.sh

echo "Start derby..."
nohup sh -c /usr/local/derby/bin/startNetworkServer > /tmp/nohup-derby.out 2>&1 &

/usr/local/hadoop/bin/hadoop fs -mkdir /tmp
/usr/local/hadoop/bin/hadoop fs -chmod g+w /tmp

/usr/local/hadoop/bin/hadoop fs -mkdir /user
/usr/local/hadoop/bin/hadoop fs -chmod g+w /user

/usr/local/hadoop/bin/hadoop fs -mkdir /user/hive
/usr/local/hadoop/bin/hadoop fs -chmod g+w /user/hive

/usr/local/hadoop/bin/hadoop fs -mkdir /user/hive/warehouse
/usr/local/hadoop/bin/hadoop fs -chmod g+w /user/hive/warehouse

/usr/local/hadoop/bin/hadoop fs -mkdir /user/APP
/usr/local/hadoop/bin/hadoop fs -chmod g+w /user/APP

/usr/local/hadoop/bin/hadoop fs -mkdir /user/APP/warehouse
/usr/local/hadoop/bin/hadoop fs -chmod g+w /user/APP/warehouse

/usr/local/hadoop/bin/hadoop fs -mkdir /apps
/usr/local/hadoop/bin/hadoop fs -mkdir /apps/hive
/usr/local/hadoop/bin/hadoop fs -mkdir /apps/hive/install

#/usr/local/hadoop/bin/hadoop dfsadmin -safemode leave
/usr/local/hadoop/bin/hadoop fs -put /usr/local/tez /tez

sleep 5

echo "Init DB schema..."
/usr/local/hive/bin/schematool -dbType derby -initSchema

echo "Start Hive..."
nohup sh -c /usr/local/hive/bin/hiveserver2 --hiveconf hive.server2.enable.doAs=false -hiveconf hive.log.dir=/tmp/hive > /tmp/nohup-hive.out 2>&1 &

sleep 5