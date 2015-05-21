# first cmd line param to specify number of days - it's 25 right now

if [ -z $1 ]
then
    d=25;
else
    d=$1
elif
    
find  .  -type f  -ctime -"$d"d -depth 1

