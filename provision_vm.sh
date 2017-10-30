#!/bin/bash

# exit the script on command errors or unset variables
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# https://stackoverflow.com/a/246128/295807
# readonly script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# this script runs as root

set -x

sudo yum -y install man man-pages bash-completion vim

# add another user to play with ACLs (chap4)
sudo adduser michael

# set the password for Michael
echo michael:michael | chpasswd

set +x
