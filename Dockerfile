FROM cleydyr/tomcat:7-jdk8

# Fix Debian Stretch EOL repository issues
RUN sed -i 's|deb.debian.org|archive.debian.org|g' /etc/apt/sources.list && \
    sed -i 's|security.debian.org|archive.debian.org/debian-security|g' /etc/apt/sources.list && \
    sed -i '/stretch-updates/d' /etc/apt/sources.list && \
    apt-get update -o Acquire::Check-Valid-Until=false && \
    apt-get install -y --allow-unauthenticated maven postgresql && \
    rm -rf /var/lib/apt/lists/*

ENV GITHUB_USER=wsilveiranz
ENV BRANCH_NAME=docker-producao-v2
ENV JAVA_OPTS="-agentlib:jdwp=transport=dt_socket,address=8000,server=y,suspend=n"

ENTRYPOINT ["/bin/sh", "-c", "echo \"listen_addresses = '*'\" >> /etc/postgresql/9.6/main/postgresql.conf && echo \"host    all             all              0.0.0.0/0                       md5\" >> /etc/postgresql/9.6/main/pg_hba.conf && /etc/init.d/postgresql start && wget https://github.com/$GITHUB_USER/Biblivre-5/archive/$BRANCH_NAME.zip && unzip $BRANCH_NAME.zip -d /tmp && rm $BRANCH_NAME.zip && cd /tmp/Biblivre-5-$BRANCH_NAME/lib/ && sh maven_deps.sh && cd .. && mvn sass:update-stylesheets package -Ddebug=true && cp target/Biblivre4.war $CATALINA_HOME/webapps && catalina.sh run"]

EXPOSE 8080