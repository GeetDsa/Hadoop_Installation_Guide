#!/bin/bash

#generate ssh-key (rsa) with no pass-phrase
ssh-keygen -t rsa -P ""

#copy the public key to authorized_keys file
cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys

#disable ipv6

sudo echo "" >> /etc/sysctl.conf
sudo echo "#disable ipv6" >> /etc/sysctl.conf
sudo echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
sudo echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
sudo echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf

#extract hadoop <replace with the appropriate installation file name>

sudo tar -xzvf hadoop-2.7.3.tar.gz
sudo mv hadoop-2.7.3 /usr/local/hadoop

sudo chown hduser:hadoop -R /usr/local/hadoop


## Create Hadoop temp directories for Namenode and Datanode
sudo mkdir -p /usr/local/hadoop_tmp/hdfs/namenode
sudo mkdir -p /usr/local/hadoop_tmp/hdfs/datanode

## Again assign ownership of this Hadoop temp folder to Hadoop user
sudo chown hduser:hadoop -R /usr/local/hadoop_tmp/

## Update hduser configuration file by appending

echo "" >> $HOME/.bashrc
echo '# -- HADOOP ENVIRONMENT VARIABLES START -- #' >> $HOME/.bashrc
echo 'export JAVA_HOME=/usr/lib/jvm/default-java' >> $HOME/.bashrc
echo 'export HADOOP_HOME=/usr/local/hadoop' >> $HOME/.bashrc
echo 'export PATH=$PATH:$HADOOP_HOME/bin' >> $HOME/.bashrc
echo 'export PATH=$PATH:$HADOOP_HOME/sbin' >> $HOME/.bashrc
echo 'export HADOOP_MAPRED_HOME=$HADOOP_HOME' >> $HOME/.bashrc
echo 'export HADOOP_COMMON_HOME=$HADOOP_HOME' >> $HOME/.bashrc
echo 'export HADOOP_HDFS_HOME=$HADOOP_HOME' >> $HOME/.bashrc
echo 'export YARN_HOME=$HADOOP_HOME' >> $HOME/.bashrc
echo 'export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native' >> $HOME/.bashrc
echo 'export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib"' >> $HOME/.bashrc
echo "# -- HADOOP ENVIRONMENT VARIABLES END -- #" >> $HOME/.bashrc


#Hadoop Configuration files are modified below

sudo sed -i "s!JAVA_HOME.*!JAVA_HOME=/usr/lib/jvm/default-java!g" /usr/local/hadoop/etc/hadoop/hadoop-env.sh

sudo sed -i '/<configuration>/r core-site-content' /usr/local/hadoop/etc/hadoop/core-site.xml
sudo sed -i '/<configuration>/r hdfs-site-content' /usr/local/hadoop/etc/hadoop/hdfs-site.xml
sudo sed -i '/<configuration>/r yarn-site-content' /usr/local/hadoop/etc/hadoop/yarn-site.xml
sudo cp /usr/local/hadoop/etc/hadoop/mapred-site.xml.template /usr/local/hadoop/etc/hadoop/mapred-site.xml
sudo sed -i '/<configuration>/r mapred-site-content' /usr/local/hadoop/etc/hadoop/mapred-site.xml

