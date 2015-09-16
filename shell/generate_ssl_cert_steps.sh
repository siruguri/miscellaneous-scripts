#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters - give a directory"
    exit -1
fi
if [ ! -d "$1" ]; then
    echo "Illegal first parameter - give a directory"
    exit -1
fi
    
echo generating server pass key
openssl genrsa -des3 -passout pass:x -out server.pass.key 2048
echo writing RSA key
openssl rsa -passin pass:x -in server.pass.key -out server.key
echo removing server pass key
rm server.pass.key
echo generating csr
openssl req -new -key server.key -out server.csr
mv server.csr server.key $1
