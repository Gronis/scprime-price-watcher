#!/bin/bash

# Debug flag
# set -x

# Exit on failure
set -e

PRICE_CONSTANT=${PRICE_CONSTANT:-"1.0"}

get_target_price(){
  URL='https://grafana.scpri.me/api/ds/query'
  BODY='{
    "queries":[
      {
        "refId":"A",
        "datasourceId":2,
        "rawSql":"select
                    to_scp(network.current_xm_maxstorageprice()*4320*1000000000000) as maxprice,
                    to_scp((storageprice.storage_price*10^15/usd_scp_rate/4320)::numeric(38,0)*1000000000000*4320) as goalSCP
                  from markets.target_storage_price_scp scp
                    cross join
                      (select storage_price from markets.storage_price_usd spu
                       where valid_since<=unix_now()
                       order by valid_since desc limit 1) storageprice
                    cross join
                      (select usd as usd_scp_rate
                       from markets.coingecko_simple cs
                       order by last_updated_at desc limit 1) cs1
                    where valid_since <= unix_now()
                    order by valid_since desc limit 1;",
        "format": "table",
        "intervalMs":43200000,
        "maxDataPoints":641
      }
    ],
    "range":{
      "raw":{
        "from":"now-10M",
        "to":"now"
      }
    }
  }'
  # Replace newline with space
  BODY_ENCODED=$(echo $BODY | awk '$1=$1' ORS=' ')
  RES=$(curl "$URL" -H 'accept: application/json' -H 'content-type: application/json' --data "$BODY_ENCODED" --compressed 2> /dev/null)
  # Compute target price
  GOAL_PRICE=$(echo $RES | jq ."results"."A"."frames" | jq ".[0].data.values" | jq ".[1]" | jq ".[0]")
  MAX_PRICE=$(echo $RES | jq ."results"."A"."frames" | jq ".[0].data.values" | jq ".[0]" | jq ".[0]" | awk "{print (\$1==\"null\")*$GOAL_PRICE+ (1-(\$1==\"null\"))*\$1}")
  TARGET_PRICE=$(awk "BEGIN {print ($PRICE_CONSTANT*$GOAL_PRICE)}")
  CAPPED_PRICE=$(awk "BEGIN {print ((($MAX_PRICE>$TARGET_PRICE)*$TARGET_PRICE)+(1-($MAX_PRICE>$TARGET_PRICE))*$MAX_PRICE)}")
  FINAL_PRICE=$(echo $CAPPED_PRICE | awk '{printf "%.2f", $1}')
  echo $FINAL_PRICE
}

THREE_HOURS=10800
while [ 1 ]
do
    TARGET_PRICE=$(get_target_price)
    echo "Setting target price to: $TARGET_PRICE SCP"
    docker exec -it $CONTAINER spc host config minstorageprice ${TARGET_PRICE}SCP
    echo "Sleeping 3 hours..."
    sleep $THREE_HOURS
done

