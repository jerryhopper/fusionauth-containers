
FROM alpine:latest as build

ADD https://download.java.net/java/early_access/alpine/15/binaries/openjdk-14-ea+15_linux-x64-musl_bin.tar.gz /opt/jdk/
RUN tar -xzvf /opt/jdk/openjdk-14-ea+15_linux-x64-musl_bin.tar.gz -C /opt/jdk/

RUN ["/opt/jdk/jdk-14/bin/jlink", "--compress=2", \
     "--module-path", "/opt/jdk/jdk-14/jmods/", \
     "--add-modules", "java.base", \
     "--output", "/jlinked"]

FROM alpine:latest
COPY --from=build /jlinked /opt/jdk/

ENV JAVA_HOME=/opt/jdk/
ENV PATH=$PATH:$JAVA_HOME/bin
