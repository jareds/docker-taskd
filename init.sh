#!/bin/bash
export TASKDDATA=/var/taskd
taskd init
cd /opt/taskdpki
sed -i s/localhost/$3/g vars
sed -i s/365/3650/g vars
./generate
cp client.cert.pem /var/taskd
cp client.key.pem  /var/taskd
cp server.cert.pem /var/taskd
cp server.key.pem  /var/taskd
cp server.crl.pem  /var/taskd
cp ca.cert.pem     /var/taskd
taskd config --force log /var/taskd/taskd.log
taskd config --force pid.file /var/taskd/taskd.pid
taskd config --force server 0.0.0.0:53589
taskd config --force client.cert /var/taskd/client.cert.pem
taskd config --force client.key /var/taskd/client.key.pem
taskd config --force server.cert /var/taskd/server.cert.pem
taskd config --force server.key /var/taskd/server.key.pem
taskd config --force server.crl /var/taskd/server.crl.pem
taskd config --force ca.cert /var/taskd/ca.cert.pem
./generate.client $2
cp $2* /var/taskd
taskd add org $1
taskd add user $1 $2