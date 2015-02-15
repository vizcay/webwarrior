#!/bin/bash

cd `dirname $0`
java -jar webwarrior.war --httpPort=4488 &
sleep 8
xdg-open http://localhost:4488
