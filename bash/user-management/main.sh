#!/bin/bash

if [ ! -d "users" ]; then
  mkdir users
fi

if [ ! -f "users/logged-in-users.txt" ]; then
  touch users/logged-in-users.txt
fi

if [ ! -f "users/users.csv" ]; then
  touch users/users.csv
fi

while IFS=',' read -r uuid _; do
  bash ./generate-report.sh "users/$uuid" &
done < users/users.csv

while true; do
  echo -e '\nType '\''add-user'\'' to create a new user'
  echo 'Type '\''login'\'' to log into an existing user account'
  echo -e 'Type '\''pick-user'\'' to access one of the already logged-in accounts!\n'

  read input

  case $input in
  "add-user")
    bash -i ./add-user.sh
    ;;
  "login")
    bash -i ./login.sh
    ;;
  "pick-user")
    bash -i ./pick-user.sh
    ;;
  "purge-users")
    rm -r users
    ;;
  "exit")
    exit
    ;;
  *)
    echo -e '\nPlease input one of the valid commands!'
    ;;
  esac
done