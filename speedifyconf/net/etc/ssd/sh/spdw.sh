tac /tmp/spdstat.log | sed -n '/receiveBps/{p;q}' | grep 'receiveBps' | awk -F'[^0-9]*' '{printf "%s%.1f\n", $1, $2/(1000000)}' | cut -c 1-3
