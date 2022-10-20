FROM debian:stable-slim

RUN apt-get update && apt-get install -y jq curl && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.cache /usr/share/doc/* && \
    rm /etc/pam.d/login

COPY --from=docker:dind /usr/local/bin/docker /usr/local/bin/
COPY entrypoint.sh /
CMD /entrypoint.sh
