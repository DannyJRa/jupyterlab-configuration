
docker build -t jpl_config -f config/jpl_config.Dockerfile .
docker run -ti -v ${PWD}:/usr/local/bin/jpl_config -p 8891:8888 jpl_config