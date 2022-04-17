tac /tmp/spdstat.log | sed -n '/receiveBps/{nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn;p;q}' | awk -F '"' {'print $4'} | cut -c 0 | tr -d '\n'
echo -n ":"
tac /tmp/spdstat.log | sed -n '/receiveBps/{nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn;p;q}' | grep 'receiveBps' | awk -F'[^0-9]*' '{printf "%s%.1f", $1, $2/(1000000)}' | cut -c 1-3
