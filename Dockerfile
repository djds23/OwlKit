# syntax=docker/dockerfile:1

FROM swift:5.10 AS base

FROM base AS build
ADD . /usr/local/owlkit

WORKDIR /usr/local/owlkit
RUN chmod +x /usr/local/owlkit/linux/build.sh
RUN chmod +x /usr/local/owlkit/linux/test.sh
RUN chmod +x /usr/local/owlkit/linux/cli.sh
RUN /usr/local/owlkit/linux/build.sh

FROM base AS final

RUN groupadd -g 998 build-user && \
    useradd -m -r -u 998 -g build-user build-user

# Copy the executable from the "build" stage.
COPY --from=build /usr/local/owlkit /usr/local/owlkit

WORKDIR /usr/local/owlkit
# What the container should run when it is started.
ENTRYPOINT [ "./linux/cli.sh" ]
