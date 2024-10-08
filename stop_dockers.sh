#!/bin/sh

docker stop ssh_container
docker rm ssh_container

docker stop writable_shadow_container
docker rm writable_shadow_container

docker stop sudo_privilege_container
docker rm sudo_privilege_container

docker stop take_my_cert_container
docker rm take_my_cert_container

docker stop hash_container
docker rm hash_container
