tac /tmp/spdstat.log | sed -n '/lossReceive/{nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn;p;q}' | grep 'lossReceive' | awk -F'[^0-9]*' '{printf "%s%.1f ", $1, $2/(1)}' | cut -c 1-3

