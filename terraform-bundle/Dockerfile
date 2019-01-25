FROM alpine:3.7
RUN apk add --no-cache bash ca-certificates
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

VOLUME ["/output"]

COPY entrypoint.sh .
COPY terraform-bundle.hcl .
COPY plugins ./plugins
COPY terraform-bundle .

CMD ["./entrypoint.sh"]