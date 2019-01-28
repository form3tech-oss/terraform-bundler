FROM alpine:3.7
RUN apk add --no-cache bash ca-certificates gettext libintl \
    && mkdir /lib64 \
    && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

VOLUME ["/output"]

ADD https://github.com/mattolenik/hclq/releases/download/0.1.8/hclq-linux-amd64 hclq
COPY entrypoint.sh .
COPY terraform-bundle.hcl.template .
COPY terraform-bundle .
COPY install_terraform_provider.sh .

CMD ["./entrypoint.sh"]