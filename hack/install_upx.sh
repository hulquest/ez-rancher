#!/usr/bin/env sh

UPX_VERSION=3.96

wget https://github.com/upx/upx/releases/download/v${UPX_VERSION}/upx-${UPX_VERSION}-amd64_linux.tar.xz
tar -xvf upx-${UPX_VERSION}-amd64_linux.tar.xz
mv upx-${UPX_VERSION}-amd64_linux/upx /bin/upx
rm -rf upx-${UPX_VERSION}-amd64_linux.tar.xz upx-${UPX_VERSION}-amd64_linux

