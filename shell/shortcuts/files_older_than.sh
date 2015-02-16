find  .  -type f  -ctime +25d -depth 1 -print0|xargs -0
# Doesn't work - have to add an xargs command, and also note this has a specific age in it - 25 days
