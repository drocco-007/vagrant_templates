#!/usr/bin/env bash


# Le variables

# Client identifier; used as the virtualenv name and in various paths
CLIENT="nasm"
DBPREFIX=$CLIENT
BTCLIENT="NASM"

PIP="sudo -u vagrant /home/vagrant/$CLIENT/bin/pip "
PYTHON="sudo -u vagrant /home/vagrant/$CLIENT/bin/python "
PSQL="sudo -u postgres psql "


# system packages
apt-get update
apt-get install -y postgresql subversion git python-pip python-dev libjpeg-dev libz-dev libpq-dev vim git-svn screen
pip install -U pip virtualenv grin


# allow PIL to find 64-bit libs
ln -s /usr/lib/x86_64-linux-gnu/libjpeg.so /usr/lib
ln -s /usr/lib/x86_64-linux-gnu/libz.so /usr/lib


# tweak user startup
echo ". ~/$CLIENT/bin/activate" >> /home/vagrant/.bashrc
echo "cd /brightlink_dev" >> /home/vagrant/.bashrc


# create the virtualenv for $CLIENT
sudo -u vagrant virtualenv /home/vagrant/$CLIENT


# Special snowflake packages need to be installed first
$PIP install /brightlink_dev/packages/trml2pdf/trml2pdf-1.0.tar.gz
for package in `find /brightlink_dev/packages/forks -name trunk` ; do
    cd $package

    # not develop because it breaks django
    $PYTHON setup.py install
    cd -
done


# Install the base Python packages
$PIP install --download-cache /tmp -r /brightlink_dev/brighttrac/requirements.txt
$PIP install --download-cache /tmp -r /brightlink_dev/modules-git/blcore/requirements.txt
$PIP install --download-cache /tmp pytest pytest-xdist pdbpp


# Install our packages
for package in blcore blauthentication blconfig blerrorhandling bllang blnotification blexcel blrules blfilter bllocking blscripts blcrypto blintegration blmonitor bltemplates blwebtop utctime template_resolver ; do
    cd /brightlink_dev/modules-git/$package
    $PYTHON setup.py develop
    cd -
done


# Install core and custom
for package in brighttrac $CLIENT ; do
    cd /brightlink_dev/$package
    $PYTHON setup.py develop
    cd -
done


# Symlink needed until we fix custom client loading
mkdir -p /src/clients/NASM/
ln -s /brightlink_dev/$CLIENT /src/clients/NASM/trunk


# Le Database

$PSQL -c "CREATE ROLE core_user LOGIN PASSWORD 'core_pass'"
$PSQL -c "CREATE ROLE ${DBPREFIX}_user LOGIN PASSWORD '${DBPREFIX}_pass'"
$PSQL -c "CREATE DATABASE ${DBPREFIX}_data OWNER ${DBPREFIX}_user"
$PSQL ${DBPREFIX}_data < /brightlink_dev/brighttrac/schema/bt_init.sql
$PSQL -c "REASSIGN OWNED BY core_user TO ${DBPREFIX}_user" ${DBPREFIX}_data

/brightlink_dev/$CLIENT/update_schemas.sh -m
