FROM sebge2/hadoop-hbase-master:latest
MAINTAINER sgerard <sgerard@emasphere.com>



ENV HADOOP_HOME /usr/local/hadoop
ENV TEZ_VERSION 0.8.4
ENV TEZ_HOME /usr/local/tez/

ADD './files-temp/apache-tez-'$TEZ_VERSION'-bin.tar.gz' /tmp
RUN mv /tmp/apache-tez-$TEZ_VERSION-bin $TEZ_HOME
RUN rm $TEZ_HOME'/lib/slf4j-log4j12-1.7.10.jar'
ADD files/tez-site.xml $HADOOP_HOME/etc/hadoop/tez-site.xml
ADD files/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml

RUN echo 'TEZ_JARS=${TEZ_HOME}/*' >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh
RUN echo 'TEZ_LIB=${TEZ_HOME}/lib/*' >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh
RUN echo 'TEZ_CONF=${HADOOP_HOME}/etc/hadoop' >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh
RUN echo 'export HADOOP_CLASSPATH=$HADOOP_CLASSPATH:$TEZ_CONF:$TEZ_JARS:$TEZ_LIB' >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh



ENV HIVE_VERSION 2.1.1
ENV HIVE_HOME /usr/local/hive
ENV HIVE_CONF $HIVE_HOME/conf
ENV PATH $HIVE_HOME/bin:$PATH

ADD './files-temp/apache-hive-'$HIVE_VERSION'-bin.tar.gz' /tmp
RUN mv /tmp/apache-hive-$HIVE_VERSION-bin $HIVE_HOME
ADD files/hive-site.xml $HIVE_CONF/hive-site.xml
#RUN rm $HADOOP_HOME/share/hadoop/yarn/lib/jline-0.9.94.jar # zookeeper pulls jline 0.9.94 and hive pulls jline2. This workaround is from HIVE-8609
ADD files/hive-env.sh $HIVE_HOME/conf/hive-env.sh
ADD files/start-hive.sh /root/start-hive.sh
RUN cp $TEZ_HOME/*.jar $HIVE_HOME/lib
RUN rm $HIVE_HOME/jdbc/hive-jdbc-*-standalone.jar
RUN rm $HIVE_HOME/lib/log4j-slf4j-impl-*.jar
RUN chmod ugo+x /root/start-hive.sh
RUN echo 'export HIVE_HOME=$HIVE_HOME' >> ~/.bashrc
RUN echo 'export PATH=$PATH:$HIVE_HOME/bin' >> ~/.bashrc



ENV DERBY_VERSION 10.13.1.1
ENV DERBY_DIST /usr/local/derby

ADD './files-temp/db-derby-'$DERBY_VERSION'-bin.tar.gz' /tmp
RUN mv /tmp/db-derby-*-bin $DERBY_DIST
RUN mkdir $DERBY_DIST/data
RUN cp $DERBY_DIST/lib/derbyclient.jar $HIVE_HOME/jdbc/
RUN cp $DERBY_DIST/lib/derbytools.jar $HIVE_HOME/jdbc/
RUN mv $HIVE_HOME/lib/derby-*.jar $HIVE_HOME/jdbc/
RUN echo 'export DERBY_HOME=$DERBY_HOME' >> ~/.bashrc
RUN echo 'export PATH=$PATH:$DERBY_HOME/bin' >> ~/.bashrc


EXPOSE 10000