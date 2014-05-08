#!/bin/bash

set -x

# append ssh public key to authorized_keys file
echo $AUTHORIZED_SSH_PUBLIC_KEY >> /home/hduser/.ssh/authorized_keys

adduser hduser sudo
adduser hduser root

addgroup hduser
adduser hduser hduser

echo -e '%hduser ALL=NOPASSWD:ALL\n' >> /etc/sudoers.d/hduser
chown root:root /etc/shdoers.d/hduser
chmod 0440 /etc/sudoers.d/hduser

# format the namenode if it's not already done
su -l -c 'mkdir -p /home/hduser/hdfs-data/namenode /home/hduser/hdfs-data/datanode && hdfs namenode -format -nonInteractive' hduser

# start ssh daemon
service ssh start

# start zookeeper used for HDFS
service zookeeper start

# clear hadoop logs
rm -fr /opt/hadoop/logs/*

# start HDFS
su -l -c 'start-dfs.sh' hduser

sleep 1

# tail log directory
tail -n 1000 -f /opt/hadoop/logs/*.log
