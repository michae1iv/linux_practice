#!/bin/sh

cd ssh_missconfig/
docker build -t ssh-server .
docker run -d -p 2222:22 --name ssh_container ssh-server
cd ../

cd writable_shadow/
docker build -t writable_shadow .
docker run -d -p 2223:22 --name writable_shadow_container writable_shadow
cd ../

cd sudo_privilege/
docker build -t sudo_privilege .
docker run -d -p 2224:22 --name sudo_privilege_container sudo_privilege
cd ../

cd take_my_cert
docker build -t take_my_cert .
docker run -d -p 2225:22 --name take_my_cert_container take_my_cert
cd ../

cd hash_mainkun
docker build -t hash .
docker run -d -p 2226:22 --name hash_container hash
cd ../
