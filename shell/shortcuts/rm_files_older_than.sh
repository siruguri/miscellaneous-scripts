# Should add a param to specify number of days - it's 25 right now

find  .  -type f  -ctime +25d -depth 1 -print0|xargs -0 rm

