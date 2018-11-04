FROM rappdw/docker-java-python
 
ENV JENKINS_VERSION=2.138.1

RUN apt-get update \
    && apt-get install -y sudo make wget curl libltdl7 uuid-runtime sshpass \
    && curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - \
    && apt-get install -y nodejs \
    && npm install -g n \
    && n 6.9.5

RUN pip install ansible==2.5.0


WORKDIR /app

RUN wget -O jenkins.war http://ftp.yz.yamagata-u.ac.jp/pub/misc/jenkins/war-stable/$JENKINS_VERSION/jenkins.war

ENV JENKINS_HOME=/var/jenkins_home
ENTRYPOINT ["java", "-Dhudson.model.DirectoryBrowserSupport.CSP=", "-Dmail.smtp.starttls.enable=true", "-jar", "/app/jenkins.war"]
