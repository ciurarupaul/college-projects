#!/bin/bash

while true; do
  echo "Name:"
  read name

  if [[ $name =~ ^[A-Z][a-z]+( [A-Z][a-z]+)*$ ]]; then
    break
  else
    echo "Invalid name! (the first letter must be uppercase)"
    continue
  fi
done

while true; do
  echo "Email:"
  read email

  if [[ $email =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    break
  else
    echo "Invalid email!"
    continue
  fi
done

while true; do
  echo "Phone Number:"
  read phone

  if [[ $phone =~ ^[0-9]{10}$ ]]; then
    break
  else
    echo "Invalid phone number!"
    continue
  fi
done

while true; do
  echo "Password:"
  read password

  if echo "$password" | awk '{ if (length >= 8 && /[0-9]/ && /[!@#$%^&*]/) exit 0; else exit 1 }'; then
    break
  else
    echo "Invalid password! (must contain at least 8 characters, a special symbol and a digit)"
    continue
  fi
done

uuid=$(uuidgen)

echo -e "\nUser created successfully!"
last_login=""

mkdir "users/$uuid"

echo "$uuid,$name,$email,$phone,$password,$last_login" >> users/users.csv

bash ./generate-report.sh "users/$uuid" &