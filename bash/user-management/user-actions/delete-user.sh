#!/bin/bash

sed -i "/$1/d" users/users.csv

sed -i "/$1/d" users/logged-in-users.txt

rm -r "users/$1"

echo -e '\nUser deleted successfully!'