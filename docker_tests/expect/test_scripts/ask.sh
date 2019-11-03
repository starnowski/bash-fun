#!/bin/bash
# source
# https://stackoverflow.com/questions/3231804/in-bash-how-to-add-are-you-sure-y-n-to-any-command-or-alias

read -r -p "Are you sure? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        echo "The response was positive: $response"
        ;;
    *)
        echo "The response was negative: $response"
        ;;
esac