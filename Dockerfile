FROM openjdk:8-jdk
 
ENV JENKINS_VERSION=2.150.1
ENV GITHUB_VERSION="2.11.2"
ENV HELM_VERSION="v2.12.3"

RUN apt-get update \
    && apt-get install -y sudo make wget curl libltdl7 uuid-runtime \
    && curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - \
    && apt-get install -y nodejs gettext-base \
    && npm install -g n \
    && n 8.9.1 


WORKDIR /app

#http://ftp.yz.yamagata-u.ac.jp/pub/misc/jenkins/war-stable//jenkins.war
RUN wget -O jenkins.war http://ftp-nyc.osuosl.org/pub/jenkins/war-stable/$JENKINS_VERSION/jenkins.war \
    && wget -O hub.tar.gz https://github.com/github/hub/releases/download/v$GITHUB_VERSION/hub-linux-amd64-$GITHUB_VERSION.tgz \
    && tar xfz hub.tar.gz && rm -f hub.tar.gz \
    && hub-linux-amd64-$GITHUB_VERSION/install \
    && rm -rf hub-linux-amd64-$GITHUB_VERSION/ \
    && wget -O /app/helm.tar.gz "https://storage.googleapis.com/kubernetes-helm/helm-$HELM_VERSION-linux-amd64.tar.gz" \
    && tar xfzv helm.tar.gz && mv /app/linux-amd64/helm /usr/local/bin && rm -rf helm.tar.gz linux-amd64 \
    && helm init -c && helm plugin install https://github.com/chartmuseum/helm-push


ENV JENKINS_HOME=/var/jenkins_home
ENTRYPOINT ["java", "-Dhudson.model.DirectoryBrowserSupport.CSP=", "-Dmail.smtp.starttls.enable=true", "-jar", "/app/jenkins.war"]
