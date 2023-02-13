#!/bin/bash
# sample: ./rc-api.sh <app_url> <admin_username> <admin_password>
# usage: uncomment sections to use the scripts
# reference: https://developer.rocket.chat/reference/api/rest-api
set -e
if [ "$1" == "" ]; then
    echo "Error: Missing Arguments"
    echo ''
    echo "Usage:"
    echo "$0 app-url '<admin_username>' '<admin_password>'"
    echo ''
    echo "e.g.:$0 'https://chat.pathfinder.gov.bc.ca' admin password"
    echo ''
    exit 1
fi

filename=channels
rocketurl=$1
user=$2
pass=$3

# get API token
userid=$(curl $rocketurl/api/v1/login -d "user=$user&password=$pass" | jq '.data.userId' | tr -d '"')
token=$(curl $rocketurl/api/v1/login -d "user=$user&password=$pass" | jq '.data.authToken' | tr -d '"')

# ------ Manage webhooks: ------
# curl -H "X-Auth-Token: $token" -H "X-User-Id: $userid" -H "Content-type: application/json" $rocketurl/api/v1/integrations.list?count=5000 > output/webhooks.json
# curl -H "X-Auth-Token: $token" -H "X-User-Id: $userid" -H "Content-type: application/json" $rocketurl/api/v1/integrations.get?integrationId=xxxx
# curl -H "X-Auth-Token: $token" -H "X-User-Id: $userid" -H "Content-type: application/json" $rocketurl/api/v1/integrations.remove \
#      -d '{ "type": "webhook-incoming", "integrationId": "xxxx" }'

# # ------ Manage users: ------
# curl -H "X-Auth-Token: $token" -H "X-User-Id: $userid" -H "Content-type: application/json" $rocketurl/api/v1/users.list?count=5000 | jq -r ".users[] | ._id" > output/users.txt
# curl -H "X-Auth-Token: $token" -H "X-User-Id: $userid" -H "Content-type: application/json" $rocketurl/api/v1/users.list?count=5000 > output/users.json
# curl -H "X-Auth-Token: $token" -H "X-User-Id: $userid" -H "Content-type: application/json" $rocketurl/api/v1/users.info?userId=xxxx
# curl -H "X-Auth-Token: $token" -H "X-User-Id: $userid" -H "Content-type: application/json" $rocketurl/api/v1/users.info?username=admin

# # ------ Get user auth token: ------
# curl -H "X-Auth-Token: $token" -H "X-User-Id: $userid" -H "Content-type: application/json" $rocketurl/api/v1/users.generatePersonalAccessToken \
#      -d '{ "tokenName": "devhub" }'

# # ------ Get rooms and users: ------
# curl -H "X-Auth-Token: $token" -H "X-User-Id: $userid" -H "Content-type: application/json" $rocketurl/api/v1/channels.list?count=5000 | jq -r ".channels[] | ._id" > output/channels.txt
# curl -H "X-Auth-Token: $token" -H "X-User-Id: $userid" -H "Content-type: application/json" $rocketurl/api/v1/groups.listAll?count=5000

# while read -r line; do
#     channel="$line"
#     echo $channel
#     curl -H "X-Auth-Token: $token" -H "X-User-Id: $userid" -H "Content-type: application/json" $rocketurl/api/v1/channels.messages?roomId=$channel
# done < output/channels.txt

# while read -r line; do
#     user="$line"
#     echo $user
#     curl -H "X-Auth-Token: $token" -H "X-User-Id: $userid" -H "Content-type: application/json" $rocketurl/api/v1/users.info?userId=$user
# done < output/users.txt

# # ------ Get chats from a channel: ------
# curl -H "X-Auth-Token: $token" -H "X-User-Id: $userid" -H "Content-type: application/json" $rocketurl/api/v1/channels.messages?roomId=xxx

# ------ Create channel: ------
# while read -r line; do
#     channel="$line"
#     curl -H "X-Auth-Token: $token" -H "X-User-Id: $userid" -H "Content-type: application/json" $rocketurl/api/v1/channels.create -d '{ "name": "'$channel'" }'
# done < "$filename"

# ------ Clear inactive users: ------
# # get channel owners:
# curl -H "X-Auth-Token: $token" -H "X-User-Id: $userid" -H "Content-type: application/json" $rocketurl/api/v1/channels.list > output/channels.json
# curl -H "X-Auth-Token: $token" -H "X-User-Id: $userid" -H "Content-type: application/json" $rocketurl/api/v1/channels.list | jq -r ".channels[] | ._id" > output/channel-owner.txt
# curl -H "X-Auth-Token: $token" -H "X-User-Id: $userid" -H "Content-type: application/json" $rocketurl/api/v1/users.list?count=5000 > output/users.json
# # get inactive users:
# curl -H "X-Auth-Token: $token" -H "X-User-Id: $userid" -H "Content-type: application/json" \
#     $rocketurl/api/v1/users.list?count=5000 | jq -r '.users[] | select(.lastLogin | startswith("2019")) | ._id' > output/inactive-users.txt
# # users to be removed, that are not channel owners:
# comm -23 output/inactive-users.txt output/channel-owner.txt > output/delete-users.txt

# # uncomment to delete users:
# while read user; do
#   echo "delete user $user \n"
#   curl -H "X-Auth-Token: $token" -H "X-User-Id: $userid" -H "Content-type: application/json" $rocketurl/api/v1/users.delete -d '{ "userId": "'$user'" }'
# done <output/delete-users.txt
