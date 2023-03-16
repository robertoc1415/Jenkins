FROM jenkins/jenkins:latest

USER root

RUN apt-get update && \
      apt-get -y install sudo

RUN mkdir -p /tmp/download && \
 curl -L https://download.docker.com/linux/static/stable/x86_64/docker-18.03.1-ce.tgz | tar -xz -C /tmp/download && \
 rm -rf /tmp/download/docker/dockerd && \
 mv /tmp/download/docker/docker* /usr/local/bin/ && \
 rm -rf /tmp/download && \
 groupadd -g 999 docker && \
 usermod -aG staff,docker jenkins


RUN mkdir -p /usr/local/bin
RUN curl -SL https://github.com/docker/compose/releases/download/v2.3.3/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose

RUN sudo chmod +x /usr/local/bin/docker-compose

RUN sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

RUN docker-compose --version

RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# USER jenkins

EXPOSE 8080
EXPOSE 50000



# FROM jenkins/jenkins:lts-jdk11

# # add ability to run docker from within jenkins (docker in docker)
# USER root
# RUN apt-get update && apt-get install -y lsb-release sudo
# RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
#   https://download.docker.com/linux/debian/gpg
# RUN echo "deb [arch=$(dpkg --print-architecture) \
#   signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
#   https://download.docker.com/linux/debian \
#   $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
# RUN apt-get update && apt-get install -y docker-ce-cli \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

# USER jenkins

# # set default user attributes
# ENV JENKINS_UID=1000
# ENV JENKINS_GID=1000

# # add entrypoint script
# COPY docker-entrypoint.sh /docker-entrypoint.sh

# # normally user would be set to jenkins, but this is handled by the docker-entrypoint script on startup
# #USER jenkins
# USER root

# RUN chmod -R -f 777 ./docker-entrypoint.sh
# # bypass normal entrypoint and use custom one
# #ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/jenkins.sh"]
# ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint.sh"]