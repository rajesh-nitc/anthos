#!/bin/bash

set -eux

ssh-keygen -t rsa -b 4096 \
 -C "rajesh-nitc" \
 -N '' \
 -f /home/$USER/acm-git-ssh-keys