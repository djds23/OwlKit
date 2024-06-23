# syntax=docker/dockerfile:1

# Comments are provided throughout this file to help you get started.
# If you need more help, visit the Dockerfile reference guide at
# https://docs.docker.com/go/dockerfile-reference/
FROM swift:5.10 as base

################################################################################
# Create a stage for building/compiling the application.
#
# The following commands will leverage the "base" stage above to generate
# a "hello world" script and make it executable, but for a real application, you
# would issue a RUN command for your application's build process to generate the
# executable. For language-specific examples, take a look at the Dockerfiles in
# the Awesome Compose repository: https://github.com/docker/awesome-compose
FROM base as build
ADD . /usr/local/owlkit

WORKDIR /usr/local/owlkit
RUN chmod +x /usr/local/owlkit/ci/build.sh
RUN chmod +x /usr/local/owlkit/ci/test.sh
RUN /usr/local/owlkit/ci/build.sh

FROM base AS final

RUN groupadd -g 998 build-user && \
    useradd -m -r -u 998 -g build-user build-user

# Copy the executable from the "build" stage.
COPY --from=build /usr/local/owlkit /usr/local/owlkit

WORKDIR /usr/local/owlkit
# What the container should run when it is started.
ENTRYPOINT [ "./ci/test.sh" ]
