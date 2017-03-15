#!/bin/bash
# how to send cookies via curl
# if no = is in the -b argument it's a filename
curl --verbose -b cookiejar.txt 'https://twitter.com/i/search/typeahead.json?count=10&filters=true&q=righth&result_type=users&src=COMPOSE'
