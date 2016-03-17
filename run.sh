#!/usr/bin/env bash

bundle install
nohup ruby lib/graphiteReporter.rb &
