FROM docker
MAINTAINER mdevey+github@gmail.com

#override this, eg America/Chicago or Australia/Sydney
ENV TZ="UTC"

RUN apk update &&\
    apk add tzdata &&\
    rm -rf /var/cache/apk/*

COPY crontab /crontab.example
COPY crontab /crontab
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x entrypoint.sh

#Note crontab is copied each restart to avoid changing ownership of volume mounted files.
CMD /entrypoint.sh
