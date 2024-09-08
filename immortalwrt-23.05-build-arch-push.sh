#!/bin/bash
#
#	* File     : immortalwrt-23.05-build-arch-push.sh
#	* Author   : sunowsir
#	* Mail     : sunowsir@163.com
#	* Github   : github.com/sunowsir
#	* Creation : 2024年08月15日 星期四 22时13分51秒

set -x

sudo podman login docker.io || exit

sudo podman rmi docker.io/sunowsir/immortalwrt-23.05-build:latest
sudo podman rmi localhost/immortalwrt-23.05-build

sudo podman commit 1dad52d9c598 immortalwrt-23.05-build || exit
sudo podman tag immortalwrt-23.05-build docker.io/sunowsir/immortalwrt-23.05-build:latest || exit

sudo podman push docker.io/sunowsir/immortalwrt-23.05-build:latest 


set +x
