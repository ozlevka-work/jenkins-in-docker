FROM rappdw/docker-java-python
 
ENV JENKINS_VERSION=2.204.2
ENV GITHUB_VERSION="2.11.2"
ENV JENKINS_UC="https://updates.jenkins.io"

RUN apt-get update \
    && apt-get install -y sudo make wget curl libltdl7 uuid-runtime \
    && curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - \
    && apt-get install -y nodejs npm gettext-base \
    && npm install -g n \
    && n 8.9.1 


WORKDIR /app

#http://ftp.yz.yamagata-u.ac.jp/pub/misc/jenkins/war-stable/jenkins.war
RUN mkdir -p /usr/share/jenkins \
    && wget -O /usr/share/jenkins/jenkins.war $JENKINS_UC/download/war/$JENKINS_VERSION/jenkins.war \
    && wget -O hub.tar.gz https://github.com/github/hub/releases/download/v$GITHUB_VERSION/hub-linux-amd64-$GITHUB_VERSION.tgz \
    && tar xfz hub.tar.gz && rm -f hub.tar.gz \
    && hub-linux-amd64-$GITHUB_VERSION/install \
    && rm -rf hub-linux-amd64-$GITHUB_VERSION/ \
    # Install awscli for using by kubectl into EC2 node
    && pip --disable-pip-version-check --no-cache-dir install awscli


ENV JAVA_OPTS='"-Dhudson.model.DirectoryBrowserSupport.CSP=", "-Dpermissive-script-security.enabled=true", "-Dmail.smtp.starttls.enable=true"'
ENV JENKINS_HOME="/var/jenkins_home"
ENV COPY_REFERENCE_FILE_LOG="/var/jenkins_home/jenkins.log"
COPY jenkins.sh /usr/local/bin/jenkins.sh
COPY jenkins-support /usr/local/bin/jenkins-support
COPY install-plugins.sh /usr/local/bin/install-plugins.sh
RUN /usr/local/bin/install-plugins.sh \
    dashboard-view 
    # pipeline-stage-view:2.11 \  
    # parameterized-trigger:2.35.2 \  
    # #bitbucket:1.1.5 \  
    # git:3.10.0 \  
    # github:1.29.4 \
    # pipeline-utility-steps:2.3.0 \
    # pipeline-github-lib:1.0 \
    # job-dsl:1.74 \
    # build-pipeline-plugin:1.5.8 \
    # ssh-agent:1.17 \
    # ws-cleanup:0.37 \
    # ssh-steps:1.2.1 \
    # htmlpublisher:1.18 \
    # permissive-script-security:0.5 \
    # kubernetes:1.17.3 \
    # email-ext:2.66
ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/jenkins.sh"]
