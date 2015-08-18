FROM tsilenzio/base

MAINTAINER Taylor Silenzio <tsilenzio@gmail.com>

# Install nessesary packages
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    curl -q https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - && \
    apt-get update && \
    apt-get install -y postgresql-9.4 \
    postgresql-client-9.4 \
    postgresql-contrib-9.4

# Clean apt-get
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Switch to the postgres user
USER postgres

#RUN /etc/init.d/postgresql start &&\
#    psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" &&\
#    createdb -O docker docker

# Remove the config files
RUN rm -rf /etc/postgresql/9.4/main/postgresql.conf && \
    rm -rf /etc/postgresql/9.4/main/pg_hba.conf && \
    # Prevent a common error
    mkdir -p /var/run/postgresql/9.4-main.pg_stat_tmp && \
    chown -R postgres.postgres /var/run/postgresql/9.4-main.pg_stat_tmp

# Add the config files
ADD conf/postgresql.conf /etc/postgresql/9.4/main/
ADD conf/pg_hba.conf /etc/postgresql/9.4/main/

# Switch back to the root user
USER root

# Enable the service
ADD service/ /etc/service/

VOLUME ["/var/lib/postgresql/"]

EXPOSE 5432

CMD ["/sbin/my_init"]