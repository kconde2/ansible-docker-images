FROM python:3.8-slim-buster

ARG BUILD_DIR=docker/python

# Define is when are building
# a deployment (IS_DEPLOYMENT=false) or
# a provision dockerfile (IS_DEPLOYMENT=true)
ARG IS_DEPLOYMENT=true

COPY $BUILD_DIR/mount-ssh.sh /bin/mount-ssh.sh
RUN chmod +x /bin/mount-ssh.sh && /bin/mount-ssh.sh

COPY $BUILD_DIR/requirements.txt /tmp/
RUN pip install --no-cache-dir -r /tmp/requirements.txt

ENV TZ="Europe/Paris"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    apt-get update && \
    apt-get -y --no-install-recommends install git sshpass openssh-client openssh-server && \
    if [ "$IS_DEPLOYMENT" = "true" ]; then \
    # Docker
    apt-get update && apt-get install curl apt-transport-https ca-certificates gnupg2 software-properties-common -y && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
    $(lsb_release -cs) \
    stable" && \
    apt-get update && \
    apt-get -y install docker-ce; \
    fi && \
    # Clean
    rm -rf /tmp/* && \
    rm -rf /var/cache/apt && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# SSH Forwarding
RUN cp /etc/ssh/sshd_config /etc/ssh/sshd_config_bak && \
    sed -i "s/^.*X11Forwarding.*$/X11Forwarding yes/" /etc/ssh/sshd_config && \
    sed -i "s/^.*X11UseLocalhost.*$/X11UseLocalhost no/" /etc/ssh/sshd_config && \
    grep "^X11UseLocalhost" /etc/ssh/sshd_config || echo "X11UseLocalhost no" >> /etc/ssh/sshd_config

WORKDIR /ansible
ENTRYPOINT ["/bin/mount-ssh.sh"]

CMD ["ansible-playbook", "--version"]
