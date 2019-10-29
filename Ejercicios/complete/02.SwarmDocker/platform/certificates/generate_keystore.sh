#!/bin/bash

# https://docs.wso2.com/display/IS550/Changing+the+hostname / OPTION 2

CARBON_HOST="*"
KEYSTORE_ALIAS=wso2carbon

DNAME="CN=$CARBON_HOST.$DOMAIN,OU=Developer,O=Chakray,ST=Sevilla,C=ES"
KEYSTORE_FILE=wso2carbon.jks
KEYSTORE_PASSWORD=wso2carbon
P12_FILE=wso2carbon.p12
EXTENSIONS="digitalSignature,keyEncipherment,dataEncipherment"

keytool -genkey -noprompt -alias $KEYSTORE_ALIAS -ext KeyUsage=$EXTENSIONS \
    -keyalg RSA -sigalg SHA256withRSA -keysize 2048 -validity 3650 -dname "$DNAME" \
    -keystore $KEYSTORE_FILE -storepass $KEYSTORE_PASSWORD -keypass $KEYSTORE_PASSWORD

keytool -export -noprompt -alias $KEYSTORE_ALIAS -file $KEYSTORE_ALIAS.crt \
    -keystore $KEYSTORE_FILE -storepass $KEYSTORE_PASSWORD -keypass $KEYSTORE_PASSWORD
cp client-truststore-complete.jks client-truststore.jks 

keytool -import -noprompt -alias $KEYSTORE_ALIAS -file $KEYSTORE_ALIAS.crt \
    -keystore client-truststore.jks -storepass wso2carbon -keypass $KEYSTORE_PASSWORD

keytool -importkeystore -srckeystore $KEYSTORE_FILE -srcstorepass wso2carbon \
    -destkeystore $P12_FILE -deststorepass wso2carbon -deststoretype PKCS12

openssl pkcs12 -in $P12_FILE -nokeys -out $KEYSTORE_ALIAS.crt -passin pass:wso2carbon -nokeys

openssl pkcs12 -in $P12_FILE -nocerts -nodes -out $KEYSTORE_ALIAS.key -passin pass:wso2carbon -nocerts

chmod 750 *.jks
mkdir -p ../stacks/openbanking/configs/keystores/
mkdir -p ../stacks/wso2/configs/keystores/
cp -fr $KEYSTORE_ALIAS.key ../stacks/traefik/configs/traefik.key
cp -fr $KEYSTORE_ALIAS.crt ../stacks/traefik/configs/traefik.crt
cp -fr client-truststore.jks ../stacks/wso2/configs/keystores/
cp -fr $KEYSTORE_FILE ../stacks/wso2/configs/keystores/
cp -fr client-truststore.jks ../stacks/openbanking/configs/keystores/
cp -fr $KEYSTORE_FILE ../stacks/openbanking/configs/keystores/

rm *.p12
rm wso2carbon.*	
rm client-truststore.jks 	
