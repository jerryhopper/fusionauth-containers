#
# FusionAuth App Dockerfile
#
# Build:
#   > cp ~/dev/inversoft/fusionauth/fusionauth-app/build/bundles/*.zip .
#   > docker build -t fusionauth/fusionauth-app:dev .
#
# Run:
#  > docker run -p 9011:9011 -it fusionauth/fusionauth-app
#

FROM openjdk:14-jdk-alpine

LABEL description="Create an image running FusionAuth App. Installs FusionAuth App"
LABEL maintainer="FusionAuth <dev@fusionauth.io>"

EXPOSE 9011

###### Install stuff we need and then cleanup cache #################
RUN apk add --no-cache \
  unzip \
  curl \
  && addgroup -g 1000 fusionauth \
  && adduser -G fusionauth -u 1000 -D -H fusionauth

###### Copy the latest dev build ####################################
COPY fusionauth-app.zip setenv.sh ./

###### Install FusionAuth App Bundle ########################
RUN mkdir -p /usr/local/fusionauth/fusionauth-app \
  && unzip -nq fusionauth-app.zip -d /usr/local/fusionauth \
  && rm fusionauth-app.zip \
  && mv setenv.sh /usr/local/fusionauth/fusionauth-app/apache-tomcat/bin \
  && chown -R fusionauth:fusionauth /usr/local/fusionauth

###### Start FusionAuth App #########################################
USER fusionauth
CMD ["/usr/local/fusionauth/fusionauth-app/apache-tomcat/bin/catalina.sh", "run"]
