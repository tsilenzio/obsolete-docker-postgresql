FROM tsilenzio/base

MAINTAINER Taylor Silenzio <tsilenzio@gmail.com>

# Define installation details
ENV PG_VERSION=9.4 \
    PG_USER=postgres \
    PG_HOME=/var/lib/postgresql

# Define installation locations
ENV PG_RUNDIR=/var/run/postgresql \
    PG_CONFDIR="/etc/postgresql/${PG_VERSION}/main" \
    PG_BINDIR="/usr/lib/postgresql/${PG_VERSION}/bin" \
    PG_DATADIR="${PG_HOME}/${PG_VERSION}/main"

# Add the config files
ADD conf.d/* /tmp/

# Enable the service
ADD service/ /etc/service/

# Enable startup scripts
ADD init.d/ /etc/my_init.d/

# Enable PostgreSQL repository
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && curl -q https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - \
    # Update package manager repositories
    && apt-get update \
    # Install PostgreSQL
    && apt-get install -y postgresql-${PG_VERSION} \
        postgresql-client-${PG_VERSION} \
        postgresql-contrib-${PG_VERSION} \
    # Install configuration files
    && rm -rf /etc/postgresql/${PG_VERSION}/main/postgresql.conf \
    && mv /tmp/postgresql.conf /etc/postgresql/${PG_VERSION}/main/postgresql.conf \
    && chown postgres:postgres /etc/postgresql/${PG_VERSION}/main/postgresql.conf \
    && chmod 644 /etc/postgresql/${PG_VERSION}/main/postgresql.conf \
    && rm -rf /etc/postgresql/${PG_VERSION}/main/pg_hba.conf \
    && mv /tmp/pg_hba.conf /etc/postgresql/${PG_VERSION}/main/pg_hba.conf \
    && chown postgres:postgres /etc/postgresql/${PG_VERSION}/main/pg_hba.conf \
    && chmod 644 /etc/postgresql/${PG_VERSION}/main/pg_hba.conf \
    # Handle post installation clean-up
    && rm -rf ${PG_HOME} \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

# Enable data persistency
VOLUME ["/var/lib/postgresql/"]

# Start init
CMD ["/sbin/my_init"]