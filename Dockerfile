FROM ozlevka/java-8-jdk-python-3-6:1
 
ENV JENKINS_VERSION=2.249.3
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
    && mkdir -p /usr/share/jenkins/ref/ \
    # Install awscli for using by kubectl into EC2 node
    && pip --disable-pip-version-check --no-cache-dir install awscli python-jenkins


ENV JAVA_OPTS='"-Dhudson.model.DirectoryBrowserSupport.CSP=", "-Dpermissive-script-security.enabled=true", "-Dmail.smtp.starttls.enable=true"'
ENV JENKINS_HOME="/var/jenkins_home"
ENV COPY_REFERENCE_FILE_LOG="/var/jenkins_home/jenkins.log"
COPY jenkins.sh /usr/local/bin/jenkins.sh
COPY jenkins-support /usr/local/bin/jenkins-support
ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/jenkins.sh"]
