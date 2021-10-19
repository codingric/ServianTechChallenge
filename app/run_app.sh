#!/bin/sh

export VTT_DBPASSWORD=`echo $DBPASSWORD| jq .password |xargs`
./TechChallengeApp $1
