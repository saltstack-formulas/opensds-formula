### opensds/files/profile.sh
BINHOME={{ sdshome }}
LANGHOME={{ langhome }}
export GOPATH=${PATH}:${LANGHOME}/bin
export SDSPATH={{ binhome }}/bin
export PATH=${PATH}:${SDSPATH}:${GOPATH}
