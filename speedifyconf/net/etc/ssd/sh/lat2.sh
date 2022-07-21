tac /tmp/spdstat.log | sed -n '/latencyMs/{nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn;p;q}' | grep 'latencyMs' | awk -F'[^0-9]*' '{printf "%s%.0f", $1, $2}' | cut -c 1-3

