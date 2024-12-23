#!/bin/bash

if [[ ! -s users/logged-in-users.txt ]]; then
  echo -e '\nThere are no logged in users.'
  exit 1
fi

echo -e '\nPlease choose one of the following logged in users!\n'

declare -A users

while IFS= read -r line; do
  name=$(echo "$line" | awk -F'(' '{gsub(/ *$/,"",$1); print $1}')
  uuid=$(echo "$line" | awk -F'id: ' '{print $2}' | awk '{print $1}' | tr -d ')')
  users["$uuid"]=$name
done < users/logged-in-users.txt

for uuid in "${!users[@]}"; do
  echo "${users[$uuid]} (id: $uuid)"
done

read -p 'Enter the UUID of the user: ' input_uuid

if [[ ${users[$input_uuid]} ]]; then
  echo -e "\n${users[$input_uuid]} is selected."
  bash ./generate-report.sh "users/$uuid" &
  bash -i ./user-menu.sh $input_uuid
else
  echo "No such user is logged in."
fi
