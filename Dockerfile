FROM cleydyr/tomcat:7-jdk8
RUN apt-get update
RUN apt-get install -y maven postgresql

ENV GITHUB_USER wsilveiranz
ENV BRANCH_NAME docker-producao
ENV JAVA_OPTS="-agentlib:jdwp=transport=dt_socket,address=8000,server=y,suspend=n"
ENTRYPOINT echo "listen_addresses = '*'" >> /etc/postgresql/9.6/main/postgresql.conf \
&& 	echo "host    all             all              0.0.0.0/0                       md5" >> /etc/postgresql/9.6/main/pg_hba.conf \
&& 	/etc/init.d/postgresql start \
&&	wget https://github.com/$GITHUB_USER/Biblivre-5/archive/$BRANCH_NAME.zip \
&&	unzip Biblivre-5-$BRANCH_NAME.zip -d /tmp && rm $BRANCH_NAME.zip \
&&	cd /tmp/Biblivre-5-$BRANCH_NAME/lib/ \
&&	sh maven_deps.sh \
&&	cd .. \
&&	mvn sass:update-stylesheets package -Ddebug=true \
&&	su postgres -c "psql -U postgres -f sql/createdatabase.sql" \
&&	su postgres -c "psql -U postgres -f sql/biblivre4.sql -d biblivre4" \
&&  cp target/Biblivre4.war $CATALINA_HOME/webapps \
&&	catalina.sh run

EXPOSE 8080
