# scprime-price-watcher
Updates the price of your ScPrime container to what the price is currently on https://scpri.me

Currently, it will set the price to the goal price. This can be adjusted by using the
`PRICE_CONSTANT` variable.

- The price will be capped to "Ceiling" price (on https://scpri.me) automatically.
- The price is updated every 3 hours.

### Price adjustment examples:
- `PRICE_CONSTANT=1.0` will use the goal price.
- `PRICE_CONSTANT=1.1` will add 10% to goal price.
- `PRICE_CONSTANT=0.95` will use goal price with 5% rebate

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
      # Optional. Adjust pricing. Default 1.0.
      - PRICE_CONSTANT=1.0
```
## Example output:
```log
Setting target price to: 18.1 SCP
Host settings updated.
Estimated conversion rate: 0.036186524090953694%
Sleeping 3 hours...
```
