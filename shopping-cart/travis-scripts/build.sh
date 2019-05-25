#! /bin/bash

# Travis configured to setup a postgres db 
# we only need to setup the schema, user and password
psql -c "CREATE DATABASE shopping_cart;" -U postgres
psql -c "CREATE USER shopping_cart WITH PASSWORD 'shopping_cart';" -U postgres

SHOPPING_CART_SOURCES=$1
BUILD_TOOL=$2

if [ "$BUILD_TOOL" == "sbt" ]; then
    bin/runSbtJob $SHOPPING_CART_SOURCES test 
elif [ "$BUILD_TOOL" == "maven" ]; then
    # we need to pass org.jboss.logging.provider=slf4j, otherwise jboss logging, 
    # used by hibernate, will try to bind to log4j
    mvn -f $SHOPPING_CART_SOURCES -Dorg.jboss.logging.provider=slf4j test 
else
    echo "unknown build tool [$BUILD_TOOL]"
    exit 1
fi
