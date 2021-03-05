# vi: ft=dockerfile
FROM openjdk:8-jdk-alpine

ARG TOMCAT_VERSION=9.0.43
# Anything else than 'true' will keep the default webapps.
ARG REMOVE_TOMCAT_DEFAULT_WEBAPPS=true
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk/

ADD web2.rya.war /tmp/
ADD entrypoint.sh /entrypoint.sh

RUN apk update && \
    apk add --no-cache unzip wget && \
    mkdir -p /opt/tomcat && \
    wget -nv -O /tmp/tomcat.tar.gz https://archive.apache.org/dist/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    tar zxf /tmp/tomcat.tar.gz -C /opt/tomcat --strip-components=1 && \
    rm -rf /opt/tomcat/webapps/ROOT && \
    if [ "${REMOVE_TOMCAT_DEFAULT_WEBAPPS}" = "true" ]; then rm -rf /opt/tomcat/webapps/docs /opt/tomcat/webapps/manager /opt/tomcat/webapps/host-manager /opt/tomcat/webapps/examples; fi && \
    ls /opt/tomcat/webapps && \
    unzip /tmp/web2.rya.war -d /opt/tomcat/webapps/ROOT && \
    rm /tmp/web2.rya.war /tmp/tomcat.tar.gz && \
    apk del unzip wget && \
    rm -rf /var/cache/apk && \
    chmod 750 /entrypoint.sh 

#VOLUME /opt/tomcat/webapps/web2.rya/classes/application.yml

ENV CATALINA_HOME /opt/tomcat
ENV PATH "$PATH:/opt/tomcat/bin"

ENTRYPOINT ["/entrypoint.sh"]

