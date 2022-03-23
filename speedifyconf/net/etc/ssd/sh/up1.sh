tac /tmp/spdstat.log | sed -n '/sendBps/{nnnnnnnnnnnnnnnnnnnnnnn;p;q}' | grep 'sendBps' | awk -F'[^0-9]*' '{printf "%s%.1f", $1, $2/(1000000)}' | cut -c 1-3

