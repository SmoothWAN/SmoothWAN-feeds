tac /tmp/spdset.log  |  sed -n '/bondingMode/{p;q}' | awk -F"[A-Z=&\"]*" {'print $5'}

