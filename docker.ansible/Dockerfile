FROM ubuntu:18.04
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    vim \
    locales \
    build-essential \
    openssh-client \
    openssh-server \
    python \
    python-dev \
    pass \
    python-httplib2 \
    python-jinja2 \
    python-keyczar \
    python-lxml \
    python-mock \
    python-mysqldb \
    python-nose \
    python-paramiko \
    python-passlib \
    python-pip \
    python-setuptools \
    python-virtualenv \
    python-yaml \
    ansible \
    sshpass \
    iputils-ping \
    sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/ansible/ && \
    /bin/echo -e "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts
RUN locale-gen en_US.UTF-8

RUN useradd -u 10000 ansible && \
    mkdir -p /home/ansible/.ssh && \
    chown -R ansible:ansible /home/ansible

# Needed to make nerdtree plugin for vim work
RUN locale-gen en_US.UTF-8 && \
    echo "export LC_CTYPE=en_US.UTF-8" >> /home/ansible/.bashrc && \
echo "export LC_ALL=en_US.UTF-8" >> /home/ansible/.bashrc

RUN ssh-keygen -q -t rsa -N '' -f /home/ansible/.ssh/id_rsa && \
    cp /home/ansible/.ssh/id_rsa.pub /home/ansible/.ssh/authorized_keys && \
    for key in /etc/ssh/ssh_host_*_key.pub; do echo "localhost $(cat ${key})" >> /home/ansible/.ssh/known_hosts; done
RUN usermod -a -G staff ansible
RUN chown -R ansible:ansible /home/ansible
VOLUME /sys/fs/cgroup /run/lock /run /tmp
WORKDIR /home/ansible
USER ansible

