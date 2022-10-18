# scprime-price-watcher
Updates the price of your ScPrime container to what the price is currently on https://scpri.me

Currently, it will set the price to the goal price. This can be adjusted by using the
`PRICE_CONSTANT` variable.

### Price adjustment examples:
- `PRICE_CONSTANT=0.0` will use the goal price.
- `PRICE_CONSTANT=1.0` will use the max price (don't do this lol).
- `PRICE_CONSTANT=0.5` will use the middle between max and goal price.
- `PRICE_CONSTANT=-1.0` will use goal price with rebate `= max - goal` as price
Default is 0.0 which is the goal price. Adjust for your situation. Typically you would offer
a lower price (maybe `PRICE_CONSTANT=-0.2`) if you have alot of space and really want to get
contracts. If you are running low on storage, maybe you want to increase prices so then you
could use `PRICE_CONSTANT=-0.5` to get the price just between the max and goal price. It's
up to you.

# Run daemon:
```bash
docker run --rm -it -e CONTAINER=<name-of-scprime-daemon> -v /var/run/docker.sock:/var/run/docker.sock:ro gronis/scprime-price-watcher
```

# Run with docker-compose
```yml
version: "3.6"
services:
  scp1-price-watcher:
    container_name: scp1-price-watcher
    image: gronis/scprime-price-watcher
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
    tty: true
    environment:
      # Required. Container name of scprime container
      - CONTAINER=<name-of-scprime-daemon>
      # Optional. Adjust pricing. Default 0.0.
      - PRICE_CONSTANT=0.0
```
## Example output:
```log
Setting target price to: 18.1 SCP
Host settings updated.
Estimated conversion rate: 0.036186524090953694%
Sleeping 24h...
```
