#!/bin/bash
set -e

# create data directory
if [[ ! -d ${PG_HOME} ]]; then
    mkdir -p "${PG_HOME}"
    chmod -R 0700 "${PG_HOME}"
    chown -R "${PG_USER}":"${PG_USER}" "${PG_HOME}"
fi

# create run directory
if [[ ! -d ${PG_RUNDIR}/${PG_VERSION}-main.pg_stat_tmp ]]; then
    mkdir -p "${PG_RUNDIR}" "${PG_RUNDIR}/${PG_VERSION}-main.pg_stat_tmp"
    chmod -R 0755 "${PG_RUNDIR}"
    chmod g+s "${PG_RUNDIR}"
    chown -R "${PG_USER}":"${PG_USER}" "${PG_RUNDIR}"
fi

# initialize postgres data directory
if [[ ! -d ${PG_DATADIR} ]]; then
    mkdir -p "${PG_DATADIR}"
    chmod -R 0700 "${PG_DATADIR}"
    chown -R "${PG_USER}":"${PG_USER}" "${PG_DATADIR}"

    echo "creating the database"
    sudo -Hu "${PG_USER}" "${PG_BINDIR}"/initdb --pgdata="${PG_DATADIR}" \
        --username="${PG_USER}" --encoding=unicode --auth=trust >/dev/null
fi