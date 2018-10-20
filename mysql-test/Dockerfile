FROM mysql:8.0

ENV HOSTNAME local-mysql
ENV MYSQL_ROOT_PASSWORD qwer1234!@#$
ENV MYSQL_USER test
ENV MYSQL_PASSWORD qwer1234!@#$


RUN sed -i 's@#bind-address[\t]= 127.0.0.1@bind-address = 0.0.0.0@' /etc/mysql/mysql.conf.d/mysqld.cnf

# VOLUME /var/lib/mysql
# # Config files
# COPY config/ /etc/mysql/
# COPY docker-entrypoint.sh /usr/local/bin/
# RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat
# RUN sed -i 's@#bind-address[\t]= 127.0.0.1@bind-address = 0.0.0.0@' /etc/mysql/mysql.conf.d/mysqld.cnf
# ENTRYPOINT ["docker-entrypoint.sh"]

# EXPOSE 3306
# CMD ["mysqld"]
