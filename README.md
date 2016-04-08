# Taskwarrior taskd for Docker

(c) 2016 Jared Stofflett
Redistribution and modifications are welcome, see the LICENSE file for details.

[Taskwarrior](http://www.taskwarrior.org) is an open-source cross platform command-line task management tool. It allows you to capture, annotate, manipulate and present your tasks, then sync them among devices.

This Dockerfile packages taskd, Taskwarrior's sync server, built from source. During initial setup you create an organization and initial user. This docker image is not currently available on Docker Hub

##build

docker build -t taskd .

## Setup

The image stores configuration and data in `/var/taskd`, which you should persist somewhere. Configuration is copied when running with the init command. For creating the initial directory hierarchy and example configuration, run the following command to create a persistent volume.

docker create -v /var/taskd --name taskddata busybox

To initialize the configuration and create your first user run

docker run --volumes-from taskddata --name taskdserver  --rm taskd /usr/local/bin/init.sh public jared 192.168.99.100

Replace public with your organization name, jared with your user name, and 192.168.99.100 with the IP address or domain name your server will be accessed at.

##configuration
To get required files for setup run

docker cp taskddata:/var/taskd taskd

For setting up taskd with the copied files refer to official documentation.
Note for password use the folder name at orgs/public/9714c653-dd82-4626-9b11-879386f0d90a where public was the organization you created and 9714c653-dd82-4626-9b11-879386f0d90a will be replaced with the name of the folder created when creating your first user.

## Running a Container

Run the image in a container, exposing taskd's port and making `/var/taskd` permanent. An example run command is

docker run --volumes-from taskddata --name taskdserver -p 53589:53589 -d taskd /usr/local/bin/server.sh  