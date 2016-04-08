#!/bin/bash
export TASKDDATA=/var/taskd
cd /opt/taskdpki
./generate.client $2
cp $2* /var/taskd
taskd add org $1
taskd add user $1 $2