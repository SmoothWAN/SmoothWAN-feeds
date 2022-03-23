tac /tmp/spdsrv.log  |  sed -n '/tag/{p;q}' | awk -F"[A-Z=&\"]*" {'print $4'}
