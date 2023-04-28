#!/bin/bash

 

SERVER_HOST_DIR=$(pwd)/nestjs-rest-api

CLIENT_HOST_DIR=$(pwd)/shop-app

 

SERVER_REMOTE_DIR=/var/app/lab2_server

CLIENT_REMOTE_DIR=/var/www/lab2_client

 

SSH_ALIAS=my_ssh_alias

SSH_USER_NAME=sshuser

 

check_remote_dir_exists() {

  if ssh $SSH_ALIAS "[ ! -d $1 ]"; then

    ssh -t $SSH_ALIAS "sudo bash -c 'mkdir -p $1 && chown -R $SSH_USER_NAME: $1'"

  else

    ssh $SSH_ALIAS "sudo -S rm -r $1/*"

  fi

}

 

check_remote_dir_exists $SERVER_REMOTE_DIR

check_remote_dir_exists $CLIENT_REMOTE_DIR

 

cd $SERVER_HOST_DIR && npm run build

scp -Cr dist/ package.json $SSH_ALIAS:$SERVER_REMOTE_DIR

 

cd $CLIENT_HOST_DIR && npm run build && cd ../

scp -Cr $CLIENT_HOST_DIR/dist/* ssl_cert/ devops-js-app.conf $SSH_ALIAS:$CLIENT_REMOTE_DIR