FROM ubuntu:18.04
RUN apt-get update && apt-get install nginx -y
RUN apt-get update && apt-get install -q -y \
    nginx \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# user-specific arguments
ARG userid
ARG groupid
ARG workspacename
ARG username
ENV USERNAME=$username
ENV UNITYPROJECTPATH=$unityprojectpath
ENV WORKSPACENAME=$workspacename

# user setup
ENV UID=$userid
ENV GID=$groupid
RUN mkdir -p /home/$username && \
    echo "${USERNAME}:x:${UID}:${GID}:${USERNAME},,,:/home/${USERNAME}:/bin/bash" >> /etc/passwd && \
    echo "${USERNAME}:x:${GID}:" >> /etc/group && \
    usermod -a -G www-data ${USERNAME} && \
    usermod -a -G adm ${USERNAME} && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME} && \
    chown ${UID}:${GID} -R /home/${USERNAME}
