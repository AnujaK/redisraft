#!/bin/bash
colorize() {
    local colstr
    case $1 in 
        red) color="31m" ;;
        green) color="32m" ;;
        yellow) color="33m" ;;
        blue) color="34m" ;;
        magenta) color="35m" ;;
        cyan) color="36m" ;;
    esac

    while read line;
    do
        echo -e "\033[${color}${line}\033[0m"
    done
}

LOGLEVEL=notice
#valgrind --tool=callgrind \
../redis/src/redis-server --port 5001 --loglevel $LOGLEVEL --logfile redis1.log --loadmodule `pwd`/redisraft.so init id=1 addr=localhost:5001 &
../redis/src/redis-server --port 5002 --loglevel $LOGLEVEL --logfile redis2.log --loadmodule `pwd`/redisraft.so id=2 & 
../redis/src/redis-server --port 5003 --loglevel $LOGLEVEL --logfile redis3.log --loadmodule `pwd`/redisraft.so id=3 &
sleep 1
redis-cli -p 5001 raft.addnode 2 localhost:5002
redis-cli -p 5001 raft.addnode 3 localhost:5003
read
