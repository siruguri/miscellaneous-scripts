#!/bin/bash
# how to send json in curl via data in file
curl --verbose -H 'Content-Type: application/json' -d@/Users/sameer/tmp/data/json_file.txt -X POST 'https://trackstatus.offtherailsapps.com/process_email?wildcard=true'
#curl --verbose -H 'Content-Type: application/json' -d@/Users/sameer/tmp/data/json_file.txt -X POST 'http://localhost:3000/process_email?wildcard=true'
