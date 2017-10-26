#!/bin/bash

# exit the script on command errors or unset variables
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# https://stackoverflow.com/a/246128/295807
# readonly script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# this script runs as root

sudo yum -y install man man-pages bash-completion vim
sudo yum -y reinstall setup  # to get some /usr/share/doc stuff back

# add another user to play with ACLs (chap4)
sudo adduser michael

# lol this ain't prod
echo michael:michael | chpasswd
