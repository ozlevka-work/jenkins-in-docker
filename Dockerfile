FROM openjdk:8-jdk
 
ENV JENKINS_VERSION=2.60.3

RUN apt-get update \
    && apt-get install -y sudo make wget curl libltdl7 uuid-runtime \
    && curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - \
    && apt-get install -y nodejs \
    && npm install -g n \
    && n 6.9.5 


WORKDIR /app

RUN wget -O jenkins.war http://ftp.yz.yamagata-u.ac.jp/pub/misc/jenkins/war-stable/$JENKINS_VERSION/jenkins.war

ENV JENKINS_HOME=/var/jenkins_home
ENTRYPOINT ["java", "-Dhudson.model.DirectoryBrowserSupport.CSP=", "-jar", "/app/jenkins.war"]
