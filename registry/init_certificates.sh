#!/bin/sh
current_dir=$(dirname "$(greadlink -f "$0")")

openssl req \
  -newkey rsa:4096 -nodes -sha256 -keyout ${current_dir}/domain.key \
  -x509 -days 365 -out ${current_dir}/domain.crt
