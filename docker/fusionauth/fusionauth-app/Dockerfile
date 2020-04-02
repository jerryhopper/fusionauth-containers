#
# FusionAuth App Dockerfile
#
# Build:
#   > docker build -t fusionauth/fusionauth-app:1.16.0 .
#   > docker build -t fusionauth/fusionauth-app:latest .
#
# Run:
#  > docker run -p 9011:9011 -it fusionauth/fusionauth-app
#
# Publish:
#   > docker push fusionauth/fusionauth-app:1.16.0
#   > docker push fusionauth/fusionauth-app:latest
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

###### Get and install FusionAuth App Bundle ########################
ENV FUSIONAUTH_VERSION=1.16.0
RUN curl -Sk --progress-bar https://storage.googleapis.com/inversoft_products_j098230498/products/fusionauth/${FUSIONAUTH_VERSION}/fusionauth-app-${FUSIONAUTH_VERSION}.zip -o fusionauth-app.zip \
  && mkdir -p /usr/local/fusionauth/fusionauth-app \
  && unzip -nq fusionauth-app.zip -d /usr/local/fusionauth \
  && rm fusionauth-app.zip \
  && mv setenv.sh /usr/local/fusionauth/fusionauth-app/apache-tomcat/bin \
  && chown -R fusionauth:fusionauth /usr/local/fusionauth

###### Start FusionAuth App #########################################
USER fusionauth
CMD ["/usr/local/fusionauth/fusionauth-app/apache-tomcat/bin/catalina.sh", "run"]