#!/bin/bash

set -eux

ssh-keygen -t rsa -b 4096 \
 -C "rajesh-nitc" \
 -N '' \
 -f ~/acm-git-ssh-keys