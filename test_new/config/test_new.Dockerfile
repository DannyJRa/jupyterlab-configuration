FROM leandatascience/jupyterlab-ds:latest
ENV MAIN_PATH=/usr/local/bin/test_new
ENV LIBS_PATH=${MAIN_PATH}/libs
ENV CONFIG_PATH=${MAIN_PATH}/config
ENV NOTEBOOK_PATH=${MAIN_PATH}/notebooks

EXPOSE 8891

CMD cd ${MAIN_PATH} && sh config/run_jupyter.sh
