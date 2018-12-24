FROM openjdk:8-jdk
 
ENV JENKINS_VERSION=2.150.1
ENV GITHUB_RELEASE_VERSION="v0.7.2"

RUN apt-get update \
    && apt-get install -y sudo make wget curl libltdl7 uuid-runtime \
    && curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - \
    && apt-get install -y nodejs gettext-base \
    && npm install -g n \
    && n 6.9.5 


WORKDIR /app

#http://ftp.yz.yamagata-u.ac.jp/pub/misc/jenkins/war-stable//jenkins.war
RUN wget -O jenkins.war http://ftp-nyc.osuosl.org/pub/jenkins/war-stable/$JENKINS_VERSION/jenkins.war \
    && wget https://github.com/aktau/github-release/releases/download/$GITHUB_RELEASE_VERSION/linux-amd64-github-release.tar.bz2 \
    && tar xf linux-amd64-github-release.tar.bz2 && rm -f linux-amd64-github-release.tar.bz2


ENV JENKINS_HOME=/var/jenkins_home
ENTRYPOINT ["java", "-Dhudson.model.DirectoryBrowserSupport.CSP=", "-Dmail.smtp.starttls.enable=true", "-jar", "/app/jenkins.war"]
