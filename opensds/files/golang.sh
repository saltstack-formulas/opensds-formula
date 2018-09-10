###  opensds/files/golang.sh
export GOHOME={{ gohome }}
export GOPATH=${PATH}:${GOHOME}/bin
export PATH=${PATH}:${GOPATH}
