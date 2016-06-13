find Digital\ Strategies/ -size +10M -print | sed 's/ /" "/g'|xargs ls -l|sort -n -k 5
