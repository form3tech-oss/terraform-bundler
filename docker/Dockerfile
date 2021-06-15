FROM 288840537196.dkr.ecr.eu-west-1.amazonaws.com/tech.form3/alpine:3.13.5-f3-1.0.0

RUN apk add --no-cache \
    # necessary for terraform provider plugins
    libc6-compat \
    gettext \
    postgresql-client \
    bash \
    curl && \
    wget -O /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 && \
	chmod +x /usr/bin/dumb-init

COPY bundle.zip /bundle.zip
COPY custom-entrypoint.sh /custom-entrypoint.sh
COPY terraformrc.template /tmp/terraformrc.template

RUN unzip bundle.zip \
    && mv ./terraform* /bin \
    && mkdir /tf \
    && mkdir /tf_test_overrides \
    && chmod a+x /custom-entrypoint.sh \
    && terraform version

ENTRYPOINT ["/custom-entrypoint.sh"]

