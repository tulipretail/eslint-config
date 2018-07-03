FROM node:8.1
RUN apt-get update

# Add a label to the container
ARG GIT_COMMIT
ARG GIT_BRANCH=master
ARG GIT_AUTHOR 
ARG BUILD_HOST
ARG BUILD_DATE

LABEL branch=$GIT_BRANCH \
    commit=$GIT_COMMIT \
    author=$GIT_AUTHOR \
    build-host=$BUILD_HOST \
    build-date=$BUILD_DATE

# build client
COPY . /tmp/eslint_config
