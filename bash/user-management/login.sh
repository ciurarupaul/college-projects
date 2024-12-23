#!/bin/bash

update_last_login() {
  local uuid="$1"
  local name="$2"
  local last_login="$3"

  awk -v uuid="$uuid" -v last_login="$last_login" \
  'BEGIN{FS=OFS=","} $1==uuid {$6=last_login}1' "users/users.csv" > temp && mv temp "users/users.csv"

  if grep -q "$uuid" "users/logged-in-users.txt"; then
    sed -i '/$uuid/ s/.*/$name (id: $uuid) logged in at $last_login/' "users/logged-in-users.txt"
  else
    echo "$name (id: $uuid) logged in at $last_login" >> "users/logged-in-users.txt"
  fi
}

echo "Email:"
read email
echo "Password:"
read password

match_found=false

while IFS=',' read -r uuid name email_in_file phone password_in_file last_login; do
  if [[ $email == $email_in_file && $password == $password_in_file ]]; then

    last_login=$(date '+%Y-%m-%d %H:%M:%S')
    update_last_login "$uuid" "$name" "$last_login"

    echo -e '\nLogin successful!'

    match_found=true
  fi
done < "users/users.csv"

if [ "$match_found" != true ]; then
  echo -e '\nNo match found for the provided email and password.'
fi
