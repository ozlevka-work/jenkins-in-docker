FROM rappdw/docker-java-python
 
ENV JENKINS_VERSION=2.222
ENV JENKINS_UC="https://updates.jenkins.io"

RUN apt-get update \
    && apt-get install -y sudo make wget curl libltdl7 uuid-runtime salt-master \
    && python3 -m pip --disable-pip-version-check install wheel \
    && python3 -m pip --disable-pip-version-check install salt docker


WORKDIR /app

#http://ftp.yz.yamagata-u.ac.jp/pub/misc/jenkins/war-stable/jenkins.war
RUN mkdir -p /usr/share/jenkins \
    && wget -O /usr/share/jenkins/jenkins.war $JENKINS_UC/download/war/$JENKINS_VERSION/jenkins.war 


ENV JENKINS_HOME=/var/jenkins_home
ENV JAVA_OPTS='"-Dhudson.model.DirectoryBrowserSupport.CSP=", "-Dpermissive-script-security.enabled=true", "-Dmail.smtp.starttls.enable=true"'
ENV JENKINS_HOME="/var/jenkins_home"
ENV COPY_REFERENCE_FILE_LOG="/var/jenkins_home/jenkins.log"
COPY jenkins.sh /usr/local/bin/jenkins.sh
COPY jenkins-support /usr/local/bin/jenkins-support
COPY install-plugins.sh /usr/local/bin/install-plugins.sh
RUN /usr/local/bin/install-plugins.sh \
    dashboard-view:2.10 \
    pipeline-stage-view:2.11 \  
    parameterized-trigger:2.35.2 \  
    #bitbucket:1.1.5 \  
    git:3.10.0 \  
    github:1.29.4 \
    pipeline-utility-steps:2.3.0 \
    pipeline-github-lib:1.0 \
    job-dsl:1.74 \
    build-pipeline-plugin:1.5.8 \
    ssh-agent:1.17 \
    ws-cleanup:0.37 \
    ssh-steps:1.2.1 \
    htmlpublisher:1.18 \
    permissive-script-security:0.5 \
    kubernetes:1.17.3 \
    email-ext:2.66 \
    saltstack:3.2.2
ENTRYPOINT ["/bin/bash", "-c", "salt-master -d && /usr/local/bin/jenkins.sh"]
