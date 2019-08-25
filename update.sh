#!/bin/bash

TIME=$(date "+%Y/%m/%d-%H:%M:%S")
echo "[$TIME] Update Start"
cd /security
curl http://cefs.steve-meier.de/errata.latest.xml.bz2 -O
python generate_updateinfo.py --destination=/security --release=7 <(bzip2 -dc errata.latest.xml.bz2)
modifyrepo /security/updateinfo-7/updateinfo.xml /security/repodata/
rm -f errata.latest.xml.bz2
echo "[$TIME] Update Finished"
