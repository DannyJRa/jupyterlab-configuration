#!/bin/bash

docker build -t test_new -f config/test_new.Dockerfile .
docker run -ti -v ${PWD}:/usr/local/bin/test_new -p 8891:8888 test_new