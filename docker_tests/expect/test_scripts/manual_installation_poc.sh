#!/bin/bash

read -r -p "Do you want to start installation? [y/N] :\n" response
case "$response" in
    [yY][eE][sS]|[yY])
        echo "Installation will be started:"
        ;;
    *)
        exit 1
        ;;
esac

read -r -p "Write installation directory path. :\n" dir_path

mkdir -p $dir_path

read -r -p "Pass your user name. :\n" user_name

echo "Main user is $user_name" > "$dir_path/username"