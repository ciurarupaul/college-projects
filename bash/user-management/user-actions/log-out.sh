#!/bin/bash

sed -i "/$1/d" users/logged-in-users.txt

echo -e "\nUser logged out successfully!"