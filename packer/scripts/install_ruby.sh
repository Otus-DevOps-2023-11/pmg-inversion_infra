#!/bin/bash
apt update && apt install -y ruby-full ruby-bundler build-essential && (ruby -v; bundler -v) > check_ruby.txt
