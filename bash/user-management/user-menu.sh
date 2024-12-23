#!/bin/bash

echo -e '\nPlease select an action for this user:'
echo '1. Log out'
echo '2. Delete user'
echo '3. Go Back'
echo -e '\nType 1 2 or 3 to choose:'

read option

case $option in
  1)
    bash -i ./user-actions/log-out.sh $1
    ;;
  2)
    bash -i ./user-actions/delete-user.sh $1
    ;;
  3)
    bash -i ./main.sh
    ;;
  *)
    echo "Please input a valid value!"
    ;;
esac
