#! /bin/bash

set -u
set -e

if [ -z ${1} ]; then
	echo "Release version (arg1) not set !"
	exit 1;
fi

SRC_DIR=`dirname $0`"/.."
RELEASE_VERSION=${1}
echo "Release version set to ${RELEASE_VERSION}"

sed -ri 's/(.*)<version>(.+)<\/version>/\1<version>'${RELEASE_VERSION}'<\/version>/g' ${SRC_DIR}/appinfo/info.xml
uglifyjs js/devel/*.js > js/app.min.js
git commit -am "Release "${RELEASE_VERSION}
git tag ${RELEASE_VERSION}
git push
git push --tags
# Wait a second for Github to ingest our data
sleep 1
cd /tmp
rm -Rf ocsms-packaging && mkdir ocsms-packaging && cd ocsms-packaging
wget https://github.com/nextcloud/ocsms/archive/${RELEASE_VERSION}.tar.gz
tar xzf ${RELEASE_VERSION}.tar.gz
mv ocsms-${RELEASE_VERSION} ocsms
tar cfz ocsms-${RELEASE_VERSION}.tar.gz ocsms
echo "Release version "${RELEASE_VERSION}" is now ready."
