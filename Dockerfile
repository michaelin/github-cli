FROM bitnami/golang:1.14 as builder
ARG CLI_VERSION="trunk"
ENV GH_CLI_VERSION="$CLI_VERSION"
RUN git clone --depth 1 --branch $GH_CLI_VERSION https://github.com/cli/cli.git /go/src/gh-cli
RUN cd /go/src/gh-cli && make

FROM bitnami/git:2.27.0
LABEL maintainer="Michael Ingeman-Nielsen <michael@i-n.dk>"

COPY --from=builder /go/src/gh-cli/bin/gh /usr/local/bin/
ENTRYPOINT [ "gh" ]
CMD [ "help" ]
