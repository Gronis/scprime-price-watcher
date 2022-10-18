# scprime-price-watcher
Updates the price of your ScPrime container to what the price is currently on https://scpri.me
Currently, it will set the price to in between the max price and the goal price. This might change
in the future.

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
      - CONTAINER=<name-of-scprime-daemon>
```
## Example output:
```log
Setting target price to: 18.1 SCP
Host settings updated.
Estimated conversion rate: 0.036186524090953694%
Sleeping 24h...
```
