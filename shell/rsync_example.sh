#!/bin/bash

# I used this for transferring my resume
rsync -avzrLki -e 'ssh -p 220 -i /Users/sameer/.ssh/digital_ocean_sameer' coded/ www-data@192.241.223.49:new_ss/resume/
