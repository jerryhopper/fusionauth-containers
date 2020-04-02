#!/bin/bash

#
# FusionAuth environment setup. The fusionauth.properties file
# is parsed by this script to setup additional command-line properties including memory settings.
#

FUSIONAUTH_PLUGIN_DIR=${CATALINA_HOME}/../../plugins
FUSIONAUTH_CONFIG_DIR=${CATALINA_HOME}/../../config
#FUSIONAUTH_JAVA_DIR=${CATALINA_HOME}/../../java
FUSIONAUTH_LOG_DIR=${CATALINA_HOME}/../../logs
CATALINA_OUT=${FUSIONAUTH_LOG_DIR}/fusionauth-app.log
CATALINA_OPTS="-Dfusionauth.home.directory=$CATALINA_HOME/.. -Dfusionauth.config.directory=$FUSIONAUTH_CONFIG_DIR -Dfusionauth.log.directory=$FUSIONAUTH_LOG_DIR -Dfusionauth.plugin.directory=$FUSIONAUTH_PLUGIN_DIR -Dnashorn.args=--no-deprecation-warning"
# Ready for Java 10
#CATALINA_OPTS="-Dfusionauth.home.directory=$CATALINA_HOME/.. -Dfusionauth.config.directory=$FUSIONAUTH_CONFIG_DIR -Dfusionauth.log.directory=$FUSIONAUTH_LOG_DIR -Dfusionauth.plugin.directory=$FUSIONAUTH_PLUGIN_DIR -Dnashorn.args=--no-deprecation-warning -Djavax.net.ssl.trustStore=$FUSIONAUTH_CONFIG_DIR/cacerts"
JAVA_OPTS=" -Djava.awt.headless=true --enable-preview"
JAVA_OPTS=$(echo ${JAVA_OPTS}|tr -d '\r')

CURL_OPTS="-fSL --progress-bar"
# If we are in a non interactive shell then hide the progress but show errors
if ! tty -s; then
  CURL_OPTS="-sS"
fi

if [ ! -d ${CATALINA_HOME}/logs ]; then
  mkdir -p ${CATALINA_HOME}/logs
fi

#if [ ! -d ${FUSIONAUTH_JAVA_DIR} ]; then
#  mkdir -p ${FUSIONAUTH_JAVA_DIR}
#fi

if [ ! -d ${FUSIONAUTH_LOG_DIR} ]; then
  mkdir -p ${FUSIONAUTH_LOG_DIR}
fi

# Download Java if we are not yet setup, or the version is not the target version.
#if [ "$(uname -s)" = "Darwin" ]; then
#  JAVA_PATH=${FUSIONAUTH_JAVA_DIR}/jdk-14+36/Contents
#elif [ "$(uname -s)" = "Linux" ]; then
#  JAVA_PATH=${FUSIONAUTH_JAVA_DIR}/jdk-14+36
#fi
#
#if [ ! -e ${FUSIONAUTH_JAVA_DIR}/current ] || [ ! -d ${JAVA_PATH} ]; then
#  if [ "$(uname -s)" = "Darwin" ]; then
#    if [ -f ~/dev/inversoft/java/openjdk-macos-14.0.0+36.tar.gz ]; then
#      # Development, just sym link to our current version of Java
#      cd ${FUSIONAUTH_JAVA_DIR}
#      rm -f current
#      ln -s ~/dev/inversoft/java/macos/jdk-14+36/Contents current
#    else
#      curl ${CURL_OPTS} https://storage.googleapis.com/inversoft_products_j098230498/java/openjdk/openjdk-macos-14.0.0+36.tar.gz -o ${FUSIONAUTH_JAVA_DIR}/openjdk-macos-14.0.0+36.tar.gz
#      tar xfz ${FUSIONAUTH_JAVA_DIR}/openjdk-macos-14.0.0+36.tar.gz -C ${FUSIONAUTH_JAVA_DIR}
#      cd ${FUSIONAUTH_JAVA_DIR}
#      rm -f current
#      ln -s jdk-14+36/Contents current
#      rm openjdk-macos-14.0.0+36.tar.gz
#    fi
#  elif [ "$(uname -s)" = "Linux" ]; then
#    curl ${CURL_OPTS} https://storage.googleapis.com/inversoft_products_j098230498/java/openjdk/openjdk-linux-14.0.0+36.tar.gz -o ${FUSIONAUTH_JAVA_DIR}/openjdk-linux-14.0.0+36.tar.gz
#    tar xfz ${FUSIONAUTH_JAVA_DIR}/openjdk-linux-14.0.0+36.tar.gz -C ${FUSIONAUTH_JAVA_DIR}
#    cd ${FUSIONAUTH_JAVA_DIR}
#    rm -f current
#    ln -s jdk-14+36 current
#    rm openjdk-linux-14.0.0+36.tar.gz
#  fi
#fi
#
#if [ "$(uname -s)" = "Darwin" ]; then
#  JAVA_HOME=${FUSIONAUTH_JAVA_DIR}/current/Home
#elif [ "$(uname -s)" = "Linux" ]; then
#  JAVA_HOME=${FUSIONAUTH_JAVA_DIR}/current
#fi

if [ -f ${FUSIONAUTH_CONFIG_DIR}/fusionauth.properties ]; then
  value=$(cat ${FUSIONAUTH_CONFIG_DIR}/fusionauth.properties | grep "^fusionauth-app.http-port" | awk -F'=' '{ sub(/\r$/,""); print $2}')
  if [ ! -z "${FUSIONAUTH_HTTP_PORT}" ]; then
    JAVA_OPTS="$JAVA_OPTS -Dfusionauth.http.port=$FUSIONAUTH_HTTP_PORT"
  elif  [ -n "$value" ]; then
    JAVA_OPTS="$JAVA_OPTS -Dfusionauth.http.port=$value"
  fi

  value=$(cat ${FUSIONAUTH_CONFIG_DIR}/fusionauth.properties | grep "^fusionauth-app.https-port" | awk -F'=' '{ sub(/\r$/,""); print $2}')
  if [ ! -z "${FUSIONAUTH_HTTPS_PORT}" ]; then
    JAVA_OPTS="$JAVA_OPTS -Dfusionauth.https.port=$FUSIONAUTH_HTTPS_PORT"
  elif [ -n "$value" ]; then
    JAVA_OPTS="$JAVA_OPTS -Dfusionauth.https.port=$value"
  fi

  value=$(cat ${FUSIONAUTH_CONFIG_DIR}/fusionauth.properties | grep "^fusionauth-app.ajp-port" | awk -F'=' '{ sub(/\r$/,""); print $2}')
  if [ ! -z "${FUSIONAUTH_AJP_PORT}" ]; then
    JAVA_OPTS="$JAVA_OPTS -Dfusionauth.ajp.port=$FUSIONAUTH_AJP_PORT"
  elif [ -n "$value" ]; then
    JAVA_OPTS="$JAVA_OPTS -Dfusionauth.ajp.port=$value"
  fi

  value=$(cat ${FUSIONAUTH_CONFIG_DIR}/fusionauth.properties | grep "^fusionauth-app.management-port" | awk -F'=' '{ sub(/\r$/,""); print $2}')
  if [ ! -z "${FUSIONAUTH_MANAGEMENT_PORT}" ]; then
    JAVA_OPTS="$JAVA_OPTS -Dfusionauth.management.port=$FUSIONAUTH_MANAGEMENT_PORT"
  elif [ -n "$value" ]; then
    JAVA_OPTS="$JAVA_OPTS -Dfusionauth.management.port=$value"
  fi

  value=$(cat ${FUSIONAUTH_CONFIG_DIR}/fusionauth.properties | grep "^fusionauth-app.memory" | awk -F'=' '{ sub(/\r$/,""); print $2}')
  if [ ! -z "${FUSIONAUTH_MEMORY}" ]; then
    CATALINA_OPTS="$CATALINA_OPTS -Xms$FUSIONAUTH_MEMORY -Xmx$FUSIONAUTH_MEMORY"
  elif [ -n "$value" ]; then
    CATALINA_OPTS="$CATALINA_OPTS -Xms$value -Xmx$value"
  fi

  value=$(cat ${FUSIONAUTH_CONFIG_DIR}/fusionauth.properties | grep "^fusionauth-app.additional-java-args" | sed 's/^[a-zA-Z.-]*=//' | awk '{ sub(/\r$/,""); print }')
  if [ ! -z "${FUSIONAUTH_ADDITIONAL_JAVA_ARGS}" ]; then
    CATALINA_OPTS="$CATALINA_OPTS $FUSIONAUTH_ADDITIONAL_JAVA_ARGS"
  elif [ -n "$value" ]; then
    CATALINA_OPTS="$CATALINA_OPTS $value"
  fi
fi
