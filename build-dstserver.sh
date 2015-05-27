#!/bin/bash

docker build -t dstserver "$(dirname "$0")/dst"
