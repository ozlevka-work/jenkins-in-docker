FROM rappdw/docker-java-python
 
ENV JENKINS_VERSION=2.150.1

RUN apt-get update \
    && apt-get install -y sudo make wget curl libltdl7 uuid-runtime sshpass 

RUN pip install ansible==2.7.5 boto



WORKDIR /app

RUN wget -O jenkins.war http://mirrors.jenkins.io/war-stable/$JENKINS_VERSION/jenkins.war

ENV JENKINS_HOME=/var/jenkins_home
ENTRYPOINT ["java", "-Dhudson.model.DirectoryBrowserSupport.CSP=", "-Dmail.smtp.starttls.enable=true", "-jar", "/app/jenkins.war"]
