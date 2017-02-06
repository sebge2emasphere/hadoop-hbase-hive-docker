#!/bin/bash

image=$1
tag='latest'

hiveDocker=$1'/files-temp'

tezVersion='0.8.4'
tezFileName='apache-tez-'$tezVersion'-bin.tar.gz'
tezFile=$hiveDocker'/'$tezFileName

hiveVersion='2.1.1'
hiveFileName='apache-hive-'$hiveVersion'-bin.tar.gz'
hiveFile=$hiveDocker'/'$hiveFileName

derbyVersion='10.13.1.1'
derbyFileName='db-derby-'$derbyVersion'-bin.tar.gz'
derbyFile=$hiveDocker'/'$derbyFileName



if [ $1 = 0 ]
then
	echo "Please use image name as the first argument!"
	exit 1
fi

# founction for delete images
function docker_rmi()
{
	echo -e "\n\nsudo docker rmi sebge2/$1:$tag"
	sudo docker rmi sebge2/$1:$tag
}


# founction for build images
function docker_build()
{
	cd $1
	echo -e "\n\nsudo docker build -t sebge2/$1:$tag ."
	/usr/bin/time -f "real  %e" sudo docker build -t sebge2/$1:$tag .
	cd ..
}



mkdir -p $hiveDocker

if [ ! -f "$tezFile" ]
then
  wget -O $tezFile 'http://apache.cu.be/tez/'$tezVersion'/'$tezFileName
fi

if [ ! -f "$hiveFile" ]
then
  wget -O $hiveFile 'http://www-eu.apache.org/dist/hive/hive-'$hiveVersion'/'$hiveFileName
fi

if [ ! -f "$derbyFile" ]
then
  wget -O $derbyFile 'http://apache.cu.be/db/derby/db-derby-'$derbyVersion'/'$derbyFileName
fi



echo -e "\ndocker rm -f slave1.krejcmat.com slave2.krejcmat.com master.krejcmat.com"
sudo docker rm -f slave1.krejcmat.com slave2.krejcmat.com master.krejcmat.com

sudo docker images >images.txt

#all image is based on dnsmasq. master and slaves are based on base image.
if [ $image == "hadoop-hbase-hive-master" ]
then
	docker_rmi hadoop-hbase-hive-master
	docker_build hadoop-hbase-hive-master
elif [ $image == "hadoop-hbase-hive-slave" ]
then
	docker_rmi hadoop-hbase-hive-slave
	docker_build hadoop-hbase-hive-slave
else
	echo "The image name is wrong! $image"
fi

echo -e "\nimages before build"
cat images.txt
rm images.txt

echo -e "\nimages after build"
sudo docker images
