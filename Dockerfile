FROM ubuntu
# Taskd user, volume and port, logs
RUN addgroup --gid 53589 taskd && \
    adduser --uid 53589 --gid 53589 --disabled-password --gecos "taskd" taskd && \
    usermod -L taskd && \
    mkdir -p /var/taskd && \
    chmod 700 /var/taskd && \
    ln -sf /dev/stdout /var/log/taskd.log && \
    chown taskd:taskd /var/taskd /var/log/taskd.log
VOLUME /var/taskd
EXPOSE 53589

# Fetch taskd and dependencies, build and install taskd
RUN apt-get update && \
apt-get upgrade -y && \
apt-get install -y --no-install-recommends git ca-certificates build-essential cmake gnutls-bin libgnutls28-dev uuid-dev && \
    git clone https://git.tasktools.org/TM/taskd.git /opt/taskd && \
    cd /opt/taskd && \
    git checkout 1.1.0 && \
    cmake . && \
    make && \
    make install && \
	# copy cert geneeration scripts so we can run them after deleting the taskd source && \
	cp -R /opt/taskd/pki /opt/taskdpki && \
rm -rf /opt/taskd
ADD init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh
ADD addUser.sh /usr/local/bin/addUser.sh
RUN chmod +x /usr/local/bin/addUser.sh
ADD server.sh /usr/local/bin/server.sh
RUN chmod +x /usr/local/bin/server.sh